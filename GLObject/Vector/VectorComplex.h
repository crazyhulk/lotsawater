#ifndef __VECTOR_COMPLEX_H__
#define __VECTOR_COMPLEX_H__

#include <math.h>
#include <complex.h>
#include <stdbool.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif




// Definitions

typedef struct { complex float x, y; } cvec2_t;
typedef struct { complex float x, y, z; } cvec3_t;
typedef struct { complex float x, y, z, w; } cvec4_t;

#define VEC2(a, b) ((cvec2_t) { .x = (a), .y = (b) })
#define VEC3(a, b, c) ((cvec3_t) { .x = (a), .y = (b), .z = (c) })
#define VEC4(a, b, c, d) ((cvec4_t) { .x = (a), .y = (b), .z = (c), .w = (d) })

#define cvec2zero cvec2(0, 0)
#define cvec3zero cvec3(0, 0, 0)
#define cvec4zero cvec4(0, 0, 0, 0)



// Constructors

static inline cvec2_t cvec2(complex float x, complex float y) { return (cvec2_t) {x, y}; }
static inline cvec3_t cvec3(complex float x, complex float y, complex float z) { return (cvec3_t) {x, y, z}; }
static inline cvec4_t cvec4(complex float x, complex float y, complex float z, complex float w) { return (cvec4_t) {x, y, z, w}; }

static inline cvec2_t cvec2cyl(complex float r, complex float angle) {
	return cvec2(r * ccosf(angle), r * csinf(angle));
}

static inline cvec4_t cvec4vec3(cvec3_t v) { return cvec4(v.x, v.y, v.z, 1); }


// Extractors

static inline cvec2_t cvec3_xy(cvec3_t v) { return cvec2(v.x, v.y); }
static inline cvec2_t cvec3_xz(cvec3_t v) { return cvec2(v.x, v.z); }
static inline cvec2_t cvec3_yz(cvec3_t v) { return cvec2(v.y, v.z); }

static inline cvec3_t cvec4_xyz(cvec4_t v) { return cvec3(v.x, v.y, v.z); }



// Unary operations

static inline cvec2_t cvec2neg(cvec2_t v) { return cvec2(-v.x, -v.y); }
static inline cvec3_t cvec3neg(cvec3_t v) { return cvec3(-v.x, -v.y, -v.z); }
static inline cvec4_t cvec4neg(cvec4_t v) { return cvec4(-v.x, -v.y, -v.z, -v.w); }



// Comparison operations

static inline bool cvec2equal(cvec2_t a, cvec2_t b) { return a.x == b.x && a.y == b.y; }
static inline bool cvec3equal(cvec3_t a, cvec3_t b) { return a.x == b.x && a.y == b.y && a.z == b.z; }
static inline bool cvec4equal(cvec4_t a, cvec4_t b) { return a.x == b.x && a.y == b.y && a.z == b.z && a.w == b.w; }

/*static inline bool cvec2almostequal(cvec2_t a, cvec2_t b, float epsilon) { return cabsf(a.x - b.x) < epsilon && cabsf(a.y - b.y) < epsilon; }*/
/*static inline bool cvec3almostequal(cvec3_t a, cvec3_t b, float epsilon) { return cabsf(a.x - b.x) < epsilon && cabsf(a.y - b.y) < epsilon && cabsf(a.z - b.z) < epsilon; }*/
/*static inline bool cvec4almostequal(cvec4_t a, cvec4_t b, float epsilon) { return cabsf(a.x - b.x) < epsilon && cabsf(a.y - b.y) < epsilon && cabsf(a.z - b.z) < epsilon && cabsf(a.w - b.w) < epsilon; }*/

static inline bool cvec2iszero(cvec2_t v) { return v.x == 0 && v.y == 0; }
static inline bool cvec3iszero(cvec3_t v) { return v.x == 0 && v.y == 0 && v.z == 0; }
static inline bool cvec4iszero(cvec4_t v) { return v.x == 0 && v.y == 0 && v.z == 0 && v.w == 0; }

