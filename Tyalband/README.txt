NOTES

I don't think the CMakeSettings.json is used. NOT TESTED

VS Compile -> Sim (changes in lua and C) / Device (changes for lua)
NMAKE compile -> Sim (no changes) -> Device (changes in lua and C)
VSCode Compile -> Crashes if changes in C but compiles otherwise

	NMAKE only compiles when things have changed

--

SIMULATOR BUILDING

1. Open VS 2022 Dev console
2. cd to */Build/
3. Enter: cmake ..
4. Open .sln in /Build/
5. Right click solution named after the game and "Set as starting project"
6. F5 to debug, CTRL+F5 to start without debugging, F7 to build

If changing a lua file then you must rebuild the solution(s) for changes to be reflected.

--

DEVICE BUILDING

1. Open VS 2022 Dev console
2. cd to */Build/
3. Enter: cmake .. -G "NMake Makefiles" --toolchain=C:/Apps/PlaydateSDK/C_API/buildsupport/arm.cmake -DCMAKE_BUILD_TYPE=Release
4. Enter: nmake
5. Open in sim and upload OR set device to data disk mode and add it to /Games/