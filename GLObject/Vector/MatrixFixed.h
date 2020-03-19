#ifndef __MATRIX_FIXED_H__
#define __MATRIX_FIXED_H__

#include "VectorFixed.h"



// Definitions

typedef struct { int32_t m[4]; } imat2x2_t;
typedef struct { int32_t m[6]; } imat3x2_t;
typedef struct { int32_t m[9]; } imat3x3_t;
typedef struct { int32_t m[12]; } imat4x3_t;
typedef struct { int32_t m[16]; } imat4x4_t;

#define imat2x2one imat2x2(F(1), 0, 0, F(1))
#define imat3x2one imat3x2(F(1), 0, 0, 0, F(1), 0)
#define imat3x3one imat3x3(F(1), 0, 0, 0, F(1), 0, 0, 0, F(1))
#define imat4x3one imat4x3(F(1), 0, 0, 0, 0, F(1), 0, 0, 0, 0, F(1), 0)
#define imat4x4one imat4x4(F(1), 0, 0, 0, 0, F(1), 0, 0, 0, 0, F(1), 0, 0, 0, 0, F(1))



// Individual element constructors

static inline imat2x2_t imat2x2(int32_t a11, int32_t a12,
                              int32_t a21, int32_t a22)
{ return (imat2x2_t){{a11, a21, a12, a22}}; }

static inline imat3x2_t imat3x2(int32_t a11, int32_t a12, int32_t a13,
                              int32_t a21, int32_t a22, int32_t a23)
{ return (imat3x2_t){{a11, a21, a12, a22, a13, a23}}; }

static inline imat3x3_t imat3x3(int32_t a11, int32_t a12, int32_t a13,
                              int32_t a21, int32_t a22, int32_t a23,
                              int32_t a31, int32_t a32, int32_t a33)
{ return (imat3x3_t){{a11, a21, a31, a12, a22, a32, a13, a23, a33}}; }

static inline imat4x3_t imat4x3(int32_t a11, int32_t a12, int32_t a13, int32_t a14,
                              int32_t a21, int32_t a22, int32_t a23, int32_t a24,
                              int32_t a31, int32_t a32, int32_t a33, int32_t a34)
{ return (imat4x3_t){{a11, a21, a31, a12, a22, a32, a13, a23, a33, a14, a24, a34}}; }

static inline imat4x4_t imat4x4(int32_t a11, int32_t a12, int32_t a13, int32_t a14,
                              int32_t a21, int32_t a22, int32_t a23, int32_t a24,
                              int32_t a31, int32_t a32, int32_t a33, int32_t a34,
                              int32_t a41, int32_t a42, int32_t a43, int32_t a44)
{ return (imat4x4_t){{a11, a21, a31, a41, a12, a22, a32, a42, a13, a23, a33, a43, a14, a24, a34, a44}}; }



// Individual element extractors

static inline int32_t imat2x2_11(imat2x2_t m) { return m.m[0]; }
static inline int32_t imat2x2_21(imat2x2_t m) { return m.m[1]; }
static inline int32_t imat2x2_12(imat2x2_t m) { return m.m[2]; }
static inline int32_t imat2x2_22(imat2x2_t m) { return m.m[3]; }

static inline int32_t imat3x2_11(imat3x2_t m) { return m.m[0]; }
static inline int32_t imat3x2_21(imat3x2_t m) { return m.m[1]; }
static inline int32_t imat3x2_12(imat3x2_t m) { return m.m[2]; }
static inline int32_t imat3x2_22(imat3x2_t m) { return m.m[3]; }
static inline int32_t imat3x2_13(imat3x2_t m) { return m.m[4]; }
static inline int32_t imat3x2_23(imat3x2_t m) { return m.m[5]; }

static inline int32_t imat3x3_11(imat3x3_t m) { return m.m[0]; }
static inline int32_t imat3x3_21(imat3x3_t m) { return m.m[1]; }
static inline int32_t imat3x3_31(imat3x3_t m) { return m.m[2]; }
static inline int32_t imat3x3_12(imat3x3_t m) { return m.m[3]; }
static inline int32_t imat3x3_22(imat3x3_t m) { return m.m[4]; }
static inline int32_t imat3x3_32(imat3x3_t m) { return m.m[5]; }
static inline int32_t imat3x3_13(imat3x3_t m) { return m.m[6]; }
static inline int32_t imat3x3_23(imat3x3_t m) { return m.m[7]; }
static inline int32_t imat3x3_33(imat3x3_t m) { return m.m[8]; }

