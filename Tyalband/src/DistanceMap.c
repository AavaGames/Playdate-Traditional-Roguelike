#include "DistanceMap.h"

static PlaydateAPI* pd;

const static int BASE_VALUE = 99999;

Vector2* Direction_getVector(enum Direction dir)
{
	switch (dir)
	{
	case North:
		return Vector2_new(0, -1);
		break;
	case East:
		return Vector2_new(1, 0);
		break;
	case South:
		return Vector2_new(0, 1);
		break;
	case West:
		return Vector2_new(-1, 0);
		break;
	default:
		if (DEBUG_LOG)
			pd->system->logToConsole("C: Invalid Direction for Vector");
		return NULL;
		break;
	}
}

DistanceMap_Source* DistanceMap_Source_new(int x, int y, int weight)
{
	DistanceMap_Source* fs = malloc(sizeof(*fs));
	fs->x = x;
	fs->y = y;
	fs->weight = weight;
	return fs;
}

void* DistanceMap_Source_free(DistanceMap_Source* source)
{
	free(source);
}

// PARAM: width, height, stepLimit
static int DistanceMap_new(lua_State* L)
{
	DistanceMap* dm = malloc(sizeof(*dm));
	dm->width = pd->lua->getArgInt(1);
	dm->height = pd->lua->getArgInt(2);
	dm->collisionMask = pd->lua->getArgObject(3, "CollisionMask", NULL);
	dm->stepLimit = pd->lua->getArgInt(4);
	dm->centerSource = NULL;
	dm->sources = NULL;
	list_set_elem_destructor(dm->sources, DistanceMap_Source_free);

	dm->map = malloc(dm->width * sizeof(*(dm->map)));
	for (int x = 0; x < dm->width; x++)
	{
		dm->map[x] = malloc(dm->height * sizeof(*(dm->map[0])));
		for (int y = 0; y < dm->height; y++) {
			dm->map[x][y] = BASE_VALUE;
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
	free(dm->map);
	free(dm->centerSource);
	list_free(dm->sources);
	free(dm);
	if (DEBUG_LOG)
		pd->system->logToConsole("Cleaned DistanceMap");
	return 0;
}

//PARAM: x, y, weight
static int DistanceMap_addSource(lua_State* L)
{
	DistanceMap* dm = pd->lua->getArgObject(1, "DistanceMap", NULL);
	// NOTE: subtract x and y by 1 because arrays count from 1 in lua
	list_push_back(dm->sources, DistanceMap_Source_new(pd->lua->getArgInt(2) - 1, pd->lua->getArgInt(3) - 1, pd->lua->getArgInt(4)));
	if (DEBUG_LOG)
		pd->system->logToConsole("Add source");
	return 0;
}

//PARAM: x, y, weight
static int DistanceMap_addCenterSource(lua_State* L)
{
	DistanceMap* dm = pd->lua->getArgObject(1, "DistanceMap", NULL);
	if (dm->centerSource != NULL)
	{
		free(dm->centerSource);
		dm->centerSource = NULL;
	}
	// NOTE: subtract x and y by 1 because arrays count from 1 in lua
	dm->centerSource = DistanceMap_Source_new(pd->lua->getArgInt(2) - 1, pd->lua->getArgInt(3) - 1, pd->lua->getArgInt(4));
	if (DEBUG_LOG)
		pd->system->logToConsole("Add center source");
	return 0;
}

static int DistanceMap_clearSources(lua_State* L)
{
	DistanceMap* dm = pd->lua->getArgObject(1, "DistanceMap", NULL);
	free(dm->centerSource);
	dm->centerSource = NULL;
	list_free(dm->sources);
	dm->sources = NULL;
	if (DEBUG_LOG)
		pd->system->logToConsole("Cleared sources");
	return 0;
}

//PARAM: x, y
static int DistanceMap_getTile(lua_State* L)
{
	DistanceMap* dm = pd->lua->getArgObject(1, "DistanceMap", NULL);
	int x = pd->lua->getArgInt(2) - 1;
	int y = pd->lua->getArgInt(3) - 1;
	if (DistanceMap_inBounds(dm, x, y) && dm->map[x][y] != BASE_VALUE)
		pd->lua->pushInt(dm->map[x][y]);
	else
		pd->lua->pushNil();
	return 1;
}

//PARAM: x, y
// returns direction of lowest neightbor
static int DistanceMap_getStep(lua_State* L)
{
	DistanceMap* dm = pd->lua->getArgObject(1, "DistanceMap", NULL);
	int x = pd->lua->getArgInt(2) - 1;
	int y = pd->lua->getArgInt(3) - 1;
	enum Direction dir = DistanceMap_lowestNeighbor(dm, x, y);
	if (dir > -1)
	{
		Vector2* direction = Direction_getVector(dir);
		if (direction != NULL)
		{
			pd->lua->pushInt(direction->x);
			pd->lua->pushInt(direction->y);
			return 2;
		}
	}
	pd->lua->pushNil();
	return 1;
}

//PARAM: x, y
static int DistanceMap_getPath(lua_State* L)
{

}

static int DistanceMap_setRangeLimit(lua_State* L)
{
	DistanceMap* dm = pd->lua->getArgObject(1, "DistanceMap", NULL);
	dm->stepLimit = pd->lua->getArgInt(2);
	return 0;
}

bool DistanceMap_inBounds(DistanceMap* dm, int x, int y)
{
	return x >= 0 && x < dm->width && y >= 0 && y < dm->height;
}

// Returns the lowest neighbor that is lower than the tile
enum Direction DistanceMap_lowestNeighbor(DistanceMap* dm, int x, int y)
{
	int n = dm->map[x][y];
	enum Direction dir = -1;

	int xx = x;
	int yy = y - 1;
	if (DistanceMap_inBounds(dm, xx, yy) && dm->map[xx][yy] < n)
	{
		n = dm->map[xx][yy];
		dir = North;
	}

	xx = x + 1;
	yy = y;
	if (DistanceMap_inBounds(dm, xx, yy) && dm->map[xx][yy] < n)
	{
		n = dm->map[xx][yy];
		dir = East;
	}

	xx = x;
	yy = y + 1;
	if (DistanceMap_inBounds(dm, xx, yy) && dm->map[xx][yy] < n)
	{
		n = dm->map[xx][yy];
		dir = South;
	}

	xx = x - 1;
	yy = y;
	if (DistanceMap_inBounds(dm, xx, yy) && dm->map[xx][yy] < n)
	{
		n = dm->map[xx][yy];
		dir = West;
	}
	
	return dir;
}

static int Dijkstra_fillMap(lua_State* L)
{
	DistanceMap* dm = pd->lua->getArgObject(1, "DistanceMap", NULL);

	// reset map
	for (int x = 0; x < dm->width; x++)
	{
		for (int y = 0; y < dm->height; y++) {
			dm->map[x][y] = BASE_VALUE;
		}
	}

	list_type(Vector2*) toCheck = NULL;
	list_type(int) steps = NULL;

	list_set_elem_destructor(toCheck, Vector2_free);

	list_push_back(toCheck, Vector2_new(dm->centerSource->x, dm->centerSource->y));
	list_push_back(steps, dm->centerSource->weight);
	for (int i = 0; i < list_size(dm->sources); ++i) {
		DistanceMap_Source* source = dm->sources[i];
		list_push_back(toCheck, Vector2_new(source->x, source->y));
		list_push_back(steps, source->weight);
	}

	// TODO change rangelimit from step limit to square around primary target

	// TODO could implement a tile move cost along with blocking for water, grease, etc.
	// int tileMoveCost = 1;
	
	while (list_size(toCheck) != 0)
	{
		int x = toCheck[0]->x;
		int y = toCheck[0]->y;
		int step = steps[0];

		// see if blocked and check map again incase it was changed already
		if (step < dm->stepLimit && !CollisionMask_collision(dm->collisionMask, x, y) && dm->map[x][y] > step)
		{
			dm->map[x][y] = step;
			// set value to CameFrom + 1

			int xx = x - 1;
			int yy = y;
			if (DistanceMap_inBounds(dm, xx, yy) && (dm->map[xx][yy] >= step + 1))
			{
				list_push_back(toCheck, Vector2_new(xx, yy));
				list_push_back(steps, step + 1);
			}
				

			xx = x + 1;
			yy = y;
			if (DistanceMap_inBounds(dm, xx, yy) && (dm->map[xx][yy] >= step + 1))
			{
				list_push_back(toCheck, Vector2_new(xx, yy));
				list_push_back(steps, step + 1);
			}

			xx = x;
			yy = y - 1;
			if (DistanceMap_inBounds(dm, xx, yy) && (dm->map[xx][yy] >= step + 1))
			{
				list_push_back(toCheck, Vector2_new(xx, yy));
				list_push_back(steps, step + 1);
			}

			xx = x;
			yy = y + 1;
			if (DistanceMap_inBounds(dm, xx, yy) && (dm->map[xx][yy] >= step + 1))
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
	return 0;
}

//

static const lua_reg DistanceMapLib[] =
{
	{ "new", DistanceMap_new },
	{ "__gc", DistanceMap_free },
	{ "addSource", DistanceMap_addSource },
	{ "addCenterSource", DistanceMap_addCenterSource },
	{ "clearSources", DistanceMap_clearSources },
	{ "getStep", DistanceMap_getStep },
	{ "getTile", DistanceMap_getTile },
	{ "setRangeLimit", DistanceMap_setRangeLimit },
	{ "fillMap", Dijkstra_fillMap },
	{ NULL, NULL }
};

void Register_DistanceMap(PlaydateAPI* api)
{
	pd = api;
	const char* err;
	if (!pd->lua->registerClass("DistanceMap", DistanceMapLib, NULL, 0, &err))
		pd->system->logToConsole("%s:%i: registerClass failed, %s", __FILE__, __LINE__, err);
}
