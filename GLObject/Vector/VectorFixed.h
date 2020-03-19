#ifndef __VECTOR_FIXED_H__
#define __VECTOR_FIXED_H__

#include "Integer.h"
#include <stdbool.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif




// Definitions

typedef struct { int32_t x, y; } ivec2_t;
typedef struct { int32_t x, y, z; } ivec3_t;
typedef struct { int32_t x, y, z, w; } ivec4_t;

#define VEC2(a, b) ((ivec2_t) { .x = (a), .y = (b) })
#define VEC3(a, b, c) ((ivec3_t) { .x = (a), .y = (b), .z = (c) })
#define VEC4(a, b, c, d) ((ivec4_t) { .x = (a), .y = (b), .z = (c), .w = (d) })

#define ivec2zero ivec2(0, 0)
#define ivec3zero ivec3(0, 0, 0)
#define ivec4zero ivec4(0, 0, 0, 0)



// Constructors

static inline ivec2_t ivec2(int32_t x, int32_t y) { return (ivec2_t) {x, y}; }
static inline ivec3_t ivec3(int32_t x, int32_t y, int32_t z) { return (ivec3_t) {x, y, z}; }
static inline ivec4_t ivec4(int32_t x, int32_t y, int32_t z, int32_t w) { return (ivec4_t) {x, y, z, w}; }

static inline ivec2_t ivec2cyl(int32_t r, int angle) {
	return ivec2(r * icos(angle), r * isin(angle));
}

static inline ivec4_t ivec4vec3(ivec3_t v) { return ivec4(v.x, v.y, v.z, F(1)); }


// Extractors

static inline ivec2_t ivec3_xy(ivec3_t v) { return ivec2(v.x, v.y); }
static inline ivec2_t ivec3_xz(ivec3_t v) { return ivec2(v.x, v.z); }
static inline ivec2_t ivec3_yz(ivec3_t v) { return ivec2(v.y, v.z); }

static inline ivec3_t ivec4_xyz(ivec4_t v) { return ivec3(v.x, v.y, v.z); }



// Unary operations

static inline ivec2_t ivec2neg(ivec2_t v) { return ivec2(-v.x, -v.y); }
static inline ivec3_t ivec3neg(ivec3_t v) { return ivec3(-v.x, -v.y, -v.z); }
static inline ivec4_t ivec4neg(ivec4_t v) { return ivec4(-v.x, -v.y, -v.z, -v.w); }



// Comparison operations

static inline bool ivec2equal(ivec2_t a, ivec2_t b) { return a.x == b.x && a.y == b.y; }
static inline bool ivec3equal(ivec3_t a, ivec3_t b) { return a.x == b.x && a.y == b.y && a.z == b.z; }
static inline bool ivec4equal(ivec4_t a, ivec4_t b) { return a.x == b.x && a.y == b.y && a.z == b.z && a.w == b.w; }

static inline bool ivec2almostequal(ivec2_t a, ivec2_t b, int32_t epsilon) { return abs(a.x - b.x) < epsilon && abs(a.y - b.y) < epsilon; }
static inline bool ivec3almostequal(ivec3_t a, ivec3_t b, int32_t epsilon) { return abs(a.x - b.x) < epsilon && abs(a.y - b.y) < epsilon && abs(a.z - b.z) < epsilon; }
static inline bool ivec4almostequal(ivec4_t a, ivec4_t b, int32_t epsilon) { return abs(a.x - b.x) < epsilon && abs(a.y - b.y) < epsilon && abs(a.z - b.z) < epsilon && abs(a.w - b.w) < epsilon; }

static inline bool ivec2iszero(ivec2_t v) { return v.x == 0 && v.y == 0; }
static inline bool ivec3iszero(ivec3_t v) { return v.x == 0 && v.y == 0 && v.z == 0; }
static inline bool ivec4iszero(ivec4_t v) { return v.x == 0 && v.y == 0 && v.z == 0 && v.w == 0; }

static inline bool ivec2almostzero(ivec2_t v, int32_t epsilon) { return abs(v.x) < epsilon && abs(v.y) < epsilon; }
static inline bool ivec3almostzero(ivec3_t v, int32_t epsilon) { return abs(v.x) < epsilon && abs(v.y) < epsilon && abs(v.z) < epsilon; }
static inline bool ivec4almostzero(ivec4_t v, int32_t epsilon) { return abs(v.x) < epsilon && abs(v.y) < epsilon && abs(v.z) < epsilon && abs(v.w) < epsilon; }



