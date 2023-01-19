#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "pd_api.h"

static PlaydateAPI* pd = NULL;
static int hello(lua_State* L);

#ifdef _WINDLL
__declspec(dllexport)
#endif
int eventHandler(PlaydateAPI* playdate, PDSystemEvent event, uint32_t arg)
{
	(void)arg;

	if (event == kEventInitLua)
	{
		pd = playdate;

		/*
		If you don�t provide an update callback, the system initializes a Lua context and calls eventHandler()
		again with event equal to kEventInitLua. At this point, you can use playdate->lua->addFunction() and playdate->lua->registerClass()
		to extend the Lua runtime. Note that this happens before main.lua is loaded and run.
		*/

		pd->system->logToConsole("Initialized C to Lua");

		const char* err;
		if (!pd->lua->addFunction(hello, "hello", &err)) {
			pd->system->logToConsole("%s:%i: addFunction failed, %s", __FILE__, __LINE__, err);
		}
	}

	return 0;
}

static int hello(lua_State* L)
{
	pd->lua->pushString("hello from Cia to lua");
	return 1;
}