static inline int32_t imat4x3_11(imat4x3_t m) { return m.m[0]; }
static inline int32_t imat4x3_21(imat4x3_t m) { return m.m[1]; }
static inline int32_t imat4x3_31(imat4x3_t m) { return m.m[2]; }
static inline int32_t imat4x3_12(imat4x3_t m) { return m.m[3]; }
static inline int32_t imat4x3_22(imat4x3_t m) { return m.m[4]; }
static inline int32_t imat4x3_32(imat4x3_t m) { return m.m[5]; }
static inline int32_t imat4x3_13(imat4x3_t m) { return m.m[6]; }
static inline int32_t imat4x3_23(imat4x3_t m) { return m.m[7]; }
static inline int32_t imat4x3_33(imat4x3_t m) { return m.m[8]; }
static inline int32_t imat4x3_14(imat4x3_t m) { return m.m[9]; }
static inline int32_t imat4x3_24(imat4x3_t m) { return m.m[10]; }
static inline int32_t imat4x3_34(imat4x3_t m) { return m.m[11]; }

static inline int32_t imat4x4_11(imat4x4_t m) { return m.m[0]; }
static inline int32_t imat4x4_21(imat4x4_t m) { return m.m[1]; }
static inline int32_t imat4x4_31(imat4x4_t m) { return m.m[2]; }
static inline int32_t imat4x4_41(imat4x4_t m) { return m.m[3]; }
static inline int32_t imat4x4_12(imat4x4_t m) { return m.m[4]; }
static inline int32_t imat4x4_22(imat4x4_t m) { return m.m[5]; }
static inline int32_t imat4x4_32(imat4x4_t m) { return m.m[6]; }
static inline int32_t imat4x4_42(imat4x4_t m) { return m.m[7]; }
static inline int32_t imat4x4_13(imat4x4_t m) { return m.m[8]; }
static inline int32_t imat4x4_23(imat4x4_t m) { return m.m[9]; }
static inline int32_t imat4x4_33(imat4x4_t m) { return m.m[10]; }
static inline int32_t imat4x4_43(imat4x4_t m) { return m.m[11]; }
static inline int32_t imat4x4_14(imat4x4_t m) { return m.m[12]; }
static inline int32_t imat4x4_24(imat4x4_t m) { return m.m[13]; }
static inline int32_t imat4x4_34(imat4x4_t m) { return m.m[14]; }
static inline int32_t imat4x4_44(imat4x4_t m) { return m.m[15]; }




// Column vector constructors

static inline imat2x2_t imat2x2cols(ivec2_t col1, ivec2_t col2) {
	return imat2x2(col1.x, col2.x,
	              col1.y, col2.y);
}

static inline imat3x2_t imat3x2cols(ivec2_t col1, ivec2_t col2, ivec2_t col3) {
	return imat3x2(col1.x, col2.x, col3.x,
	              col1.y, col2.y, col3.y);
}

static inline imat3x3_t imat3x3cols(ivec3_t col1, ivec3_t col2, ivec3_t col3) {
	return imat3x3(col1.x, col2.x, col3.x,
	              col1.y, col2.y, col3.y,
	              col1.z, col2.z, col3.z);
}

static inline imat4x3_t imat4x3cols(ivec3_t col1, ivec3_t col2, ivec3_t col3, ivec3_t col4) {
	return imat4x3(col1.x, col2.x, col3.x, col4.x,
	              col1.y, col2.y, col3.y, col4.y,
	              col1.z, col2.z, col3.z, col4.z);
}

static inline imat4x4_t imat4x4cols(ivec4_t col1, ivec4_t col2, ivec4_t col3, ivec4_t col4) {
	return imat4x4(col1.x, col2.x, col3.x, col4.x,
	              col1.y, col2.y, col3.y, col4.y,
	              col1.z, col2.z, col3.z, col4.z,
	              col1.w, col2.w, col3.w, col4.w);
}

static inline imat2x2_t imat2x2vec2(ivec2_t x, ivec2_t y) { return imat2x2cols(x, y); }
static inline imat3x2_t imat3x2vec2(ivec2_t x, ivec2_t y, ivec2_t z) { return imat3x2cols(x, y, z); }
static inline imat3x3_t imat3x3vec3(ivec3_t x, ivec3_t y, ivec3_t z) { return imat3x3cols(x, y, z); }
static inline imat4x3_t imat4x3vec3(ivec3_t x, ivec3_t y, ivec3_t z, ivec3_t w) { return imat4x3cols(x, y, z, w); }
static inline imat4x4_t imat4x4vec4(ivec4_t x, ivec4_t y, ivec4_t z, ivec4_t w) { return imat4x4cols(x, y, z, w); }



// Column vector extractors

static inline ivec2_t imat2x2_col1(imat2x2_t m) { return ivec2(imat2x2_11(m), imat2x2_21(m)); }
static inline ivec2_t imat2x2_col2(imat2x2_t m) { return ivec2(imat2x2_12(m), imat2x2_22(m)); }

static inline ivec2_t imat3x2_col1(imat3x2_t m) { return ivec2(imat3x2_11(m), imat3x2_21(m)); }
static inline ivec2_t imat3x2_col2(imat3x2_t m) { return ivec2(imat3x2_12(m), imat3x2_22(m)); }
static inline ivec2_t imat3x2_col3(imat3x2_t m) { return ivec2(imat3x2_13(m), imat3x2_23(m)); }

