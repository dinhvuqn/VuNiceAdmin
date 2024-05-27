from pywinauto import Application
import warnings

# Hàm đóng cửa sổ alert bằng cách sử dụng handle (hwnd)
def close_alert(hwnd):
    try:
        warnings.filterwarnings('ignore')
        app = Application().connect(handle=hwnd)
        window = app.window(handle=hwnd)
        window.close()
        return True
    except Exception as e:
        return False

# Đóng cửa sổ alert với handle đã xác định
hwnd_alert = 527214  # Thay thế bằng handle thực của cửa sổ alert
close_alert(hwnd_alert)
