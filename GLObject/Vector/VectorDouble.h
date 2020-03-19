#ifndef __VECTOR_DOUBLE_H__
#define __VECTOR_DOUBLE_H__

#include <math.h>
#include <stdbool.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif




// Definitions

typedef struct { double x, y; } dvec2_t;
typedef struct { double x, y, z; } dvec3_t;
typedef struct { double x, y, z, w; } dvec4_t;

#define VEC2(a, b) ((dvec2_t) { .x = (a), .y = (b) })
#define VEC3(a, b, c) ((dvec3_t) { .x = (a), .y = (b), .z = (c) })
#define VEC4(a, b, c, d) ((dvec4_t) { .x = (a), .y = (b), .z = (c), .w = (d) })

#define dvec2zero dvec2(0, 0)
#define dvec3zero dvec3(0, 0, 0)
#define dvec4zero dvec4(0, 0, 0, 0)



// Constructors

static inline dvec2_t dvec2(double x, double y) { return (dvec2_t) {x, y}; }
static inline dvec3_t dvec3(double x, double y, double z) { return (dvec3_t) {x, y, z}; }
static inline dvec4_t dvec4(double x, double y, double z, double w) { return (dvec4_t) {x, y, z, w}; }

static inline dvec2_t dvec2cyl(double r, double angle) {
	return dvec2(r * cos(angle), r * sin(angle));
}

static inline dvec4_t dvec4vec3(dvec3_t v) { return dvec4(v.x, v.y, v.z, 1); }


// Extractors

static inline dvec2_t dvec3_xy(dvec3_t v) { return dvec2(v.x, v.y); }
static inline dvec2_t dvec3_xz(dvec3_t v) { return dvec2(v.x, v.z); }
static inline dvec2_t dvec3_yz(dvec3_t v) { return dvec2(v.y, v.z); }

static inline dvec3_t dvec4_xyz(dvec4_t v) { return dvec3(v.x, v.y, v.z); }



// Unary operations

static inline dvec2_t dvec2neg(dvec2_t v) { return dvec2(-v.x, -v.y); }
static inline dvec3_t dvec3neg(dvec3_t v) { return dvec3(-v.x, -v.y, -v.z); }
static inline dvec4_t dvec4neg(dvec4_t v) { return dvec4(-v.x, -v.y, -v.z, -v.w); }



// Comparison operations

static inline bool dvec2equal(dvec2_t a, dvec2_t b) { return a.x == b.x && a.y == b.y; }
static inline bool dvec3equal(dvec3_t a, dvec3_t b) { return a.x == b.x && a.y == b.y && a.z == b.z; }
static inline bool dvec4equal(dvec4_t a, dvec4_t b) { return a.x == b.x && a.y == b.y && a.z == b.z && a.w == b.w; }

static inline bool dvec2almostequal(dvec2_t a, dvec2_t b, double epsilon) { return fabs(a.x - b.x) < epsilon && fabs(a.y - b.y) < epsilon; }
static inline bool dvec3almostequal(dvec3_t a, dvec3_t b, double epsilon) { return fabs(a.x - b.x) < epsilon && fabs(a.y - b.y) < epsilon && fabs(a.z - b.z) < epsilon; }
static inline bool dvec4almostequal(dvec4_t a, dvec4_t b, double epsilon) { return fabs(a.x - b.x) < epsilon && fabs(a.y - b.y) < epsilon && fabs(a.z - b.z) < epsilon && fabs(a.w - b.w) < epsilon; }

static inline bool dvec2iszero(dvec2_t v) { return v.x == 0 && v.y == 0; }
static inline bool dvec3iszero(dvec3_t v) { return v.x == 0 && v.y == 0 && v.z == 0; }
static inline bool dvec4iszero(dvec4_t v) { return v.x == 0 && v.y == 0 && v.z == 0 && v.w == 0; }

static inline bool dvec2almostzero(dvec2_t v, double epsilon) { return fabs(v.x) < epsilon && fabs(v.y) < epsilon; }
static inline bool dvec3almostzero(dvec3_t v, double epsilon) { return fabs(v.x) < epsilon && fabs(v.y) < epsilon && fabs(v.z) < epsilon; }
static inline bool dvec4almostzero(dvec4_t v, double epsilon) { return fabs(v.x) < epsilon && fabs(v.y) < epsilon && fabs(v.z) < epsilon && fabs(v.w) < epsilon; }



