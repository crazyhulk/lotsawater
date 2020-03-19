#include "VectorComplex.h"

cvec3_t cvec3cross(cvec3_t a, cvec3_t b) {
	return cvec3(a.y * b.z - a.z * b.y,
	            a.z * b.x - a.x * b.z,
	            a.x * b.y - a.y * b.x);
}

