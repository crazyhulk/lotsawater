#ifndef __MATRIX_COMPLEX_H__
#define __MATRIX_COMPLEX_H__

#include "VectorComplex.h"



// Definitions

typedef struct { complex float m[4]; } cmat2x2_t;
typedef struct { complex float m[6]; } cmat3x2_t;
typedef struct { complex float m[9]; } cmat3x3_t;
typedef struct { complex float m[12]; } cmat4x3_t;
typedef struct { complex float m[16]; } cmat4x4_t;

#define cmat2x2one cmat2x2(1, 0, 0, 1)
#define cmat3x2one cmat3x2(1, 0, 0, 0, 1, 0)
#define cmat3x3one cmat3x3(1, 0, 0, 0, 1, 0, 0, 0, 1)
#define cmat4x3one cmat4x3(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0)
#define cmat4x4one cmat4x4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)



// Individual element constructors

static inline cmat2x2_t cmat2x2(complex float a11, complex float a12,
                              complex float a21, complex float a22)
{ return (cmat2x2_t){{a11, a21, a12, a22}}; }

static inline cmat3x2_t cmat3x2(complex float a11, complex float a12, complex float a13,
                              complex float a21, complex float a22, complex float a23)
{ return (cmat3x2_t){{a11, a21, a12, a22, a13, a23}}; }

static inline cmat3x3_t cmat3x3(complex float a11, complex float a12, complex float a13,
                              complex float a21, complex float a22, complex float a23,
                              complex float a31, complex float a32, complex float a33)
{ return (cmat3x3_t){{a11, a21, a31, a12, a22, a32, a13, a23, a33}}; }

static inline cmat4x3_t cmat4x3(complex float a11, complex float a12, complex float a13, complex float a14,
                              complex float a21, complex float a22, complex float a23, complex float a24,
                              complex float a31, complex float a32, complex float a33, complex float a34)
{ return (cmat4x3_t){{a11, a21, a31, a12, a22, a32, a13, a23, a33, a14, a24, a34}}; }

static inline cmat4x4_t cmat4x4(complex float a11, complex float a12, complex float a13, complex float a14,
                              complex float a21, complex float a22, complex float a23, complex float a24,
                              complex float a31, complex float a32, complex float a33, complex float a34,
                              complex float a41, complex float a42, complex float a43, complex float a44)
{ return (cmat4x4_t){{a11, a21, a31, a41, a12, a22, a32, a42, a13, a23, a33, a43, a14, a24, a34, a44}}; }



// Individual element extractors

static inline complex float cmat2x2_11(cmat2x2_t m) { return m.m[0]; }
static inline complex float cmat2x2_21(cmat2x2_t m) { return m.m[1]; }
static inline complex float cmat2x2_12(cmat2x2_t m) { return m.m[2]; }
static inline complex float cmat2x2_22(cmat2x2_t m) { return m.m[3]; }

static inline complex float cmat3x2_11(cmat3x2_t m) { return m.m[0]; }
static inline complex float cmat3x2_21(cmat3x2_t m) { return m.m[1]; }
static inline complex float cmat3x2_12(cmat3x2_t m) { return m.m[2]; }
static inline complex float cmat3x2_22(cmat3x2_t m) { return m.m[3]; }
static inline complex float cmat3x2_13(cmat3x2_t m) { return m.m[4]; }
static inline complex float cmat3x2_23(cmat3x2_t m) { return m.m[5]; }

static inline complex float cmat3x3_11(cmat3x3_t m) { return m.m[0]; }
static inline complex float cmat3x3_21(cmat3x3_t m) { return m.m[1]; }
static inline complex float cmat3x3_31(cmat3x3_t m) { return m.m[2]; }
static inline complex float cmat3x3_12(cmat3x3_t m) { return m.m[3]; }
static inline complex float cmat3x3_22(cmat3x3_t m) { return m.m[4]; }
static inline complex float cmat3x3_32(cmat3x3_t m) { return m.m[5]; }
static inline complex float cmat3x3_13(cmat3x3_t m) { return m.m[6]; }
static inline complex float cmat3x3_23(cmat3x3_t m) { return m.m[7]; }
static inline complex float cmat3x3_33(cmat3x3_t m) { return m.m[8]; }

static inline complex float cmat4x3_11(cmat4x3_t m) { return m.m[0]; }
static inline complex float cmat4x3_21(cmat4x3_t m) { return m.m[1]; }
static inline complex float cmat4x3_31(cmat4x3_t m) { return m.m[2]; }
static inline complex float cmat4x3_12(cmat4x3_t m) { return m.m[3]; }
static inline complex float cmat4x3_22(cmat4x3_t m) { return m.m[4]; }
static inline complex float cmat4x3_32(cmat4x3_t m) { return m.m[5]; }
static inline complex float cmat4x3_13(cmat4x3_t m) { return m.m[6]; }
static inline complex float cmat4x3_23(cmat4x3_t m) { return m.m[7]; }
static inline complex float cmat4x3_33(cmat4x3_t m) { return m.m[8]; }
static inline complex float cmat4x3_14(cmat4x3_t m) { return m.m[9]; }
static inline complex float cmat4x3_24(cmat4x3_t m) { return m.m[10]; }
static inline complex float cmat4x3_34(cmat4x3_t m) { return m.m[11]; }

