#ifndef DISTANCEMAP_H
#define DISTANCEMAP_H

#include "Imports.h"
#include "list.h"
#include "Vector2.h"
#include "CollisionMask.h"

static enum Direction
{
	North,
	East,
	South,
	West
};

Vector2* Direction_getVector(enum Direction dir);

//NOTE: Always subtract X & Y because lua counts from 1

typedef struct DistanceMap_Source {
	int x;
	int y;
	int weight;
} DistanceMap_Source;

DistanceMap_Source* DistanceMap_Source_new(int x, int y, int weight);
void* DistanceMap_Source_free(DistanceMap_Source* source);

typedef struct DistanceMap {
	int width;
	int height;
	CollisionMask* collisionMask;
	int** map;
	DistanceMap_Source* centerSource;
	list_type(DistanceMap_Source*) sources;
	uint16_t stepLimit;
} DistanceMap;

// PARAM: width, height
// return DistanceMap
static int DistanceMap_new(lua_State* L);
	// pass collision mask

static int DistanceMap_free(lua_State* L);
//PARAM: x, y, weight
static int DistanceMap_addSource(lua_State* L);
static int DistanceMap_addCenterSource(lua_State* L);
static int DistanceMap_clearSources(lua_State* L);

static int DistanceMap_getTile(lua_State* L);
static int DistanceMap_getStep(lua_State* L);
static int DistanceMap_getPath(lua_State* L);

static int DistanceMap_setRangeLimit(lua_State* L);

bool DistanceMap_inBounds(DistanceMap* dm, int x, int y);
enum Direction DistanceMap_lowestNeighbor(DistanceMap* dm, int x, int y);

static int Dijkstra_fillMap(lua_State* L);

void Register_DistanceMap(PlaydateAPI* p);

#endif