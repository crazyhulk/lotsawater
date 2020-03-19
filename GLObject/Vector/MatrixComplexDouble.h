#ifndef __MATRIX_COMPLEX_DOUBLE_H__
#define __MATRIX_COMPLEX_DOUBLE_H__

#include "VectorComplexDouble.h"



// Definitions

typedef struct { complex double m[4]; } cdmat2x2_t;
typedef struct { complex double m[6]; } cdmat3x2_t;
typedef struct { complex double m[9]; } cdmat3x3_t;
typedef struct { complex double m[12]; } cdmat4x3_t;
typedef struct { complex double m[16]; } cdmat4x4_t;

#define cdmat2x2one cdmat2x2(1, 0, 0, 1)
#define cdmat3x2one cdmat3x2(1, 0, 0, 0, 1, 0)
#define cdmat3x3one cdmat3x3(1, 0, 0, 0, 1, 0, 0, 0, 1)
#define cdmat4x3one cdmat4x3(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0)
#define cdmat4x4one cdmat4x4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)



// Individual element constructors

static inline cdmat2x2_t cdmat2x2(complex double a11, complex double a12,
                              complex double a21, complex double a22)
{ return (cdmat2x2_t){{a11, a21, a12, a22}}; }

static inline cdmat3x2_t cdmat3x2(complex double a11, complex double a12, complex double a13,
                              complex double a21, complex double a22, complex double a23)
{ return (cdmat3x2_t){{a11, a21, a12, a22, a13, a23}}; }

static inline cdmat3x3_t cdmat3x3(complex double a11, complex double a12, complex double a13,
                              complex double a21, complex double a22, complex double a23,
                              complex double a31, complex double a32, complex double a33)
{ return (cdmat3x3_t){{a11, a21, a31, a12, a22, a32, a13, a23, a33}}; }

static inline cdmat4x3_t cdmat4x3(complex double a11, complex double a12, complex double a13, complex double a14,
                              complex double a21, complex double a22, complex double a23, complex double a24,
                              complex double a31, complex double a32, complex double a33, complex double a34)
{ return (cdmat4x3_t){{a11, a21, a31, a12, a22, a32, a13, a23, a33, a14, a24, a34}}; }

static inline cdmat4x4_t cdmat4x4(complex double a11, complex double a12, complex double a13, complex double a14,
                              complex double a21, complex double a22, complex double a23, complex double a24,
                              complex double a31, complex double a32, complex double a33, complex double a34,
                              complex double a41, complex double a42, complex double a43, complex double a44)
{ return (cdmat4x4_t){{a11, a21, a31, a41, a12, a22, a32, a42, a13, a23, a33, a43, a14, a24, a34, a44}}; }



// Individual element extractors

static inline complex double cdmat2x2_11(cdmat2x2_t m) { return m.m[0]; }
static inline complex double cdmat2x2_21(cdmat2x2_t m) { return m.m[1]; }
static inline complex double cdmat2x2_12(cdmat2x2_t m) { return m.m[2]; }
static inline complex double cdmat2x2_22(cdmat2x2_t m) { return m.m[3]; }

static inline complex double cdmat3x2_11(cdmat3x2_t m) { return m.m[0]; }
static inline complex double cdmat3x2_21(cdmat3x2_t m) { return m.m[1]; }
static inline complex double cdmat3x2_12(cdmat3x2_t m) { return m.m[2]; }
static inline complex double cdmat3x2_22(cdmat3x2_t m) { return m.m[3]; }
static inline complex double cdmat3x2_13(cdmat3x2_t m) { return m.m[4]; }
static inline complex double cdmat3x2_23(cdmat3x2_t m) { return m.m[5]; }

static inline complex double cdmat3x3_11(cdmat3x3_t m) { return m.m[0]; }
static inline complex double cdmat3x3_21(cdmat3x3_t m) { return m.m[1]; }
static inline complex double cdmat3x3_31(cdmat3x3_t m) { return m.m[2]; }
static inline complex double cdmat3x3_12(cdmat3x3_t m) { return m.m[3]; }
static inline complex double cdmat3x3_22(cdmat3x3_t m) { return m.m[4]; }
static inline complex double cdmat3x3_32(cdmat3x3_t m) { return m.m[5]; }
static inline complex double cdmat3x3_13(cdmat3x3_t m) { return m.m[6]; }
static inline complex double cdmat3x3_23(cdmat3x3_t m) { return m.m[7]; }
static inline complex double cdmat3x3_33(cdmat3x3_t m) { return m.m[8]; }

static inline complex double cdmat4x3_11(cdmat4x3_t m) { return m.m[0]; }
static inline complex double cdmat4x3_21(cdmat4x3_t m) { return m.m[1]; }
static inline complex double cdmat4x3_31(cdmat4x3_t m) { return m.m[2]; }
static inline complex double cdmat4x3_12(cdmat4x3_t m) { return m.m[3]; }
static inline complex double cdmat4x3_22(cdmat4x3_t m) { return m.m[4]; }
static inline complex double cdmat4x3_32(cdmat4x3_t m) { return m.m[5]; }
static inline complex double cdmat4x3_13(cdmat4x3_t m) { return m.m[6]; }
static inline complex double cdmat4x3_23(cdmat4x3_t m) { return m.m[7]; }
static inline complex double cdmat4x3_33(cdmat4x3_t m) { return m.m[8]; }
static inline complex double cdmat4x3_14(cdmat4x3_t m) { return m.m[9]; }
static inline complex double cdmat4x3_24(cdmat4x3_t m) { return m.m[10]; }
static inline complex double cdmat4x3_34(cdmat4x3_t m) { return m.m[11]; }