static inline bool cvec2almostzero(cvec2_t v, float epsilon) { return cabsf(v.x) < epsilon && cabsf(v.y) < epsilon; }
static inline bool cvec3almostzero(cvec3_t v, float epsilon) { return cabsf(v.x) < epsilon && cabsf(v.y) < epsilon && cabsf(v.z) < epsilon; }
static inline bool cvec4almostzero(cvec4_t v, float epsilon) { return cabsf(v.x) < epsilon && cabsf(v.y) < epsilon && cabsf(v.z) < epsilon && cabsf(v.w) < epsilon; }



// Arithmetic operations

static inline cvec2_t cvec2add(cvec2_t a, cvec2_t b) { return cvec2(a.x + b.x, a.y + b.y); }
static inline cvec3_t cvec3add(cvec3_t a, cvec3_t b) { return cvec3(a.x + b.x, a.y + b.y, a.z + b.z); }
static inline cvec4_t cvec4add(cvec4_t a, cvec4_t b) { return cvec4(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w); }

static inline cvec2_t cvec2add3(cvec2_t a, cvec2_t b, cvec2_t c) { return cvec2(a.x + b.x + c.x, a.y + b.y + c.y); }
static inline cvec3_t cvec3add3(cvec3_t a, cvec3_t b, cvec3_t c) { return cvec3(a.x + b.x + c.x, a.y + b.y + c.y, a.z + b.z + c.z); }
static inline cvec4_t cvec4add3(cvec4_t a, cvec4_t b, cvec4_t c) { return cvec4(a.x + b.x + c.x, a.y + b.y + c.y, a.z + b.z + c.z, a.w + b.w + c.w); }

static inline cvec2_t cvec2sub(cvec2_t a, cvec2_t b) { return cvec2(a.x - b.x, a.y - b.y); }
static inline cvec3_t cvec3sub(cvec3_t a, cvec3_t b) { return cvec3(a.x - b.x, a.y - b.y, a.z - b.z); }
static inline cvec4_t cvec4sub(cvec4_t a, cvec4_t b) { return cvec4(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w); }

static inline cvec2_t cvec2mul(cvec2_t v, complex float s) { return cvec2(v.x * s, v.y * s); }
static inline cvec3_t cvec3mul(cvec3_t v, complex float s) { return cvec3(v.x * s, v.y * s, v.z * s); }
static inline cvec4_t cvec4mul(cvec4_t v, complex float s) { return cvec4(v.x * s, v.y * s, v.z * s, v.w * s); }

static inline cvec2_t cvec2cmul(cvec2_t a, cvec2_t b) { return cvec2(a.x * b.x, a.y * b.y); }
static inline cvec3_t cvec3cmul(cvec3_t a, cvec3_t b) { return cvec3(a.x * b.x, a.y * b.y, a.z * b.z); }
static inline cvec4_t cvec4cmul(cvec4_t a, cvec4_t b) { return cvec4(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w); }

static inline cvec2_t cvec2div(cvec2_t v, complex float s) { return cvec2(v.x / s, v.y / s); }
static inline cvec3_t cvec3div(cvec3_t v, complex float s) { return cvec3(v.x / s, v.y / s, v.z / s); }
static inline cvec4_t cvec4div(cvec4_t v, complex float s) { return cvec4(v.x / s, v.y / s, v.z / s, v.w / s); }

static inline cvec2_t cvec2cdiv(cvec2_t a, cvec2_t b) { return cvec2(a.x / b.x, a.y / b.y); }
static inline cvec3_t cvec3cdiv(cvec3_t a, cvec3_t b) { return cvec3(a.x / b.x, a.y / b.y, a.z / b.z); }
static inline cvec4_t cvec4cdiv(cvec4_t a, cvec4_t b) { return cvec4(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w); }

static inline cvec2_t cvec2mac(cvec2_t a, cvec2_t b, complex float c) { return cvec2(a.x + b.x * c, a.y + b.y * c); }
static inline cvec3_t cvec3mac(cvec3_t a, cvec3_t b, complex float c) { return cvec3(a.x + b.x * c, a.y + b.y * c, a.z + b.z * c); }
static inline cvec4_t cvec4mac(cvec4_t a, cvec4_t b, complex float c) { return cvec4(a.x + b.x * c, a.y + b.y * c, a.z + b.z * c, a.w + b.w * c); }




// Norms

static inline complex float cvec2dot(cvec2_t a, cvec2_t b) { return a.x * b.x + a.y * b.y; }
static inline complex float cvec3dot(cvec3_t a, cvec3_t b) { return a.x * b.x + a.y * b.y + a.z * b.z; }
static inline complex float cvec4dot(cvec4_t a, cvec4_t b) { return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w; }