static inline complex float cmat4x4_11(cmat4x4_t m) { return m.m[0]; }
static inline complex float cmat4x4_21(cmat4x4_t m) { return m.m[1]; }
static inline complex float cmat4x4_31(cmat4x4_t m) { return m.m[2]; }
static inline complex float cmat4x4_41(cmat4x4_t m) { return m.m[3]; }
static inline complex float cmat4x4_12(cmat4x4_t m) { return m.m[4]; }
static inline complex float cmat4x4_22(cmat4x4_t m) { return m.m[5]; }
static inline complex float cmat4x4_32(cmat4x4_t m) { return m.m[6]; }
static inline complex float cmat4x4_42(cmat4x4_t m) { return m.m[7]; }
static inline complex float cmat4x4_13(cmat4x4_t m) { return m.m[8]; }
static inline complex float cmat4x4_23(cmat4x4_t m) { return m.m[9]; }
static inline complex float cmat4x4_33(cmat4x4_t m) { return m.m[10]; }
static inline complex float cmat4x4_43(cmat4x4_t m) { return m.m[11]; }
static inline complex float cmat4x4_14(cmat4x4_t m) { return m.m[12]; }
static inline complex float cmat4x4_24(cmat4x4_t m) { return m.m[13]; }
static inline complex float cmat4x4_34(cmat4x4_t m) { return m.m[14]; }
static inline complex float cmat4x4_44(cmat4x4_t m) { return m.m[15]; }




// Column vector constructors

static inline cmat2x2_t cmat2x2cols(cvec2_t col1, cvec2_t col2) {
	return cmat2x2(col1.x, col2.x,
	              col1.y, col2.y);
}

static inline cmat3x2_t cmat3x2cols(cvec2_t col1, cvec2_t col2, cvec2_t col3) {
	return cmat3x2(col1.x, col2.x, col3.x,
	              col1.y, col2.y, col3.y);
}

static inline cmat3x3_t cmat3x3cols(cvec3_t col1, cvec3_t col2, cvec3_t col3) {
	return cmat3x3(col1.x, col2.x, col3.x,
	              col1.y, col2.y, col3.y,
	              col1.z, col2.z, col3.z);
}

static inline cmat4x3_t cmat4x3cols(cvec3_t col1, cvec3_t col2, cvec3_t col3, cvec3_t col4) {
	return cmat4x3(col1.x, col2.x, col3.x, col4.x,
	              col1.y, col2.y, col3.y, col4.y,
	              col1.z, col2.z, col3.z, col4.z);
}

static inline cmat4x4_t cmat4x4cols(cvec4_t col1, cvec4_t col2, cvec4_t col3, cvec4_t col4) {
	return cmat4x4(col1.x, col2.x, col3.x, col4.x,
	              col1.y, col2.y, col3.y, col4.y,
	              col1.z, col2.z, col3.z, col4.z,
	              col1.w, col2.w, col3.w, col4.w);
}

static inline cmat2x2_t cmat2x2vec2(cvec2_t x, cvec2_t y) { return cmat2x2cols(x, y); }
static inline cmat3x2_t cmat3x2vec2(cvec2_t x, cvec2_t y, cvec2_t z) { return cmat3x2cols(x, y, z); }
static inline cmat3x3_t cmat3x3vec3(cvec3_t x, cvec3_t y, cvec3_t z) { return cmat3x3cols(x, y, z); }
static inline cmat4x3_t cmat4x3vec3(cvec3_t x, cvec3_t y, cvec3_t z, cvec3_t w) { return cmat4x3cols(x, y, z, w); }
static inline cmat4x4_t cmat4x4vec4(cvec4_t x, cvec4_t y, cvec4_t z, cvec4_t w) { return cmat4x4cols(x, y, z, w); }



// Column vector extractors

static inline cvec2_t cmat2x2_col1(cmat2x2_t m) { return cvec2(cmat2x2_11(m), cmat2x2_21(m)); }
static inline cvec2_t cmat2x2_col2(cmat2x2_t m) { return cvec2(cmat2x2_12(m), cmat2x2_22(m)); }

static inline cvec2_t cmat3x2_col1(cmat3x2_t m) { return cvec2(cmat3x2_11(m), cmat3x2_21(m)); }
static inline cvec2_t cmat3x2_col2(cmat3x2_t m) { return cvec2(cmat3x2_12(m), cmat3x2_22(m)); }
static inline cvec2_t cmat3x2_col3(cmat3x2_t m) { return cvec2(cmat3x2_13(m), cmat3x2_23(m)); }

static inline cvec3_t cmat3x3_col1(cmat3x3_t m) { return cvec3(cmat3x3_11(m), cmat3x3_21(m), cmat3x3_31(m)); }
static inline cvec3_t cmat3x3_col2(cmat3x3_t m) { return cvec3(cmat3x3_12(m), cmat3x3_22(m), cmat3x3_32(m)); }
static inline cvec3_t cmat3x3_col3(cmat3x3_t m) { return cvec3(cmat3x3_13(m), cmat3x3_23(m), cmat3x3_33(m)); }

