::[Bat To Exe Converter]
::
::fBE1pAF6MU+EWH3eyGMiKxpQSTigPXmuCaUj2/Ho+++KnmQTR/Y+dIPnmZCLNtww60fbRp4o2nZfivceCQhkfB6qbQR6q2NS1g==
::fBE1pAF6MU+EWH3eyGMiKxpQSTigPXmuCaUj2/Ho+++KnmQTR/Y+dIPnmZCLNtww60fbRp4o2nZfivceCQhkfB6qbQQwpnoMtXGXVw==
::YAwzoRdxOk+EWAjk
::fBw5plQjdCuDJHiW90M0LSd2TRaWM3uFNawP/O3208OJsVkcWO4DO6vezIitIeIs2U3heZooxEZTm8QwDQlbfxauIAY3pg4=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSzk=
::cBs/ulQjdF25
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpSI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+IeA==
::cxY6rQJ7JhzQF1fEqQJhZksaHErSXA==
::ZQ05rAF9IBncCkqN+0xwdVsFAlTMbCXqZg==
::ZQ05rAF9IAHYFVzEqQITKRkUfwyHMGe/FNU=
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATE1005JjRkf0SmNXi5CacYqNv+/fyCsC0=
::dhAmsQZ3MwfNWATE8BYeEUs0
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCuDJHiW90M0LSd2TRaWM3uFNawP/O3208OJsVkcWO4DO6vezIitIeIs2U3heZooxEZ5mckzPxNdch6ufDAs/zoMs3yAVw==
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
SETLOCAL EnableDelayedExpansion

:: Check admin permissions
start /wait /b %SystemRoot%\System32\net.exe session >nul 2>&1

:: Is admin
if %errorLevel% == 0 (
	goto admin
) else (
	goto noadmin
)

:admin
:: Check for argument
if ["%~1"]==[""] (
	goto noargument
)

:: Get shell value from registry
for /f "tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell 2^>^&1^|find "REG_SZ"') do @set Shell=%%b

