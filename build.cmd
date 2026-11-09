@echo off
setlocal
cd /d "%~dp0"

set "CSC=%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
if not exist "%CSC%" set "CSC=%WINDIR%\Microsoft.NET\Framework\v4.0.30319\csc.exe"
if not exist "%CSC%" (
    echo [ERROR] Cannot find the .NET Framework 4.x C# compiler.
    echo         Install .NET Framework 4.8 and run this script again.
    exit /b 1
)

if not exist "build" mkdir "build"

"%CSC%" /nologo /target:winexe /platform:anycpu /optimize+ ^
    /out:"build\DomainUserManager.exe" ^
    /win32icon:"assets\app.ico" ^
    /win32manifest:"app.manifest" ^
    /resource:"assets\donation.png",DonationImage ^
    /r:System.dll ^
    /r:System.Core.dll ^
    /r:System.Windows.Forms.dll ^
    /r:System.Drawing.dll ^
    /r:System.DirectoryServices.Protocols.dll ^
    /r:System.Security.dll ^
    /r:System.Xml.dll ^
    src\Program.cs src\AssemblyInfo.cs src\Models.cs src\LdapUtils.cs src\LdapService.cs ^
    src\AppSettings.cs src\UiTheme.cs src\Dialogs.cs src\AboutDialog.cs src\MainForm.cs

if errorlevel 1 (
    echo.
    echo [ERROR] Build failed.
    exit /b 1
)

if exist "app.config" copy /y "app.config" "域用户管理器.exe.config" >nul
if exist "build\DomainUserManager.exe" copy /y "build\DomainUserManager.exe" "域用户管理器.exe" >nul
if exist "app.config" copy /y "app.config" "build\DomainUserManager.exe.config" >nul

echo.
echo Build completed:
echo   %CD%\域用户管理器.exe
echo.
endlocal