// Arithmetic operations

static inline dvec2_t dvec2add(dvec2_t a, dvec2_t b) { return dvec2(a.x + b.x, a.y + b.y); }
static inline dvec3_t dvec3add(dvec3_t a, dvec3_t b) { return dvec3(a.x + b.x, a.y + b.y, a.z + b.z); }
static inline dvec4_t dvec4add(dvec4_t a, dvec4_t b) { return dvec4(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w); }

static inline dvec2_t dvec2add3(dvec2_t a, dvec2_t b, dvec2_t c) { return dvec2(a.x + b.x + c.x, a.y + b.y + c.y); }
static inline dvec3_t dvec3add3(dvec3_t a, dvec3_t b, dvec3_t c) { return dvec3(a.x + b.x + c.x, a.y + b.y + c.y, a.z + b.z + c.z); }
static inline dvec4_t dvec4add3(dvec4_t a, dvec4_t b, dvec4_t c) { return dvec4(a.x + b.x + c.x, a.y + b.y + c.y, a.z + b.z + c.z, a.w + b.w + c.w); }

static inline dvec2_t dvec2sub(dvec2_t a, dvec2_t b) { return dvec2(a.x - b.x, a.y - b.y); }
static inline dvec3_t dvec3sub(dvec3_t a, dvec3_t b) { return dvec3(a.x - b.x, a.y - b.y, a.z - b.z); }
static inline dvec4_t dvec4sub(dvec4_t a, dvec4_t b) { return dvec4(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w); }

static inline dvec2_t dvec2mul(dvec2_t v, double s) { return dvec2(v.x * s, v.y * s); }
static inline dvec3_t dvec3mul(dvec3_t v, double s) { return dvec3(v.x * s, v.y * s, v.z * s); }
static inline dvec4_t dvec4mul(dvec4_t v, double s) { return dvec4(v.x * s, v.y * s, v.z * s, v.w * s); }

static inline dvec2_t dvec2cmul(dvec2_t a, dvec2_t b) { return dvec2(a.x * b.x, a.y * b.y); }
static inline dvec3_t dvec3cmul(dvec3_t a, dvec3_t b) { return dvec3(a.x * b.x, a.y * b.y, a.z * b.z); }
static inline dvec4_t dvec4cmul(dvec4_t a, dvec4_t b) { return dvec4(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w); }

static inline dvec2_t dvec2div(dvec2_t v, double s) { return dvec2(v.x / s, v.y / s); }
static inline dvec3_t dvec3div(dvec3_t v, double s) { return dvec3(v.x / s, v.y / s, v.z / s); }
static inline dvec4_t dvec4div(dvec4_t v, double s) { return dvec4(v.x / s, v.y / s, v.z / s, v.w / s); }

static inline dvec2_t dvec2cdiv(dvec2_t a, dvec2_t b) { return dvec2(a.x / b.x, a.y / b.y); }
static inline dvec3_t dvec3cdiv(dvec3_t a, dvec3_t b) { return dvec3(a.x / b.x, a.y / b.y, a.z / b.z); }
static inline dvec4_t dvec4cdiv(dvec4_t a, dvec4_t b) { return dvec4(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w); }

static inline dvec2_t dvec2mac(dvec2_t a, dvec2_t b, double c) { return dvec2(a.x + b.x * c, a.y + b.y * c); }
static inline dvec3_t dvec3mac(dvec3_t a, dvec3_t b, double c) { return dvec3(a.x + b.x * c, a.y + b.y * c, a.z + b.z * c); }
static inline dvec4_t dvec4mac(dvec4_t a, dvec4_t b, double c) { return dvec4(a.x + b.x * c, a.y + b.y * c, a.z + b.z * c, a.w + b.w * c); }




// Norms

static inline double dvec2dot(dvec2_t a, dvec2_t b) { return a.x * b.x + a.y * b.y; }
static inline double dvec3dot(dvec3_t a, dvec3_t b) { return a.x * b.x + a.y * b.y + a.z * b.z; }
static inline double dvec4dot(dvec4_t a, dvec4_t b) { return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w; }