if "%Shell%" == "explorer.exe" (
	:: Check if the windows logo branding can be renamed.
	if exist %SystemRoot%\Branding\Basebrd\basebrd.dll (
		ren %SystemRoot%\Branding\Basebrd\basebrd.dll basebrd.dll_ >nul 2>&1
	)
	
	:: Check if the black dot cursor is already there.
	if not exist %SystemRoot%\System32\blackdot.cur (
		copy %APPDATA%\blackdot.cur %SystemRoot%\System32\ >nul 2>&1
	)
	
	:: Check if the black wallpaper is already there.
	if not exist %SystemRoot%\System32\black.bmp (
		copy %APPDATA%\black.bmp %SystemRoot%\System32\ >nul 2>&1
	)
	
	:: Edit uac.
	for /f "tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA 2^>^&1^|find "REG_DWORD"') do @set EnableLUA=%%b
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUABak /t REG_DWORD /d !EnableLUA! /f >nul 2>&1
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /f /v "EnableLUA" /t REG_DWORD /d 0 >nul 2>&1
	
	:: Get existing wallpaper values.
	for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper 2^>^&1^|find "REG_SZ"') do @set Wallpaper=%%b
	for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Control Panel\Desktop" /v TileWallpaper 2^>^&1^|find "REG_SZ"') do @set TileWallpaper=%%b
	for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallpaperStyle 2^>^&1^|find "REG_SZ"') do @set WallpaperStyle=%%b
	
	:: Save backup values.
	reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallpaperBak /t REG_SZ /d "!Wallpaper!" /f >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v TileWallpaperBak /t REG_SZ /d !TileWallpaper! /f >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallpaperStyleBak /t REG_SZ /d !WallpaperStyle! /f >nul 2>&1
	
	:: Now change it.
	reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%SystemRoot%\System32\black.bmp" /f >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v TileWallpaper /t REG_SZ /d 1 /f >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallpaperStyle /t REG_SZ /d 0 /f >nul 2>&1

	:: Set exe path by passed parameter.
	set shellValue=%~1
	
	:: Set cursor path.
	set cursorValue=%SystemRoot%\System32\blackdot.cur
	
	:: Change shell application in registry.
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /f /v "Shell" /t REG_SZ /d "!shellValue!" >nul 2>&1
	:: Change regular cursors.
	for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Control Panel\Cursors" 2^>^&1^|find "REG_SZ"') do @set HKCUDefaultBak=%%b
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "DefaultBak" /t REG_SZ /d "!HKCUDefaultBak!" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /t REG_SZ /d "sheller" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "Scheme Source" /t REG_DWORD /d 0 >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "AppStarting" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "Arrow" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "Crosshair" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "Hand" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "Help" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "IBeam" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "No" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "NWPen" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "SizeAll" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "SizeNESW" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "SizeNS" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "SizeNWSE" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "SizeWE" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "UpArrow" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "Wait" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors\schemes" /f /v "sheller" /t REG_SZ /d "C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur" >nul 2>&1
	:: Change startup / shutdown cursors.
	for /f "tokens=2*" %%a in ('reg query "HKEY_USERS\.DEFAULT\Control Panel\Cursors" 2^>^&1^|find "REG_SZ"') do @set HKUDefaultBak=%%b
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "DefaultBak" /t REG_SZ /d "!HKUDefaultBak!" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /t REG_SZ /d "sheller" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "Scheme Source" /t REG_DWORD /d 0 >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "AppStarting" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "Arrow" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "Crosshair" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "Hand" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "Help" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "IBeam" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "No" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "NWPen" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "SizeAll" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "SizeNESW" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "SizeNS" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "SizeNWSE" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "SizeWE" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "UpArrow" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "Wait" /t REG_SZ /d "!cursorValue!" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors\schemes" /f /v "sheller" /t REG_SZ /d "C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur,C:\Windows\System32\blackdot.cur" >nul 2>&1
	:: Change system sounds.
	reg add "HKEY_CURRENT_USER\AppEvents\Schemes" /f /t REG_SZ /d "shell" >nul 2>&1
	reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Names" /f /t REG_SZ /d "shell" >nul 2>&1
	:: Disable gamebar.
	reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /f /v "ShowStartupPanel" /t REG_DWORD /d 0 >nul 2>&1
	:: Disable windows 10 lock screen.
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData" /f /v "AllowLockScreen" /t REG_DWORD /d 0 >nul 2>&1
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization" /f /v "NoLockScreen" /t REG_DWORD /d 1 >nul 2>&1
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /f /v "AnimationDisabled" /t REG_DWORD /d 1 >nul 2>&1
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /f /v "UIVerbosityLevel" /t REG_DWORD /d 1 >nul 2>&1
	:: Change login graphics.
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Background" /f /v "OEMBackground" /t REG_DWORD /d 1 >nul 2>&1
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Embedded\EmbeddedLogon" /f /v "HideAutoLogonUI" /t REG_DWORD /d 1 >nul 2>&1
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Embedded\EmbeddedLogon" /f /v "HideFirstLogonAnimation" /t REG_DWORD /d 1 >nul 2>&1
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" /f /v "DisableLogonBackgroundImage" /t REG_DWORD /d 1 >nul 2>&1
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\System" /f /v "DisableLogonBackgroundImage" /t REG_DWORD /d 1 >nul 2>&1
	:: Disable auto update.
	for /f "tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate 2^>^&1^|find "REG_DWORD"') do @set NoAutoUpdate=%%b
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /f /v "NoAutoUpdateBak" /t REG_DWORD /d !NoAutoUpdate! >nul 2>&1
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /f /v "NoAutoUpdate" /t REG_DWORD /d 1 >nul 2>&1
	
	:: Set no-gui boot.
	start /wait /b %SystemRoot%\System32\bcdedit.exe /set quietboot on >nul 2>&1
	:: Disable boot ux.
	start /wait /b %SystemRoot%\System32\bcdedit.exe /set bootuxdisabled on >nul 2>&1
	
) else (
	:: Check if the windows logo branding can be renamed.
	if exist %SystemRoot%\Branding\Basebrd\basebrd.dll_ (
		ren %SystemRoot%\Branding\Basebrd\basebrd.dll_ basebrd.dll >nul 2>&1
	)
	
	:: Edit uac.
	for /f "tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUABak 2^>^&1^|find "REG_DWORD"') do @set EnableLUABak=%%b
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d !EnableLUABak! /f >nul 2>&1
	reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUABak" /f >nul 2>&1
	
	:: Get existing wallpaper backup values.
	for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallpaperBak 2^>^&1^|find "REG_SZ"') do @set WallpaperBak=%%b
	for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Control Panel\Desktop" /v TileWallpaperBak 2^>^&1^|find "REG_SZ"') do @set TileWallpaperBak=%%b
	for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallpaperStyleBak 2^>^&1^|find "REG_SZ"') do @set WallpaperStyleBak=%%b
	
	:: Restore backup values.
	reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "!WallpaperBak!" /f >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v TileWallpaper /t REG_SZ /d !TileWallpaperBak! /f >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallpaperStyle /t REG_SZ /d !WallpaperStyleBak! /f >nul 2>&1
	
	:: Now delete the backup values.
	reg delete "HKEY_CURRENT_USER\Control Panel\Desktop" /v "WallpaperBak" /f >nul 2>&1
	reg delete "HKEY_CURRENT_USER\Control Panel\Desktop" /v "TileWallpaperBak" /f >nul 2>&1
	reg delete "HKEY_CURRENT_USER\Control Panel\Desktop" /v "WallpaperStyleBak" /f >nul 2>&1
	
	:: Set shell value.
	set shellValue=explorer.exe
	
	:: Set cursor path.
	set cursorPath=%SystemRoot%\Cursors\
	
	:: Change shell application in registry.
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /f /v "Shell" /t REG_SZ /d "!shellValue!" >nul 2>&1
	:: Change regular cursors.
	for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Control Panel\Cursors" /v DefaultBak 2^>^&1^|find "REG_SZ"') do @set HKCUDefaultBak=%%b
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /t REG_SZ /d "!HKCUDefaultBak!" >nul 2>&1
	reg delete "HKEY_CURRENT_USER\Control Panel\Cursors" /v "DefaultBak" /f >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "Scheme Source" /t REG_DWORD /d 2 >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "AppStarting" /t REG_SZ /d "!cursorPath!aero_working.ani" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "Arrow" /t REG_SZ /d "!cursorPath!aero_arrow.cur" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "Crosshair" /t REG_SZ /d "" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "Hand" /t REG_SZ /d "!cursorPath!aero_link.cur" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "Help" /t REG_SZ /d "!cursorPath!aero_helpsel.cur" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "IBeam" /t REG_SZ /d "" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "No" /t REG_SZ /d "!cursorPath!aero_unavail.cur" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "NWPen" /t REG_SZ /d "!cursorPath!aero_pen.cur" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "SizeAll" /t REG_SZ /d "!cursorPath!aero_move.cur" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "SizeNESW" /t REG_SZ /d "!cursorPath!aero_nesw.cur" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "SizeNS" /t REG_SZ /d "!cursorPath!aero_ns.cur" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "SizeNWSE" /t REG_SZ /d "!cursorPath!aero_nwse.cur" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "SizeWE" /t REG_SZ /d "!cursorPath!aero_ew.cur" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "UpArrow" /t REG_SZ /d "!cursorPath!aero_up.cur" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors" /f /v "Wait" /t REG_SZ /d "!cursorPath!aero_busy.cur" >nul 2>&1
	reg add "HKEY_CURRENT_USER\Control Panel\Cursors\schemes" /f /v "sheller" /t REG_SZ /d "" >nul 2>&1
	:: Change startup / shutdown cursors.
	for /f "tokens=2*" %%a in ('reg query "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /v DefaultBak 2^>^&1^|find "REG_SZ"') do @set HKCUDefaultBak=%%b
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /t REG_SZ /d "!HKCUDefaultBak!" >nul 2>&1
	reg delete "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /v "DefaultBak" /f >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "Scheme Source" /t REG_DWORD /d 2 >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "AppStarting" /t REG_SZ /d "!cursorPath!aero_working.ani" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "Arrow" /t REG_SZ /d "!cursorPath!aero_arrow.cur" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "Crosshair" /t REG_SZ /d "" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "Hand" /t REG_SZ /d "!cursorPath!aero_link.cur" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "Help" /t REG_SZ /d "!cursorPath!aero_helpsel.cur" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "IBeam" /t REG_SZ /d "" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "No" /t REG_SZ /d "!cursorPath!aero_unavail.cur" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "NWPen" /t REG_SZ /d "!cursorPath!aero_pen.cur" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "SizeAll" /t REG_SZ /d "!cursorPath!aero_move.cur" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "SizeNESW" /t REG_SZ /d "!cursorPath!aero_nesw.cur" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "SizeNS" /t REG_SZ /d "!cursorPath!aero_ns.cur" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "SizeNWSE" /t REG_SZ /d "!cursorPath!aero_nwse.cur" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "SizeWE" /t REG_SZ /d "!cursorPath!aero_ew.cur" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "UpArrow" /t REG_SZ /d "!cursorPath!aero_up.cur" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors" /f /v "Wait" /t REG_SZ /d "!cursorPath!aero_busy.cur" >nul 2>&1
	reg add "HKEY_USERS\.DEFAULT\Control Panel\Cursors\schemes" /f /v "sheller" /t REG_SZ /d "" >nul 2>&1
	:: Change system sounds.
	reg add "HKEY_CURRENT_USER\AppEvents\Schemes" /f /t REG_SZ /d ".Default" >nul 2>&1
	reg add "HKEY_CURRENT_USER\AppEvents\Schemes\Names" /f /t REG_SZ /d "" >nul 2>&1
	:: Re-enable gamebar.
	reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /f /v "ShowStartupPanel" /t REG_DWORD /d 1 >nul 2>&1
	:: Re-enable windows 10 lock screen.
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData" /f /v "AllowLockScreen" /t REG_DWORD /d 1 >nul 2>&1
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization" /f /v "NoLockScreen" /t REG_DWORD /d 0 >nul 2>&1
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /f /v "AnimationDisabled" /t REG_DWORD /d 0 >nul 2>&1
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /f /v "UIVerbosityLevel" /t REG_DWORD /d 0 >nul 2>&1
	:: Change login graphics.
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Background" /f /v "OEMBackground" /t REG_DWORD /d 0 >nul 2>&1
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Embedded\EmbeddedLogon" /f /v "HideAutoLogonUI" /t REG_DWORD /d 0 >nul 2>&1
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Embedded\EmbeddedLogon" /f /v "HideFirstLogonAnimation" /t REG_DWORD /d 0 >nul 2>&1
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" /f /v "DisableLogonBackgroundImage" /t REG_DWORD /d 0 >nul 2>&1
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\System" /f /v "DisableLogonBackgroundImage" /t REG_DWORD /d 0 >nul 2>&1
	:: Re-enable auto update.
	for /f "tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdateBak 2^>^&1^|find "REG_DWORD"') do @set NoAutoUpdateBak=%%b
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /f /v "NoAutoUpdate" /t REG_DWORD /d !NoAutoUpdateBak! >nul 2>&1
	reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdateBak" /f >nul 2>&1
	
	:: Set no-gui boot.
	start /wait /b %SystemRoot%\System32\bcdedit.exe /set quietboot off >nul 2>&1
	:: Enable boot ux.
	start /wait /b %SystemRoot%\System32\bcdedit.exe /set bootuxdisabled off >nul 2>&1
)

:: Reboot system
%SystemRoot%\System32\shutdown.exe /r /t 0
endlocal & exit

:noadmin
echo msgbox "This program must be run as an administrator. Right-click this file, select properties, go to the Compatibility tab and check ""Run this program as an administrator.""", vbInformation, "Computer says:"> %temp%\msg.vbs 
%temp%\msg.vbs 
erase %temp%\msg.vbs
endlocal & exit

:noargument
echo msgbox "This program needs the full path to the shell application as an command line argument.", vbInformation, "Computer says:"> %temp%\msg.vbs 
%temp%\msg.vbs 
erase %temp%\msg.vbs
endlocal & exit