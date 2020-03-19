#include "QuaternionFixed.h"

iquat_t iquatmat3x3(imat3x3_t m) {
	if(imat3x3_11(m) > imat3x3_22(m) && imat3x3_11(m) > imat3x3_33(m)) {
		int32_t r = isqrt(F(1) + imat3x3_11(m) - imat3x3_22(m) - imat3x3_33(m));
		if(r == 0) return iquatone;
		return iquat(
			(imat3x3_32(m) - imat3x3_23(m)) / (2 * r),
			ivec3(
				r / 2,
				(imat3x3_12(m) + imat3x3_21(m)) / (2 * r),
				(imat3x3_31(m) + imat3x3_13(m)) / (2 * r)
				)
			);
	} else if(imat3x3_22(m) > imat3x3_11(m) && imat3x3_22(m) > imat3x3_33(m)) {
		int32_t r = isqrt(F(1) + imat3x3_22(m) - imat3x3_33(m) - imat3x3_11(m));
		if(r == 0) return iquatone;
		return iquat(
			(imat3x3_13(m) - imat3x3_31(m)) / (2 * r),
			ivec3(
				(imat3x3_12(m) + imat3x3_21(m)) / (2 * r),
				r / 2,
				(imat3x3_23(m) + imat3x3_32(m)) / (2 * r)
				)
			);
	} else {
		int32_t r = isqrt(F(1) + imat3x3_33(m) - imat3x3_11(m) - imat3x3_22(m));
		if(r == 0) return iquatone;
		return iquat(
			(imat3x3_21(m) - imat3x3_12(m)) / (2 * r),
			ivec3(
				(imat3x3_31(m) + imat3x3_13(m)) / (2 * r),
				(imat3x3_23(m) + imat3x3_32(m)) / (2 * r),
				r / 2
				)
			);
	}
}

imat3x3_t imat3x3quat(iquat_t q) {
	int32_t s2 = q.r * q.r;
	int32_t x2 = q.i.x * q.i.x;
	int32_t y2 = q.i.y * q.i.y;
	int32_t z2 = q.i.z * q.i.z;

	return imat3x3(
		s2 + x2 - y2 - z2,
		2 * (q.i.x * q.i.y - q.r * q.i.z),
		2 * (q.i.x * q.i.z + q.r * q.i.y),

		2 * (q.i.x * q.i.y + q.r * q.i.z),
		s2 - x2 + y2 - z2,
		2 * (q.i.y * q.i.z - q.r * q.i.x),

		2 * (q.i.x * q.i.z - q.r * q.i.y),
		2 * (q.i.y * q.i.z + q.r * q.i.x),
		s2 - x2 - y2 + z2);
}
