#include "QuaternionDouble.h"

dquat_t dquatmat3x3(dmat3x3_t m) {
	if(dmat3x3_11(m) > dmat3x3_22(m) && dmat3x3_11(m) > dmat3x3_33(m)) {
		double r = sqrt(1 + dmat3x3_11(m) - dmat3x3_22(m) - dmat3x3_33(m));
		if(r == 0) return dquatone;
		return dquat(
			(dmat3x3_32(m) - dmat3x3_23(m)) / (2 * r),
			dvec3(
				r / 2,
				(dmat3x3_12(m) + dmat3x3_21(m)) / (2 * r),
				(dmat3x3_31(m) + dmat3x3_13(m)) / (2 * r)
				)
			);
	} else if(dmat3x3_22(m) > dmat3x3_11(m) && dmat3x3_22(m) > dmat3x3_33(m)) {
		double r = sqrt(1 + dmat3x3_22(m) - dmat3x3_33(m) - dmat3x3_11(m));
		if(r == 0) return dquatone;
		return dquat(
			(dmat3x3_13(m) - dmat3x3_31(m)) / (2 * r),
			dvec3(
				(dmat3x3_12(m) + dmat3x3_21(m)) / (2 * r),
				r / 2,
				(dmat3x3_23(m) + dmat3x3_32(m)) / (2 * r)
				)
			);
	} else {
		double r = sqrt(1 + dmat3x3_33(m) - dmat3x3_11(m) - dmat3x3_22(m));
		if(r == 0) return dquatone;
		return dquat(
			(dmat3x3_21(m) - dmat3x3_12(m)) / (2 * r),
			dvec3(
				(dmat3x3_31(m) + dmat3x3_13(m)) / (2 * r),
				(dmat3x3_23(m) + dmat3x3_32(m)) / (2 * r),
				r / 2
				)
			);
	}
}

dmat3x3_t dmat3x3quat(dquat_t q) {
	double s2 = q.r * q.r;
	double x2 = q.i.x * q.i.x;
	double y2 = q.i.y * q.i.y;
	double z2 = q.i.z * q.i.z;

	return dmat3x3(
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
