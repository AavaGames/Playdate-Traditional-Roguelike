#ifndef FLOODFILL_H
#define FLOODFILL_H

#include "global.h"

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
static int FloodMap_map(lua_State* L);
static int FloodMap_fillMap(lua_State* L);

static void FloodMap_fill(FloodMap* map, int x, int y);

void Register_floodfill();

#endif