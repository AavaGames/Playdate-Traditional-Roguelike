#include "level.h"

int dungeon[] = { 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 3, 1, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 1, 0, 0, 0, 1, 3, 1, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 3, 1, 0, 0, 0, 1, 3, 1, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 0, 1, 3, 1, 0, 0, 0, 1, 3, 1, 0, 0, 0, 0, 0,
0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 0, 1, 3, 1, 0, 0, 0, 1, 3, 1, 0, 0, 0, 0, 0,
0, 0, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 3, 3, 1, 0, 1, 3, 1, 0, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1,
0, 0, 1, 3, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 0, 1, 3, 1, 0, 1, 3, 3, 3, 3, 3, 3, 3, 3, 1,
0, 0, 1, 3, 1, 0, 0, 0, 0, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 0, 1, 3, 1, 0, 1, 3, 3, 3, 3, 3, 1, 3, 3, 1,
0, 0, 1, 3, 1, 0, 0, 0, 0, 1, 1, 1, 3, 1, 1, 1, 1, 3, 1, 1, 1, 1, 3, 1, 1, 1, 3, 3, 3, 3, 3, 3, 1, 3, 1,
1, 1, 1, 3, 1, 0, 0, 0, 0, 0, 0, 1, 3, 1, 0, 0, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1,
1, 3, 3, 3, 1, 0, 0, 0, 0, 0, 0, 1, 3, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3, 1,
1, 3, 3, 3, 1, 0, 0, 0, 0, 0, 0, 1, 3, 3, 3, 3, 3, 3, 1, 0, 0, 0, 0, 0, 0, 1, 3, 3, 3, 3, 3, 3, 3, 3, 1,
1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 3, 1, 1, 1, 1, 3, 1, 0, 0, 0, 0, 0, 0, 1, 1, 3, 3, 3, 3, 3, 3, 3, 1,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 1, 0, 0, 1, 3, 1, 0, 0, 0, 0, 0, 0, 1, 3, 1, 3, 3, 3, 3, 1, 3, 1,
0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 0, 0, 0, 0, 1, 3, 3, 1, 3, 1, 1, 3, 3, 1,
0, 0, 0, 0, 0, 0, 0, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 0, 0, 0, 0, 1, 3, 3, 3, 3, 3, 3, 3, 3, 1,
0, 0, 0, 0, 0, 0, 0, 1, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 1, 0, 0, 0, 0, 1, 3, 3, 3, 3, 3, 3, 3, 3, 1,
0, 0, 0, 0, 0, 0, 0, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
0, 0, 0, 0, 0, 0, 0, 1, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 1, 3, 3, 3, 3, 3, 3, 1, 1, 3, 3, 3, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
int dungeonHeight = 24;
int dungeonWidth = 35;

void Vector2_Set(Vector2 v, int x, int y)
{
	v.x = x;
	v.y = y;
}

void Actor_new(Actor* actor, int x, int y)
{
	actor->name = "Actor";
	Vector2_Set(actor->position, x, y);
}

Vector2 Actor_GetPosition(Actor* actor)
{
	return actor->position;
}

Feature* Feature_new(char* name, char* character, bool collision)
{
	Feature* f = malloc(sizeof(*f));
	f->name = name;
	f->character = character;
	f->collision = collision;
	return f;
}

Level* Level_new_json(char* jsonPath)
{
	char* path = "/assets/dungeon.json";

	SDFile* file = pd->file->open(path, kFileRead);
	if (file == NULL)
		pd->system->logToConsole(pd->file->geterr());
	json_value json;
	json_decoder decoder = JSON_GetDecoder();
	pd->json->decode(&decoder, (json_reader) { .read = pd->file->read, .userdata = file }, & json);
	pd->file->close(file);

	//pd->system->logToConsole(json.data.stringval);
	pd->system->logToConsole("End of test");

	Level* level = malloc(sizeof * level);
	//level.height = 0;

	return level;
}

Level* Level_new()
{
	Level* level = malloc(sizeof(*level));
	if (level)
	{
		level->name = "Dungeon";
		level->width = dungeonWidth;
		level->height = dungeonHeight;

		level->tiles = malloc(level->width * sizeof(*(level->tiles)));
		for (int x = 0; x < level->width; x++)
		{
			level->tiles[x] = malloc(level->height * sizeof(*(level->tiles[0])));
			for (int y = 0; y < level->height; y++) {

				int d = dungeon[x + y * dungeonWidth];
				Tile* tile = &(level->tiles[x][y]);
				Vector2_Set(tile->position, x, y);

				switch (d)
				{
				//case 0: // nil
				//	tile->feature = NULL;
				//	break;
				case 1: // wall
					tile->feature = Feature_new("Wall", "#", true);
					tile->blocksVision = true;
					break;
				//case 2: // nothing
				//	tile->feature = NULL;
				//	break;
				case 3: // ground
					tile->feature = Feature_new("Ground", ".", false);
					tile->blocksVision = false;
					break;
				default:
					tile->feature = NULL;
					break;
				}
				level->tiles[x][y].seen = true;
			}
		}

		return level;
	}
	else
		return NULL;
}



void Level_free(Level* level)
{
	free(level->tiles);
	//list_free(level->features);
	//list_free(level->actors);
}

void json_test(char* jsonPath) {
	//json_decoder decoder = JSON_GetDecoder();
	SDFile* file;
	file = pd->file->open(jsonPath, kFileRead);
	if (file == NULL)
		pd->system->logToConsole(pd->file->geterr());
	json_value json;
	//pd->json->decode(&decoder, (json_reader) { .read = pd->file->read, .userdata = file }, &json);
	//pd->file->close(file);

	pd->system->logToConsole("End of test");
}

static int Container_new(lua_State* L)
{
	Container* con = malloc(sizeof(*con));
	con->name = "Beeg";
	con->size = 5;

	int* num[] = { 5, 12, 3, 4, 8 };
	con->numbers = num;

	con->grid = malloc(con->size * sizeof(*(con->grid)));
	for (int x = 0; x < con->size; x++)
	{
		con->grid[x] = malloc(con->size * sizeof(*(con->grid[0])));
		for (int y = 0; y < con->size; y++) {
			con->grid[x][y] = x + y;
		}
	}

	pd->lua->pushObject(con, "Container", 0);
	return 1;
}

static int Container_getName(lua_State* L)
{
	// get from args then push X
	return 1;
}

static int Container_getSize(lua_State* L)
{
	return 1;
}

static int Container_getNumbers(lua_State* L)
{
	return 1;
}

static int Container_getGrid(lua_State* L)
{
	return 1;
}

static const lua_reg containerLib[] =
{
	{ "new", Container_new },
	{ "getName", Container_getName },
	{ "getSize", Container_getSize },
	{ "getNumbers", Container_getNumbers },
	{ "getGrid", Container_getGrid },
	{ NULL, NULL }
};

void RegisterContainer()
{
	const char* err;
	pd->lua->registerClass("Container", containerLib, NULL, 0, err);
}