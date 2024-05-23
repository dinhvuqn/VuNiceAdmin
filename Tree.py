import subprocess
import json

def get_process_tree_via_powershell(parent_pid):
    # Lệnh PowerShell để lấy cây quá trình
    powershell_command = f"""
    $parent = Get-Process -Id {parent_pid}
    function Get-ChildProcesses {{
        param ($proc)
        $children = Get-Process -ParentId $proc.Id 2>$null
        $proc | Select-Object Id, ProcessName, @{Name='Children';Expression={ $children | ForEach-Object { Get-ChildProcesses $_ } }}
    }}
    $tree = Get-ChildProcesses $parent
    $tree | ConvertTo-Json -Depth 10
    """

    # Chạy lệnh PowerShell và lấy kết quả
    result = subprocess.run(["powershell", "-Command", powershell_command], capture_output=True, text=True)
    
    if result.returncode != 0:
        print("Error running PowerShell command:", result.stderr)
        return None

    # Phân tích kết quả đầu ra (JSON)
    process_tree = json.loads(result.stdout)
    return process_tree

def find_leaf_processes(process):
    if not process.get('Children'):
        return [process]
    
    leaf_processes = []
    for child in process['Children']:
        leaf_processes.extend(find_leaf_processes(child))
    
    return leaf_processes

# PID của tiến trình cha cần tìm
parent_pid = 1234  # Thay thế bằng PID của tiến trình cha

# Lấy cây quá trình
process_tree = get_process_tree_via_powershell(parent_pid)

if process_tree:
    leaf_processes = find_leaf_processes(process_tree)
    for proc in leaf_processes:
        print(f"Leaf PID: {proc['Id']}, Name: {proc['ProcessName']}")