static inline complex double cdmat4x4_11(cdmat4x4_t m) { return m.m[0]; }
static inline complex double cdmat4x4_21(cdmat4x4_t m) { return m.m[1]; }
static inline complex double cdmat4x4_31(cdmat4x4_t m) { return m.m[2]; }
static inline complex double cdmat4x4_41(cdmat4x4_t m) { return m.m[3]; }
static inline complex double cdmat4x4_12(cdmat4x4_t m) { return m.m[4]; }
static inline complex double cdmat4x4_22(cdmat4x4_t m) { return m.m[5]; }
static inline complex double cdmat4x4_32(cdmat4x4_t m) { return m.m[6]; }
static inline complex double cdmat4x4_42(cdmat4x4_t m) { return m.m[7]; }
static inline complex double cdmat4x4_13(cdmat4x4_t m) { return m.m[8]; }
static inline complex double cdmat4x4_23(cdmat4x4_t m) { return m.m[9]; }
static inline complex double cdmat4x4_33(cdmat4x4_t m) { return m.m[10]; }
static inline complex double cdmat4x4_43(cdmat4x4_t m) { return m.m[11]; }
static inline complex double cdmat4x4_14(cdmat4x4_t m) { return m.m[12]; }
static inline complex double cdmat4x4_24(cdmat4x4_t m) { return m.m[13]; }
static inline complex double cdmat4x4_34(cdmat4x4_t m) { return m.m[14]; }
static inline complex double cdmat4x4_44(cdmat4x4_t m) { return m.m[15]; }




// Column vector constructors

static inline cdmat2x2_t cdmat2x2cols(cdvec2_t col1, cdvec2_t col2) {
	return cdmat2x2(col1.x, col2.x,
	              col1.y, col2.y);
}

static inline cdmat3x2_t cdmat3x2cols(cdvec2_t col1, cdvec2_t col2, cdvec2_t col3) {
	return cdmat3x2(col1.x, col2.x, col3.x,
	              col1.y, col2.y, col3.y);
}

static inline cdmat3x3_t cdmat3x3cols(cdvec3_t col1, cdvec3_t col2, cdvec3_t col3) {
	return cdmat3x3(col1.x, col2.x, col3.x,
	              col1.y, col2.y, col3.y,
	              col1.z, col2.z, col3.z);
}

static inline cdmat4x3_t cdmat4x3cols(cdvec3_t col1, cdvec3_t col2, cdvec3_t col3, cdvec3_t col4) {
	return cdmat4x3(col1.x, col2.x, col3.x, col4.x,
	              col1.y, col2.y, col3.y, col4.y,
	              col1.z, col2.z, col3.z, col4.z);
}

static inline cdmat4x4_t cdmat4x4cols(cdvec4_t col1, cdvec4_t col2, cdvec4_t col3, cdvec4_t col4) {
	return cdmat4x4(col1.x, col2.x, col3.x, col4.x,
	              col1.y, col2.y, col3.y, col4.y,
	              col1.z, col2.z, col3.z, col4.z,
	              col1.w, col2.w, col3.w, col4.w);
}

static inline cdmat2x2_t cdmat2x2vec2(cdvec2_t x, cdvec2_t y) { return cdmat2x2cols(x, y); }
static inline cdmat3x2_t cdmat3x2vec2(cdvec2_t x, cdvec2_t y, cdvec2_t z) { return cdmat3x2cols(x, y, z); }
static inline cdmat3x3_t cdmat3x3vec3(cdvec3_t x, cdvec3_t y, cdvec3_t z) { return cdmat3x3cols(x, y, z); }
static inline cdmat4x3_t cdmat4x3vec3(cdvec3_t x, cdvec3_t y, cdvec3_t z, cdvec3_t w) { return cdmat4x3cols(x, y, z, w); }
static inline cdmat4x4_t cdmat4x4vec4(cdvec4_t x, cdvec4_t y, cdvec4_t z, cdvec4_t w) { return cdmat4x4cols(x, y, z, w); }



// Column vector extractors

static inline cdvec2_t cdmat2x2_col1(cdmat2x2_t m) { return cdvec2(cdmat2x2_11(m), cdmat2x2_21(m)); }
static inline cdvec2_t cdmat2x2_col2(cdmat2x2_t m) { return cdvec2(cdmat2x2_12(m), cdmat2x2_22(m)); }

static inline cdvec2_t cdmat3x2_col1(cdmat3x2_t m) { return cdvec2(cdmat3x2_11(m), cdmat3x2_21(m)); }
static inline cdvec2_t cdmat3x2_col2(cdmat3x2_t m) { return cdvec2(cdmat3x2_12(m), cdmat3x2_22(m)); }
static inline cdvec2_t cdmat3x2_col3(cdmat3x2_t m) { return cdvec2(cdmat3x2_13(m), cdmat3x2_23(m)); }

static inline cdvec3_t cdmat3x3_col1(cdmat3x3_t m) { return cdvec3(cdmat3x3_11(m), cdmat3x3_21(m), cdmat3x3_31(m)); }
static inline cdvec3_t cdmat3x3_col2(cdmat3x3_t m) { return cdvec3(cdmat3x3_12(m), cdmat3x3_22(m), cdmat3x3_32(m)); }
static inline cdvec3_t cdmat3x3_col3(cdmat3x3_t m) { return cdvec3(cdmat3x3_13(m), cdmat3x3_23(m), cdmat3x3_33(m)); }