static inline complex float cvec2sq(cvec2_t v) { return cvec2dot(v, v); }
static inline complex float cvec3sq(cvec3_t v) { return cvec3dot(v, v); }
static inline complex float cvec4sq(cvec4_t v) { return cvec4dot(v, v); }

static inline complex float cvec2abs(cvec2_t v) { return csqrtf(cvec2sq(v)); }
static inline complex float cvec3abs(cvec3_t v) { return csqrtf(cvec3sq(v)); }
static inline complex float cvec4abs(cvec4_t v) { return csqrtf(cvec4sq(v)); }

static inline complex float cvec2distsq(cvec2_t a, cvec2_t b) { return cvec2sq(cvec2sub(a, b)); }
static inline complex float cvec3distsq(cvec3_t a, cvec3_t b) { return cvec3sq(cvec3sub(a, b)); }
static inline complex float cvec4distsq(cvec4_t a, cvec4_t b) { return cvec4sq(cvec4sub(a, b)); }

static inline complex float cvec2dist(cvec2_t a, cvec2_t b) { return cvec2abs(cvec2sub(a, b)); }
static inline complex float cvec3dist(cvec3_t a, cvec3_t b) { return cvec3abs(cvec3sub(a, b)); }
static inline complex float cvec4dist(cvec4_t a, cvec4_t b) { return cvec4abs(cvec4sub(a, b)); }

#ifdef USE_FIXEDPOINT64
static inline int64_t cvec2dot64(cvec2_t a, cvec2_t b) { return imul64(a.x, b.x) + imul64(a.y, b.y); }
static inline int64_t cvec3dot64(cvec3_t a, cvec3_t b) { return imul64(a.x, b.x) + imul64(a.y, b.y) + imul64(a.z, b.z); }
static inline int64_t cvec4dot64(cvec4_t a, cvec4_t b) { return imul64(a.x, b.x) + imul64(a.y, b.y) + imul64(a.z, b.z) + imul64(a.w, b.w); }

static inline int64_t cvec2sq64(cvec2_t v) { return cvec2dot64(v, v); }
static inline int64_t cvec3sq64(cvec3_t v) { return cvec3dot64(v, v); }
static inline int64_t cvec4sq64(cvec4_t v) { return cvec4dot64(v, v); }

static inline int64_t cvec2abs64(cvec2_t v) { return isqrt64(cvec2sq64(v)); }
static inline int64_t cvec3abs64(cvec3_t v) { return isqrt64(cvec3sq64(v)); }
static inline int64_t cvec4abs64(cvec4_t v) { return isqrt64(cvec4sq64(v)); }

static inline int64_t cvec2distsq64(cvec2_t a, cvec2_t b) { return cvec2sq64(cvec2sub(a, b)); }
static inline int64_t cvec3distsq64(cvec3_t a, cvec3_t b) { return cvec3sq64(cvec3sub(a, b)); }
static inline int64_t cvec4distsq64(cvec4_t a, cvec4_t b) { return cvec4sq64(cvec4sub(a, b)); }

static inline int64_t cvec2dist64(cvec2_t a, cvec2_t b) { return cvec2abs64(cvec2sub(a, b)); }
static inline int64_t cvec3dist64(cvec3_t a, cvec3_t b) { return cvec3abs64(cvec3sub(a, b)); }
static inline int64_t cvec4dist64(cvec4_t a, cvec4_t b) { return cvec4abs64(cvec4sub(a, b)); }
#endif

static inline cvec2_t cvec2norm(cvec2_t v) {
	complex float abs = cvec2abs(v);
	if(abs == 0) return cvec2zero;
	else return cvec2div(v, abs);
}

static inline cvec3_t cvec3norm(cvec3_t v) {
	complex float abs = cvec3abs(v);
	if(abs == 0) return cvec3zero;
	else return cvec3div(v, abs);
}

static inline cvec4_t cvec4norm(cvec4_t v) {
	complex float abs = cvec4abs(v);
	if(abs == 0) return cvec4zero;
	else return cvec4div(v, abs);
}