static inline cvec3_t cmat4x3_col1(cmat4x3_t m) { return cvec3(cmat4x3_11(m), cmat4x3_21(m), cmat4x3_31(m)); }
static inline cvec3_t cmat4x3_col2(cmat4x3_t m) { return cvec3(cmat4x3_12(m), cmat4x3_22(m), cmat4x3_32(m)); }
static inline cvec3_t cmat4x3_col3(cmat4x3_t m) { return cvec3(cmat4x3_13(m), cmat4x3_23(m), cmat4x3_33(m)); }
static inline cvec3_t cmat4x3_col4(cmat4x3_t m) { return cvec3(cmat4x3_14(m), cmat4x3_24(m), cmat4x3_34(m)); }

static inline cvec4_t cmat4x4_col1(cmat4x4_t m) { return cvec4(cmat4x4_11(m), cmat4x4_21(m), cmat4x4_31(m), cmat4x4_41(m)); }
static inline cvec4_t cmat4x4_col2(cmat4x4_t m) { return cvec4(cmat4x4_12(m), cmat4x4_22(m), cmat4x4_32(m), cmat4x4_42(m)); }
static inline cvec4_t cmat4x4_col3(cmat4x4_t m) { return cvec4(cmat4x4_13(m), cmat4x4_23(m), cmat4x4_33(m), cmat4x4_43(m)); }
static inline cvec4_t cmat4x4_col4(cmat4x4_t m) { return cvec4(cmat4x4_14(m), cmat4x4_24(m), cmat4x4_34(m), cmat4x4_44(m)); }

static inline cvec2_t cmat2x2_x(cmat2x2_t m) { return cmat2x2_col1(m); }
static inline cvec2_t cmat2x2_y(cmat2x2_t m) { return cmat2x2_col2(m); }

static inline cvec2_t cmat3x2_x(cmat3x2_t m) { return cmat3x2_col1(m); }
static inline cvec2_t cmat3x2_y(cmat3x2_t m) { return cmat3x2_col2(m); }
static inline cvec2_t cmat3x2_z(cmat3x2_t m) { return cmat3x2_col3(m); }

static inline cvec3_t cmat3x3_x(cmat3x3_t m) { return cmat3x3_col1(m); }
static inline cvec3_t cmat3x3_y(cmat3x3_t m) { return cmat3x3_col2(m); }
static inline cvec3_t cmat3x3_z(cmat3x3_t m) { return cmat3x3_col3(m); }

static inline cvec3_t cmat4x3_x(cmat4x3_t m) { return cmat4x3_col1(m); }
static inline cvec3_t cmat4x3_y(cmat4x3_t m) { return cmat4x3_col2(m); }
static inline cvec3_t cmat4x3_z(cmat4x3_t m) { return cmat4x3_col3(m); }
static inline cvec3_t cmat4x3_w(cmat4x3_t m) { return cmat4x3_col4(m); }

static inline cvec4_t cmat4x4_x(cmat4x4_t m) { return cmat4x4_col1(m); }
static inline cvec4_t cmat4x4_y(cmat4x4_t m) { return cmat4x4_col2(m); }
static inline cvec4_t cmat4x4_z(cmat4x4_t m) { return cmat4x4_col3(m); }
static inline cvec4_t cmat4x4_w(cmat4x4_t m) { return cmat4x4_col4(m); }



// Row vector constructors

static inline cmat2x2_t cmat2x2rows(cvec2_t row1, cvec2_t row2) {
	return cmat2x2(row1.x, row1.y,
	              row2.x, row2.y);
}

static inline cmat3x2_t cmat3x2rows(cvec3_t row1, cvec3_t row2) {
	return cmat3x2(row1.x, row1.y, row1.z,
	              row2.x, row2.y, row2.z);
}

static inline cmat3x3_t cmat3x3rows(cvec3_t row1, cvec3_t row2, cvec3_t row3) {
	return cmat3x3(row1.x, row1.y, row1.z,
	              row2.x, row2.y, row2.z,
	              row3.x, row3.y, row3.z);
}

static inline cmat4x3_t cmat4x3rows(cvec4_t row1, cvec4_t row2, cvec4_t row3) {
	return cmat4x3(row1.x, row1.y, row1.z, row1.w,
	              row2.x, row2.y, row2.z, row2.w,
	              row3.x, row3.y, row3.z, row3.w);
}

static inline cmat4x4_t cmat4x4rows(cvec4_t row1, cvec4_t row2, cvec4_t row3, cvec4_t row4) {
	return cmat4x4(row1.x, row1.y, row1.z, row1.w,
	              row2.x, row2.y, row2.z, row2.w,
	              row3.x, row3.y, row3.z, row3.w,
	              row4.x, row4.y, row4.z, row4.w);
}



// Row vector extractors

static inline cvec2_t cmat2x2_row1(cmat2x2_t m) { return cvec2(cmat2x2_11(m), cmat2x2_12(m)); }
static inline cvec2_t cmat2x2_row2(cmat2x2_t m) { return cvec2(cmat2x2_21(m), cmat2x2_22(m)); }

