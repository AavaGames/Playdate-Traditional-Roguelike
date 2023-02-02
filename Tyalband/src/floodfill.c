#include "Floodfill.h"

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
			fm->map[x][y] = -1;
		}
	}
	if (DEBUG_LOG)
		pd->system->logToConsole("New Floodmap");
	pd->lua->pushObject(fm, "FloodMap", 0);
	return 1;
}

static int FloodMap_free(lua_State* L)
{
	FloodMap* fm = pd->lua->getArgObject(1, "FloodMap", NULL);
	free(fm->collisionMask);
	free(fm->map);
	free(fm->source);
	free(fm);
	if (DEBUG_LOG)
		pd->system->logToConsole("Cleaned Floodmap");
	return 0;
}

//PARAM: x, y, weight
static int FloodMap_addSource(lua_State* L)
{
	FloodMap* fm = pd->lua->getArgObject(1, "FloodMap", NULL);
	if (fm->source != NULL)
	{
		free(fm->source);
		fm->source = NULL;
	}

	FloodSource* source = malloc(sizeof(*source));
	// NOTE: subtract x and y by 1 because arrays count from 1 in lua
	source->x = pd->lua->getArgInt(2) - 1;
	source->y = pd->lua->getArgInt(3) - 1;
	source->weight = pd->lua->getArgInt(4);
	fm->source = source;
	if (DEBUG_LOG)
		pd->system->logToConsole("Add source");
	return 0;
}

//PARAM: x, y
static int FloodMap_getTile(lua_State* L)
{
	FloodMap* fm = pd->lua->getArgObject(1, "FloodMap", NULL);
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
	FloodMap* fm = pd->lua->getArgObject(1, "FloodMap", NULL);
	int x = pd->lua->getArgInt(2) - 1;
	int y = pd->lua->getArgInt(3) - 1;
	if (FloodMap_inBounds(fm, x, y))
		fm->collisionMask[x][y] = true;
	return 0;
}

bool FloodMap_inBounds(FloodMap* fm, int x, int y)
{
	return x >= 0 && x < fm->width && y >= 0 && y < fm->height;
}

static int Dijkstra_fillMap(lua_State* L)
{
	FloodMap* fm = pd->lua->getArgObject(1, "FloodMap", NULL);

	// reset map
	for (int x = 0; x < fm->width; x++)
	{
		for (int y = 0; y < fm->height; y++) {
			fm->map[x][y] = -1;
		}
	}

	list_type(Vector2*) toCheck = NULL;
	list_set_elem_destructor(toCheck, Vector2_free);
	list_push_back(toCheck, Vector2_new(fm->source->x, fm->source->y)); 

	list_type(int) steps = NULL;
	list_push_back(steps, 0);

	int moveCost = 1;
	
	while (list_size(toCheck) != 0)
	{
		int x = toCheck[0]->x;
		int y = toCheck[0]->y;

		// see if blocked and check map again incase it was changed already
		if (fm->collisionMask[x][y] == false && fm->map[x][y] == -1)
		{
			int step = steps[0];

			fm->map[x][y] = step;
			// set value to CameFrom + 1

			int xx = x - 1;
			int yy = y;

			if (FloodMap_inBounds(fm, xx, yy) && (fm->map[xx][yy] == -1))
			{
				list_push_back(toCheck, Vector2_new(xx, yy));
				list_push_back(steps, step + 1);
			}
				

			xx = x + 1;
			yy = y;
			if (FloodMap_inBounds(fm, xx, yy) && (fm->map[xx][yy] == -1))
			{
				list_push_back(toCheck, Vector2_new(xx, yy));
				list_push_back(steps, step + 1);
			}

			xx = x;
			yy = y - 1;
			if (FloodMap_inBounds(fm, xx, yy) && (fm->map[xx][yy] == -1))
			{
				list_push_back(toCheck, Vector2_new(xx, yy));
				list_push_back(steps, step + 1);
			}

			xx = x;
			yy = y + 1;
			if (FloodMap_inBounds(fm, xx, yy) && (fm->map[xx][yy] == -1))
			{
				list_push_back(toCheck, Vector2_new(xx, yy));
				list_push_back(steps, step + 1);
			}
		}
		list_erase(toCheck, 0); // remove first element
		list_erase(steps, 0);
	}

	if (DEBUG_LOG)
		pd->system->logToConsole("Filled Map");
	//Dijkstra_fill(fm, fm->source->x, fm->source->y, fm->source->x, fm->source->y);
	return 0;
}

void Dijkstra_fill(FloodMap* fm, int x, int y, int fromX, int FromY)
{
	
}


//

static const lua_reg FloodMapLib[] =
{
	{ "new", FloodMap_new },
	{ "__gc", FloodMap_free },
	{ "addSource", FloodMap_addSource },
	{ "getTile", FloodMap_getTile },
	{ "setTileColliding", FloodMap_setTileColliding },
	{ "fillMap", Dijkstra_fillMap },
	{ NULL, NULL }
};

void Register_floodfill(PlaydateAPI* api)
{
	pd = api;
	const char* err;
	if (!pd->lua->registerClass("FloodMap", FloodMapLib, NULL, 0, &err))
		pd->system->logToConsole("%s:%i: registerClass failed, %s", __FILE__, __LINE__, err);
}
