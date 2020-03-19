#ifndef __VECTOR_COMPLEX_DOUBLE_H__
#define __VECTOR_COMPLEX_DOUBLE_H__

#include <math.h>
#include <complex.h>
#include <stdbool.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif




// Definitions

typedef struct { complex double x, y; } cdvec2_t;
typedef struct { complex double x, y, z; } cdvec3_t;
typedef struct { complex double x, y, z, w; } cdvec4_t;

#define VEC2(a, b) ((cdvec2_t) { .x = (a), .y = (b) })
#define VEC3(a, b, c) ((cdvec3_t) { .x = (a), .y = (b), .z = (c) })
#define VEC4(a, b, c, d) ((cdvec4_t) { .x = (a), .y = (b), .z = (c), .w = (d) })

#define cdvec2zero cdvec2(0, 0)
#define cdvec3zero cdvec3(0, 0, 0)
#define cdvec4zero cdvec4(0, 0, 0, 0)



// Constructors

static inline cdvec2_t cdvec2(complex double x, complex double y) { return (cdvec2_t) {x, y}; }
static inline cdvec3_t cdvec3(complex double x, complex double y, complex double z) { return (cdvec3_t) {x, y, z}; }
static inline cdvec4_t cdvec4(complex double x, complex double y, complex double z, complex double w) { return (cdvec4_t) {x, y, z, w}; }

static inline cdvec2_t cdvec2cyl(complex double r, complex double angle) {
	return cdvec2(r * ccos(angle), r * csin(angle));
}

static inline cdvec4_t cdvec4vec3(cdvec3_t v) { return cdvec4(v.x, v.y, v.z, 1); }


// Extractors

static inline cdvec2_t cdvec3_xy(cdvec3_t v) { return cdvec2(v.x, v.y); }
static inline cdvec2_t cdvec3_xz(cdvec3_t v) { return cdvec2(v.x, v.z); }
static inline cdvec2_t cdvec3_yz(cdvec3_t v) { return cdvec2(v.y, v.z); }

static inline cdvec3_t cdvec4_xyz(cdvec4_t v) { return cdvec3(v.x, v.y, v.z); }



// Unary operations

static inline cdvec2_t cdvec2neg(cdvec2_t v) { return cdvec2(-v.x, -v.y); }
static inline cdvec3_t cdvec3neg(cdvec3_t v) { return cdvec3(-v.x, -v.y, -v.z); }
static inline cdvec4_t cdvec4neg(cdvec4_t v) { return cdvec4(-v.x, -v.y, -v.z, -v.w); }



// Comparison operations

static inline bool cdvec2equal(cdvec2_t a, cdvec2_t b) { return a.x == b.x && a.y == b.y; }
static inline bool cdvec3equal(cdvec3_t a, cdvec3_t b) { return a.x == b.x && a.y == b.y && a.z == b.z; }
static inline bool cdvec4equal(cdvec4_t a, cdvec4_t b) { return a.x == b.x && a.y == b.y && a.z == b.z && a.w == b.w; }

/*static inline bool cdvec2almostequal(cdvec2_t a, cdvec2_t b, double epsilon) { return cabs(a.x - b.x) < epsilon && cabs(a.y - b.y) < epsilon; }*/
/*static inline bool cdvec3almostequal(cdvec3_t a, cdvec3_t b, double epsilon) { return cabs(a.x - b.x) < epsilon && cabs(a.y - b.y) < epsilon && cabs(a.z - b.z) < epsilon; }*/
/*static inline bool cdvec4almostequal(cdvec4_t a, cdvec4_t b, double epsilon) { return cabs(a.x - b.x) < epsilon && cabs(a.y - b.y) < epsilon && cabs(a.z - b.z) < epsilon && cabs(a.w - b.w) < epsilon; }*/

static inline bool cdvec2iszero(cdvec2_t v) { return v.x == 0 && v.y == 0; }
static inline bool cdvec3iszero(cdvec3_t v) { return v.x == 0 && v.y == 0 && v.z == 0; }
static inline bool cdvec4iszero(cdvec4_t v) { return v.x == 0 && v.y == 0 && v.z == 0 && v.w == 0; }

static inline bool cdvec2almostzero(cdvec2_t v, double epsilon) { return cabs(v.x) < epsilon && cabs(v.y) < epsilon; }
static inline bool cdvec3almostzero(cdvec3_t v, double epsilon) { return cabs(v.x) < epsilon && cabs(v.y) < epsilon && cabs(v.z) < epsilon; }
static inline bool cdvec4almostzero(cdvec4_t v, double epsilon) { return cabs(v.x) < epsilon && cabs(v.y) < epsilon && cabs(v.z) < epsilon && cabs(v.w) < epsilon; }



