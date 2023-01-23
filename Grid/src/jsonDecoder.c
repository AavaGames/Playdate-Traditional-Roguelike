#include "jsonDecoder.h"

void decodeError(json_decoder* decoder, const char* error, int linenum)
{
	//pd->system->logToConsole("decode error line %i: %s", linenum, error);
}

const char* typeToName(json_value_type type)
{
	switch (type)
	{
	case kJSONNull: return "null";
	case kJSONTrue: return "true";
	case kJSONFalse: return "false";
	case kJSONInteger: return "integer";
	case kJSONFloat: return "float";
	case kJSONString: return "string";
	case kJSONArray: return "array";
	case kJSONTable: return "table";
	default: return "???";
	}
}

void willDecodeSublist(json_decoder* decoder, const char* name, json_value_type type)
{
	//pd->system->logToConsole("%s willDecodeSublist %s %s", decoder->path, typeToName(type), name);
}

int shouldDecodeTableValueForKey(json_decoder* decoder, const char* key)
{
	//pd->system->logToConsole("%s shouldDecodeTableValueForKey %s", decoder->path, key);
	return 1;
}

void didDecodeTableValue(json_decoder* decoder, const char* key, json_value value)
{
	//pd->system->logToConsole("%s didDecodeTableValue %s %s", decoder->path, key, typeToName(value.type));
}

int shouldDecodeArrayValueAtIndex(json_decoder* decoder, int pos)
{
	//pd->system->logToConsole("%s shouldDecodeArrayValueAtIndex %i", decoder->path, pos);
	return 1;
}

void didDecodeArrayValue(json_decoder* decoder, int pos, json_value value)
{
	//pd->system->logToConsole("%s didDecodeArrayValue %i %s", decoder->path, pos, typeToName(value.type));
}

void* didDecodeSublist(json_decoder* decoder, const char* name, json_value_type type)
{
	//pd->system->logToConsole("%s didDecodeSublist %s %s", decoder->path, typeToName(type), name);
	return NULL;
}

json_decoder JSON_GetDecoder()
{
	json_decoder decoder =
	{
		.decodeError = decodeError,
		.willDecodeSublist = willDecodeSublist,
		.shouldDecodeTableValueForKey = shouldDecodeTableValueForKey,
		.didDecodeTableValue = didDecodeTableValue,
		.shouldDecodeArrayValueAtIndex = shouldDecodeArrayValueAtIndex,
		.didDecodeArrayValue = didDecodeArrayValue,
		.didDecodeSublist = didDecodeSublist
	};
	return decoder;
}