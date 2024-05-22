import win32gui
import win32con
import win32process
import traceback
import time
import subprocess
import json

def wait_for_window_to_close(hwnd):
	max_wait = 100
	while win32gui.IsWindow(hwnd):
		time.sleep(0.05)
		if max_wait <= 0:
			return False
		max_wait -= 1
	return True

def wait_for_bring_window_to_front(hwnd):
	max_wait = 100
	while win32gui.GetForegroundWindow() != hwnd:
		time.sleep(0.05)
		if max_wait <= 0:
			return False
		max_wait -= 1
	return True

def get_descendant_processes(parent_pid):
	# Sử dụng PowerShell để lấy tất cả các tiến trình con và cháu của tiến trình cha
	command = f"Get-WmiObject Win32_Process -Filter 'ParentProcessId={parent_pid} AND Name=\"iexplore.exe\"' | Select-Object -ExpandProperty ProcessId | ConvertTo-Json"
	result = subprocess.run(["powershell", "-Command", command], capture_output=True, text=True)
	return json.loads(result.stdout)

def is_alert_on_driver(hwnd, driver = None):
	_, pid = win32process.GetWindowThreadProcessId(hwnd)
	return pid in [get_descendant_processes(33544)]

def get_hwnd_alert(driver = None):
	alert_title = "Message from webpage"
	alert_class_name = "#32770"
	hwnds_alert = []

	def find_window_alert(hwnd, lParam):
		if alert_title == win32gui.GetWindowText(hwnd) and alert_class_name == win32gui.GetClassName(hwnd):
			hwnds_alert.append(hwnd)
	win32gui.EnumWindows(find_window_alert, None)

	for hwnd in hwnds_alert:
		if hwnd != 0 and is_alert_on_driver(hwnd):
			return hwnd
	return None

def close_alert(cancel_button_text="CANCEL"):
	try:
		# Tìm cửa sổ có tiêu đề là alert_title
		hwnd = get_hwnd_alert()
		if hwnd is not None:
			win32gui.SetForegroundWindow(hwnd)
			if wait_for_bring_window_to_front(hwnd) == False:
				return False
			if cancel_button_text == "OK":
				win32gui.PostMessage(hwnd, win32con.WM_KEYDOWN, win32con.VK_RETURN, 0)
			else:
				# Lấy handle của nút "OK" nếu không tìm thấy nút "CANCEL"
				#hwnd_button = find_button(hwnd, "CANCEL")
				win32gui.PostMessage(hwnd, win32con.WM_CLOSE, 0, 0)
			if wait_for_window_to_close(hwnd) == False:
				return False
		return True
	except Exception as e:
		return False

# Sử dụng hàm để đóng cửa sổ alert bằng cách nhấn nút "CANCEL" hoặc "OK"
close_alert("OK")