// Arithmetic operations

static inline cdvec2_t cdvec2add(cdvec2_t a, cdvec2_t b) { return cdvec2(a.x + b.x, a.y + b.y); }
static inline cdvec3_t cdvec3add(cdvec3_t a, cdvec3_t b) { return cdvec3(a.x + b.x, a.y + b.y, a.z + b.z); }
static inline cdvec4_t cdvec4add(cdvec4_t a, cdvec4_t b) { return cdvec4(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w); }

static inline cdvec2_t cdvec2add3(cdvec2_t a, cdvec2_t b, cdvec2_t c) { return cdvec2(a.x + b.x + c.x, a.y + b.y + c.y); }
static inline cdvec3_t cdvec3add3(cdvec3_t a, cdvec3_t b, cdvec3_t c) { return cdvec3(a.x + b.x + c.x, a.y + b.y + c.y, a.z + b.z + c.z); }
static inline cdvec4_t cdvec4add3(cdvec4_t a, cdvec4_t b, cdvec4_t c) { return cdvec4(a.x + b.x + c.x, a.y + b.y + c.y, a.z + b.z + c.z, a.w + b.w + c.w); }

static inline cdvec2_t cdvec2sub(cdvec2_t a, cdvec2_t b) { return cdvec2(a.x - b.x, a.y - b.y); }
static inline cdvec3_t cdvec3sub(cdvec3_t a, cdvec3_t b) { return cdvec3(a.x - b.x, a.y - b.y, a.z - b.z); }
static inline cdvec4_t cdvec4sub(cdvec4_t a, cdvec4_t b) { return cdvec4(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w); }

static inline cdvec2_t cdvec2mul(cdvec2_t v, complex double s) { return cdvec2(v.x * s, v.y * s); }
static inline cdvec3_t cdvec3mul(cdvec3_t v, complex double s) { return cdvec3(v.x * s, v.y * s, v.z * s); }
static inline cdvec4_t cdvec4mul(cdvec4_t v, complex double s) { return cdvec4(v.x * s, v.y * s, v.z * s, v.w * s); }

static inline cdvec2_t cdvec2cmul(cdvec2_t a, cdvec2_t b) { return cdvec2(a.x * b.x, a.y * b.y); }
static inline cdvec3_t cdvec3cmul(cdvec3_t a, cdvec3_t b) { return cdvec3(a.x * b.x, a.y * b.y, a.z * b.z); }
static inline cdvec4_t cdvec4cmul(cdvec4_t a, cdvec4_t b) { return cdvec4(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w); }

static inline cdvec2_t cdvec2div(cdvec2_t v, complex double s) { return cdvec2(v.x / s, v.y / s); }
static inline cdvec3_t cdvec3div(cdvec3_t v, complex double s) { return cdvec3(v.x / s, v.y / s, v.z / s); }
static inline cdvec4_t cdvec4div(cdvec4_t v, complex double s) { return cdvec4(v.x / s, v.y / s, v.z / s, v.w / s); }

static inline cdvec2_t cdvec2cdiv(cdvec2_t a, cdvec2_t b) { return cdvec2(a.x / b.x, a.y / b.y); }
static inline cdvec3_t cdvec3cdiv(cdvec3_t a, cdvec3_t b) { return cdvec3(a.x / b.x, a.y / b.y, a.z / b.z); }
static inline cdvec4_t cdvec4cdiv(cdvec4_t a, cdvec4_t b) { return cdvec4(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w); }

static inline cdvec2_t cdvec2mac(cdvec2_t a, cdvec2_t b, complex double c) { return cdvec2(a.x + b.x * c, a.y + b.y * c); }
static inline cdvec3_t cdvec3mac(cdvec3_t a, cdvec3_t b, complex double c) { return cdvec3(a.x + b.x * c, a.y + b.y * c, a.z + b.z * c); }
static inline cdvec4_t cdvec4mac(cdvec4_t a, cdvec4_t b, complex double c) { return cdvec4(a.x + b.x * c, a.y + b.y * c, a.z + b.z * c, a.w + b.w * c); }




// Norms

static inline complex double cdvec2dot(cdvec2_t a, cdvec2_t b) { return a.x * b.x + a.y * b.y; }
static inline complex double cdvec3dot(cdvec3_t a, cdvec3_t b) { return a.x * b.x + a.y * b.y + a.z * b.z; }
static inline complex double cdvec4dot(cdvec4_t a, cdvec4_t b) { return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w; }

