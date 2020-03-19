#ifndef __QUATERNION_FIXED_H__
#define __QUATERNION_FIXED_H__

#include "VectorFixed.h"
#include "MatrixFixed.h"



// Definitions

typedef struct { int32_t r; ivec3_t i; } iquat_t;

#define iquatzero iquatreal(0)
#define iquatone iquatreal(F(1))



// Constructors

static inline iquat_t iquat(int32_t r, ivec3_t i) { return (iquat_t){r, i}; }
static inline iquat_t iquatreal(int32_t r) { return (iquat_t){r, ivec3zero}; }
static inline iquat_t iquatimag(ivec3_t i) { return (iquat_t){0, i}; }

static inline iquat_t iquatrotation(int angle, ivec3_t axis) {
	return iquat(icos(angle / 2), ivec3setlength(axis, isin(angle / 2)));
}

iquat_t iquatmat3x3(imat3x3_t m);
static inline iquat_t iquatmat4x3(imat4x3_t m) { return iquatmat3x3(imat4x3_mat3x3(m)); }
static inline iquat_t iquatmat4x4(imat4x4_t m) { return iquatmat3x3(imat4x4_mat3x3(m)); }


// Extractors

static inline int32_t iquat_real(iquat_t q) { return q.r; }
static inline ivec3_t iquat_imag(iquat_t q) { return q.i; }



// Unary operations

static inline int32_t iquatsq(iquat_t q);
static inline iquat_t iquatrealdiv(iquat_t a, int32_t b);

static inline iquat_t iquatneg(iquat_t q) { return iquat(-q.r, ivec3neg(q.i)); }
static inline iquat_t iquatconj(iquat_t q) { return iquat(q.r, ivec3neg(q.i)); }
static inline iquat_t iquatinverse(iquat_t q) { return iquatrealdiv(iquatconj(q), iquatsq(q)); }



// Comparison operations

static inline bool iquatequal(iquat_t a, iquat_t b) { return ivec3equal(a.i, b.i) && a.r == b.r; }
static inline bool iquatalmostequal(iquat_t a, iquat_t b, int32_t epsilon) { return ivec3almostequal(a.i, b.i, epsilon) && abs(a.r - b.r) < epsilon; }

static inline bool iquatiszero(iquat_t q) { return q.r == 0 && ivec3iszero(q.i); }
static inline bool iquatalmostzero(iquat_t q, int32_t epsilon) { return abs(q.r) < epsilon && ivec3almostzero(q.i, epsilon); }



// Arithmetic operations

static inline iquat_t iquatadd(iquat_t a, iquat_t b) { return iquat(a.r + b.r, ivec3add(a.i, b.i)); }
static inline iquat_t iquatsub(iquat_t a, iquat_t b) { return iquat(a.r - b.r, ivec3sub(a.i, b.i)); }
static inline iquat_t iquatmul(iquat_t a, iquat_t b) {
	return iquat(a.r * b.r - ivec3dot(a.i, b.i),
	            ivec3add3(ivec3mul(b.i, a.r), ivec3mul(a.i, b.r), ivec3cross(a.i, b.i)));
}
static inline iquat_t iquatdiv(iquat_t a, iquat_t b) { return iquatmul(a, iquatinverse(b)); }

static inline iquat_t iquatrealmul(iquat_t a, int32_t b) { return iquat(a.r * b, ivec3mul(a.i, b)); }
static inline iquat_t iquatrealdiv(iquat_t a, int32_t b) { return iquat(a.r / b, ivec3div(a.i, b)); }




// Norms

static inline int32_t iquatdot(iquat_t a, iquat_t b) { return a.r * b.r + ivec3dot(a.i, b.i); }
static inline int32_t iquatsq(iquat_t q) { return iquatdot(q, q); }
static inline int32_t iquatabs(iquat_t q) { return isqrt(iquatsq(q)); }

static inline iquat_t iquatnorm(iquat_t q) {
	int32_t abs = iquatabs(q);
	if(abs == 0) return iquatzero;
	else return iquatrealdiv(q, abs);
}




// Blending

static inline iquat_t iquatmix(iquat_t a, iquat_t b, int32_t t) {
	return iquat(a.r + (b.r - a.r) * t, ivec3mix(a.i, b.i, t));
}

/*static inline iquat_t iquatslerp(iquat_t a, iquat_t b, int32_t t) {
	int32_t cos_a = iquatdot(a, b);
	if(cos_a < 0) { a = iquatneg(a); cos_a = -cos_a; }
	if(cos_a > 0.9999) return iquatnorm(iquatmix(a, b, t));

	int angle = iacos(cos_a);
	int32_t sin_a = isin(angle);
	return iquatadd(
		iquatrealmul(a, isin((F(1) - t) * angle) / sin_a),
		iquatrealmul(b, isin(t * angle) / sin_a));
}*/




// Vector transformation

static inline ivec3_t iquattransform(iquat_t q, ivec3_t v) {
	return iquatmul(iquatmul(q, iquatimag(v)), iquatconj(q)).i;
}



// Matrix conversion

imat3x3_t imat3x3quat(iquat_t q);
static inline imat4x3_t imat4x3quat(iquat_t q) { return imat4x3affine3x3(imat3x3quat(q), ivec3zero); }
static inline imat4x4_t imat4x4quat(iquat_t q) { return imat4x4affine3x3(imat3x3quat(q), ivec3zero); }

#endif
