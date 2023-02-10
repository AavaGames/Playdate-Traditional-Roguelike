#ifndef COLLISIONMASK_H
#define COLLISIONMASK_H

#include "Imports.h"

//NOTE: Always subtract X & Y because lua counts from 1

typedef struct CollisionMask {
	int width;
	int height;
	bool** mask;
} CollisionMask;

//PARAM: GridDimension.x, GridDimension.y
static int CollisionMask_new(lua_State* L);
static int CollisionMask_free(lua_State* L);

bool CollisionMask_inBounds(CollisionMask* dm, int x, int y);
static int CollisionMask_setTileFloor(lua_State* L);

bool CollisionMask_collision(CollisionMask* dm, int x, int y);

void Register_CollisionMask(PlaydateAPI* p);

#endif