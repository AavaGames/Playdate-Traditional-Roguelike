#include "Imports.h"
#include "DistanceMap.h"

static PlaydateAPI* pd = NULL;

static int Test_C(lua_State* L)
{
	pd->lua->pushString("Hello from Cia to lua");
	return 1;
}

#ifdef _WINDLL
__declspec(dllexport)
#endif
int eventHandler(PlaydateAPI* playdate, PDSystemEvent event, uint32_t arg)
{
	(void)arg;

	if (event == kEventInit)
	{
		pd = playdate;
	}

	/*
		If you don't provide an update callback, the system initializes a Lua context and calls eventHandler()
		again with event equal to kEventInitLua. At this point, you can use playdate->lua->addFunction() and playdate->lua->registerClass()
		to extend the Lua runtime. Note that this happens before main.lua is loaded and run.

		Can't call lua functions here because its before LUA initialization
	*/
	if (event == kEventInitLua)
	{
		const char* err;
		if (!pd->lua->addFunction(Test_C, "test_c", &err))
			pd->system->logToConsole("%s:%i: addFunction failed, %s", __FILE__, __LINE__, err);
		Register_CollisionMask(pd);
		Register_DistanceMap(pd);

		pd->system->logToConsole("Initialized C to Lua");
	}

	return 0;
}