static inline cdvec3_t cdmat4x3_col1(cdmat4x3_t m) { return cdvec3(cdmat4x3_11(m), cdmat4x3_21(m), cdmat4x3_31(m)); }
static inline cdvec3_t cdmat4x3_col2(cdmat4x3_t m) { return cdvec3(cdmat4x3_12(m), cdmat4x3_22(m), cdmat4x3_32(m)); }
static inline cdvec3_t cdmat4x3_col3(cdmat4x3_t m) { return cdvec3(cdmat4x3_13(m), cdmat4x3_23(m), cdmat4x3_33(m)); }
static inline cdvec3_t cdmat4x3_col4(cdmat4x3_t m) { return cdvec3(cdmat4x3_14(m), cdmat4x3_24(m), cdmat4x3_34(m)); }

static inline cdvec4_t cdmat4x4_col1(cdmat4x4_t m) { return cdvec4(cdmat4x4_11(m), cdmat4x4_21(m), cdmat4x4_31(m), cdmat4x4_41(m)); }
static inline cdvec4_t cdmat4x4_col2(cdmat4x4_t m) { return cdvec4(cdmat4x4_12(m), cdmat4x4_22(m), cdmat4x4_32(m), cdmat4x4_42(m)); }
static inline cdvec4_t cdmat4x4_col3(cdmat4x4_t m) { return cdvec4(cdmat4x4_13(m), cdmat4x4_23(m), cdmat4x4_33(m), cdmat4x4_43(m)); }
static inline cdvec4_t cdmat4x4_col4(cdmat4x4_t m) { return cdvec4(cdmat4x4_14(m), cdmat4x4_24(m), cdmat4x4_34(m), cdmat4x4_44(m)); }

static inline cdvec2_t cdmat2x2_x(cdmat2x2_t m) { return cdmat2x2_col1(m); }
static inline cdvec2_t cdmat2x2_y(cdmat2x2_t m) { return cdmat2x2_col2(m); }

static inline cdvec2_t cdmat3x2_x(cdmat3x2_t m) { return cdmat3x2_col1(m); }
static inline cdvec2_t cdmat3x2_y(cdmat3x2_t m) { return cdmat3x2_col2(m); }
static inline cdvec2_t cdmat3x2_z(cdmat3x2_t m) { return cdmat3x2_col3(m); }

static inline cdvec3_t cdmat3x3_x(cdmat3x3_t m) { return cdmat3x3_col1(m); }
static inline cdvec3_t cdmat3x3_y(cdmat3x3_t m) { return cdmat3x3_col2(m); }
static inline cdvec3_t cdmat3x3_z(cdmat3x3_t m) { return cdmat3x3_col3(m); }

static inline cdvec3_t cdmat4x3_x(cdmat4x3_t m) { return cdmat4x3_col1(m); }
static inline cdvec3_t cdmat4x3_y(cdmat4x3_t m) { return cdmat4x3_col2(m); }
static inline cdvec3_t cdmat4x3_z(cdmat4x3_t m) { return cdmat4x3_col3(m); }
static inline cdvec3_t cdmat4x3_w(cdmat4x3_t m) { return cdmat4x3_col4(m); }

static inline cdvec4_t cdmat4x4_x(cdmat4x4_t m) { return cdmat4x4_col1(m); }
static inline cdvec4_t cdmat4x4_y(cdmat4x4_t m) { return cdmat4x4_col2(m); }
static inline cdvec4_t cdmat4x4_z(cdmat4x4_t m) { return cdmat4x4_col3(m); }
static inline cdvec4_t cdmat4x4_w(cdmat4x4_t m) { return cdmat4x4_col4(m); }



// Row vector constructors

static inline cdmat2x2_t cdmat2x2rows(cdvec2_t row1, cdvec2_t row2) {
	return cdmat2x2(row1.x, row1.y,
	              row2.x, row2.y);
}

static inline cdmat3x2_t cdmat3x2rows(cdvec3_t row1, cdvec3_t row2) {
	return cdmat3x2(row1.x, row1.y, row1.z,
	              row2.x, row2.y, row2.z);
}

static inline cdmat3x3_t cdmat3x3rows(cdvec3_t row1, cdvec3_t row2, cdvec3_t row3) {
	return cdmat3x3(row1.x, row1.y, row1.z,
	              row2.x, row2.y, row2.z,
	              row3.x, row3.y, row3.z);
}

static inline cdmat4x3_t cdmat4x3rows(cdvec4_t row1, cdvec4_t row2, cdvec4_t row3) {
	return cdmat4x3(row1.x, row1.y, row1.z, row1.w,
	              row2.x, row2.y, row2.z, row2.w,
	              row3.x, row3.y, row3.z, row3.w);
}

static inline cdmat4x4_t cdmat4x4rows(cdvec4_t row1, cdvec4_t row2, cdvec4_t row3, cdvec4_t row4) {
	return cdmat4x4(row1.x, row1.y, row1.z, row1.w,
	              row2.x, row2.y, row2.z, row2.w,
	              row3.x, row3.y, row3.z, row3.w,
	              row4.x, row4.y, row4.z, row4.w);
}



// Row vector extractors

static inline cdvec2_t cdmat2x2_row1(cdmat2x2_t m) { return cdvec2(cdmat2x2_11(m), cdmat2x2_12(m)); }
static inline cdvec2_t cdmat2x2_row2(cdmat2x2_t m) { return cdvec2(cdmat2x2_21(m), cdmat2x2_22(m)); }

