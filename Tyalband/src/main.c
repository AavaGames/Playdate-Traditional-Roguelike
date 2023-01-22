#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "pd_api.h"
#include "fov.h"

static PlaydateAPI* pd = NULL;
static int Test_C(lua_State* L);
static int Setup_FOV(lua_State* L);
static int Compute_FOV(lua_State* L);
static int Test_Lua(lua_State* L);

fov_settings_type fov_settings;

/**
 * Function called by libfov to apply light to a cell.
 *
 * \param map Pointer to map data structure passed to function such as
 *            fov_circle.
 * \param x   Absolute x-axis position of cell.
 * \param y   Absolute x-axis position of cell.
 * \param dx  Offset of cell from source cell on x-axis.
 * \param dy  Offset of cell from source cell on y-axis.
 * \param src Pointer to source data structure passed to function such
 *            as fov_circle.
 */
void SetVisible(void* map, int x, int y, int dx, int dy, void* src) {
	// Call lua to set visible X, Y, distance (dx+dy)
	pd->lua->pushInt(x);
	pd->lua->pushInt(y);
	const char* err;
	if (!pd->lua->callFunction("SetVisible", 2, &err))
		pd->system->logToConsole("%s:%i: callFunction failed, %s", __FILE__, __LINE__, err);
}


/**
 * Function called by libfov to determine whether light can pass
 * through a cell. Return zero if light can pass though the cell at
 * (x,y), non-zero if it cannot.
 *
 * \param map Pointer to map data structure passed to function such as
 *            fov_circle.
 * \param x   Absolute x-axis position of cell.
 * \param y   Absolute x-axis position of cell.
 */
bool BlocksVision(void* map, int x, int y) {
	// Call lua to check if X, Y are blocking
	//const char* err;
	//pd->lua->callFunction("BlocksVision", 2, &err);
	return false; // if i cant get a callback from lua func then i have to pass in a collision map (faster anyway)
}

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

		fov_settings_init(&fov_settings);
		fov_settings_set_opacity_test_function(&fov_settings, BlocksVision);
		fov_settings_set_apply_lighting_function(&fov_settings, SetVisible);
		fov_settings_set_shape(&fov_settings, FOV_SHAPE_DIAMOND);

		const char* err;
		if (!pd->lua->addFunction(Test_C, "test_c", &err))
			pd->system->logToConsole("%s:%i: addFunction failed, %s", __FILE__, __LINE__, err);

		if (!pd->lua->addFunction(Setup_FOV, "Setup_FOV", &err))
			pd->system->logToConsole("%s:%i: addFunction failed, %s", __FILE__, __LINE__, err);
		if (!pd->lua->addFunction(Compute_FOV, "Compute_FOV", &err))
			pd->system->logToConsole("%s:%i: addFunction failed, %s", __FILE__, __LINE__, err);



		if (!pd->lua->addFunction(Test_Lua, "Test_Lua", &err))
			pd->system->logToConsole("%s:%i: addFunction failed, %s", __FILE__, __LINE__, err);

		pd->system->logToConsole("Testing Tyal Func");
		pd->system->logToConsole("Initialized C to Lua");

		// Can't call lua functions here because its before LUA initialization
	}

	return 0;
}

static int Test_C(lua_State* L)
{
	pd->lua->pushString("Hello from Cia to lua");
	return 1;
}

int x = 0;
int y = 0;
int radius = 0;

static int Setup_FOV(lua_State* L) {
	pd->system->logToConsole("Setup called");

	x = pd->lua->getArgInt(1);
	y = pd->lua->getArgInt(2);
	radius = pd->lua->getArgInt(3);
	return 0;
}

static int Compute_FOV(lua_State* L) {
	pd->system->logToConsole("Compute called");

	// first NULL = MAP, second = SOURCE

	//SetVisible(NULL, 0, 0, 0, 0, NULL); 
	fov_circle(&fov_settings, NULL, NULL, x, y, radius);
	return 0;
}

static int Test_Lua(lua_State* L)
{
	pd->lua->pushString("Tyal");
	const char* err;
	if (!pd->lua->callFunction("Greeting", 1, &err))
		pd->system->logToConsole("%s:%i: callFunction failed, %s", __FILE__, __LINE__, err);

	return 0;
}
