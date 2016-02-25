@ECHO OFF
cd src
"%cd%\..\moonc.exe" -t ../lib .
cd ..
xcopy /S /Y "%cd%\lib\pop\*" "%cd%\demo\pop\*"