static inline cdvec3_t cdmat3x2_row1(cdmat3x2_t m) { return cdvec3(cdmat3x2_11(m), cdmat3x2_12(m), cdmat3x2_13(m)); }
static inline cdvec3_t cdmat3x2_row2(cdmat3x2_t m) { return cdvec3(cdmat3x2_21(m), cdmat3x2_22(m), cdmat3x2_23(m)); }

static inline cdvec3_t cdmat3x3_row1(cdmat3x3_t m) { return cdvec3(cdmat3x3_11(m), cdmat3x3_12(m), cdmat3x3_13(m)); }
static inline cdvec3_t cdmat3x3_row2(cdmat3x3_t m) { return cdvec3(cdmat3x3_21(m), cdmat3x3_22(m), cdmat3x3_23(m)); }
static inline cdvec3_t cdmat3x3_row3(cdmat3x3_t m) { return cdvec3(cdmat3x3_31(m), cdmat3x3_32(m), cdmat3x3_33(m)); }

static inline cdvec4_t cdmat4x3_row1(cdmat4x3_t m) { return cdvec4(cdmat4x3_11(m), cdmat4x3_12(m), cdmat4x3_13(m), cdmat4x3_14(m)); }
static inline cdvec4_t cdmat4x3_row2(cdmat4x3_t m) { return cdvec4(cdmat4x3_21(m), cdmat4x3_22(m), cdmat4x3_23(m), cdmat4x3_24(m)); }
static inline cdvec4_t cdmat4x3_row3(cdmat4x3_t m) { return cdvec4(cdmat4x3_31(m), cdmat4x3_32(m), cdmat4x3_33(m), cdmat4x3_34(m)); }

static inline cdvec4_t cdmat4x4_row1(cdmat4x4_t m) { return cdvec4(cdmat4x4_11(m), cdmat4x4_12(m), cdmat4x4_13(m), cdmat4x4_14(m)); }
static inline cdvec4_t cdmat4x4_row2(cdmat4x4_t m) { return cdvec4(cdmat4x4_21(m), cdmat4x4_22(m), cdmat4x4_23(m), cdmat4x4_24(m)); }
static inline cdvec4_t cdmat4x4_row3(cdmat4x4_t m) { return cdvec4(cdmat4x4_31(m), cdmat4x4_32(m), cdmat4x4_33(m), cdmat4x4_34(m)); }
static inline cdvec4_t cdmat4x4_row4(cdmat4x4_t m) { return cdvec4(cdmat4x4_41(m), cdmat4x4_42(m), cdmat4x4_43(m), cdmat4x4_44(m)); }





// Upgrade constructors

static inline cdmat3x2_t cdmat3x2affine2x2(cdmat2x2_t m, cdvec2_t col3) {
	cdvec2_t col1 = cdmat2x2_col1(m), col2 = cdmat2x2_col2(m);
	return cdmat3x2cols(col1, col2, col3);
}

static inline cdmat3x3_t cdmat3x3affine2x2(cdmat2x2_t m, cdvec2_t col3) {
	cdvec2_t col1 = cdmat2x2_col1(m), col2 = cdmat2x2_col2(m);
	return cdmat3x3(col1.x, col2.x, col3.x,
	              col1.y, col2.y, col3.y,
	              0, 0, 1);
}

static inline cdmat3x3_t cdmat3x3affine3x2(cdmat3x2_t m) {
	cdvec2_t col1 = cdmat3x2_col1(m), col2 = cdmat3x2_col2(m), col3 = cdmat3x2_col3(m);
	return cdmat3x3(col1.x, col2.x, col3.x,
	              col1.y, col2.y, col3.y,
	              0, 0, 1);
}

static inline cdmat4x3_t cdmat4x3affine3x3(cdmat3x3_t m, cdvec3_t col4) {
	cdvec3_t col1 = cdmat3x3_col1(m), col2 = cdmat3x3_col2(m), col3 = cdmat3x3_col3(m);
	return cdmat4x3cols(col1, col2, col3, col4);
}

static inline cdmat4x4_t cdmat4x4affine3x3(cdmat3x3_t m, cdvec3_t col4) {
	cdvec3_t col1 = cdmat3x3_col1(m), col2 = cdmat3x3_col2(m), col3 = cdmat3x3_col3(m);
	return cdmat4x4(col1.x, col2.x, col3.x, col4.x,
	              col1.y, col2.y, col3.y, col4.y,
	              col1.z, col2.z, col3.z, col4.z,
	              0, 0, 0, 1);
}

static inline cdmat4x4_t cdmat4x4affine4x3(cdmat4x3_t m) {
	cdvec3_t col1 = cdmat4x3_col1(m), col2 = cdmat4x3_col2(m), col3 = cdmat4x3_col3(m), col4 = cdmat4x3_col4(m);
	return cdmat4x4(col1.x, col2.x, col3.x, col4.x,
	              col1.y, col2.y, col3.y, col4.y,
	              col1.z, col2.z, col3.z, col4.z,
	              0, 0, 0, 1);
}



// Downgrade extractors

