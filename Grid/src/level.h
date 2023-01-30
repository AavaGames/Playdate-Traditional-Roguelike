#ifndef LEVEL_H
#define LEVEL_H

#include "list.h"
#include "global.h"
#include "jsonDecoder.h"

typedef struct Vector2 {
    int x;
    int y;
} Vector2;

void Vector2_Set(Vector2 v, int x, int y);

typedef struct Actor {
    char* name;
    Vector2 position;

    char character;
} Actor;

void Actor_new(Actor* actor, int x, int y);
Vector2 Actor_GetPosition(Actor* actor);

typedef struct Player {
    Actor super;
} Player;

typedef struct Feature {
    char* name;
    char* character;
    bool collision;
} Feature;

Feature* Feature_new(char* name, char* character, bool collision);

//make a con for this

typedef struct Tile {
    Vector2 position;

    Feature* feature;
    Actor* actor;
    //Item* item;
    //Effect*
    //Triggers*

    bool seen;
    bool glow;
    bool blocksVision;

    bool inView;
    int lightLevel;
    //Sources* []
} Tile;

typedef struct Level {
    char* name;
    int depth;

    Player* player;

    Tile** tiles;

    //list_type(Feature*) features;
    //list_type(Actor*) actors;

    int width;
    int height;
} Level;

//struct Level* Level_new(int height, int width);
Level* Level_new_json(char* jsonPath);
Level* Level_new();
void Level_free(Level* level);

void json_test(char* jsonPath);
#endif