static inline cvec3_t cmat3x2_row1(cmat3x2_t m) { return cvec3(cmat3x2_11(m), cmat3x2_12(m), cmat3x2_13(m)); }
static inline cvec3_t cmat3x2_row2(cmat3x2_t m) { return cvec3(cmat3x2_21(m), cmat3x2_22(m), cmat3x2_23(m)); }

static inline cvec3_t cmat3x3_row1(cmat3x3_t m) { return cvec3(cmat3x3_11(m), cmat3x3_12(m), cmat3x3_13(m)); }
static inline cvec3_t cmat3x3_row2(cmat3x3_t m) { return cvec3(cmat3x3_21(m), cmat3x3_22(m), cmat3x3_23(m)); }
static inline cvec3_t cmat3x3_row3(cmat3x3_t m) { return cvec3(cmat3x3_31(m), cmat3x3_32(m), cmat3x3_33(m)); }

static inline cvec4_t cmat4x3_row1(cmat4x3_t m) { return cvec4(cmat4x3_11(m), cmat4x3_12(m), cmat4x3_13(m), cmat4x3_14(m)); }
static inline cvec4_t cmat4x3_row2(cmat4x3_t m) { return cvec4(cmat4x3_21(m), cmat4x3_22(m), cmat4x3_23(m), cmat4x3_24(m)); }
static inline cvec4_t cmat4x3_row3(cmat4x3_t m) { return cvec4(cmat4x3_31(m), cmat4x3_32(m), cmat4x3_33(m), cmat4x3_34(m)); }

static inline cvec4_t cmat4x4_row1(cmat4x4_t m) { return cvec4(cmat4x4_11(m), cmat4x4_12(m), cmat4x4_13(m), cmat4x4_14(m)); }
static inline cvec4_t cmat4x4_row2(cmat4x4_t m) { return cvec4(cmat4x4_21(m), cmat4x4_22(m), cmat4x4_23(m), cmat4x4_24(m)); }
static inline cvec4_t cmat4x4_row3(cmat4x4_t m) { return cvec4(cmat4x4_31(m), cmat4x4_32(m), cmat4x4_33(m), cmat4x4_34(m)); }
static inline cvec4_t cmat4x4_row4(cmat4x4_t m) { return cvec4(cmat4x4_41(m), cmat4x4_42(m), cmat4x4_43(m), cmat4x4_44(m)); }





// Upgrade constructors

static inline cmat3x2_t cmat3x2affine2x2(cmat2x2_t m, cvec2_t col3) {
	cvec2_t col1 = cmat2x2_col1(m), col2 = cmat2x2_col2(m);
	return cmat3x2cols(col1, col2, col3);
}

static inline cmat3x3_t cmat3x3affine2x2(cmat2x2_t m, cvec2_t col3) {
	cvec2_t col1 = cmat2x2_col1(m), col2 = cmat2x2_col2(m);
	return cmat3x3(col1.x, col2.x, col3.x,
	              col1.y, col2.y, col3.y,
	              0, 0, 1);
}

static inline cmat3x3_t cmat3x3affine3x2(cmat3x2_t m) {
	cvec2_t col1 = cmat3x2_col1(m), col2 = cmat3x2_col2(m), col3 = cmat3x2_col3(m);
	return cmat3x3(col1.x, col2.x, col3.x,
	              col1.y, col2.y, col3.y,
	              0, 0, 1);
}

static inline cmat4x3_t cmat4x3affine3x3(cmat3x3_t m, cvec3_t col4) {
	cvec3_t col1 = cmat3x3_col1(m), col2 = cmat3x3_col2(m), col3 = cmat3x3_col3(m);
	return cmat4x3cols(col1, col2, col3, col4);
}

static inline cmat4x4_t cmat4x4affine3x3(cmat3x3_t m, cvec3_t col4) {
	cvec3_t col1 = cmat3x3_col1(m), col2 = cmat3x3_col2(m), col3 = cmat3x3_col3(m);
	return cmat4x4(col1.x, col2.x, col3.x, col4.x,
	              col1.y, col2.y, col3.y, col4.y,
	              col1.z, col2.z, col3.z, col4.z,
	              0, 0, 0, 1);
}

static inline cmat4x4_t cmat4x4affine4x3(cmat4x3_t m) {
	cvec3_t col1 = cmat4x3_col1(m), col2 = cmat4x3_col2(m), col3 = cmat4x3_col3(m), col4 = cmat4x3_col4(m);
	return cmat4x4(col1.x, col2.x, col3.x, col4.x,
	              col1.y, col2.y, col3.y, col4.y,
	              col1.z, col2.z, col3.z, col4.z,
	              0, 0, 0, 1);
}



// Downgrade extractors

