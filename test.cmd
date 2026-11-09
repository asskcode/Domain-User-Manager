@echo off
setlocal
cd /d "%~dp0"

set "CSC=%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
if not exist "%CSC%" set "CSC=%WINDIR%\Microsoft.NET\Framework\v4.0.30319\csc.exe"
if not exist "%CSC%" (
    echo [ERROR] Cannot find the .NET Framework 4.x C# compiler.
    exit /b 1
)
if not exist "build" mkdir "build"

"%CSC%" /nologo /target:exe /out:"build\CoreTests.exe" ^
    /r:System.dll /r:System.Core.dll /r:System.DirectoryServices.Protocols.dll ^
    /r:System.Security.dll /r:System.Xml.dll ^
    src\Models.cs src\LdapUtils.cs src\LdapService.cs src\AppSettings.cs tests\CoreTests.cs
if errorlevel 1 exit /b 1

"build\CoreTests.exe"
if errorlevel 1 exit /b 1
endlocal