static inline ivec3_t imat3x3_col1(imat3x3_t m) { return ivec3(imat3x3_11(m), imat3x3_21(m), imat3x3_31(m)); }
static inline ivec3_t imat3x3_col2(imat3x3_t m) { return ivec3(imat3x3_12(m), imat3x3_22(m), imat3x3_32(m)); }
static inline ivec3_t imat3x3_col3(imat3x3_t m) { return ivec3(imat3x3_13(m), imat3x3_23(m), imat3x3_33(m)); }

static inline ivec3_t imat4x3_col1(imat4x3_t m) { return ivec3(imat4x3_11(m), imat4x3_21(m), imat4x3_31(m)); }
static inline ivec3_t imat4x3_col2(imat4x3_t m) { return ivec3(imat4x3_12(m), imat4x3_22(m), imat4x3_32(m)); }
static inline ivec3_t imat4x3_col3(imat4x3_t m) { return ivec3(imat4x3_13(m), imat4x3_23(m), imat4x3_33(m)); }
static inline ivec3_t imat4x3_col4(imat4x3_t m) { return ivec3(imat4x3_14(m), imat4x3_24(m), imat4x3_34(m)); }

static inline ivec4_t imat4x4_col1(imat4x4_t m) { return ivec4(imat4x4_11(m), imat4x4_21(m), imat4x4_31(m), imat4x4_41(m)); }
static inline ivec4_t imat4x4_col2(imat4x4_t m) { return ivec4(imat4x4_12(m), imat4x4_22(m), imat4x4_32(m), imat4x4_42(m)); }
static inline ivec4_t imat4x4_col3(imat4x4_t m) { return ivec4(imat4x4_13(m), imat4x4_23(m), imat4x4_33(m), imat4x4_43(m)); }
static inline ivec4_t imat4x4_col4(imat4x4_t m) { return ivec4(imat4x4_14(m), imat4x4_24(m), imat4x4_34(m), imat4x4_44(m)); }

static inline ivec2_t imat2x2_x(imat2x2_t m) { return imat2x2_col1(m); }
static inline ivec2_t imat2x2_y(imat2x2_t m) { return imat2x2_col2(m); }

static inline ivec2_t imat3x2_x(imat3x2_t m) { return imat3x2_col1(m); }
static inline ivec2_t imat3x2_y(imat3x2_t m) { return imat3x2_col2(m); }
static inline ivec2_t imat3x2_z(imat3x2_t m) { return imat3x2_col3(m); }

static inline ivec3_t imat3x3_x(imat3x3_t m) { return imat3x3_col1(m); }
static inline ivec3_t imat3x3_y(imat3x3_t m) { return imat3x3_col2(m); }
static inline ivec3_t imat3x3_z(imat3x3_t m) { return imat3x3_col3(m); }

static inline ivec3_t imat4x3_x(imat4x3_t m) { return imat4x3_col1(m); }
static inline ivec3_t imat4x3_y(imat4x3_t m) { return imat4x3_col2(m); }
static inline ivec3_t imat4x3_z(imat4x3_t m) { return imat4x3_col3(m); }
static inline ivec3_t imat4x3_w(imat4x3_t m) { return imat4x3_col4(m); }

static inline ivec4_t imat4x4_x(imat4x4_t m) { return imat4x4_col1(m); }
static inline ivec4_t imat4x4_y(imat4x4_t m) { return imat4x4_col2(m); }
static inline ivec4_t imat4x4_z(imat4x4_t m) { return imat4x4_col3(m); }
static inline ivec4_t imat4x4_w(imat4x4_t m) { return imat4x4_col4(m); }



// Row vector constructors

static inline imat2x2_t imat2x2rows(ivec2_t row1, ivec2_t row2) {
	return imat2x2(row1.x, row1.y,
	              row2.x, row2.y);
}

static inline imat3x2_t imat3x2rows(ivec3_t row1, ivec3_t row2) {
	return imat3x2(row1.x, row1.y, row1.z,
	              row2.x, row2.y, row2.z);
}

static inline imat3x3_t imat3x3rows(ivec3_t row1, ivec3_t row2, ivec3_t row3) {
	return imat3x3(row1.x, row1.y, row1.z,
	              row2.x, row2.y, row2.z,
	              row3.x, row3.y, row3.z);
}

static inline imat4x3_t imat4x3rows(ivec4_t row1, ivec4_t row2, ivec4_t row3) {
	return imat4x3(row1.x, row1.y, row1.z, row1.w,
	              row2.x, row2.y, row2.z, row2.w,
	              row3.x, row3.y, row3.z, row3.w);
}

static inline imat4x4_t imat4x4rows(ivec4_t row1, ivec4_t row2, ivec4_t row3, ivec4_t row4) {
	return imat4x4(row1.x, row1.y, row1.z, row1.w,
	              row2.x, row2.y, row2.z, row2.w,
	              row3.x, row3.y, row3.z, row3.w,
	              row4.x, row4.y, row4.z, row4.w);
}