static inline cmat2x2_t cmat3x2_mat2x2(cmat3x2_t m) { return cmat2x2cols(cmat3x2_col1(m), cmat3x2_col2(m)); }
static inline cmat2x2_t cmat3x3_mat2x2(cmat3x3_t m) { return cmat2x2cols(cvec3_xy(cmat3x3_col1(m)), cvec3_xy(cmat3x3_col2(m))); }
static inline cmat3x2_t cmat3x3_mat3x2(cmat3x3_t m) { return cmat3x2cols(cvec3_xy(cmat3x3_col1(m)), cvec3_xy(cmat3x3_col2(m)), cvec3_xy(cmat3x3_col3(m))); }
static inline cmat3x3_t cmat4x3_mat3x3(cmat4x3_t m) { return cmat3x3cols(cmat4x3_col1(m), cmat4x3_col2(m), cmat4x3_col3(m)); }
static inline cmat3x3_t cmat4x4_mat3x3(cmat4x4_t m) { return cmat3x3cols(cvec4_xyz(cmat4x4_col1(m)), cvec4_xyz(cmat4x4_col2(m)), cvec4_xyz(cmat4x4_col3(m))); }
static inline cmat4x3_t cmat4x4_mat4x3(cmat4x4_t m) { return cmat4x3cols(cvec4_xyz(cmat4x4_col1(m)), cvec4_xyz(cmat4x4_col2(m)), cvec4_xyz(cmat4x4_col3(m)), cvec4_xyz(cmat4x4_col4(m))); }




// Translation constructors

static inline cmat3x2_t cmat3x2translate(cvec2_t v) {
	return cmat3x2(1, 0, v.x,
	              0, 1, v.y);
}

static inline cmat4x3_t cmat4x3translate(cvec3_t v) {
	return cmat4x3(1, 0, 0, v.x,
	              0, 1, 0, v.y,
	              0, 0, 1, v.z);
}
static inline cmat4x4_t cmat4x4translate(cvec3_t v) { return cmat4x4affine4x3(cmat4x3translate(v)); }



// Scaling constructors

static inline cmat2x2_t cmat2x2scale(complex float x, complex float y) {
	return cmat2x2(x, 0,
	              0, y);
}
static inline cmat3x2_t cmat3x2scale(complex float x, complex float y) { return cmat3x2affine2x2(cmat2x2scale(x, y), cvec2zero); }

static inline cmat3x3_t cmat3x3scale(complex float x, complex float y, complex float z) {
	return cmat3x3(x, 0, 0,
	              0, y, 0,
	              0, 0, z);
}
static inline cmat4x3_t cmat4x3scale(complex float x, complex float y, complex float z) { return cmat4x3affine3x3(cmat3x3scale(x, y, z), cvec3zero); }
static inline cmat4x4_t cmat4x4scale(complex float x, complex float y, complex float z) { return cmat4x4affine3x3(cmat3x3scale(x, y, z), cvec3zero); }



// Rotation constructors

static inline cmat2x2_t cmat2x2rotate(complex float a) {
	return cmat2x2(ccosf(a), -csinf(a),
	              csinf(a), ccosf(a));
}
static inline cmat3x2_t cmat3x2rotate(complex float a) { return cmat3x2affine2x2(cmat2x2rotate(a), cvec2zero); }

static inline cmat3x3_t cmat3x3rotatex(complex float a) {
	return cmat3x3(1, 0, 0,
	              0, ccosf(a), -csinf(a),
	              0, csinf(a), ccosf(a));
}
static inline cmat4x3_t cmat4x3rotatex(complex float a) { return cmat4x3affine3x3(cmat3x3rotatex(a), cvec3zero); }
static inline cmat4x4_t cmat4x4rotatex(complex float a) { return cmat4x4affine3x3(cmat3x3rotatex(a), cvec3zero); }

static inline cmat3x3_t cmat3x3rotatey(complex float a) {
	return cmat3x3( ccosf(a), 0, csinf(a),
	               0, 1, 0,
	               -csinf(a), 0, ccosf(a));
}
static inline cmat4x3_t cmat4x3rotatey(complex float a) { return cmat4x3affine3x3(cmat3x3rotatey(a), cvec3zero); }
static inline cmat4x4_t cmat4x4rotatey(complex float a) { return cmat4x4affine3x3(cmat3x3rotatey(a), cvec3zero); }

static inline cmat3x3_t cmat3x3rotatez(complex float a) {
	return cmat3x3(ccosf(a), -csinf(a), 0,
	              csinf(a), ccosf(a), 0,
	              0, 0, 1);
}
static inline cmat4x3_t cmat4x3rotatez(complex float a) { return cmat4x3affine3x3(cmat3x3rotatez(a), cvec3zero); }
static inline cmat4x4_t cmat4x4rotatez(complex float a) { return cmat4x4affine3x3(cmat3x3rotatez(a), cvec3zero); }

cmat3x3_t cmat3x3rotate(complex float angle, cvec3_t axis);
static inline cmat4x3_t cmat4x3rotate(complex float angle, cvec3_t axis) { return cmat4x3affine3x3(cmat3x3rotate(angle, axis), cvec3zero); }
static inline cmat4x4_t cmat4x4rotate(complex float angle, cvec3_t axis) { return cmat4x4affine3x3(cmat3x3rotate(angle, axis), cvec3zero); }

