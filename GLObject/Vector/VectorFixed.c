#include "VectorFixed.h"

ivec3_t ivec3cross(ivec3_t a, ivec3_t b) {
	return ivec3(a.y * b.z - a.z * b.y,
	            a.z * b.x - a.x * b.z,
	            a.x * b.y - a.y * b.x);
}

