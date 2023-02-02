call "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
if not exist BuildDevice mkdir BuildDevice
cd BuildDevice
cmake .. -G "NMake Makefiles" --toolchain=C:/Apps/PlaydateSDK/C_API/buildsupport/arm.cmake -DCMAKE_BUILD_TYPE=Release
nmake
pause