cmat4x3_t cmat4x3affinemul(cmat4x3_t a, cmat4x3_t b);
cmat4x4_t cmat4x4affinemul(cmat4x4_t a, cmat4x4_t b);
static inline cmat4x3_t cmat4x3rotatepivot(complex float angle, cvec3_t axis, cvec3_t pivot) { return cmat4x3affinemul(cmat4x3affine3x3(cmat3x3rotate(angle, axis), pivot), cmat4x3translate(cvec3neg(pivot))); }
static inline cmat4x4_t cmat4x4rotatepivot(complex float angle, cvec3_t axis, cvec3_t pivot) { return cmat4x4affinemul(cmat4x4affine3x3(cmat3x3rotate(angle, axis), pivot), cmat4x4translate(cvec3neg(pivot))); }



// Lookat constructors

cmat3x3_t cmat3x3inverselookat(cvec3_t eye, cvec3_t center, cvec3_t up);
static inline cmat4x3_t cmat4x3inverselookat(cvec3_t eye, cvec3_t center, cvec3_t up) { return cmat4x3affine3x3(cmat3x3inverselookat(eye, center, up), eye); }
static inline cmat4x4_t cmat4x4inverselookat(cvec3_t eye, cvec3_t center, cvec3_t up) { return cmat4x4affine3x3(cmat3x3inverselookat(eye, center, up), eye); }

static inline cmat3x3_t cmat3x3transpose(cmat3x3_t m);
cvec3_t cmat3x3transform(cmat3x3_t m, cvec3_t v);

static inline cmat3x3_t cmat3x3lookat(cvec3_t eye, cvec3_t center, cvec3_t up) { return cmat3x3transpose(cmat3x3inverselookat(eye, center, up)); }
static inline cmat4x3_t cmat4x3lookat(cvec3_t eye, cvec3_t center, cvec3_t up) { cmat3x3_t m = cmat3x3lookat(eye, center, up); return cmat4x3affine3x3(m, cmat3x3transform(m, eye)); }
static inline cmat4x4_t cmat4x4lookat(cvec3_t eye, cvec3_t center, cvec3_t up) { cmat3x3_t m = cmat3x3lookat(eye, center, up); return cmat4x4affine3x3(m, cmat3x3transform(m, eye)); }




// Orthogonal constructors

static inline cmat3x2_t cmat3x2ortho(complex float xmin, complex float xmax, complex float ymin, complex float ymax) {
	return cmat3x2(2 / (xmax - xmin), 0, -(xmax + xmin) / (xmax - xmin),
	              0, 2 / (ymax - ymin), -(ymax + ymin) / (ymax - ymin));
}
static inline cmat3x3_t cmat3x3ortho(complex float xmin, complex float xmax, complex float ymin, complex float ymax) { return cmat3x3affine3x2(cmat3x2ortho(xmin, xmax, ymin, ymax)); }

static inline cmat4x3_t cmat4x3ortho(complex float xmin, complex float xmax, complex float ymin, complex float ymax, complex float zmin, complex float zmax) {
	return cmat4x3(2 / (xmax - xmin), 0, 0, -(xmax + xmin) / (xmax - xmin),
	              0, 2 / (ymax - ymin), 0, -(ymax + ymin) / (ymax - ymin),
	              0, 0, -2 / (zmax - zmin), -(zmax + zmin) / (zmax - zmin));
	// -2 on z to match the OpenGL definition.
}
static inline cmat4x4_t cmat4x4ortho(complex float xmin, complex float xmax, complex float ymin, complex float ymax, complex float zmin, complex float zmax) { return cmat4x4affine4x3(cmat4x3ortho(xmin, xmax, ymin, ymax, zmin, zmax)); }



// Perspective constructors

static inline cmat4x4_t cmat4x4perspectiveinternal(complex float fx, complex float fy, complex float znear, complex float zfar) {
	return cmat4x4(fx, 0, 0, 0,
	              0, fy, 0, 0,
	              0, 0, (zfar + znear) / (znear - zfar), 2 * zfar * znear / (znear - zfar),
	              0, 0, -1, 0);
}

static inline cmat4x4_t cmat4x4horizontalperspective(complex float fovx, complex float aspect, complex float znear, complex float zfar) {
	complex float f = 1 / ctanf(fovx * M_PI / 180 / 2);
	return cmat4x4perspectiveinternal(f, f * aspect, znear, zfar);
}

static inline cmat4x4_t cmat4x4verticalperspective(complex float fovy, complex float aspect, complex float znear, complex float zfar) {
	complex float f = 1 / ctanf(fovy * M_PI / 180 / 2);
	return cmat4x4perspectiveinternal(f / aspect, f, znear, zfar);
}

/*static inline cmat4x4_t cmat4x4minperspective(complex float fov, complex float aspect, complex float znear, complex float zfar) {
	if(aspect < 1) return cmat4x4horizontalperspective(fov, aspect, znear, zfar);
	else return cmat4x4verticalperspective(fov, aspect, znear, zfar);
}*/

/*static inline cmat4x4_t cmat4x4maxperspective(complex float fov, complex float aspect, complex float znear, complex float zfar) {
	if(aspect > 1) return cmat4x4horizontalperspective(fov, aspect, znear, zfar);
	else return cmat4x4verticalperspective(fov, aspect, znear, zfar);
}*/

