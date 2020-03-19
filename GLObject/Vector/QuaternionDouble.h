#ifndef __QUATERNION_DOUBLE_H__
#define __QUATERNION_DOUBLE_H__

#include "VectorDouble.h"
#include "MatrixDouble.h"



// Definitions

typedef struct { double r; dvec3_t i; } dquat_t;

#define dquatzero dquatreal(0)
#define dquatone dquatreal(1)



// Constructors

static inline dquat_t dquat(double r, dvec3_t i) { return (dquat_t){r, i}; }
static inline dquat_t dquatreal(double r) { return (dquat_t){r, dvec3zero}; }
static inline dquat_t dquatimag(dvec3_t i) { return (dquat_t){0, i}; }

static inline dquat_t dquatrotation(double angle, dvec3_t axis) {
	return dquat(cos(angle / 2), dvec3setlength(axis, sin(angle / 2)));
}

dquat_t dquatmat3x3(dmat3x3_t m);
static inline dquat_t dquatmat4x3(dmat4x3_t m) { return dquatmat3x3(dmat4x3_mat3x3(m)); }
static inline dquat_t dquatmat4x4(dmat4x4_t m) { return dquatmat3x3(dmat4x4_mat3x3(m)); }


// Extractors

static inline double dquat_real(dquat_t q) { return q.r; }
static inline dvec3_t dquat_imag(dquat_t q) { return q.i; }



// Unary operations

static inline double dquatsq(dquat_t q);
static inline dquat_t dquatrealdiv(dquat_t a, double b);

static inline dquat_t dquatneg(dquat_t q) { return dquat(-q.r, dvec3neg(q.i)); }
static inline dquat_t dquatconj(dquat_t q) { return dquat(q.r, dvec3neg(q.i)); }
static inline dquat_t dquatinverse(dquat_t q) { return dquatrealdiv(dquatconj(q), dquatsq(q)); }



// Comparison operations

static inline bool dquatequal(dquat_t a, dquat_t b) { return dvec3equal(a.i, b.i) && a.r == b.r; }
static inline bool dquatalmostequal(dquat_t a, dquat_t b, double epsilon) { return dvec3almostequal(a.i, b.i, epsilon) && fabs(a.r - b.r) < epsilon; }

static inline bool dquatiszero(dquat_t q) { return q.r == 0 && dvec3iszero(q.i); }
static inline bool dquatalmostzero(dquat_t q, double epsilon) { return fabs(q.r) < epsilon && dvec3almostzero(q.i, epsilon); }



// Arithmetic operations

static inline dquat_t dquatadd(dquat_t a, dquat_t b) { return dquat(a.r + b.r, dvec3add(a.i, b.i)); }
static inline dquat_t dquatsub(dquat_t a, dquat_t b) { return dquat(a.r - b.r, dvec3sub(a.i, b.i)); }
static inline dquat_t dquatmul(dquat_t a, dquat_t b) {
	return dquat(a.r * b.r - dvec3dot(a.i, b.i),
	            dvec3add3(dvec3mul(b.i, a.r), dvec3mul(a.i, b.r), dvec3cross(a.i, b.i)));
}
static inline dquat_t dquatdiv(dquat_t a, dquat_t b) { return dquatmul(a, dquatinverse(b)); }

static inline dquat_t dquatrealmul(dquat_t a, double b) { return dquat(a.r * b, dvec3mul(a.i, b)); }
static inline dquat_t dquatrealdiv(dquat_t a, double b) { return dquat(a.r / b, dvec3div(a.i, b)); }




// Norms

static inline double dquatdot(dquat_t a, dquat_t b) { return a.r * b.r + dvec3dot(a.i, b.i); }
static inline double dquatsq(dquat_t q) { return dquatdot(q, q); }
static inline double dquatabs(dquat_t q) { return sqrt(dquatsq(q)); }

static inline dquat_t dquatnorm(dquat_t q) {
	double abs = dquatabs(q);
	if(abs == 0) return dquatzero;
	else return dquatrealdiv(q, abs);
}




// Blending

static inline dquat_t dquatmix(dquat_t a, dquat_t b, double t) {
	return dquat(a.r + (b.r - a.r) * t, dvec3mix(a.i, b.i, t));
}

static inline dquat_t dquatslerp(dquat_t a, dquat_t b, double t) {
	double cos_a = dquatdot(a, b);
	if(cos_a < 0) { a = dquatneg(a); cos_a = -cos_a; }
	if(cos_a > 0.9999) return dquatnorm(dquatmix(a, b, t));

	double angle = acos(cos_a);
	double sin_a = sin(angle);
	return dquatadd(
		dquatrealmul(a, sin((1 - t) * angle) / sin_a),
		dquatrealmul(b, sin(t * angle) / sin_a));
}




// Vector transformation

static inline dvec3_t dquattransform(dquat_t q, dvec3_t v) {
	return dquatmul(dquatmul(q, dquatimag(v)), dquatconj(q)).i;
}



// Matrix conversion

dmat3x3_t dmat3x3quat(dquat_t q);
static inline dmat4x3_t dmat4x3quat(dquat_t q) { return dmat4x3affine3x3(dmat3x3quat(q), dvec3zero); }
static inline dmat4x4_t dmat4x4quat(dquat_t q) { return dmat4x4affine3x3(dmat3x3quat(q), dvec3zero); }

#endif
