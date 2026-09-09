@echo off
rem c=port
rem --------------------------------------
choice Load New IDSDL in You USRobotics 
if errorlevel==2 goto end
freelsd.exe /c2 /b57600 idsdl302.rom
:end