// Row vector extractors

static inline ivec2_t imat2x2_row1(imat2x2_t m) { return ivec2(imat2x2_11(m), imat2x2_12(m)); }
static inline ivec2_t imat2x2_row2(imat2x2_t m) { return ivec2(imat2x2_21(m), imat2x2_22(m)); }

static inline ivec3_t imat3x2_row1(imat3x2_t m) { return ivec3(imat3x2_11(m), imat3x2_12(m), imat3x2_13(m)); }
static inline ivec3_t imat3x2_row2(imat3x2_t m) { return ivec3(imat3x2_21(m), imat3x2_22(m), imat3x2_23(m)); }

static inline ivec3_t imat3x3_row1(imat3x3_t m) { return ivec3(imat3x3_11(m), imat3x3_12(m), imat3x3_13(m)); }
static inline ivec3_t imat3x3_row2(imat3x3_t m) { return ivec3(imat3x3_21(m), imat3x3_22(m), imat3x3_23(m)); }
static inline ivec3_t imat3x3_row3(imat3x3_t m) { return ivec3(imat3x3_31(m), imat3x3_32(m), imat3x3_33(m)); }

static inline ivec4_t imat4x3_row1(imat4x3_t m) { return ivec4(imat4x3_11(m), imat4x3_12(m), imat4x3_13(m), imat4x3_14(m)); }
static inline ivec4_t imat4x3_row2(imat4x3_t m) { return ivec4(imat4x3_21(m), imat4x3_22(m), imat4x3_23(m), imat4x3_24(m)); }
static inline ivec4_t imat4x3_row3(imat4x3_t m) { return ivec4(imat4x3_31(m), imat4x3_32(m), imat4x3_33(m), imat4x3_34(m)); }

static inline ivec4_t imat4x4_row1(imat4x4_t m) { return ivec4(imat4x4_11(m), imat4x4_12(m), imat4x4_13(m), imat4x4_14(m)); }
static inline ivec4_t imat4x4_row2(imat4x4_t m) { return ivec4(imat4x4_21(m), imat4x4_22(m), imat4x4_23(m), imat4x4_24(m)); }
static inline ivec4_t imat4x4_row3(imat4x4_t m) { return ivec4(imat4x4_31(m), imat4x4_32(m), imat4x4_33(m), imat4x4_34(m)); }
static inline ivec4_t imat4x4_row4(imat4x4_t m) { return ivec4(imat4x4_41(m), imat4x4_42(m), imat4x4_43(m), imat4x4_44(m)); }





// Upgrade constructors

static inline imat3x2_t imat3x2affine2x2(imat2x2_t m, ivec2_t col3) {
	ivec2_t col1 = imat2x2_col1(m), col2 = imat2x2_col2(m);
	return imat3x2cols(col1, col2, col3);
}

static inline imat3x3_t imat3x3affine2x2(imat2x2_t m, ivec2_t col3) {
	ivec2_t col1 = imat2x2_col1(m), col2 = imat2x2_col2(m);
	return imat3x3(col1.x, col2.x, col3.x,
	              col1.y, col2.y, col3.y,
	              0, 0, F(1));
}

static inline imat3x3_t imat3x3affine3x2(imat3x2_t m) {
	ivec2_t col1 = imat3x2_col1(m), col2 = imat3x2_col2(m), col3 = imat3x2_col3(m);
	return imat3x3(col1.x, col2.x, col3.x,
	              col1.y, col2.y, col3.y,
	              0, 0, F(1));
}

static inline imat4x3_t imat4x3affine3x3(imat3x3_t m, ivec3_t col4) {
	ivec3_t col1 = imat3x3_col1(m), col2 = imat3x3_col2(m), col3 = imat3x3_col3(m);
	return imat4x3cols(col1, col2, col3, col4);
}

static inline imat4x4_t imat4x4affine3x3(imat3x3_t m, ivec3_t col4) {
	ivec3_t col1 = imat3x3_col1(m), col2 = imat3x3_col2(m), col3 = imat3x3_col3(m);
	return imat4x4(col1.x, col2.x, col3.x, col4.x,
	              col1.y, col2.y, col3.y, col4.y,
	              col1.z, col2.z, col3.z, col4.z,
	              0, 0, 0, F(1));
}

static inline imat4x4_t imat4x4affine4x3(imat4x3_t m) {
	ivec3_t col1 = imat4x3_col1(m), col2 = imat4x3_col2(m), col3 = imat4x3_col3(m), col4 = imat4x3_col4(m);
	return imat4x4(col1.x, col2.x, col3.x, col4.x,
	              col1.y, col2.y, col3.y, col4.y,
	              col1.z, col2.z, col3.z, col4.z,
	              0, 0, 0, F(1));
}



// Downgrade extractors

