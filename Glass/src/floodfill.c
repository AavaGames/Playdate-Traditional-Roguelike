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
	// NOTE: subtract x and y by 1 because arrays count from 1 in lua
	source->x = pd->lua->getArgInt(2) - 1;
	source->y = pd->lua->getArgInt(3) - 1;
	source->weight = pd->lua->getArgInt(4);
	fm->source = source;
	pd->system->logToConsole("Add source");
	return 0;
}

//PARAM: x, y
static int FloodMap_getTile(lua_State* L)
{
	FloodMap* fm = pd->lua->getArgObject(1, "floodMap", NULL);
	int x = pd->lua->getArgInt(2) - 1;
	int y = pd->lua->getArgInt(3) - 1;
	if (FloodMap_inBounds(fm, x, y))
		pd->lua->pushInt(fm->map[x][y]);
	else
		pd->lua->pushNil();
	return 1;
}

//PARAM: x, y
static int FloodMap_setTileColliding(lua_State* L)
{
	FloodMap* fm = pd->lua->getArgObject(1, "floodMap", NULL);
	int x = pd->lua->getArgInt(2) - 1;
	int y = pd->lua->getArgInt(3) - 1;
	if (FloodMap_inBounds(fm, x, y))
		fm->collisionMask[x][y] = true;
	return 0;
}

static int FloodMap_fillMap(lua_State* L)
{
	pd->system->logToConsole("Filling Map");
	FloodMap* fm = pd->lua->getArgObject(1, "floodMap", NULL);
	FloodMap_fill(fm, fm->source->x, fm->source->y, fm->source->weight);
	return 0;
}

void FloodMap_fill(FloodMap* fm, int x, int y, int weight)
{
	// 1 = filled, 0 == not filled
	// in bounds and zone isn't filled yet (also needs to check collision mask)

	//add weight in new algo

	if (FloodMap_inBounds(fm, x, y))
	{
		if (fm->collisionMask[x][y] == false)
		{
			fm->map[x][y] = weight;

			int xx = x - 1;
			int yy = y;
			int w = weight;// +1;

			if (FloodMap_inBounds(fm, xx, yy) && (fm->map[xx][yy] == 0))
				FloodMap_fill(fm, xx, yy, w);

			xx = x + 1;
			yy = y;
			if (FloodMap_inBounds(fm, xx, yy) && (fm->map[xx][yy] == 0))
				FloodMap_fill(fm, xx, yy, w);

			xx = x;
			yy = y - 1;
			if (FloodMap_inBounds(fm, xx, yy) && (fm->map[xx][yy] == 0))
				FloodMap_fill(fm, xx, yy, w);

			xx = x;
			yy = y + 1;
			if (FloodMap_inBounds(fm, xx, yy) && (fm->map[xx][yy] == 0))
				FloodMap_fill(fm, xx, yy, w);

			//char str[3];
			//sprintf(str, "%d", w);
			//pd->system->logToConsole(str);
		}
		else
		{
			//pd->system->logToConsole("blocked");
		}
	}
	else
	{
		//pd->system->logToConsole("oob");
	}
}

bool FloodMap_inBounds(FloodMap* fm, int x, int y)
{
	return x >= 0 && x < fm->width && y >= 0 && y < fm->height;
}

//

static const lua_reg floodMapLib[] =
{
	{ "new", FloodMap_new },
	{ "__gc", FloodMap_free },
	{ "addSource", FloodMap_addSource },
	{ "getTile", FloodMap_getTile },
	{ "setTileColliding", FloodMap_setTileColliding },
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