static inline complex double cdvec2sq(cdvec2_t v) { return cdvec2dot(v, v); }
static inline complex double cdvec3sq(cdvec3_t v) { return cdvec3dot(v, v); }
static inline complex double cdvec4sq(cdvec4_t v) { return cdvec4dot(v, v); }

static inline complex double cdvec2abs(cdvec2_t v) { return csqrt(cdvec2sq(v)); }
static inline complex double cdvec3abs(cdvec3_t v) { return csqrt(cdvec3sq(v)); }
static inline complex double cdvec4abs(cdvec4_t v) { return csqrt(cdvec4sq(v)); }

static inline complex double cdvec2distsq(cdvec2_t a, cdvec2_t b) { return cdvec2sq(cdvec2sub(a, b)); }
static inline complex double cdvec3distsq(cdvec3_t a, cdvec3_t b) { return cdvec3sq(cdvec3sub(a, b)); }
static inline complex double cdvec4distsq(cdvec4_t a, cdvec4_t b) { return cdvec4sq(cdvec4sub(a, b)); }

static inline complex double cdvec2dist(cdvec2_t a, cdvec2_t b) { return cdvec2abs(cdvec2sub(a, b)); }
static inline complex double cdvec3dist(cdvec3_t a, cdvec3_t b) { return cdvec3abs(cdvec3sub(a, b)); }
static inline complex double cdvec4dist(cdvec4_t a, cdvec4_t b) { return cdvec4abs(cdvec4sub(a, b)); }

#ifdef USE_FIXEDPOINT64
static inline int64_t cdvec2dot64(cdvec2_t a, cdvec2_t b) { return imul64(a.x, b.x) + imul64(a.y, b.y); }
static inline int64_t cdvec3dot64(cdvec3_t a, cdvec3_t b) { return imul64(a.x, b.x) + imul64(a.y, b.y) + imul64(a.z, b.z); }
static inline int64_t cdvec4dot64(cdvec4_t a, cdvec4_t b) { return imul64(a.x, b.x) + imul64(a.y, b.y) + imul64(a.z, b.z) + imul64(a.w, b.w); }

static inline int64_t cdvec2sq64(cdvec2_t v) { return cdvec2dot64(v, v); }
static inline int64_t cdvec3sq64(cdvec3_t v) { return cdvec3dot64(v, v); }
static inline int64_t cdvec4sq64(cdvec4_t v) { return cdvec4dot64(v, v); }

static inline int64_t cdvec2abs64(cdvec2_t v) { return isqrt64(cdvec2sq64(v)); }
static inline int64_t cdvec3abs64(cdvec3_t v) { return isqrt64(cdvec3sq64(v)); }
static inline int64_t cdvec4abs64(cdvec4_t v) { return isqrt64(cdvec4sq64(v)); }

static inline int64_t cdvec2distsq64(cdvec2_t a, cdvec2_t b) { return cdvec2sq64(cdvec2sub(a, b)); }
static inline int64_t cdvec3distsq64(cdvec3_t a, cdvec3_t b) { return cdvec3sq64(cdvec3sub(a, b)); }
static inline int64_t cdvec4distsq64(cdvec4_t a, cdvec4_t b) { return cdvec4sq64(cdvec4sub(a, b)); }

static inline int64_t cdvec2dist64(cdvec2_t a, cdvec2_t b) { return cdvec2abs64(cdvec2sub(a, b)); }
static inline int64_t cdvec3dist64(cdvec3_t a, cdvec3_t b) { return cdvec3abs64(cdvec3sub(a, b)); }
static inline int64_t cdvec4dist64(cdvec4_t a, cdvec4_t b) { return cdvec4abs64(cdvec4sub(a, b)); }
#endif

static inline cdvec2_t cdvec2norm(cdvec2_t v) {
	complex double abs = cdvec2abs(v);
	if(abs == 0) return cdvec2zero;
	else return cdvec2div(v, abs);
}

static inline cdvec3_t cdvec3norm(cdvec3_t v) {
	complex double abs = cdvec3abs(v);
	if(abs == 0) return cdvec3zero;
	else return cdvec3div(v, abs);
}

static inline cdvec4_t cdvec4norm(cdvec4_t v) {
	complex double abs = cdvec4abs(v);
	if(abs == 0) return cdvec4zero;
	else return cdvec4div(v, abs);
}

