@ECHO OFF
REM Assumes you have Windows binaries in the project's root directory!
cd src
"%cd%\..\moonc.exe" -t ../lib .
cd ..
xcopy /S /Y "%cd%\lib\pop\*" "%cd%\demo\pop\*"
