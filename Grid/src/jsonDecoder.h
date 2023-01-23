#ifndef JSON_DECODER_H
#define JSON_DECODER_H

#include "global.h"

void decodeError(json_decoder* decoder, const char* error, int linenum);
const char* typeToName(json_value_type type);
void willDecodeSublist(json_decoder* decoder, const char* name, json_value_type type);
int shouldDecodeTableValueForKey(json_decoder* decoder, const char* key);
void didDecodeTableValue(json_decoder* decoder, const char* key, json_value value);
int shouldDecodeArrayValueAtIndex(json_decoder* decoder, int pos);
void didDecodeArrayValue(json_decoder* decoder, int pos, json_value value);
void* didDecodeSublist(json_decoder* decoder, const char* name, json_value_type type);
json_decoder JSON_GetDecoder();

#endif