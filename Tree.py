from pywinauto import Application
import warnings

# Hàm đóng cửa sổ alert bằng cách sử dụng handle (hwnd)
def close_alert(hwnd):
    try:
        warnings.filterwarnings('ignore')
        app = Application().connect(handle=hwnd)
        window = app.window(handle=hwnd)
        print(window)
        window.set_focus()
        yesBtn = window[u'&OK'] 
        yesBtn.click()
        return True
    except Exception as e:
        print(e)
        return False

# Đóng cửa sổ alert với handle đã xác định
hwnd_alert = 723962  # Thay thế bằng handle thực của cửa sổ alert
close_alert(hwnd_alert)