// Arithmetic operations

static inline ivec2_t ivec2add(ivec2_t a, ivec2_t b) { return ivec2(a.x + b.x, a.y + b.y); }
static inline ivec3_t ivec3add(ivec3_t a, ivec3_t b) { return ivec3(a.x + b.x, a.y + b.y, a.z + b.z); }
static inline ivec4_t ivec4add(ivec4_t a, ivec4_t b) { return ivec4(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w); }

static inline ivec2_t ivec2add3(ivec2_t a, ivec2_t b, ivec2_t c) { return ivec2(a.x + b.x + c.x, a.y + b.y + c.y); }
static inline ivec3_t ivec3add3(ivec3_t a, ivec3_t b, ivec3_t c) { return ivec3(a.x + b.x + c.x, a.y + b.y + c.y, a.z + b.z + c.z); }
static inline ivec4_t ivec4add3(ivec4_t a, ivec4_t b, ivec4_t c) { return ivec4(a.x + b.x + c.x, a.y + b.y + c.y, a.z + b.z + c.z, a.w + b.w + c.w); }

static inline ivec2_t ivec2sub(ivec2_t a, ivec2_t b) { return ivec2(a.x - b.x, a.y - b.y); }
static inline ivec3_t ivec3sub(ivec3_t a, ivec3_t b) { return ivec3(a.x - b.x, a.y - b.y, a.z - b.z); }
static inline ivec4_t ivec4sub(ivec4_t a, ivec4_t b) { return ivec4(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w); }

static inline ivec2_t ivec2mul(ivec2_t v, int32_t s) { return ivec2(v.x * s, v.y * s); }
static inline ivec3_t ivec3mul(ivec3_t v, int32_t s) { return ivec3(v.x * s, v.y * s, v.z * s); }
static inline ivec4_t ivec4mul(ivec4_t v, int32_t s) { return ivec4(v.x * s, v.y * s, v.z * s, v.w * s); }

static inline ivec2_t ivec2cmul(ivec2_t a, ivec2_t b) { return ivec2(a.x * b.x, a.y * b.y); }
static inline ivec3_t ivec3cmul(ivec3_t a, ivec3_t b) { return ivec3(a.x * b.x, a.y * b.y, a.z * b.z); }
static inline ivec4_t ivec4cmul(ivec4_t a, ivec4_t b) { return ivec4(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w); }

static inline ivec2_t ivec2div(ivec2_t v, int32_t s) { return ivec2(v.x / s, v.y / s); }
static inline ivec3_t ivec3div(ivec3_t v, int32_t s) { return ivec3(v.x / s, v.y / s, v.z / s); }
static inline ivec4_t ivec4div(ivec4_t v, int32_t s) { return ivec4(v.x / s, v.y / s, v.z / s, v.w / s); }

static inline ivec2_t ivec2cdiv(ivec2_t a, ivec2_t b) { return ivec2(a.x / b.x, a.y / b.y); }
static inline ivec3_t ivec3cdiv(ivec3_t a, ivec3_t b) { return ivec3(a.x / b.x, a.y / b.y, a.z / b.z); }
static inline ivec4_t ivec4cdiv(ivec4_t a, ivec4_t b) { return ivec4(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w); }

static inline ivec2_t ivec2mac(ivec2_t a, ivec2_t b, int32_t c) { return ivec2(a.x + b.x * c, a.y + b.y * c); }
static inline ivec3_t ivec3mac(ivec3_t a, ivec3_t b, int32_t c) { return ivec3(a.x + b.x * c, a.y + b.y * c, a.z + b.z * c); }
static inline ivec4_t ivec4mac(ivec4_t a, ivec4_t b, int32_t c) { return ivec4(a.x + b.x * c, a.y + b.y * c, a.z + b.z * c, a.w + b.w * c); }




// Norms

static inline int32_t ivec2dot(ivec2_t a, ivec2_t b) { return a.x * b.x + a.y * b.y; }
static inline int32_t ivec3dot(ivec3_t a, ivec3_t b) { return a.x * b.x + a.y * b.y + a.z * b.z; }
static inline int32_t ivec4dot(ivec4_t a, ivec4_t b) { return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w; }

