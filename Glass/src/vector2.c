#include "vector2.h"

Vector2* Vector2_new(int x, int y)
{
    Vector2* v = malloc(sizeof(*v));
    v->x = x;
    v->y = y;
    return v;
}

void Vector2_free(Vector2* v)
{
    free(v);
}

void Vector2_set(Vector2* v, int x, int y) 
{
    v->x = x;
    v->y = y;
}