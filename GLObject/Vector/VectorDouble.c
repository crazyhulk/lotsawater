#include "VectorDouble.h"

dvec3_t dvec3cross(dvec3_t a, dvec3_t b) {
	return dvec3(a.y * b.z - a.z * b.y,
	            a.z * b.x - a.x * b.z,
	            a.x * b.y - a.y * b.x);
}

