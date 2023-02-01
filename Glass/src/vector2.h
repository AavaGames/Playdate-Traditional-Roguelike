#ifndef VECTOR2_H
#define VECTOR2_H

#include <stdlib.h>

typedef struct Vector2 {
    int x;
    int y;
} Vector2;

Vector2* Vector2_new(int x, int y);
void Vector2_free(Vector2* v);
void Vector2_set(Vector2* v, int x, int y);

#endif