static inline imat2x2_t imat3x2_mat2x2(imat3x2_t m) { return imat2x2cols(imat3x2_col1(m), imat3x2_col2(m)); }
static inline imat2x2_t imat3x3_mat2x2(imat3x3_t m) { return imat2x2cols(ivec3_xy(imat3x3_col1(m)), ivec3_xy(imat3x3_col2(m))); }
static inline imat3x2_t imat3x3_mat3x2(imat3x3_t m) { return imat3x2cols(ivec3_xy(imat3x3_col1(m)), ivec3_xy(imat3x3_col2(m)), ivec3_xy(imat3x3_col3(m))); }
static inline imat3x3_t imat4x3_mat3x3(imat4x3_t m) { return imat3x3cols(imat4x3_col1(m), imat4x3_col2(m), imat4x3_col3(m)); }
static inline imat3x3_t imat4x4_mat3x3(imat4x4_t m) { return imat3x3cols(ivec4_xyz(imat4x4_col1(m)), ivec4_xyz(imat4x4_col2(m)), ivec4_xyz(imat4x4_col3(m))); }
static inline imat4x3_t imat4x4_mat4x3(imat4x4_t m) { return imat4x3cols(ivec4_xyz(imat4x4_col1(m)), ivec4_xyz(imat4x4_col2(m)), ivec4_xyz(imat4x4_col3(m)), ivec4_xyz(imat4x4_col4(m))); }




// Translation constructors

static inline imat3x2_t imat3x2translate(ivec2_t v) {
	return imat3x2(F(1), 0, v.x,
	              0, F(1), v.y);
}

static inline imat4x3_t imat4x3translate(ivec3_t v) {
	return imat4x3(F(1), 0, 0, v.x,
	              0, F(1), 0, v.y,
	              0, 0, F(1), v.z);
}
static inline imat4x4_t imat4x4translate(ivec3_t v) { return imat4x4affine4x3(imat4x3translate(v)); }



// Scaling constructors

static inline imat2x2_t imat2x2scale(int32_t x, int32_t y) {
	return imat2x2(x, 0,
	              0, y);
}
static inline imat3x2_t imat3x2scale(int32_t x, int32_t y) { return imat3x2affine2x2(imat2x2scale(x, y), ivec2zero); }

static inline imat3x3_t imat3x3scale(int32_t x, int32_t y, int32_t z) {
	return imat3x3(x, 0, 0,
	              0, y, 0,
	              0, 0, z);
}
static inline imat4x3_t imat4x3scale(int32_t x, int32_t y, int32_t z) { return imat4x3affine3x3(imat3x3scale(x, y, z), ivec3zero); }
static inline imat4x4_t imat4x4scale(int32_t x, int32_t y, int32_t z) { return imat4x4affine3x3(imat3x3scale(x, y, z), ivec3zero); }



// Rotation constructors

static inline imat2x2_t imat2x2rotate(int a) {
	return imat2x2(icos(a), -isin(a),
	              isin(a), icos(a));
}
static inline imat3x2_t imat3x2rotate(int a) { return imat3x2affine2x2(imat2x2rotate(a), ivec2zero); }

static inline imat3x3_t imat3x3rotatex(int a) {
	return imat3x3(F(1), 0, 0,
	              0, icos(a), -isin(a),
	              0, isin(a), icos(a));
}
static inline imat4x3_t imat4x3rotatex(int a) { return imat4x3affine3x3(imat3x3rotatex(a), ivec3zero); }
static inline imat4x4_t imat4x4rotatex(int a) { return imat4x4affine3x3(imat3x3rotatex(a), ivec3zero); }

static inline imat3x3_t imat3x3rotatey(int a) {
	return imat3x3( icos(a), 0, isin(a),
	               0, F(1), 0,
	               -isin(a), 0, icos(a));
}
static inline imat4x3_t imat4x3rotatey(int a) { return imat4x3affine3x3(imat3x3rotatey(a), ivec3zero); }
static inline imat4x4_t imat4x4rotatey(int a) { return imat4x4affine3x3(imat3x3rotatey(a), ivec3zero); }

static inline imat3x3_t imat3x3rotatez(int a) {
	return imat3x3(icos(a), -isin(a), 0,
	              isin(a), icos(a), 0,
	              0, 0, F(1));
}
static inline imat4x3_t imat4x3rotatez(int a) { return imat4x3affine3x3(imat3x3rotatez(a), ivec3zero); }
static inline imat4x4_t imat4x4rotatez(int a) { return imat4x4affine3x3(imat3x3rotatez(a), ivec3zero); }

imat3x3_t imat3x3rotate(int angle, ivec3_t axis);
static inline imat4x3_t imat4x3rotate(int angle, ivec3_t axis) { return imat4x3affine3x3(imat3x3rotate(angle, axis), ivec3zero); }
static inline imat4x4_t imat4x4rotate(int angle, ivec3_t axis) { return imat4x4affine3x3(imat3x3rotate(angle, axis), ivec3zero); }