static inline cmat4x4_t cmat4x4diagonalperspective(complex float fov, complex float aspect, complex float znear, complex float zfar) {
	complex float f = 1 / ctanf(fov * M_PI / 180 / 2);
	return cmat4x4perspectiveinternal(f * csqrtf(1 / (aspect * aspect) + 1), f * csqrtf(aspect * aspect + 1), znear, zfar);
}




// Prespective extractors

static inline cvec4_t cmat4x4_leftplane(cmat4x4_t m) { return cvec4add(cmat4x4_row4(m), cmat4x4_row1(m)); }
static inline cvec4_t cmat4x4_rightplane(cmat4x4_t m) { return cvec4sub(cmat4x4_row4(m), cmat4x4_row1(m)); }
static inline cvec4_t cmat4x4_bottomplane(cmat4x4_t m) { return cvec4add(cmat4x4_row4(m), cmat4x4_row2(m)); }
static inline cvec4_t cmat4x4_topplane(cmat4x4_t m) { return cvec4sub(cmat4x4_row4(m), cmat4x4_row2(m)); }
static inline cvec4_t cmat4x4_nearplane(cmat4x4_t m) { return cvec4add(cmat4x4_row4(m), cmat4x4_row3(m)); }
static inline cvec4_t cmat4x4_farplane(cmat4x4_t m) { return cvec4sub(cmat4x4_row4(m), cmat4x4_row3(m)); }

cmat4x3_t cmat4x3affineinverse(cmat4x3_t m);
static inline cvec3_t cmat4x4_cameraposition(cmat4x4_t m) { return cmat4x3_col4(cmat4x3affineinverse(cmat4x3rows(cmat4x4_row1(m), cmat4x4_row2(m), cmat4x4_row4(m)))); }



// Comparison operations

static inline bool cmat2x2equal(cmat2x2_t a, cmat2x2_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }
static inline bool cmat3x2equal(cmat3x2_t a, cmat3x2_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }
static inline bool cmat3x3equal(cmat3x3_t a, cmat3x3_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }
static inline bool cmat4x3equal(cmat4x3_t a, cmat4x3_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }
static inline bool cmat4x4equal(cmat4x4_t a, cmat4x4_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }

/*static inline bool cmat2x2almostequal(cmat2x2_t a, cmat2x2_t b, float epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(cabsf(a.m[i] - b.m[i]) > epsilon) return false; return true; }*/
/*static inline bool cmat3x2almostequal(cmat3x2_t a, cmat3x2_t b, float epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(cabsf(a.m[i] - b.m[i]) > epsilon) return false; return true; }*/
/*static inline bool cmat3x3almostequal(cmat3x3_t a, cmat3x3_t b, float epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(cabsf(a.m[i] - b.m[i]) > epsilon) return false; return true; }*/
/*static inline bool cmat4x3almostequal(cmat4x3_t a, cmat4x3_t b, float epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(cabsf(a.m[i] - b.m[i]) > epsilon) return false; return true; }*/
/*static inline bool cmat4x4almostequal(cmat4x4_t a, cmat4x4_t b, float epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(cabsf(a.m[i] - b.m[i]) > epsilon) return false; return true; }*/



// Multiplication

cmat2x2_t cmat2x2mul(cmat2x2_t a, cmat2x2_t b);
cmat3x3_t cmat3x3mul(cmat3x3_t a, cmat3x3_t b);
cmat4x4_t cmat4x4mul(cmat4x4_t a, cmat4x4_t b);

cmat3x2_t cmat3x2affinemul(cmat3x2_t a, cmat3x2_t b);
cmat3x3_t cmat3x3affinemul(cmat3x3_t a, cmat3x3_t b);
cmat4x3_t cmat4x3affinemul(cmat4x3_t a, cmat4x3_t b);
cmat4x4_t cmat4x4affinemul(cmat4x4_t a, cmat4x4_t b);



// Scalar multiplication and division

static inline cmat2x2_t cmat2x2smul(cmat2x2_t a, complex float b) { cmat2x2_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }
static inline cmat3x2_t cmat3x2smul(cmat2x2_t a, complex float b) { cmat3x2_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }
static inline cmat3x3_t cmat3x3smul(cmat3x3_t a, complex float b) { cmat3x3_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }
static inline cmat4x3_t cmat4x3smul(cmat2x2_t a, complex float b) { cmat4x3_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }
static inline cmat4x4_t cmat4x4smul(cmat4x4_t a, complex float b) { cmat4x4_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }

static inline cmat2x2_t cmat2x2sdiv(cmat2x2_t a, complex float b) { cmat2x2_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }
static inline cmat3x2_t cmat3x2sdiv(cmat2x2_t a, complex float b) { cmat3x2_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }
static inline cmat3x3_t cmat3x3sdiv(cmat3x3_t a, complex float b) { cmat3x3_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }
static inline cmat4x3_t cmat4x3sdiv(cmat2x2_t a, complex float b) { cmat4x3_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }
static inline cmat4x4_t cmat4x4sdiv(cmat4x4_t a, complex float b) { cmat4x4_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }



// Transpose

