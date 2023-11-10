@echo off
setlocal enabledelayedexpansion

rem Thư mục chứa các tệp .txt bạn muốn cập nhật
set "folder_path=D:\Kbatch\files"

rem Lấy tháng và năm hiện tại (yyyymm)

for /f "skip=1" %%x in ('wmic os get localdatetime') do if not defined MyDate set MyDate=%%x
for /f %%x in ('wmic path win32_localtime get /format:list ^| findstr "="') do set %%x
set fmonth=00%Month%
set today=%Year%%fmonth:~-2%
echo %today%

rem Nội dung bạn muốn thêm vào các tệp .txt
set "newContent=%date:~-4%/%date:~4,2%/%date:~7,2%%time:~0,2%:%time:~3,2%:%time:~6,2%,system,,,Close"

rem Di chuyển đến thư mục chỉ định
cd /d "%folder_path%"

rem Duyệt qua tất cả các tệp .txt và cập nhật chúng nếu tên tệp theo định dạng "*_yyyymm.txt"
for %%i in (*_*%today%.txt) do (
  set "file=%%i"
  echo %newContent%>>"!file!"
)

echo Cập nhật đã hoàn thành.
pause
