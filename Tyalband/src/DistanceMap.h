#ifndef DISTANCEMAP_H
#define DISTANCEMAP_H

#include "Imports.h"
#include "list.h"
#include "Vector2.h"

//NOTE: Always subtract X & Y because lua counts from 1

typedef struct DistanceMap_Source {
	int x;
	int y;
	int weight;
} DistanceMap_Source;

DistanceMap_Source* DistanceMap_Source_new(int x, int y, int weight);

typedef struct DistanceMap {
	int width;
	int height;
	bool** collisionMask;
	int** map;
	DistanceMap_Source* source;
} DistanceMap;

// PARAM: width, height
// return DistanceMap
static int DistanceMap_new(lua_State* L);
	// pass collision mask

static int DistanceMap_free(lua_State* L);
//PARAM: x, y, weight
static int DistanceMap_addSource(lua_State* L);

static int DistanceMap_getTile(lua_State* L);
static int DistanceMap_setTileColliding(lua_State* L);

bool DistanceMap_inBounds(DistanceMap* dm, int x, int y);

void Dijkstra_fill(DistanceMap* dm, int x, int y, int fromX, int FromY);

void Register_distanceMap(PlaydateAPI* p);

#endif