imat4x3_t imat4x3affinemul(imat4x3_t a, imat4x3_t b);
imat4x4_t imat4x4affinemul(imat4x4_t a, imat4x4_t b);
static inline imat4x3_t imat4x3rotatepivot(int angle, ivec3_t axis, ivec3_t pivot) { return imat4x3affinemul(imat4x3affine3x3(imat3x3rotate(angle, axis), pivot), imat4x3translate(ivec3neg(pivot))); }
static inline imat4x4_t imat4x4rotatepivot(int angle, ivec3_t axis, ivec3_t pivot) { return imat4x4affinemul(imat4x4affine3x3(imat3x3rotate(angle, axis), pivot), imat4x4translate(ivec3neg(pivot))); }



// Lookat constructors

imat3x3_t imat3x3inverselookat(ivec3_t eye, ivec3_t center, ivec3_t up);
static inline imat4x3_t imat4x3inverselookat(ivec3_t eye, ivec3_t center, ivec3_t up) { return imat4x3affine3x3(imat3x3inverselookat(eye, center, up), eye); }
static inline imat4x4_t imat4x4inverselookat(ivec3_t eye, ivec3_t center, ivec3_t up) { return imat4x4affine3x3(imat3x3inverselookat(eye, center, up), eye); }

static inline imat3x3_t imat3x3transpose(imat3x3_t m);
ivec3_t imat3x3transform(imat3x3_t m, ivec3_t v);

static inline imat3x3_t imat3x3lookat(ivec3_t eye, ivec3_t center, ivec3_t up) { return imat3x3transpose(imat3x3inverselookat(eye, center, up)); }
static inline imat4x3_t imat4x3lookat(ivec3_t eye, ivec3_t center, ivec3_t up) { imat3x3_t m = imat3x3lookat(eye, center, up); return imat4x3affine3x3(m, imat3x3transform(m, eye)); }
static inline imat4x4_t imat4x4lookat(ivec3_t eye, ivec3_t center, ivec3_t up) { imat3x3_t m = imat3x3lookat(eye, center, up); return imat4x4affine3x3(m, imat3x3transform(m, eye)); }




// Orthogonal constructors

static inline imat3x2_t imat3x2ortho(int32_t xmin, int32_t xmax, int32_t ymin, int32_t ymax) {
	return imat3x2(2 / (xmax - xmin), 0, -(xmax + xmin) / (xmax - xmin),
	              0, 2 / (ymax - ymin), -(ymax + ymin) / (ymax - ymin));
}
static inline imat3x3_t imat3x3ortho(int32_t xmin, int32_t xmax, int32_t ymin, int32_t ymax) { return imat3x3affine3x2(imat3x2ortho(xmin, xmax, ymin, ymax)); }

static inline imat4x3_t imat4x3ortho(int32_t xmin, int32_t xmax, int32_t ymin, int32_t ymax, int32_t zmin, int32_t zmax) {
	return imat4x3(2 / (xmax - xmin), 0, 0, -(xmax + xmin) / (xmax - xmin),
	              0, 2 / (ymax - ymin), 0, -(ymax + ymin) / (ymax - ymin),
	              0, 0, -2 / (zmax - zmin), -(zmax + zmin) / (zmax - zmin));
	// -2 on z to match the OpenGL definition.
}
static inline imat4x4_t imat4x4ortho(int32_t xmin, int32_t xmax, int32_t ymin, int32_t ymax, int32_t zmin, int32_t zmax) { return imat4x4affine4x3(imat4x3ortho(xmin, xmax, ymin, ymax, zmin, zmax)); }



// Perspective constructors

/*static inline imat4x4_t imat4x4perspectiveinternal(int32_t fx, int32_t fy, int32_t znear, int32_t zfar) {
	return imat4x4(fx, 0, 0, 0,
	              0, fy, 0, 0,
	              0, 0, (zfar + znear) / (znear - zfar), 2 * zfar * znear / (znear - zfar),
	              0, 0, -F(1), 0);
}*/

/*static inline imat4x4_t imat4x4horizontalperspective(int32_t fovx, int32_t aspect, int32_t znear, int32_t zfar) {
	int32_t f = F(1) / itan(fovx * M_PI / 180 / 2);
	return imat4x4perspectiveinternal(f, f * aspect, znear, zfar);
}*/

/*static inline imat4x4_t imat4x4verticalperspective(int32_t fovy, int32_t aspect, int32_t znear, int32_t zfar) {
	int32_t f = F(1) / itan(fovy * M_PI / 180 / 2);
	return imat4x4perspectiveinternal(f / aspect, f, znear, zfar);
}*/

/*static inline imat4x4_t imat4x4minperspective(int32_t fov, int32_t aspect, int32_t znear, int32_t zfar) {
	if(aspect < F(1)) return imat4x4horizontalperspective(fov, aspect, znear, zfar);
	else return imat4x4verticalperspective(fov, aspect, znear, zfar);
}*/