static inline cdvec2_t cdvec2setlength(cdvec2_t v, complex double length) { return cdvec2mul(cdvec2norm(v), length); }
static inline cdvec3_t cdvec3setlength(cdvec3_t v, complex double length) { return cdvec3mul(cdvec3norm(v), length); }
static inline cdvec4_t cdvec4setlength(cdvec4_t v, complex double length) { return cdvec4mul(cdvec4norm(v), length); }



// Homogenous conversion functions

static inline cdvec4_t cdvec4homogenize(cdvec4_t v) { return cdvec4(v.x / v.w, v.y / v.w, v.z / v.w, 1); }
static inline cdvec3_t cdvec4homogenize3(cdvec4_t v) { return cdvec3(v.x / v.w, v.y / v.w, v.z / v.w); }
static inline cdvec4_t cdvec3unhomogenize(cdvec3_t v) { return cdvec4(v.x, v.y, v.z, 1); }



// Blending

static inline cdvec2_t cdvec2midpoint(cdvec2_t a, cdvec2_t b) { return cdvec2((a.x + b.x) / 2, (a.y + b.y) / 2); }
static inline cdvec3_t cdvec3midpoint(cdvec3_t a, cdvec3_t b) { return cdvec3((a.x + b.x) / 2, (a.y + b.y) / 2, (a.z + b.z) / 2); }
static inline cdvec4_t cdvec4midpoint(cdvec4_t a, cdvec4_t b) { return cdvec4((a.x + b.x) / 2, (a.y + b.y) / 2, (a.z + b.z) / 2, (a.w + b.w) / 2); }

static inline cdvec2_t cdvec2mix(cdvec2_t a, cdvec2_t b, complex double x) { return cdvec2add(a, cdvec2mul(cdvec2sub(b, a), x)); }
static inline cdvec3_t cdvec3mix(cdvec3_t a, cdvec3_t b, complex double x) { return cdvec3add(a, cdvec3mul(cdvec3sub(b, a), x)); }
static inline cdvec4_t cdvec4mix(cdvec4_t a, cdvec4_t b, complex double x) { return cdvec4add(a, cdvec4mul(cdvec4sub(b, a), x)); }



// 2D specifics

static inline cdvec2_t cdvec2perp(cdvec2_t v) { return cdvec2(-v.y, v.x); }

static inline complex double cdvec2pdot(cdvec2_t a, cdvec2_t b) { return cdvec2dot(a, cdvec2perp(b)); }
#ifdef USE_FIXEDPOINT64
static inline complex double cdvec2pdot64(cdvec2_t a, cdvec2_t b) { return cdvec2dot64(a, cdvec2perp(b)); }
#endif

static inline cdvec2_t cdvec2rot(cdvec2_t v, complex double angle) {
	return cdvec2(
		v.x * ccos(angle) - v.y * csin(angle),
		v.x * csin(angle) + v.y * ccos(angle));
}



// 3D specifics

cdvec3_t cdvec3cross(cdvec3_t a, cdvec3_t b);



// Plane functions

static inline cdvec3_t cdvec4_planenormal(cdvec4_t p) { return cdvec4_xyz(p); }

static inline cdvec3_t cdvec4_vec3plane(cdvec4_t p) { return cdvec4homogenize3(p); }

static inline cdvec4_t cdvec4planenorm(cdvec4_t p) {
	complex double abs = cdvec3abs(cdvec4_planenormal(p));
	if(abs == 0) return cdvec4zero;
	else return cdvec4div(p, abs);
}

static inline complex double cdvec3planepointdistance(cdvec3_t p, cdvec3_t v) { return (cdvec3dot(p, v) + 1) / cdvec3abs(p); }
static inline complex double cdvec4planepointdistance(cdvec4_t p, cdvec3_t v) { return cdvec4dot(p, cdvec4vec3(v)) / cdvec3abs(cdvec4_planenormal(p)); }

static inline cdvec3_t cdvec3projectontoline(cdvec3_t p, cdvec3_t unitline) { return cdvec3mul(unitline, cdvec3dot(p, unitline)); }
static inline cdvec3_t cdvec3projectontoplane(cdvec3_t p, cdvec3_t unitnormal) { return cdvec3sub(p, cdvec3projectontoline(p, unitnormal)); }
static inline cdvec3_t cdvec3reflect(cdvec3_t p, cdvec3_t unitnormal) { return cdvec3sub(p, cdvec3mul(cdvec3projectontoline(p, unitnormal), 2)); }

static inline cdvec3_t cdvec3trianglenormal(cdvec3_t v1, cdvec3_t v2, cdvec3_t v3) { return cdvec3norm(cdvec3cross(cdvec3sub(v2, v1), cdvec3sub(v3, v1))); }

#endif

