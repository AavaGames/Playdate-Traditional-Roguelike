#include "floodfill.h"

static PlaydateAPI* pd;

FloodSource* FloodSource_new(int x, int y, int weight)
{
	FloodSource* fs = malloc(sizeof(*fs));
	fs->x = x;
	fs->y = y;
	fs->weight = weight;
	return fs;
}

// PARAM: width, height
static int FloodMap_new(lua_State* L)
{
	FloodMap* fm = malloc(sizeof(*fm));
	fm->width = pd->lua->getArgInt(1);
	fm->height = pd->lua->getArgInt(2);
	fm->source = NULL;

	fm->collisionMask = malloc(fm->width * sizeof(*(fm->collisionMask)));
	fm->map = malloc(fm->width * sizeof(*(fm->map)));
	for (int x = 0; x < fm->width; x++)
	{
		fm->collisionMask[x] = malloc(fm->height * sizeof(*(fm->collisionMask[0])));
		fm->map[x] = malloc(fm->height * sizeof(*(fm->map[0])));
		for (int y = 0; y < fm->height; y++) {
			fm->collisionMask[x][y] = false;
			fm->map[x][y] = 0;
		}
	}
	pd->system->logToConsole("New Floodmap");
	pd->lua->pushObject(fm, "floodMap", 0);
	return 1;
}

static int FloodMap_free(lua_State* L)
{
	pd->system->logToConsole("Cleaned Floodmap");
	FloodMap* fm = pd->lua->getArgObject(1, "floodMap", NULL);
	free(fm->collisionMask);
	free(fm->map);
	free(fm->source);
	free(fm);
	return 0;
}

//PARAM: x, y, weight
static int FloodMap_addSource(lua_State* L)
{
	FloodMap* fm = pd->lua->getArgObject(1, "floodMap", NULL);
	FloodSource* source = malloc(sizeof(*source));
	// subtract x and y by 1 because arrays count from 1 in lua
	source->x = pd->lua->getArgInt(1) - 1;
	source->y = pd->lua->getArgInt(2) - 1;
	source->weight = pd->lua->getArgInt(3);
	fm->source = source;
	pd->system->logToConsole("Add source");
	return 0;
}

//PARAM: x, y
static int FloodMap_getTile(lua_State* L)
{
	FloodMap* fm = pd->lua->getArgObject(1, "floodMap", NULL);
	int x = pd->lua->getArgInt(2);
	int y = pd->lua->getArgInt(3);
	pd->lua->pushInt(fm->map[x][y]);
	return 1;
}

static int FloodMap_fillMap(lua_State* L)
{
	FloodMap* fm = pd->lua->getArgObject(1, "floodMap", NULL);
	//FloodMap_fill(fm, fm->source->x, fm->source->y);
	return 0;
}

static void FloodMap_fill(FloodMap* fm, int x, int y)
{
	// 1 = filled, 0 == not filled
	// in bounds and zone isn't filled yet (also needs to check collision mask)

	//add weight in new algo
	fm->map[x][y] = 1;
	if (x > 0 && (fm->map[x - 1][y] == 0))
		FloodMap_fill(fm, x - 1, y);
	if (y > 0 && (fm->map[x][y - 1] == 0))
		FloodMap_fill(fm, x, y - 1);
	if (x < fm->width - 1 && (fm->map[x + 1][y] == 0))
		FloodMap_fill(fm, x + 1, y);
	if (y < fm->height && (fm->map[x][y + 1] == 0))
		FloodMap_fill(fm, x, y + 1);
}

static const lua_reg floodMapLib[] =
{
	{ "new", FloodMap_new },
	{ "__gc", FloodMap_free },
	{ "addSource", FloodMap_addSource },
	{ "getTile", FloodMap_getTile },
	{ "fillMap", FloodMap_fillMap },
	{ NULL, NULL }
};

void Register_floodfill(PlaydateAPI* api)
{
	pd = api;
	const char* err;
	if (!pd->lua->registerClass("floodMap", floodMapLib, NULL, 0, &err))
		pd->system->logToConsole("%s:%i: registerClass failed, %s", __FILE__, __LINE__, err);
}