static inline cdmat2x2_t cdmat3x2_mat2x2(cdmat3x2_t m) { return cdmat2x2cols(cdmat3x2_col1(m), cdmat3x2_col2(m)); }
static inline cdmat2x2_t cdmat3x3_mat2x2(cdmat3x3_t m) { return cdmat2x2cols(cdvec3_xy(cdmat3x3_col1(m)), cdvec3_xy(cdmat3x3_col2(m))); }
static inline cdmat3x2_t cdmat3x3_mat3x2(cdmat3x3_t m) { return cdmat3x2cols(cdvec3_xy(cdmat3x3_col1(m)), cdvec3_xy(cdmat3x3_col2(m)), cdvec3_xy(cdmat3x3_col3(m))); }
static inline cdmat3x3_t cdmat4x3_mat3x3(cdmat4x3_t m) { return cdmat3x3cols(cdmat4x3_col1(m), cdmat4x3_col2(m), cdmat4x3_col3(m)); }
static inline cdmat3x3_t cdmat4x4_mat3x3(cdmat4x4_t m) { return cdmat3x3cols(cdvec4_xyz(cdmat4x4_col1(m)), cdvec4_xyz(cdmat4x4_col2(m)), cdvec4_xyz(cdmat4x4_col3(m))); }
static inline cdmat4x3_t cdmat4x4_mat4x3(cdmat4x4_t m) { return cdmat4x3cols(cdvec4_xyz(cdmat4x4_col1(m)), cdvec4_xyz(cdmat4x4_col2(m)), cdvec4_xyz(cdmat4x4_col3(m)), cdvec4_xyz(cdmat4x4_col4(m))); }




// Translation constructors

static inline cdmat3x2_t cdmat3x2translate(cdvec2_t v) {
	return cdmat3x2(1, 0, v.x,
	              0, 1, v.y);
}

static inline cdmat4x3_t cdmat4x3translate(cdvec3_t v) {
	return cdmat4x3(1, 0, 0, v.x,
	              0, 1, 0, v.y,
	              0, 0, 1, v.z);
}
static inline cdmat4x4_t cdmat4x4translate(cdvec3_t v) { return cdmat4x4affine4x3(cdmat4x3translate(v)); }



// Scaling constructors

static inline cdmat2x2_t cdmat2x2scale(complex double x, complex double y) {
	return cdmat2x2(x, 0,
	              0, y);
}
static inline cdmat3x2_t cdmat3x2scale(complex double x, complex double y) { return cdmat3x2affine2x2(cdmat2x2scale(x, y), cdvec2zero); }

static inline cdmat3x3_t cdmat3x3scale(complex double x, complex double y, complex double z) {
	return cdmat3x3(x, 0, 0,
	              0, y, 0,
	              0, 0, z);
}
static inline cdmat4x3_t cdmat4x3scale(complex double x, complex double y, complex double z) { return cdmat4x3affine3x3(cdmat3x3scale(x, y, z), cdvec3zero); }
static inline cdmat4x4_t cdmat4x4scale(complex double x, complex double y, complex double z) { return cdmat4x4affine3x3(cdmat3x3scale(x, y, z), cdvec3zero); }



// Rotation constructors

static inline cdmat2x2_t cdmat2x2rotate(complex double a) {
	return cdmat2x2(ccos(a), -csin(a),
	              csin(a), ccos(a));
}
static inline cdmat3x2_t cdmat3x2rotate(complex double a) { return cdmat3x2affine2x2(cdmat2x2rotate(a), cdvec2zero); }

static inline cdmat3x3_t cdmat3x3rotatex(complex double a) {
	return cdmat3x3(1, 0, 0,
	              0, ccos(a), -csin(a),
	              0, csin(a), ccos(a));
}
static inline cdmat4x3_t cdmat4x3rotatex(complex double a) { return cdmat4x3affine3x3(cdmat3x3rotatex(a), cdvec3zero); }
static inline cdmat4x4_t cdmat4x4rotatex(complex double a) { return cdmat4x4affine3x3(cdmat3x3rotatex(a), cdvec3zero); }

static inline cdmat3x3_t cdmat3x3rotatey(complex double a) {
	return cdmat3x3( ccos(a), 0, csin(a),
	               0, 1, 0,
	               -csin(a), 0, ccos(a));
}
static inline cdmat4x3_t cdmat4x3rotatey(complex double a) { return cdmat4x3affine3x3(cdmat3x3rotatey(a), cdvec3zero); }
static inline cdmat4x4_t cdmat4x4rotatey(complex double a) { return cdmat4x4affine3x3(cdmat3x3rotatey(a), cdvec3zero); }

static inline cdmat3x3_t cdmat3x3rotatez(complex double a) {
	return cdmat3x3(ccos(a), -csin(a), 0,
	              csin(a), ccos(a), 0,
	              0, 0, 1);
}
static inline cdmat4x3_t cdmat4x3rotatez(complex double a) { return cdmat4x3affine3x3(cdmat3x3rotatez(a), cdvec3zero); }
static inline cdmat4x4_t cdmat4x4rotatez(complex double a) { return cdmat4x4affine3x3(cdmat3x3rotatez(a), cdvec3zero); }

cdmat3x3_t cdmat3x3rotate(complex double angle, cdvec3_t axis);
static inline cdmat4x3_t cdmat4x3rotate(complex double angle, cdvec3_t axis) { return cdmat4x3affine3x3(cdmat3x3rotate(angle, axis), cdvec3zero); }
static inline cdmat4x4_t cdmat4x4rotate(complex double angle, cdvec3_t axis) { return cdmat4x4affine3x3(cdmat3x3rotate(angle, axis), cdvec3zero); }