/*static inline imat4x4_t imat4x4maxperspective(int32_t fov, int32_t aspect, int32_t znear, int32_t zfar) {
	if(aspect > F(1)) return imat4x4horizontalperspective(fov, aspect, znear, zfar);
	else return imat4x4verticalperspective(fov, aspect, znear, zfar);
}*/

/*static inline imat4x4_t imat4x4diagonalperspective(int32_t fov, int32_t aspect, int32_t znear, int32_t zfar) {
	int32_t f = F(1) / itan(fov * M_PI / 180 / 2);
	return imat4x4perspectiveinternal(f * isqrt(F(1) / (aspect * aspect) + F(1)), f * isqrt(aspect * aspect + F(1)), znear, zfar);
}*/




// Prespective extractors

static inline ivec4_t imat4x4_leftplane(imat4x4_t m) { return ivec4add(imat4x4_row4(m), imat4x4_row1(m)); }
static inline ivec4_t imat4x4_rightplane(imat4x4_t m) { return ivec4sub(imat4x4_row4(m), imat4x4_row1(m)); }
static inline ivec4_t imat4x4_bottomplane(imat4x4_t m) { return ivec4add(imat4x4_row4(m), imat4x4_row2(m)); }
static inline ivec4_t imat4x4_topplane(imat4x4_t m) { return ivec4sub(imat4x4_row4(m), imat4x4_row2(m)); }
static inline ivec4_t imat4x4_nearplane(imat4x4_t m) { return ivec4add(imat4x4_row4(m), imat4x4_row3(m)); }
static inline ivec4_t imat4x4_farplane(imat4x4_t m) { return ivec4sub(imat4x4_row4(m), imat4x4_row3(m)); }

imat4x3_t imat4x3affineinverse(imat4x3_t m);
static inline ivec3_t imat4x4_cameraposition(imat4x4_t m) { return imat4x3_col4(imat4x3affineinverse(imat4x3rows(imat4x4_row1(m), imat4x4_row2(m), imat4x4_row4(m)))); }



// Comparison operations

static inline bool imat2x2equal(imat2x2_t a, imat2x2_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }
static inline bool imat3x2equal(imat3x2_t a, imat3x2_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }
static inline bool imat3x3equal(imat3x3_t a, imat3x3_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }
static inline bool imat4x3equal(imat4x3_t a, imat4x3_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }
static inline bool imat4x4equal(imat4x4_t a, imat4x4_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }

static inline bool imat2x2almostequal(imat2x2_t a, imat2x2_t b, int32_t epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(abs(a.m[i] - b.m[i]) > epsilon) return false; return true; }
static inline bool imat3x2almostequal(imat3x2_t a, imat3x2_t b, int32_t epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(abs(a.m[i] - b.m[i]) > epsilon) return false; return true; }
static inline bool imat3x3almostequal(imat3x3_t a, imat3x3_t b, int32_t epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(abs(a.m[i] - b.m[i]) > epsilon) return false; return true; }
static inline bool imat4x3almostequal(imat4x3_t a, imat4x3_t b, int32_t epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(abs(a.m[i] - b.m[i]) > epsilon) return false; return true; }
static inline bool imat4x4almostequal(imat4x4_t a, imat4x4_t b, int32_t epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(abs(a.m[i] - b.m[i]) > epsilon) return false; return true; }



// Multiplication

imat2x2_t imat2x2mul(imat2x2_t a, imat2x2_t b);
imat3x3_t imat3x3mul(imat3x3_t a, imat3x3_t b);
imat4x4_t imat4x4mul(imat4x4_t a, imat4x4_t b);

imat3x2_t imat3x2affinemul(imat3x2_t a, imat3x2_t b);
imat3x3_t imat3x3affinemul(imat3x3_t a, imat3x3_t b);
imat4x3_t imat4x3affinemul(imat4x3_t a, imat4x3_t b);
imat4x4_t imat4x4affinemul(imat4x4_t a, imat4x4_t b);



// Scalar multiplication and division

static inline imat2x2_t imat2x2smul(imat2x2_t a, int32_t b) { imat2x2_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }
static inline imat3x2_t imat3x2smul(imat2x2_t a, int32_t b) { imat3x2_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }
static inline imat3x3_t imat3x3smul(imat3x3_t a, int32_t b) { imat3x3_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }
static inline imat4x3_t imat4x3smul(imat2x2_t a, int32_t b) { imat4x3_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }
static inline imat4x4_t imat4x4smul(imat4x4_t a, int32_t b) { imat4x4_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }

static inline imat2x2_t imat2x2sdiv(imat2x2_t a, int32_t b) { imat2x2_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }
static inline imat3x2_t imat3x2sdiv(imat2x2_t a, int32_t b) { imat3x2_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }
static inline imat3x3_t imat3x3sdiv(imat3x3_t a, int32_t b) { imat3x3_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }
static inline imat4x3_t imat4x3sdiv(imat2x2_t a, int32_t b) { imat4x3_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }
static inline imat4x4_t imat4x4sdiv(imat4x4_t a, int32_t b) { imat4x4_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }



// Transpose

static inline imat2x2_t imat2x2transpose(imat2x2_t m) { return imat2x2cols(imat2x2_row1(m), imat2x2_row2(m)); }
static inline imat3x3_t imat3x3transpose(imat3x3_t m) { return imat3x3cols(imat3x3_row1(m), imat3x3_row2(m), imat3x3_row3(m)); }
static inline imat4x4_t imat4x4transpose(imat4x4_t m) { return imat4x4cols(imat4x4_row1(m), imat4x4_row2(m), imat4x4_row3(m), imat4x4_row4(m)); }



// Determinant

static inline int32_t imat2x2det(imat2x2_t m) {
	return imat2x2_11(m) * imat2x2_22(m) - imat2x2_21(m) * imat2x2_12(m);
}

static inline int32_t imat3x3det(imat3x3_t m) {
	return imat3x3_11(m) * imat3x3_22(m) * imat3x3_33(m)
	       - imat3x3_11(m) * imat3x3_32(m) * imat3x3_23(m)
	       + imat3x3_21(m) * imat3x3_32(m) * imat3x3_13(m)
	       - imat3x3_21(m) * imat3x3_12(m) * imat3x3_33(m)
	       + imat3x3_31(m) * imat3x3_12(m) * imat3x3_23(m)
	       - imat3x3_31(m) * imat3x3_22(m) * imat3x3_13(m);
}

int32_t imat4x4det(imat4x4_t m);

static inline int32_t imat3x2affinedet(imat3x2_t m) {
	return imat3x2_11(m) * imat3x2_22(m) - imat3x2_21(m) * imat3x2_12(m);
}

static inline int32_t imat3x3affinedet(imat3x3_t m) {
	return imat3x3_11(m) * imat3x3_22(m) - imat3x3_21(m) * imat3x3_12(m);
}

static inline int32_t imat4x3affinedet(imat4x3_t m) {
	return imat4x3_11(m) * imat4x3_22(m) * imat4x3_33(m)
	       - imat4x3_11(m) * imat4x3_32(m) * imat4x3_23(m)
	       + imat4x3_21(m) * imat4x3_32(m) * imat4x3_13(m)
	       - imat4x3_21(m) * imat4x3_12(m) * imat4x3_33(m)
	       + imat4x3_31(m) * imat4x3_12(m) * imat4x3_23(m)
	       - imat4x3_31(m) * imat4x3_22(m) * imat4x3_13(m);
}

static inline int32_t imat4x4affinedet(imat4x4_t m) {
	return imat4x4_11(m) * imat4x4_22(m) * imat4x4_33(m)
	       - imat4x4_11(m) * imat4x4_32(m) * imat4x4_23(m)
	       + imat4x4_21(m) * imat4x4_32(m) * imat4x4_13(m)
	       - imat4x4_21(m) * imat4x4_12(m) * imat4x4_33(m)
	       + imat4x4_31(m) * imat4x4_12(m) * imat4x4_23(m)
	       - imat4x4_31(m) * imat4x4_22(m) * imat4x4_13(m);
}



// Inverse

static inline imat2x2_t imat2x2inverse(imat2x2_t m) {
	int32_t det = imat2x2det(m); // singular if det==0

	return imat2x2( imat2x2_22(m) / det, -imat2x2_12(m) / det,
	               -imat2x2_21(m) / det, imat2x2_11(m) / det);
}

imat3x3_t imat3x3inverse(imat3x3_t m);
imat4x4_t imat4x4inverse(imat4x4_t m);

imat3x2_t imat3x2affineinverse(imat3x2_t m);
imat3x3_t imat3x3affineinverse(imat3x3_t m);
imat4x3_t imat4x3affineinverse(imat4x3_t m);
imat4x4_t imat4x4affineinverse(imat4x4_t m);



// Vector transformation

static inline ivec2_t imat2x2transform(imat2x2_t m, ivec2_t v) {
	return ivec2(v.x * imat2x2_11(m) + v.y * imat2x2_12(m),
	            v.x * imat2x2_21(m) + v.y * imat2x2_22(m));
}

static inline ivec2_t imat3x2transform(imat3x2_t m, ivec2_t v) {
	return ivec2(v.x * imat3x2_11(m) + v.y * imat3x2_12(m) + imat3x2_13(m),
	            v.x * imat3x2_21(m) + v.y * imat3x2_22(m) + imat3x2_23(m));
}

ivec3_t imat3x3transform(imat3x3_t m, ivec3_t v);
ivec3_t imat4x3transform(imat4x3_t m, ivec3_t v);
ivec4_t imat4x4transform(imat4x4_t m, ivec4_t v);

ivec2_t imat3x3transformvec2(imat3x3_t m, ivec2_t v);
ivec3_t imat4x4transformvec3(imat4x4_t m, ivec3_t v);

#endif