static inline int32_t ivec2sq(ivec2_t v) { return ivec2dot(v, v); }
static inline int32_t ivec3sq(ivec3_t v) { return ivec3dot(v, v); }
static inline int32_t ivec4sq(ivec4_t v) { return ivec4dot(v, v); }

static inline int32_t ivec2abs(ivec2_t v) { return isqrt(ivec2sq(v)); }
static inline int32_t ivec3abs(ivec3_t v) { return isqrt(ivec3sq(v)); }
static inline int32_t ivec4abs(ivec4_t v) { return isqrt(ivec4sq(v)); }

static inline int32_t ivec2distsq(ivec2_t a, ivec2_t b) { return ivec2sq(ivec2sub(a, b)); }
static inline int32_t ivec3distsq(ivec3_t a, ivec3_t b) { return ivec3sq(ivec3sub(a, b)); }
static inline int32_t ivec4distsq(ivec4_t a, ivec4_t b) { return ivec4sq(ivec4sub(a, b)); }

static inline int32_t ivec2dist(ivec2_t a, ivec2_t b) { return ivec2abs(ivec2sub(a, b)); }
static inline int32_t ivec3dist(ivec3_t a, ivec3_t b) { return ivec3abs(ivec3sub(a, b)); }
static inline int32_t ivec4dist(ivec4_t a, ivec4_t b) { return ivec4abs(ivec4sub(a, b)); }

#ifdef USE_FIXEDPOINT64
static inline int64_t ivec2dot64(ivec2_t a, ivec2_t b) { return imul64(a.x, b.x) + imul64(a.y, b.y); }
static inline int64_t ivec3dot64(ivec3_t a, ivec3_t b) { return imul64(a.x, b.x) + imul64(a.y, b.y) + imul64(a.z, b.z); }
static inline int64_t ivec4dot64(ivec4_t a, ivec4_t b) { return imul64(a.x, b.x) + imul64(a.y, b.y) + imul64(a.z, b.z) + imul64(a.w, b.w); }

static inline int64_t ivec2sq64(ivec2_t v) { return ivec2dot64(v, v); }
static inline int64_t ivec3sq64(ivec3_t v) { return ivec3dot64(v, v); }
static inline int64_t ivec4sq64(ivec4_t v) { return ivec4dot64(v, v); }

static inline int64_t ivec2abs64(ivec2_t v) { return isqrt64(ivec2sq64(v)); }
static inline int64_t ivec3abs64(ivec3_t v) { return isqrt64(ivec3sq64(v)); }
static inline int64_t ivec4abs64(ivec4_t v) { return isqrt64(ivec4sq64(v)); }

static inline int64_t ivec2distsq64(ivec2_t a, ivec2_t b) { return ivec2sq64(ivec2sub(a, b)); }
static inline int64_t ivec3distsq64(ivec3_t a, ivec3_t b) { return ivec3sq64(ivec3sub(a, b)); }
static inline int64_t ivec4distsq64(ivec4_t a, ivec4_t b) { return ivec4sq64(ivec4sub(a, b)); }

static inline int64_t ivec2dist64(ivec2_t a, ivec2_t b) { return ivec2abs64(ivec2sub(a, b)); }
static inline int64_t ivec3dist64(ivec3_t a, ivec3_t b) { return ivec3abs64(ivec3sub(a, b)); }
static inline int64_t ivec4dist64(ivec4_t a, ivec4_t b) { return ivec4abs64(ivec4sub(a, b)); }
#endif

static inline ivec2_t ivec2norm(ivec2_t v) {
	int32_t abs = ivec2abs(v);
	if(abs == 0) return ivec2zero;
	else return ivec2div(v, abs);
}

static inline ivec3_t ivec3norm(ivec3_t v) {
	int32_t abs = ivec3abs(v);
	if(abs == 0) return ivec3zero;
	else return ivec3div(v, abs);
}

static inline ivec4_t ivec4norm(ivec4_t v) {
	int32_t abs = ivec4abs(v);
	if(abs == 0) return ivec4zero;
	else return ivec4div(v, abs);
}