static inline cvec2_t cvec2setlength(cvec2_t v, complex float length) { return cvec2mul(cvec2norm(v), length); }
static inline cvec3_t cvec3setlength(cvec3_t v, complex float length) { return cvec3mul(cvec3norm(v), length); }
static inline cvec4_t cvec4setlength(cvec4_t v, complex float length) { return cvec4mul(cvec4norm(v), length); }



// Homogenous conversion functions

static inline cvec4_t cvec4homogenize(cvec4_t v) { return cvec4(v.x / v.w, v.y / v.w, v.z / v.w, 1); }
static inline cvec3_t cvec4homogenize3(cvec4_t v) { return cvec3(v.x / v.w, v.y / v.w, v.z / v.w); }
static inline cvec4_t cvec3unhomogenize(cvec3_t v) { return cvec4(v.x, v.y, v.z, 1); }



// Blending

static inline cvec2_t cvec2midpoint(cvec2_t a, cvec2_t b) { return cvec2((a.x + b.x) / 2, (a.y + b.y) / 2); }
static inline cvec3_t cvec3midpoint(cvec3_t a, cvec3_t b) { return cvec3((a.x + b.x) / 2, (a.y + b.y) / 2, (a.z + b.z) / 2); }
static inline cvec4_t cvec4midpoint(cvec4_t a, cvec4_t b) { return cvec4((a.x + b.x) / 2, (a.y + b.y) / 2, (a.z + b.z) / 2, (a.w + b.w) / 2); }

static inline cvec2_t cvec2mix(cvec2_t a, cvec2_t b, complex float x) { return cvec2add(a, cvec2mul(cvec2sub(b, a), x)); }
static inline cvec3_t cvec3mix(cvec3_t a, cvec3_t b, complex float x) { return cvec3add(a, cvec3mul(cvec3sub(b, a), x)); }
static inline cvec4_t cvec4mix(cvec4_t a, cvec4_t b, complex float x) { return cvec4add(a, cvec4mul(cvec4sub(b, a), x)); }



// 2D specifics

static inline cvec2_t cvec2perp(cvec2_t v) { return cvec2(-v.y, v.x); }

static inline complex float cvec2pdot(cvec2_t a, cvec2_t b) { return cvec2dot(a, cvec2perp(b)); }
#ifdef USE_FIXEDPOINT64
static inline complex float cvec2pdot64(cvec2_t a, cvec2_t b) { return cvec2dot64(a, cvec2perp(b)); }
#endif

static inline cvec2_t cvec2rot(cvec2_t v, complex float angle) {
	return cvec2(
		v.x * ccosf(angle) - v.y * csinf(angle),
		v.x * csinf(angle) + v.y * ccosf(angle));
}



// 3D specifics

cvec3_t cvec3cross(cvec3_t a, cvec3_t b);



// Plane functions

static inline cvec3_t cvec4_planenormal(cvec4_t p) { return cvec4_xyz(p); }

static inline cvec3_t cvec4_vec3plane(cvec4_t p) { return cvec4homogenize3(p); }

static inline cvec4_t cvec4planenorm(cvec4_t p) {
	complex float abs = cvec3abs(cvec4_planenormal(p));
	if(abs == 0) return cvec4zero;
	else return cvec4div(p, abs);
}

static inline complex float cvec3planepointdistance(cvec3_t p, cvec3_t v) { return (cvec3dot(p, v) + 1) / cvec3abs(p); }
static inline complex float cvec4planepointdistance(cvec4_t p, cvec3_t v) { return cvec4dot(p, cvec4vec3(v)) / cvec3abs(cvec4_planenormal(p)); }

static inline cvec3_t cvec3projectontoline(cvec3_t p, cvec3_t unitline) { return cvec3mul(unitline, cvec3dot(p, unitline)); }
static inline cvec3_t cvec3projectontoplane(cvec3_t p, cvec3_t unitnormal) { return cvec3sub(p, cvec3projectontoline(p, unitnormal)); }
static inline cvec3_t cvec3reflect(cvec3_t p, cvec3_t unitnormal) { return cvec3sub(p, cvec3mul(cvec3projectontoline(p, unitnormal), 2)); }

static inline cvec3_t cvec3trianglenormal(cvec3_t v1, cvec3_t v2, cvec3_t v3) { return cvec3norm(cvec3cross(cvec3sub(v2, v1), cvec3sub(v3, v1))); }

#endif