cdmat4x3_t cdmat4x3affinemul(cdmat4x3_t a, cdmat4x3_t b);
cdmat4x4_t cdmat4x4affinemul(cdmat4x4_t a, cdmat4x4_t b);
static inline cdmat4x3_t cdmat4x3rotatepivot(complex double angle, cdvec3_t axis, cdvec3_t pivot) { return cdmat4x3affinemul(cdmat4x3affine3x3(cdmat3x3rotate(angle, axis), pivot), cdmat4x3translate(cdvec3neg(pivot))); }
static inline cdmat4x4_t cdmat4x4rotatepivot(complex double angle, cdvec3_t axis, cdvec3_t pivot) { return cdmat4x4affinemul(cdmat4x4affine3x3(cdmat3x3rotate(angle, axis), pivot), cdmat4x4translate(cdvec3neg(pivot))); }



// Lookat constructors

cdmat3x3_t cdmat3x3inverselookat(cdvec3_t eye, cdvec3_t center, cdvec3_t up);
static inline cdmat4x3_t cdmat4x3inverselookat(cdvec3_t eye, cdvec3_t center, cdvec3_t up) { return cdmat4x3affine3x3(cdmat3x3inverselookat(eye, center, up), eye); }
static inline cdmat4x4_t cdmat4x4inverselookat(cdvec3_t eye, cdvec3_t center, cdvec3_t up) { return cdmat4x4affine3x3(cdmat3x3inverselookat(eye, center, up), eye); }

static inline cdmat3x3_t cdmat3x3transpose(cdmat3x3_t m);
cdvec3_t cdmat3x3transform(cdmat3x3_t m, cdvec3_t v);

static inline cdmat3x3_t cdmat3x3lookat(cdvec3_t eye, cdvec3_t center, cdvec3_t up) { return cdmat3x3transpose(cdmat3x3inverselookat(eye, center, up)); }
static inline cdmat4x3_t cdmat4x3lookat(cdvec3_t eye, cdvec3_t center, cdvec3_t up) { cdmat3x3_t m = cdmat3x3lookat(eye, center, up); return cdmat4x3affine3x3(m, cdmat3x3transform(m, eye)); }
static inline cdmat4x4_t cdmat4x4lookat(cdvec3_t eye, cdvec3_t center, cdvec3_t up) { cdmat3x3_t m = cdmat3x3lookat(eye, center, up); return cdmat4x4affine3x3(m, cdmat3x3transform(m, eye)); }




// Orthogonal constructors

static inline cdmat3x2_t cdmat3x2ortho(complex double xmin, complex double xmax, complex double ymin, complex double ymax) {
	return cdmat3x2(2 / (xmax - xmin), 0, -(xmax + xmin) / (xmax - xmin),
	              0, 2 / (ymax - ymin), -(ymax + ymin) / (ymax - ymin));
}
static inline cdmat3x3_t cdmat3x3ortho(complex double xmin, complex double xmax, complex double ymin, complex double ymax) { return cdmat3x3affine3x2(cdmat3x2ortho(xmin, xmax, ymin, ymax)); }

static inline cdmat4x3_t cdmat4x3ortho(complex double xmin, complex double xmax, complex double ymin, complex double ymax, complex double zmin, complex double zmax) {
	return cdmat4x3(2 / (xmax - xmin), 0, 0, -(xmax + xmin) / (xmax - xmin),
	              0, 2 / (ymax - ymin), 0, -(ymax + ymin) / (ymax - ymin),
	              0, 0, -2 / (zmax - zmin), -(zmax + zmin) / (zmax - zmin));
	// -2 on z to match the OpenGL definition.
}
static inline cdmat4x4_t cdmat4x4ortho(complex double xmin, complex double xmax, complex double ymin, complex double ymax, complex double zmin, complex double zmax) { return cdmat4x4affine4x3(cdmat4x3ortho(xmin, xmax, ymin, ymax, zmin, zmax)); }



// Perspective constructors

static inline cdmat4x4_t cdmat4x4perspectiveinternal(complex double fx, complex double fy, complex double znear, complex double zfar) {
	return cdmat4x4(fx, 0, 0, 0,
	              0, fy, 0, 0,
	              0, 0, (zfar + znear) / (znear - zfar), 2 * zfar * znear / (znear - zfar),
	              0, 0, -1, 0);
}

static inline cdmat4x4_t cdmat4x4horizontalperspective(complex double fovx, complex double aspect, complex double znear, complex double zfar) {
	complex double f = 1 / ctan(fovx * M_PI / 180 / 2);
	return cdmat4x4perspectiveinternal(f, f * aspect, znear, zfar);
}

static inline cdmat4x4_t cdmat4x4verticalperspective(complex double fovy, complex double aspect, complex double znear, complex double zfar) {
	complex double f = 1 / ctan(fovy * M_PI / 180 / 2);
	return cdmat4x4perspectiveinternal(f / aspect, f, znear, zfar);
}

/*static inline cdmat4x4_t cdmat4x4minperspective(complex double fov, complex double aspect, complex double znear, complex double zfar) {
	if(aspect < 1) return cdmat4x4horizontalperspective(fov, aspect, znear, zfar);
	else return cdmat4x4verticalperspective(fov, aspect, znear, zfar);
}*/

/*static inline cdmat4x4_t cdmat4x4maxperspective(complex double fov, complex double aspect, complex double znear, complex double zfar) {
	if(aspect > 1) return cdmat4x4horizontalperspective(fov, aspect, znear, zfar);
	else return cdmat4x4verticalperspective(fov, aspect, znear, zfar);
}*/