static inline ivec2_t ivec2setlength(ivec2_t v, int32_t length) { return ivec2mul(ivec2norm(v), length); }
static inline ivec3_t ivec3setlength(ivec3_t v, int32_t length) { return ivec3mul(ivec3norm(v), length); }
static inline ivec4_t ivec4setlength(ivec4_t v, int32_t length) { return ivec4mul(ivec4norm(v), length); }



// Homogenous conversion functions

static inline ivec4_t ivec4homogenize(ivec4_t v) { return ivec4(v.x / v.w, v.y / v.w, v.z / v.w, F(1)); }
static inline ivec3_t ivec4homogenize3(ivec4_t v) { return ivec3(v.x / v.w, v.y / v.w, v.z / v.w); }
static inline ivec4_t ivec3unhomogenize(ivec3_t v) { return ivec4(v.x, v.y, v.z, F(1)); }



// Blending

static inline ivec2_t ivec2midpoint(ivec2_t a, ivec2_t b) { return ivec2((a.x + b.x) / 2, (a.y + b.y) / 2); }
static inline ivec3_t ivec3midpoint(ivec3_t a, ivec3_t b) { return ivec3((a.x + b.x) / 2, (a.y + b.y) / 2, (a.z + b.z) / 2); }
static inline ivec4_t ivec4midpoint(ivec4_t a, ivec4_t b) { return ivec4((a.x + b.x) / 2, (a.y + b.y) / 2, (a.z + b.z) / 2, (a.w + b.w) / 2); }

static inline ivec2_t ivec2mix(ivec2_t a, ivec2_t b, int32_t x) { return ivec2add(a, ivec2mul(ivec2sub(b, a), x)); }
static inline ivec3_t ivec3mix(ivec3_t a, ivec3_t b, int32_t x) { return ivec3add(a, ivec3mul(ivec3sub(b, a), x)); }
static inline ivec4_t ivec4mix(ivec4_t a, ivec4_t b, int32_t x) { return ivec4add(a, ivec4mul(ivec4sub(b, a), x)); }



// 2D specifics

static inline ivec2_t ivec2perp(ivec2_t v) { return ivec2(-v.y, v.x); }

static inline int32_t ivec2pdot(ivec2_t a, ivec2_t b) { return ivec2dot(a, ivec2perp(b)); }
#ifdef USE_FIXEDPOINT64
static inline int32_t ivec2pdot64(ivec2_t a, ivec2_t b) { return ivec2dot64(a, ivec2perp(b)); }
#endif

static inline ivec2_t ivec2rot(ivec2_t v, int angle) {
	return ivec2(
		v.x * icos(angle) - v.y * isin(angle),
		v.x * isin(angle) + v.y * icos(angle));
}



// 3D specifics

ivec3_t ivec3cross(ivec3_t a, ivec3_t b);



// Plane functions

static inline ivec3_t ivec4_planenormal(ivec4_t p) { return ivec4_xyz(p); }

static inline ivec3_t ivec4_vec3plane(ivec4_t p) { return ivec4homogenize3(p); }

static inline ivec4_t ivec4planenorm(ivec4_t p) {
	int32_t abs = ivec3abs(ivec4_planenormal(p));
	if(abs == 0) return ivec4zero;
	else return ivec4div(p, abs);
}

static inline int32_t ivec3planepointdistance(ivec3_t p, ivec3_t v) { return (ivec3dot(p, v) + F(1)) / ivec3abs(p); }
static inline int32_t ivec4planepointdistance(ivec4_t p, ivec3_t v) { return ivec4dot(p, ivec4vec3(v)) / ivec3abs(ivec4_planenormal(p)); }

static inline ivec3_t ivec3projectontoline(ivec3_t p, ivec3_t unitline) { return ivec3mul(unitline, ivec3dot(p, unitline)); }
static inline ivec3_t ivec3projectontoplane(ivec3_t p, ivec3_t unitnormal) { return ivec3sub(p, ivec3projectontoline(p, unitnormal)); }
static inline ivec3_t ivec3reflect(ivec3_t p, ivec3_t unitnormal) { return ivec3sub(p, ivec3mul(ivec3projectontoline(p, unitnormal), 2)); }

static inline ivec3_t ivec3trianglenormal(ivec3_t v1, ivec3_t v2, ivec3_t v3) { return ivec3norm(ivec3cross(ivec3sub(v2, v1), ivec3sub(v3, v1))); }

#endif