static inline cmat2x2_t cmat2x2transpose(cmat2x2_t m) { return cmat2x2cols(cmat2x2_row1(m), cmat2x2_row2(m)); }
static inline cmat3x3_t cmat3x3transpose(cmat3x3_t m) { return cmat3x3cols(cmat3x3_row1(m), cmat3x3_row2(m), cmat3x3_row3(m)); }
static inline cmat4x4_t cmat4x4transpose(cmat4x4_t m) { return cmat4x4cols(cmat4x4_row1(m), cmat4x4_row2(m), cmat4x4_row3(m), cmat4x4_row4(m)); }



// Determinant

static inline complex float cmat2x2det(cmat2x2_t m) {
	return cmat2x2_11(m) * cmat2x2_22(m) - cmat2x2_21(m) * cmat2x2_12(m);
}

static inline complex float cmat3x3det(cmat3x3_t m) {
	return cmat3x3_11(m) * cmat3x3_22(m) * cmat3x3_33(m)
	       - cmat3x3_11(m) * cmat3x3_32(m) * cmat3x3_23(m)
	       + cmat3x3_21(m) * cmat3x3_32(m) * cmat3x3_13(m)
	       - cmat3x3_21(m) * cmat3x3_12(m) * cmat3x3_33(m)
	       + cmat3x3_31(m) * cmat3x3_12(m) * cmat3x3_23(m)
	       - cmat3x3_31(m) * cmat3x3_22(m) * cmat3x3_13(m);
}

complex float cmat4x4det(cmat4x4_t m);

static inline complex float cmat3x2affinedet(cmat3x2_t m) {
	return cmat3x2_11(m) * cmat3x2_22(m) - cmat3x2_21(m) * cmat3x2_12(m);
}

static inline complex float cmat3x3affinedet(cmat3x3_t m) {
	return cmat3x3_11(m) * cmat3x3_22(m) - cmat3x3_21(m) * cmat3x3_12(m);
}

static inline complex float cmat4x3affinedet(cmat4x3_t m) {
	return cmat4x3_11(m) * cmat4x3_22(m) * cmat4x3_33(m)
	       - cmat4x3_11(m) * cmat4x3_32(m) * cmat4x3_23(m)
	       + cmat4x3_21(m) * cmat4x3_32(m) * cmat4x3_13(m)
	       - cmat4x3_21(m) * cmat4x3_12(m) * cmat4x3_33(m)
	       + cmat4x3_31(m) * cmat4x3_12(m) * cmat4x3_23(m)
	       - cmat4x3_31(m) * cmat4x3_22(m) * cmat4x3_13(m);
}

static inline complex float cmat4x4affinedet(cmat4x4_t m) {
	return cmat4x4_11(m) * cmat4x4_22(m) * cmat4x4_33(m)
	       - cmat4x4_11(m) * cmat4x4_32(m) * cmat4x4_23(m)
	       + cmat4x4_21(m) * cmat4x4_32(m) * cmat4x4_13(m)
	       - cmat4x4_21(m) * cmat4x4_12(m) * cmat4x4_33(m)
	       + cmat4x4_31(m) * cmat4x4_12(m) * cmat4x4_23(m)
	       - cmat4x4_31(m) * cmat4x4_22(m) * cmat4x4_13(m);
}



// Inverse

static inline cmat2x2_t cmat2x2inverse(cmat2x2_t m) {
	complex float det = cmat2x2det(m); // singular if det==0

	return cmat2x2( cmat2x2_22(m) / det, -cmat2x2_12(m) / det,
	               -cmat2x2_21(m) / det, cmat2x2_11(m) / det);
}

cmat3x3_t cmat3x3inverse(cmat3x3_t m);
cmat4x4_t cmat4x4inverse(cmat4x4_t m);

cmat3x2_t cmat3x2affineinverse(cmat3x2_t m);
cmat3x3_t cmat3x3affineinverse(cmat3x3_t m);
cmat4x3_t cmat4x3affineinverse(cmat4x3_t m);
cmat4x4_t cmat4x4affineinverse(cmat4x4_t m);



// Vector transformation

static inline cvec2_t cmat2x2transform(cmat2x2_t m, cvec2_t v) {
	return cvec2(v.x * cmat2x2_11(m) + v.y * cmat2x2_12(m),
	            v.x * cmat2x2_21(m) + v.y * cmat2x2_22(m));
}

static inline cvec2_t cmat3x2transform(cmat3x2_t m, cvec2_t v) {
	return cvec2(v.x * cmat3x2_11(m) + v.y * cmat3x2_12(m) + cmat3x2_13(m),
	            v.x * cmat3x2_21(m) + v.y * cmat3x2_22(m) + cmat3x2_23(m));
}

cvec3_t cmat3x3transform(cmat3x3_t m, cvec3_t v);
cvec3_t cmat4x3transform(cmat4x3_t m, cvec3_t v);
cvec4_t cmat4x4transform(cmat4x4_t m, cvec4_t v);

cvec2_t cmat3x3transformvec2(cmat3x3_t m, cvec2_t v);
cvec3_t cmat4x4transformvec3(cmat4x4_t m, cvec3_t v);

#endif