static inline cdmat4x4_t cdmat4x4diagonalperspective(complex double fov, complex double aspect, complex double znear, complex double zfar) {
	complex double f = 1 / ctan(fov * M_PI / 180 / 2);
	return cdmat4x4perspectiveinternal(f * csqrt(1 / (aspect * aspect) + 1), f * csqrt(aspect * aspect + 1), znear, zfar);
}




// Prespective extractors

static inline cdvec4_t cdmat4x4_leftplane(cdmat4x4_t m) { return cdvec4add(cdmat4x4_row4(m), cdmat4x4_row1(m)); }
static inline cdvec4_t cdmat4x4_rightplane(cdmat4x4_t m) { return cdvec4sub(cdmat4x4_row4(m), cdmat4x4_row1(m)); }
static inline cdvec4_t cdmat4x4_bottomplane(cdmat4x4_t m) { return cdvec4add(cdmat4x4_row4(m), cdmat4x4_row2(m)); }
static inline cdvec4_t cdmat4x4_topplane(cdmat4x4_t m) { return cdvec4sub(cdmat4x4_row4(m), cdmat4x4_row2(m)); }
static inline cdvec4_t cdmat4x4_nearplane(cdmat4x4_t m) { return cdvec4add(cdmat4x4_row4(m), cdmat4x4_row3(m)); }
static inline cdvec4_t cdmat4x4_farplane(cdmat4x4_t m) { return cdvec4sub(cdmat4x4_row4(m), cdmat4x4_row3(m)); }

cdmat4x3_t cdmat4x3affineinverse(cdmat4x3_t m);
static inline cdvec3_t cdmat4x4_cameraposition(cdmat4x4_t m) { return cdmat4x3_col4(cdmat4x3affineinverse(cdmat4x3rows(cdmat4x4_row1(m), cdmat4x4_row2(m), cdmat4x4_row4(m)))); }



// Comparison operations

static inline bool cdmat2x2equal(cdmat2x2_t a, cdmat2x2_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }
static inline bool cdmat3x2equal(cdmat3x2_t a, cdmat3x2_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }
static inline bool cdmat3x3equal(cdmat3x3_t a, cdmat3x3_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }
static inline bool cdmat4x3equal(cdmat4x3_t a, cdmat4x3_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }
static inline bool cdmat4x4equal(cdmat4x4_t a, cdmat4x4_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }

/*static inline bool cdmat2x2almostequal(cdmat2x2_t a, cdmat2x2_t b, double epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(cabs(a.m[i] - b.m[i]) > epsilon) return false; return true; }*/
/*static inline bool cdmat3x2almostequal(cdmat3x2_t a, cdmat3x2_t b, double epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(cabs(a.m[i] - b.m[i]) > epsilon) return false; return true; }*/
/*static inline bool cdmat3x3almostequal(cdmat3x3_t a, cdmat3x3_t b, double epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(cabs(a.m[i] - b.m[i]) > epsilon) return false; return true; }*/
/*static inline bool cdmat4x3almostequal(cdmat4x3_t a, cdmat4x3_t b, double epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(cabs(a.m[i] - b.m[i]) > epsilon) return false; return true; }*/
/*static inline bool cdmat4x4almostequal(cdmat4x4_t a, cdmat4x4_t b, double epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(cabs(a.m[i] - b.m[i]) > epsilon) return false; return true; }*/



// Multiplication

cdmat2x2_t cdmat2x2mul(cdmat2x2_t a, cdmat2x2_t b);
cdmat3x3_t cdmat3x3mul(cdmat3x3_t a, cdmat3x3_t b);
cdmat4x4_t cdmat4x4mul(cdmat4x4_t a, cdmat4x4_t b);

cdmat3x2_t cdmat3x2affinemul(cdmat3x2_t a, cdmat3x2_t b);
cdmat3x3_t cdmat3x3affinemul(cdmat3x3_t a, cdmat3x3_t b);
cdmat4x3_t cdmat4x3affinemul(cdmat4x3_t a, cdmat4x3_t b);
cdmat4x4_t cdmat4x4affinemul(cdmat4x4_t a, cdmat4x4_t b);



// Scalar multiplication and division

static inline cdmat2x2_t cdmat2x2smul(cdmat2x2_t a, complex double b) { cdmat2x2_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }
static inline cdmat3x2_t cdmat3x2smul(cdmat2x2_t a, complex double b) { cdmat3x2_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }
static inline cdmat3x3_t cdmat3x3smul(cdmat3x3_t a, complex double b) { cdmat3x3_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }
static inline cdmat4x3_t cdmat4x3smul(cdmat2x2_t a, complex double b) { cdmat4x3_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }
static inline cdmat4x4_t cdmat4x4smul(cdmat4x4_t a, complex double b) { cdmat4x4_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }

static inline cdmat2x2_t cdmat2x2sdiv(cdmat2x2_t a, complex double b) { cdmat2x2_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }
static inline cdmat3x2_t cdmat3x2sdiv(cdmat2x2_t a, complex double b) { cdmat3x2_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }
static inline cdmat3x3_t cdmat3x3sdiv(cdmat3x3_t a, complex double b) { cdmat3x3_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }
static inline cdmat4x3_t cdmat4x3sdiv(cdmat2x2_t a, complex double b) { cdmat4x3_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }
static inline cdmat4x4_t cdmat4x4sdiv(cdmat4x4_t a, complex double b) { cdmat4x4_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }



// Transpose

