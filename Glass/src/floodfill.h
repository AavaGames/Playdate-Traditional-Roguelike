#ifndef FLOODFILL_H
#define FLOODFILL_H

#include "global.h"
#include "list.h"
#include "vector2.h"

//NOTE: Always subtract X & Y because lua counts from 1

typedef struct FloodSource {
	int x;
	int y;
	int weight;
} FloodSource;

FloodSource* FloodSource_new(int x, int y, int weight);

typedef struct FloodMap {
	int width;
	int height;
	bool** collisionMask;
	int** map;
	FloodSource* source;
} FloodMap;

// PARAM: width, height
// return FloodMap
static int FloodMap_new(lua_State* L);
	// pass collision mask

static int FloodMap_free(lua_State* L);
//PARAM: x, y, weight
static int FloodMap_addSource(lua_State* L);

static int FloodMap_getTile(lua_State* L);
static int FloodMap_setTileColliding(lua_State* L);

bool FloodMap_inBounds(FloodMap* fm, int x, int y);

void Dijkstra_fill(FloodMap* fm, int x, int y, int fromX, int FromY);

void Register_floodfill(PlaydateAPI* p);

#endif