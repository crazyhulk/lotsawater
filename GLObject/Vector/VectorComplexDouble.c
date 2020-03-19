#include "VectorComplexDouble.h"

cdvec3_t cdvec3cross(cdvec3_t a, cdvec3_t b) {
	return cdvec3(a.y * b.z - a.z * b.y,
	            a.z * b.x - a.x * b.z,
	            a.x * b.y - a.y * b.x);
}