static inline cdmat2x2_t cdmat2x2transpose(cdmat2x2_t m) { return cdmat2x2cols(cdmat2x2_row1(m), cdmat2x2_row2(m)); }
static inline cdmat3x3_t cdmat3x3transpose(cdmat3x3_t m) { return cdmat3x3cols(cdmat3x3_row1(m), cdmat3x3_row2(m), cdmat3x3_row3(m)); }
static inline cdmat4x4_t cdmat4x4transpose(cdmat4x4_t m) { return cdmat4x4cols(cdmat4x4_row1(m), cdmat4x4_row2(m), cdmat4x4_row3(m), cdmat4x4_row4(m)); }



// Determinant

static inline complex double cdmat2x2det(cdmat2x2_t m) {
	return cdmat2x2_11(m) * cdmat2x2_22(m) - cdmat2x2_21(m) * cdmat2x2_12(m);
}

static inline complex double cdmat3x3det(cdmat3x3_t m) {
	return cdmat3x3_11(m) * cdmat3x3_22(m) * cdmat3x3_33(m)
	       - cdmat3x3_11(m) * cdmat3x3_32(m) * cdmat3x3_23(m)
	       + cdmat3x3_21(m) * cdmat3x3_32(m) * cdmat3x3_13(m)
	       - cdmat3x3_21(m) * cdmat3x3_12(m) * cdmat3x3_33(m)
	       + cdmat3x3_31(m) * cdmat3x3_12(m) * cdmat3x3_23(m)
	       - cdmat3x3_31(m) * cdmat3x3_22(m) * cdmat3x3_13(m);
}

complex double cdmat4x4det(cdmat4x4_t m);

static inline complex double cdmat3x2affinedet(cdmat3x2_t m) {
	return cdmat3x2_11(m) * cdmat3x2_22(m) - cdmat3x2_21(m) * cdmat3x2_12(m);
}

static inline complex double cdmat3x3affinedet(cdmat3x3_t m) {
	return cdmat3x3_11(m) * cdmat3x3_22(m) - cdmat3x3_21(m) * cdmat3x3_12(m);
}

static inline complex double cdmat4x3affinedet(cdmat4x3_t m) {
	return cdmat4x3_11(m) * cdmat4x3_22(m) * cdmat4x3_33(m)
	       - cdmat4x3_11(m) * cdmat4x3_32(m) * cdmat4x3_23(m)
	       + cdmat4x3_21(m) * cdmat4x3_32(m) * cdmat4x3_13(m)
	       - cdmat4x3_21(m) * cdmat4x3_12(m) * cdmat4x3_33(m)
	       + cdmat4x3_31(m) * cdmat4x3_12(m) * cdmat4x3_23(m)
	       - cdmat4x3_31(m) * cdmat4x3_22(m) * cdmat4x3_13(m);
}

static inline complex double cdmat4x4affinedet(cdmat4x4_t m) {
	return cdmat4x4_11(m) * cdmat4x4_22(m) * cdmat4x4_33(m)
	       - cdmat4x4_11(m) * cdmat4x4_32(m) * cdmat4x4_23(m)
	       + cdmat4x4_21(m) * cdmat4x4_32(m) * cdmat4x4_13(m)
	       - cdmat4x4_21(m) * cdmat4x4_12(m) * cdmat4x4_33(m)
	       + cdmat4x4_31(m) * cdmat4x4_12(m) * cdmat4x4_23(m)
	       - cdmat4x4_31(m) * cdmat4x4_22(m) * cdmat4x4_13(m);
}



// Inverse

static inline cdmat2x2_t cdmat2x2inverse(cdmat2x2_t m) {
	complex double det = cdmat2x2det(m); // singular if det==0

	return cdmat2x2( cdmat2x2_22(m) / det, -cdmat2x2_12(m) / det,
	               -cdmat2x2_21(m) / det, cdmat2x2_11(m) / det);
}

cdmat3x3_t cdmat3x3inverse(cdmat3x3_t m);
cdmat4x4_t cdmat4x4inverse(cdmat4x4_t m);

cdmat3x2_t cdmat3x2affineinverse(cdmat3x2_t m);
cdmat3x3_t cdmat3x3affineinverse(cdmat3x3_t m);
cdmat4x3_t cdmat4x3affineinverse(cdmat4x3_t m);
cdmat4x4_t cdmat4x4affineinverse(cdmat4x4_t m);



// Vector transformation

static inline cdvec2_t cdmat2x2transform(cdmat2x2_t m, cdvec2_t v) {
	return cdvec2(v.x * cdmat2x2_11(m) + v.y * cdmat2x2_12(m),
	            v.x * cdmat2x2_21(m) + v.y * cdmat2x2_22(m));
}

static inline cdvec2_t cdmat3x2transform(cdmat3x2_t m, cdvec2_t v) {
	return cdvec2(v.x * cdmat3x2_11(m) + v.y * cdmat3x2_12(m) + cdmat3x2_13(m),
	            v.x * cdmat3x2_21(m) + v.y * cdmat3x2_22(m) + cdmat3x2_23(m));
}

cdvec3_t cdmat3x3transform(cdmat3x3_t m, cdvec3_t v);
cdvec3_t cdmat4x3transform(cdmat4x3_t m, cdvec3_t v);
cdvec4_t cdmat4x4transform(cdmat4x4_t m, cdvec4_t v);

cdvec2_t cdmat3x3transformvec2(cdmat3x3_t m, cdvec2_t v);
cdvec3_t cdmat4x4transformvec3(cdmat4x4_t m, cdvec3_t v);

#endif