static inline double dvec2sq(dvec2_t v) { return dvec2dot(v, v); }
static inline double dvec3sq(dvec3_t v) { return dvec3dot(v, v); }
static inline double dvec4sq(dvec4_t v) { return dvec4dot(v, v); }

static inline double dvec2abs(dvec2_t v) { return sqrt(dvec2sq(v)); }
static inline double dvec3abs(dvec3_t v) { return sqrt(dvec3sq(v)); }
static inline double dvec4abs(dvec4_t v) { return sqrt(dvec4sq(v)); }

static inline double dvec2distsq(dvec2_t a, dvec2_t b) { return dvec2sq(dvec2sub(a, b)); }
static inline double dvec3distsq(dvec3_t a, dvec3_t b) { return dvec3sq(dvec3sub(a, b)); }
static inline double dvec4distsq(dvec4_t a, dvec4_t b) { return dvec4sq(dvec4sub(a, b)); }

static inline double dvec2dist(dvec2_t a, dvec2_t b) { return dvec2abs(dvec2sub(a, b)); }
static inline double dvec3dist(dvec3_t a, dvec3_t b) { return dvec3abs(dvec3sub(a, b)); }
static inline double dvec4dist(dvec4_t a, dvec4_t b) { return dvec4abs(dvec4sub(a, b)); }

#ifdef USE_FIXEDPOINT64
static inline int64_t dvec2dot64(dvec2_t a, dvec2_t b) { return imul64(a.x, b.x) + imul64(a.y, b.y); }
static inline int64_t dvec3dot64(dvec3_t a, dvec3_t b) { return imul64(a.x, b.x) + imul64(a.y, b.y) + imul64(a.z, b.z); }
static inline int64_t dvec4dot64(dvec4_t a, dvec4_t b) { return imul64(a.x, b.x) + imul64(a.y, b.y) + imul64(a.z, b.z) + imul64(a.w, b.w); }

static inline int64_t dvec2sq64(dvec2_t v) { return dvec2dot64(v, v); }
static inline int64_t dvec3sq64(dvec3_t v) { return dvec3dot64(v, v); }
static inline int64_t dvec4sq64(dvec4_t v) { return dvec4dot64(v, v); }

static inline int64_t dvec2abs64(dvec2_t v) { return isqrt64(dvec2sq64(v)); }
static inline int64_t dvec3abs64(dvec3_t v) { return isqrt64(dvec3sq64(v)); }
static inline int64_t dvec4abs64(dvec4_t v) { return isqrt64(dvec4sq64(v)); }

static inline int64_t dvec2distsq64(dvec2_t a, dvec2_t b) { return dvec2sq64(dvec2sub(a, b)); }
static inline int64_t dvec3distsq64(dvec3_t a, dvec3_t b) { return dvec3sq64(dvec3sub(a, b)); }
static inline int64_t dvec4distsq64(dvec4_t a, dvec4_t b) { return dvec4sq64(dvec4sub(a, b)); }

static inline int64_t dvec2dist64(dvec2_t a, dvec2_t b) { return dvec2abs64(dvec2sub(a, b)); }
static inline int64_t dvec3dist64(dvec3_t a, dvec3_t b) { return dvec3abs64(dvec3sub(a, b)); }
static inline int64_t dvec4dist64(dvec4_t a, dvec4_t b) { return dvec4abs64(dvec4sub(a, b)); }
#endif

static inline dvec2_t dvec2norm(dvec2_t v) {
	double abs = dvec2abs(v);
	if(abs == 0) return dvec2zero;
	else return dvec2div(v, abs);
}

static inline dvec3_t dvec3norm(dvec3_t v) {
	double abs = dvec3abs(v);
	if(abs == 0) return dvec3zero;
	else return dvec3div(v, abs);
}

static inline dvec4_t dvec4norm(dvec4_t v) {
	double abs = dvec4abs(v);
	if(abs == 0) return dvec4zero;
	else return dvec4div(v, abs);
}

