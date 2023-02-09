#include "DistanceMap.h"

static PlaydateAPI* pd;

DistanceMap_Source* DistanceMap_Source_new(int x, int y, int weight)
{
	DistanceMap_Source* fs = malloc(sizeof(*fs));
	fs->x = x;
	fs->y = y;
	fs->weight = weight;
	return fs;
}

// PARAM: width, height
static int DistanceMap_new(lua_State* L)
{
	DistanceMap* dm = malloc(sizeof(*dm));
	dm->width = pd->lua->getArgInt(1);
	dm->height = pd->lua->getArgInt(2);
	dm->source = NULL;

	dm->collisionMask = malloc(dm->width * sizeof(*(dm->collisionMask)));
	dm->map = malloc(dm->width * sizeof(*(dm->map)));
	for (int x = 0; x < dm->width; x++)
	{
		dm->collisionMask[x] = malloc(dm->height * sizeof(*(dm->collisionMask[0])));
		dm->map[x] = malloc(dm->height * sizeof(*(dm->map[0])));
		for (int y = 0; y < dm->height; y++) {
			dm->collisionMask[x][y] = false;
			dm->map[x][y] = -1;
		}
	}
	if (DEBUG_LOG)
		pd->system->logToConsole("New DistanceMap");
	pd->lua->pushObject(dm, "DistanceMap", 0);
	return 1;
}

static int DistanceMap_free(lua_State* L)
{
	DistanceMap* dm = pd->lua->getArgObject(1, "DistanceMap", NULL);
	free(dm->collisionMask);
	free(dm->map);
	free(dm->source);
	free(dm);
	if (DEBUG_LOG)
		pd->system->logToConsole("Cleaned DistanceMap");
	return 0;
}

//PARAM: x, y, weight
static int DistanceMap_addSource(lua_State* L)
{
	DistanceMap* dm = pd->lua->getArgObject(1, "DistanceMap", NULL);
	if (dm->source != NULL)
	{
		free(dm->source);
		dm->source = NULL;
	}
	// NOTE: subtract x and y by 1 because arrays count from 1 in lua
	dm->source = DistanceMap_Source_new(pd->lua->getArgInt(2) - 1, pd->lua->getArgInt(3) - 1, pd->lua->getArgInt(4));
	if (DEBUG_LOG)
		pd->system->logToConsole("Add source");
	return 0;
}

//PARAM: x, y
static int DistanceMap_getTile(lua_State* L)
{
	DistanceMap* dm = pd->lua->getArgObject(1, "DistanceMap", NULL);
	int x = pd->lua->getArgInt(2) - 1;
	int y = pd->lua->getArgInt(3) - 1;
	if (DistanceMap_inBounds(dm, x, y))
		pd->lua->pushInt(dm->map[x][y]);
	else
		pd->lua->pushNil();
	return 1;
}

//PARAM: x, y
static int DistanceMap_setTileColliding(lua_State* L)
{
	DistanceMap* dm = pd->lua->getArgObject(1, "DistanceMap", NULL);
	int x = pd->lua->getArgInt(2) - 1;
	int y = pd->lua->getArgInt(3) - 1;
	if (DistanceMap_inBounds(dm, x, y))
		dm->collisionMask[x][y] = true;
	return 0;
}

bool DistanceMap_inBounds(DistanceMap* dm, int x, int y)
{
	return x >= 0 && x < dm->width && y >= 0 && y < dm->height;
}

static int Dijkstra_fillMap(lua_State* L)
{
	DistanceMap* dm = pd->lua->getArgObject(1, "DistanceMap", NULL);

	// reset map
	for (int x = 0; x < dm->width; x++)
	{
		for (int y = 0; y < dm->height; y++) {
			dm->map[x][y] = -1;
		}
	}

	list_type(Vector2*) toCheck = NULL;
	list_set_elem_destructor(toCheck, Vector2_free);
	list_push_back(toCheck, Vector2_new(dm->source->x, dm->source->y)); 

	list_type(int) steps = NULL;
	list_push_back(steps, 0);

	int moveCost = 1;
	
	while (list_size(toCheck) != 0)
	{
		int x = toCheck[0]->x;
		int y = toCheck[0]->y;

		// see if blocked and check map again incase it was changed already
		if (dm->collisionMask[x][y] == false && dm->map[x][y] == -1)
		{
			int step = steps[0];

			dm->map[x][y] = step;
			// set value to CameFrom + 1

			int xx = x - 1;
			int yy = y;

			if (DistanceMap_inBounds(dm, xx, yy) && (dm->map[xx][yy] == -1))
			{
				list_push_back(toCheck, Vector2_new(xx, yy));
				list_push_back(steps, step + 1);
			}
				

			xx = x + 1;
			yy = y;
			if (DistanceMap_inBounds(dm, xx, yy) && (dm->map[xx][yy] == -1))
			{
				list_push_back(toCheck, Vector2_new(xx, yy));
				list_push_back(steps, step + 1);
			}

			xx = x;
			yy = y - 1;
			if (DistanceMap_inBounds(dm, xx, yy) && (dm->map[xx][yy] == -1))
			{
				list_push_back(toCheck, Vector2_new(xx, yy));
				list_push_back(steps, step + 1);
			}

			xx = x;
			yy = y + 1;
			if (DistanceMap_inBounds(dm, xx, yy) && (dm->map[xx][yy] == -1))
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
	//Dijkstra_fill(dm, dm->source->x, dm->source->y, dm->source->x, dm->source->y);
	return 0;
}

void Dijkstra_fill(DistanceMap* dm, int x, int y, int fromX, int FromY)
{
	
}


//

static const lua_reg DistanceMapLib[] =
{
	{ "new", DistanceMap_new },
	{ "__gc", DistanceMap_free },
	{ "addSource", DistanceMap_addSource },
	{ "getTile", DistanceMap_getTile },
	{ "setTileColliding", DistanceMap_setTileColliding },
	{ "fillMap", Dijkstra_fillMap },
	{ NULL, NULL }
};

void Register_distanceMap(PlaydateAPI* api)
{
	pd = api;
	const char* err;
	if (!pd->lua->registerClass("DistanceMap", DistanceMapLib, NULL, 0, &err))
		pd->system->logToConsole("%s:%i: registerClass failed, %s", __FILE__, __LINE__, err);
}
