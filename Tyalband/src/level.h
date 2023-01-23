#ifndef LEVEL_H
#define LEVEL_H

typedef struct {

} Actor;

typedef struct {

} Player;

typedef struct {
    void* actor;

    bool inView = false;
    int lightLevel = 0;

    bool blockVision = false;
} Tile;

//void Shape_ctor(Shape * const me, int16_t x, int16_t y);

typedef struct {
    Player* player;

    Tile** grid;
    int width;
    int height;
} Level;



#endif