static inline dvec2_t dvec2setlength(dvec2_t v, double length) { return dvec2mul(dvec2norm(v), length); }
static inline dvec3_t dvec3setlength(dvec3_t v, double length) { return dvec3mul(dvec3norm(v), length); }
static inline dvec4_t dvec4setlength(dvec4_t v, double length) { return dvec4mul(dvec4norm(v), length); }



// Homogenous conversion functions

static inline dvec4_t dvec4homogenize(dvec4_t v) { return dvec4(v.x / v.w, v.y / v.w, v.z / v.w, 1); }
static inline dvec3_t dvec4homogenize3(dvec4_t v) { return dvec3(v.x / v.w, v.y / v.w, v.z / v.w); }
static inline dvec4_t dvec3unhomogenize(dvec3_t v) { return dvec4(v.x, v.y, v.z, 1); }



// Blending

static inline dvec2_t dvec2midpoint(dvec2_t a, dvec2_t b) { return dvec2((a.x + b.x) / 2, (a.y + b.y) / 2); }
static inline dvec3_t dvec3midpoint(dvec3_t a, dvec3_t b) { return dvec3((a.x + b.x) / 2, (a.y + b.y) / 2, (a.z + b.z) / 2); }
static inline dvec4_t dvec4midpoint(dvec4_t a, dvec4_t b) { return dvec4((a.x + b.x) / 2, (a.y + b.y) / 2, (a.z + b.z) / 2, (a.w + b.w) / 2); }

static inline dvec2_t dvec2mix(dvec2_t a, dvec2_t b, double x) { return dvec2add(a, dvec2mul(dvec2sub(b, a), x)); }
static inline dvec3_t dvec3mix(dvec3_t a, dvec3_t b, double x) { return dvec3add(a, dvec3mul(dvec3sub(b, a), x)); }
static inline dvec4_t dvec4mix(dvec4_t a, dvec4_t b, double x) { return dvec4add(a, dvec4mul(dvec4sub(b, a), x)); }



// 2D specifics

static inline dvec2_t dvec2perp(dvec2_t v) { return dvec2(-v.y, v.x); }

static inline double dvec2pdot(dvec2_t a, dvec2_t b) { return dvec2dot(a, dvec2perp(b)); }
#ifdef USE_FIXEDPOINT64
static inline double dvec2pdot64(dvec2_t a, dvec2_t b) { return dvec2dot64(a, dvec2perp(b)); }
#endif

static inline dvec2_t dvec2rot(dvec2_t v, double angle) {
	return dvec2(
		v.x * cos(angle) - v.y * sin(angle),
		v.x * sin(angle) + v.y * cos(angle));
}



// 3D specifics

dvec3_t dvec3cross(dvec3_t a, dvec3_t b);



// Plane functions

static inline dvec3_t dvec4_planenormal(dvec4_t p) { return dvec4_xyz(p); }

static inline dvec3_t dvec4_vec3plane(dvec4_t p) { return dvec4homogenize3(p); }

static inline dvec4_t dvec4planenorm(dvec4_t p) {
	double abs = dvec3abs(dvec4_planenormal(p));
	if(abs == 0) return dvec4zero;
	else return dvec4div(p, abs);
}

static inline double dvec3planepointdistance(dvec3_t p, dvec3_t v) { return (dvec3dot(p, v) + 1) / dvec3abs(p); }
static inline double dvec4planepointdistance(dvec4_t p, dvec3_t v) { return dvec4dot(p, dvec4vec3(v)) / dvec3abs(dvec4_planenormal(p)); }

static inline dvec3_t dvec3projectontoline(dvec3_t p, dvec3_t unitline) { return dvec3mul(unitline, dvec3dot(p, unitline)); }
static inline dvec3_t dvec3projectontoplane(dvec3_t p, dvec3_t unitnormal) { return dvec3sub(p, dvec3projectontoline(p, unitnormal)); }
static inline dvec3_t dvec3reflect(dvec3_t p, dvec3_t unitnormal) { return dvec3sub(p, dvec3mul(dvec3projectontoline(p, unitnormal), 2)); }

static inline dvec3_t dvec3trianglenormal(dvec3_t v1, dvec3_t v2, dvec3_t v3) { return dvec3norm(dvec3cross(dvec3sub(v2, v1), dvec3sub(v3, v1))); }

#endif

