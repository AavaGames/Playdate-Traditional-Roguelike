#include "CollisionMask.h"

static PlaydateAPI* pd;

// PARAM: width, height, stepLimit
static int CollisionMask_new(lua_State* L)
{
	CollisionMask* cm = malloc(sizeof(*cm));
	cm->width = pd->lua->getArgInt(1);
	cm->height = pd->lua->getArgInt(2);

	cm->mask = malloc(cm->width * sizeof(*(cm->mask)));
	for (int x = 0; x < cm->width; x++)
	{
		cm->mask[x] = malloc(cm->height * sizeof(*(cm->mask[0])));
		for (int y = 0; y < cm->height; y++) {
			cm->mask[x][y] = true;
		}
	}
	if (DEBUG_LOG)
		pd->system->logToConsole("New CollisionMask");
	pd->lua->pushObject(cm, "CollisionMask", 0);
	return 1;
}

static int CollisionMask_free(lua_State* L)
{
	CollisionMask* cm = pd->lua->getArgObject(1, "CollisionMask", NULL);
	free(cm->mask);
	free(cm);
}

bool CollisionMask_inBounds(CollisionMask* cm, int x, int y)
{
	return x >= 0 && x < cm->width && y >= 0 && y < cm->height;
}

//PARAM: x, y
static int CollisionMask_setTileFloor(lua_State* L)
{
	CollisionMask* cm = pd->lua->getArgObject(1, "CollisionMask", NULL);
	int x = pd->lua->getArgInt(2) - 1;
	int y = pd->lua->getArgInt(3) - 1;
	if (CollisionMask_inBounds(cm, x, y))
		cm->mask[x][y] = false;
	return 0;
}

bool CollisionMask_collision(CollisionMask* cm, int x, int y)
{
	if (CollisionMask_inBounds(cm, x, y))
		return cm->mask[x][y];
	else
		return false;
}

static const lua_reg CollisionMaskLib[] =
{
	{ "new", CollisionMask_new },
	{ "__gc", CollisionMask_free },
	{ "setTileFloor", CollisionMask_setTileFloor },
	{ NULL, NULL }
};

void Register_CollisionMask(PlaydateAPI* api)
{
	pd = api;
	const char* err;
	if (!pd->lua->registerClass("CollisionMask", CollisionMaskLib, NULL, 0, &err))
		pd->system->logToConsole("%s:%i: registerClass failed, %s", __FILE__, __LINE__, err);
}