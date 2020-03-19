#ifndef __MATRIX_DOUBLE_H__
#define __MATRIX_DOUBLE_H__

#include "VectorDouble.h"



// Definitions

typedef struct { double m[4]; } dmat2x2_t;
typedef struct { double m[6]; } dmat3x2_t;
typedef struct { double m[9]; } dmat3x3_t;
typedef struct { double m[12]; } dmat4x3_t;
typedef struct { double m[16]; } dmat4x4_t;

#define dmat2x2one dmat2x2(1, 0, 0, 1)
#define dmat3x2one dmat3x2(1, 0, 0, 0, 1, 0)
#define dmat3x3one dmat3x3(1, 0, 0, 0, 1, 0, 0, 0, 1)
#define dmat4x3one dmat4x3(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0)
#define dmat4x4one dmat4x4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)



// Individual element constructors

static inline dmat2x2_t dmat2x2(double a11, double a12,
                              double a21, double a22)
{ return (dmat2x2_t){{a11, a21, a12, a22}}; }

static inline dmat3x2_t dmat3x2(double a11, double a12, double a13,
                              double a21, double a22, double a23)
{ return (dmat3x2_t){{a11, a21, a12, a22, a13, a23}}; }

static inline dmat3x3_t dmat3x3(double a11, double a12, double a13,
                              double a21, double a22, double a23,
                              double a31, double a32, double a33)
{ return (dmat3x3_t){{a11, a21, a31, a12, a22, a32, a13, a23, a33}}; }

static inline dmat4x3_t dmat4x3(double a11, double a12, double a13, double a14,
                              double a21, double a22, double a23, double a24,
                              double a31, double a32, double a33, double a34)
{ return (dmat4x3_t){{a11, a21, a31, a12, a22, a32, a13, a23, a33, a14, a24, a34}}; }

static inline dmat4x4_t dmat4x4(double a11, double a12, double a13, double a14,
                              double a21, double a22, double a23, double a24,
                              double a31, double a32, double a33, double a34,
                              double a41, double a42, double a43, double a44)
{ return (dmat4x4_t){{a11, a21, a31, a41, a12, a22, a32, a42, a13, a23, a33, a43, a14, a24, a34, a44}}; }



// Individual element extractors

static inline double dmat2x2_11(dmat2x2_t m) { return m.m[0]; }
static inline double dmat2x2_21(dmat2x2_t m) { return m.m[1]; }
static inline double dmat2x2_12(dmat2x2_t m) { return m.m[2]; }
static inline double dmat2x2_22(dmat2x2_t m) { return m.m[3]; }

static inline double dmat3x2_11(dmat3x2_t m) { return m.m[0]; }
static inline double dmat3x2_21(dmat3x2_t m) { return m.m[1]; }
static inline double dmat3x2_12(dmat3x2_t m) { return m.m[2]; }
static inline double dmat3x2_22(dmat3x2_t m) { return m.m[3]; }
static inline double dmat3x2_13(dmat3x2_t m) { return m.m[4]; }
static inline double dmat3x2_23(dmat3x2_t m) { return m.m[5]; }

static inline double dmat3x3_11(dmat3x3_t m) { return m.m[0]; }
static inline double dmat3x3_21(dmat3x3_t m) { return m.m[1]; }
static inline double dmat3x3_31(dmat3x3_t m) { return m.m[2]; }
static inline double dmat3x3_12(dmat3x3_t m) { return m.m[3]; }
static inline double dmat3x3_22(dmat3x3_t m) { return m.m[4]; }
static inline double dmat3x3_32(dmat3x3_t m) { return m.m[5]; }
static inline double dmat3x3_13(dmat3x3_t m) { return m.m[6]; }
static inline double dmat3x3_23(dmat3x3_t m) { return m.m[7]; }
static inline double dmat3x3_33(dmat3x3_t m) { return m.m[8]; }

static inline double dmat4x3_11(dmat4x3_t m) { return m.m[0]; }
static inline double dmat4x3_21(dmat4x3_t m) { return m.m[1]; }
static inline double dmat4x3_31(dmat4x3_t m) { return m.m[2]; }
static inline double dmat4x3_12(dmat4x3_t m) { return m.m[3]; }
static inline double dmat4x3_22(dmat4x3_t m) { return m.m[4]; }
static inline double dmat4x3_32(dmat4x3_t m) { return m.m[5]; }
static inline double dmat4x3_13(dmat4x3_t m) { return m.m[6]; }
static inline double dmat4x3_23(dmat4x3_t m) { return m.m[7]; }
static inline double dmat4x3_33(dmat4x3_t m) { return m.m[8]; }
static inline double dmat4x3_14(dmat4x3_t m) { return m.m[9]; }
static inline double dmat4x3_24(dmat4x3_t m) { return m.m[10]; }
static inline double dmat4x3_34(dmat4x3_t m) { return m.m[11]; }

static inline double dmat4x4_11(dmat4x4_t m) { return m.m[0]; }
static inline double dmat4x4_21(dmat4x4_t m) { return m.m[1]; }
static inline double dmat4x4_31(dmat4x4_t m) { return m.m[2]; }
static inline double dmat4x4_41(dmat4x4_t m) { return m.m[3]; }
static inline double dmat4x4_12(dmat4x4_t m) { return m.m[4]; }
static inline double dmat4x4_22(dmat4x4_t m) { return m.m[5]; }
static inline double dmat4x4_32(dmat4x4_t m) { return m.m[6]; }
static inline double dmat4x4_42(dmat4x4_t m) { return m.m[7]; }
static inline double dmat4x4_13(dmat4x4_t m) { return m.m[8]; }
static inline double dmat4x4_23(dmat4x4_t m) { return m.m[9]; }
static inline double dmat4x4_33(dmat4x4_t m) { return m.m[10]; }
static inline double dmat4x4_43(dmat4x4_t m) { return m.m[11]; }
static inline double dmat4x4_14(dmat4x4_t m) { return m.m[12]; }
static inline double dmat4x4_24(dmat4x4_t m) { return m.m[13]; }
static inline double dmat4x4_34(dmat4x4_t m) { return m.m[14]; }
static inline double dmat4x4_44(dmat4x4_t m) { return m.m[15]; }




// Column vector constructors

static inline dmat2x2_t dmat2x2cols(dvec2_t col1, dvec2_t col2) {
	return dmat2x2(col1.x, col2.x,
	              col1.y, col2.y);
}

static inline dmat3x2_t dmat3x2cols(dvec2_t col1, dvec2_t col2, dvec2_t col3) {
	return dmat3x2(col1.x, col2.x, col3.x,
	              col1.y, col2.y, col3.y);
}

static inline dmat3x3_t dmat3x3cols(dvec3_t col1, dvec3_t col2, dvec3_t col3) {
	return dmat3x3(col1.x, col2.x, col3.x,
	              col1.y, col2.y, col3.y,
	              col1.z, col2.z, col3.z);
}

static inline dmat4x3_t dmat4x3cols(dvec3_t col1, dvec3_t col2, dvec3_t col3, dvec3_t col4) {
	return dmat4x3(col1.x, col2.x, col3.x, col4.x,
	              col1.y, col2.y, col3.y, col4.y,
	              col1.z, col2.z, col3.z, col4.z);
}

static inline dmat4x4_t dmat4x4cols(dvec4_t col1, dvec4_t col2, dvec4_t col3, dvec4_t col4) {
	return dmat4x4(col1.x, col2.x, col3.x, col4.x,
	              col1.y, col2.y, col3.y, col4.y,
	              col1.z, col2.z, col3.z, col4.z,
	              col1.w, col2.w, col3.w, col4.w);
}

static inline dmat2x2_t dmat2x2vec2(dvec2_t x, dvec2_t y) { return dmat2x2cols(x, y); }
static inline dmat3x2_t dmat3x2vec2(dvec2_t x, dvec2_t y, dvec2_t z) { return dmat3x2cols(x, y, z); }
static inline dmat3x3_t dmat3x3vec3(dvec3_t x, dvec3_t y, dvec3_t z) { return dmat3x3cols(x, y, z); }
static inline dmat4x3_t dmat4x3vec3(dvec3_t x, dvec3_t y, dvec3_t z, dvec3_t w) { return dmat4x3cols(x, y, z, w); }
static inline dmat4x4_t dmat4x4vec4(dvec4_t x, dvec4_t y, dvec4_t z, dvec4_t w) { return dmat4x4cols(x, y, z, w); }



// Column vector extractors

static inline dvec2_t dmat2x2_col1(dmat2x2_t m) { return dvec2(dmat2x2_11(m), dmat2x2_21(m)); }
static inline dvec2_t dmat2x2_col2(dmat2x2_t m) { return dvec2(dmat2x2_12(m), dmat2x2_22(m)); }

static inline dvec2_t dmat3x2_col1(dmat3x2_t m) { return dvec2(dmat3x2_11(m), dmat3x2_21(m)); }
static inline dvec2_t dmat3x2_col2(dmat3x2_t m) { return dvec2(dmat3x2_12(m), dmat3x2_22(m)); }
static inline dvec2_t dmat3x2_col3(dmat3x2_t m) { return dvec2(dmat3x2_13(m), dmat3x2_23(m)); }

static inline dvec3_t dmat3x3_col1(dmat3x3_t m) { return dvec3(dmat3x3_11(m), dmat3x3_21(m), dmat3x3_31(m)); }
static inline dvec3_t dmat3x3_col2(dmat3x3_t m) { return dvec3(dmat3x3_12(m), dmat3x3_22(m), dmat3x3_32(m)); }
static inline dvec3_t dmat3x3_col3(dmat3x3_t m) { return dvec3(dmat3x3_13(m), dmat3x3_23(m), dmat3x3_33(m)); }

static inline dvec3_t dmat4x3_col1(dmat4x3_t m) { return dvec3(dmat4x3_11(m), dmat4x3_21(m), dmat4x3_31(m)); }
static inline dvec3_t dmat4x3_col2(dmat4x3_t m) { return dvec3(dmat4x3_12(m), dmat4x3_22(m), dmat4x3_32(m)); }
static inline dvec3_t dmat4x3_col3(dmat4x3_t m) { return dvec3(dmat4x3_13(m), dmat4x3_23(m), dmat4x3_33(m)); }
static inline dvec3_t dmat4x3_col4(dmat4x3_t m) { return dvec3(dmat4x3_14(m), dmat4x3_24(m), dmat4x3_34(m)); }

static inline dvec4_t dmat4x4_col1(dmat4x4_t m) { return dvec4(dmat4x4_11(m), dmat4x4_21(m), dmat4x4_31(m), dmat4x4_41(m)); }
static inline dvec4_t dmat4x4_col2(dmat4x4_t m) { return dvec4(dmat4x4_12(m), dmat4x4_22(m), dmat4x4_32(m), dmat4x4_42(m)); }
static inline dvec4_t dmat4x4_col3(dmat4x4_t m) { return dvec4(dmat4x4_13(m), dmat4x4_23(m), dmat4x4_33(m), dmat4x4_43(m)); }
static inline dvec4_t dmat4x4_col4(dmat4x4_t m) { return dvec4(dmat4x4_14(m), dmat4x4_24(m), dmat4x4_34(m), dmat4x4_44(m)); }

static inline dvec2_t dmat2x2_x(dmat2x2_t m) { return dmat2x2_col1(m); }
static inline dvec2_t dmat2x2_y(dmat2x2_t m) { return dmat2x2_col2(m); }

static inline dvec2_t dmat3x2_x(dmat3x2_t m) { return dmat3x2_col1(m); }
static inline dvec2_t dmat3x2_y(dmat3x2_t m) { return dmat3x2_col2(m); }
static inline dvec2_t dmat3x2_z(dmat3x2_t m) { return dmat3x2_col3(m); }

static inline dvec3_t dmat3x3_x(dmat3x3_t m) { return dmat3x3_col1(m); }
static inline dvec3_t dmat3x3_y(dmat3x3_t m) { return dmat3x3_col2(m); }
static inline dvec3_t dmat3x3_z(dmat3x3_t m) { return dmat3x3_col3(m); }

static inline dvec3_t dmat4x3_x(dmat4x3_t m) { return dmat4x3_col1(m); }
static inline dvec3_t dmat4x3_y(dmat4x3_t m) { return dmat4x3_col2(m); }
static inline dvec3_t dmat4x3_z(dmat4x3_t m) { return dmat4x3_col3(m); }
static inline dvec3_t dmat4x3_w(dmat4x3_t m) { return dmat4x3_col4(m); }

static inline dvec4_t dmat4x4_x(dmat4x4_t m) { return dmat4x4_col1(m); }
static inline dvec4_t dmat4x4_y(dmat4x4_t m) { return dmat4x4_col2(m); }
static inline dvec4_t dmat4x4_z(dmat4x4_t m) { return dmat4x4_col3(m); }
static inline dvec4_t dmat4x4_w(dmat4x4_t m) { return dmat4x4_col4(m); }



// Row vector constructors

static inline dmat2x2_t dmat2x2rows(dvec2_t row1, dvec2_t row2) {
	return dmat2x2(row1.x, row1.y,
	              row2.x, row2.y);
}

static inline dmat3x2_t dmat3x2rows(dvec3_t row1, dvec3_t row2) {
	return dmat3x2(row1.x, row1.y, row1.z,
	              row2.x, row2.y, row2.z);
}

static inline dmat3x3_t dmat3x3rows(dvec3_t row1, dvec3_t row2, dvec3_t row3) {
	return dmat3x3(row1.x, row1.y, row1.z,
	              row2.x, row2.y, row2.z,
	              row3.x, row3.y, row3.z);
}

static inline dmat4x3_t dmat4x3rows(dvec4_t row1, dvec4_t row2, dvec4_t row3) {
	return dmat4x3(row1.x, row1.y, row1.z, row1.w,
	              row2.x, row2.y, row2.z, row2.w,
	              row3.x, row3.y, row3.z, row3.w);
}

static inline dmat4x4_t dmat4x4rows(dvec4_t row1, dvec4_t row2, dvec4_t row3, dvec4_t row4) {
	return dmat4x4(row1.x, row1.y, row1.z, row1.w,
	              row2.x, row2.y, row2.z, row2.w,
	              row3.x, row3.y, row3.z, row3.w,
	              row4.x, row4.y, row4.z, row4.w);
}



// Row vector extractors

static inline dvec2_t dmat2x2_row1(dmat2x2_t m) { return dvec2(dmat2x2_11(m), dmat2x2_12(m)); }
static inline dvec2_t dmat2x2_row2(dmat2x2_t m) { return dvec2(dmat2x2_21(m), dmat2x2_22(m)); }

static inline dvec3_t dmat3x2_row1(dmat3x2_t m) { return dvec3(dmat3x2_11(m), dmat3x2_12(m), dmat3x2_13(m)); }
static inline dvec3_t dmat3x2_row2(dmat3x2_t m) { return dvec3(dmat3x2_21(m), dmat3x2_22(m), dmat3x2_23(m)); }

static inline dvec3_t dmat3x3_row1(dmat3x3_t m) { return dvec3(dmat3x3_11(m), dmat3x3_12(m), dmat3x3_13(m)); }
static inline dvec3_t dmat3x3_row2(dmat3x3_t m) { return dvec3(dmat3x3_21(m), dmat3x3_22(m), dmat3x3_23(m)); }
static inline dvec3_t dmat3x3_row3(dmat3x3_t m) { return dvec3(dmat3x3_31(m), dmat3x3_32(m), dmat3x3_33(m)); }

static inline dvec4_t dmat4x3_row1(dmat4x3_t m) { return dvec4(dmat4x3_11(m), dmat4x3_12(m), dmat4x3_13(m), dmat4x3_14(m)); }
static inline dvec4_t dmat4x3_row2(dmat4x3_t m) { return dvec4(dmat4x3_21(m), dmat4x3_22(m), dmat4x3_23(m), dmat4x3_24(m)); }
static inline dvec4_t dmat4x3_row3(dmat4x3_t m) { return dvec4(dmat4x3_31(m), dmat4x3_32(m), dmat4x3_33(m), dmat4x3_34(m)); }

static inline dvec4_t dmat4x4_row1(dmat4x4_t m) { return dvec4(dmat4x4_11(m), dmat4x4_12(m), dmat4x4_13(m), dmat4x4_14(m)); }
static inline dvec4_t dmat4x4_row2(dmat4x4_t m) { return dvec4(dmat4x4_21(m), dmat4x4_22(m), dmat4x4_23(m), dmat4x4_24(m)); }
static inline dvec4_t dmat4x4_row3(dmat4x4_t m) { return dvec4(dmat4x4_31(m), dmat4x4_32(m), dmat4x4_33(m), dmat4x4_34(m)); }
static inline dvec4_t dmat4x4_row4(dmat4x4_t m) { return dvec4(dmat4x4_41(m), dmat4x4_42(m), dmat4x4_43(m), dmat4x4_44(m)); }





// Upgrade constructors

static inline dmat3x2_t dmat3x2affine2x2(dmat2x2_t m, dvec2_t col3) {
	dvec2_t col1 = dmat2x2_col1(m), col2 = dmat2x2_col2(m);
	return dmat3x2cols(col1, col2, col3);
}

static inline dmat3x3_t dmat3x3affine2x2(dmat2x2_t m, dvec2_t col3) {
	dvec2_t col1 = dmat2x2_col1(m), col2 = dmat2x2_col2(m);
	return dmat3x3(col1.x, col2.x, col3.x,
	              col1.y, col2.y, col3.y,
	              0, 0, 1);
}

static inline dmat3x3_t dmat3x3affine3x2(dmat3x2_t m) {
	dvec2_t col1 = dmat3x2_col1(m), col2 = dmat3x2_col2(m), col3 = dmat3x2_col3(m);
	return dmat3x3(col1.x, col2.x, col3.x,
	              col1.y, col2.y, col3.y,
	              0, 0, 1);
}

static inline dmat4x3_t dmat4x3affine3x3(dmat3x3_t m, dvec3_t col4) {
	dvec3_t col1 = dmat3x3_col1(m), col2 = dmat3x3_col2(m), col3 = dmat3x3_col3(m);
	return dmat4x3cols(col1, col2, col3, col4);
}

static inline dmat4x4_t dmat4x4affine3x3(dmat3x3_t m, dvec3_t col4) {
	dvec3_t col1 = dmat3x3_col1(m), col2 = dmat3x3_col2(m), col3 = dmat3x3_col3(m);
	return dmat4x4(col1.x, col2.x, col3.x, col4.x,
	              col1.y, col2.y, col3.y, col4.y,
	              col1.z, col2.z, col3.z, col4.z,
	              0, 0, 0, 1);
}

static inline dmat4x4_t dmat4x4affine4x3(dmat4x3_t m) {
	dvec3_t col1 = dmat4x3_col1(m), col2 = dmat4x3_col2(m), col3 = dmat4x3_col3(m), col4 = dmat4x3_col4(m);
	return dmat4x4(col1.x, col2.x, col3.x, col4.x,
	              col1.y, col2.y, col3.y, col4.y,
	              col1.z, col2.z, col3.z, col4.z,
	              0, 0, 0, 1);
}



// Downgrade extractors

static inline dmat2x2_t dmat3x2_mat2x2(dmat3x2_t m) { return dmat2x2cols(dmat3x2_col1(m), dmat3x2_col2(m)); }
static inline dmat2x2_t dmat3x3_mat2x2(dmat3x3_t m) { return dmat2x2cols(dvec3_xy(dmat3x3_col1(m)), dvec3_xy(dmat3x3_col2(m))); }
static inline dmat3x2_t dmat3x3_mat3x2(dmat3x3_t m) { return dmat3x2cols(dvec3_xy(dmat3x3_col1(m)), dvec3_xy(dmat3x3_col2(m)), dvec3_xy(dmat3x3_col3(m))); }
static inline dmat3x3_t dmat4x3_mat3x3(dmat4x3_t m) { return dmat3x3cols(dmat4x3_col1(m), dmat4x3_col2(m), dmat4x3_col3(m)); }
static inline dmat3x3_t dmat4x4_mat3x3(dmat4x4_t m) { return dmat3x3cols(dvec4_xyz(dmat4x4_col1(m)), dvec4_xyz(dmat4x4_col2(m)), dvec4_xyz(dmat4x4_col3(m))); }
static inline dmat4x3_t dmat4x4_mat4x3(dmat4x4_t m) { return dmat4x3cols(dvec4_xyz(dmat4x4_col1(m)), dvec4_xyz(dmat4x4_col2(m)), dvec4_xyz(dmat4x4_col3(m)), dvec4_xyz(dmat4x4_col4(m))); }




// Translation constructors

static inline dmat3x2_t dmat3x2translate(dvec2_t v) {
	return dmat3x2(1, 0, v.x,
	              0, 1, v.y);
}

static inline dmat4x3_t dmat4x3translate(dvec3_t v) {
	return dmat4x3(1, 0, 0, v.x,
	              0, 1, 0, v.y,
	              0, 0, 1, v.z);
}
static inline dmat4x4_t dmat4x4translate(dvec3_t v) { return dmat4x4affine4x3(dmat4x3translate(v)); }



// Scaling constructors

static inline dmat2x2_t dmat2x2scale(double x, double y) {
	return dmat2x2(x, 0,
	              0, y);
}
static inline dmat3x2_t dmat3x2scale(double x, double y) { return dmat3x2affine2x2(dmat2x2scale(x, y), dvec2zero); }

static inline dmat3x3_t dmat3x3scale(double x, double y, double z) {
	return dmat3x3(x, 0, 0,
	              0, y, 0,
	              0, 0, z);
}
static inline dmat4x3_t dmat4x3scale(double x, double y, double z) { return dmat4x3affine3x3(dmat3x3scale(x, y, z), dvec3zero); }
static inline dmat4x4_t dmat4x4scale(double x, double y, double z) { return dmat4x4affine3x3(dmat3x3scale(x, y, z), dvec3zero); }



// Rotation constructors

static inline dmat2x2_t dmat2x2rotate(double a) {
	return dmat2x2(cos(a), -sin(a),
	              sin(a), cos(a));
}
static inline dmat3x2_t dmat3x2rotate(double a) { return dmat3x2affine2x2(dmat2x2rotate(a), dvec2zero); }

static inline dmat3x3_t dmat3x3rotatex(double a) {
	return dmat3x3(1, 0, 0,
	              0, cos(a), -sin(a),
	              0, sin(a), cos(a));
}
static inline dmat4x3_t dmat4x3rotatex(double a) { return dmat4x3affine3x3(dmat3x3rotatex(a), dvec3zero); }
static inline dmat4x4_t dmat4x4rotatex(double a) { return dmat4x4affine3x3(dmat3x3rotatex(a), dvec3zero); }

static inline dmat3x3_t dmat3x3rotatey(double a) {
	return dmat3x3( cos(a), 0, sin(a),
	               0, 1, 0,
	               -sin(a), 0, cos(a));
}
static inline dmat4x3_t dmat4x3rotatey(double a) { return dmat4x3affine3x3(dmat3x3rotatey(a), dvec3zero); }
static inline dmat4x4_t dmat4x4rotatey(double a) { return dmat4x4affine3x3(dmat3x3rotatey(a), dvec3zero); }

static inline dmat3x3_t dmat3x3rotatez(double a) {
	return dmat3x3(cos(a), -sin(a), 0,
	              sin(a), cos(a), 0,
	              0, 0, 1);
}
static inline dmat4x3_t dmat4x3rotatez(double a) { return dmat4x3affine3x3(dmat3x3rotatez(a), dvec3zero); }
static inline dmat4x4_t dmat4x4rotatez(double a) { return dmat4x4affine3x3(dmat3x3rotatez(a), dvec3zero); }

dmat3x3_t dmat3x3rotate(double angle, dvec3_t axis);
static inline dmat4x3_t dmat4x3rotate(double angle, dvec3_t axis) { return dmat4x3affine3x3(dmat3x3rotate(angle, axis), dvec3zero); }
static inline dmat4x4_t dmat4x4rotate(double angle, dvec3_t axis) { return dmat4x4affine3x3(dmat3x3rotate(angle, axis), dvec3zero); }

dmat4x3_t dmat4x3affinemul(dmat4x3_t a, dmat4x3_t b);
dmat4x4_t dmat4x4affinemul(dmat4x4_t a, dmat4x4_t b);
static inline dmat4x3_t dmat4x3rotatepivot(double angle, dvec3_t axis, dvec3_t pivot) { return dmat4x3affinemul(dmat4x3affine3x3(dmat3x3rotate(angle, axis), pivot), dmat4x3translate(dvec3neg(pivot))); }
static inline dmat4x4_t dmat4x4rotatepivot(double angle, dvec3_t axis, dvec3_t pivot) { return dmat4x4affinemul(dmat4x4affine3x3(dmat3x3rotate(angle, axis), pivot), dmat4x4translate(dvec3neg(pivot))); }



// Lookat constructors

dmat3x3_t dmat3x3inverselookat(dvec3_t eye, dvec3_t center, dvec3_t up);
static inline dmat4x3_t dmat4x3inverselookat(dvec3_t eye, dvec3_t center, dvec3_t up) { return dmat4x3affine3x3(dmat3x3inverselookat(eye, center, up), eye); }
static inline dmat4x4_t dmat4x4inverselookat(dvec3_t eye, dvec3_t center, dvec3_t up) { return dmat4x4affine3x3(dmat3x3inverselookat(eye, center, up), eye); }

static inline dmat3x3_t dmat3x3transpose(dmat3x3_t m);
dvec3_t dmat3x3transform(dmat3x3_t m, dvec3_t v);

static inline dmat3x3_t dmat3x3lookat(dvec3_t eye, dvec3_t center, dvec3_t up) { return dmat3x3transpose(dmat3x3inverselookat(eye, center, up)); }
static inline dmat4x3_t dmat4x3lookat(dvec3_t eye, dvec3_t center, dvec3_t up) { dmat3x3_t m = dmat3x3lookat(eye, center, up); return dmat4x3affine3x3(m, dmat3x3transform(m, eye)); }
static inline dmat4x4_t dmat4x4lookat(dvec3_t eye, dvec3_t center, dvec3_t up) { dmat3x3_t m = dmat3x3lookat(eye, center, up); return dmat4x4affine3x3(m, dmat3x3transform(m, eye)); }




// Orthogonal constructors

static inline dmat3x2_t dmat3x2ortho(double xmin, double xmax, double ymin, double ymax) {
	return dmat3x2(2 / (xmax - xmin), 0, -(xmax + xmin) / (xmax - xmin),
	              0, 2 / (ymax - ymin), -(ymax + ymin) / (ymax - ymin));
}
static inline dmat3x3_t dmat3x3ortho(double xmin, double xmax, double ymin, double ymax) { return dmat3x3affine3x2(dmat3x2ortho(xmin, xmax, ymin, ymax)); }

static inline dmat4x3_t dmat4x3ortho(double xmin, double xmax, double ymin, double ymax, double zmin, double zmax) {
	return dmat4x3(2 / (xmax - xmin), 0, 0, -(xmax + xmin) / (xmax - xmin),
	              0, 2 / (ymax - ymin), 0, -(ymax + ymin) / (ymax - ymin),
	              0, 0, -2 / (zmax - zmin), -(zmax + zmin) / (zmax - zmin));
	// -2 on z to match the OpenGL definition.
}
static inline dmat4x4_t dmat4x4ortho(double xmin, double xmax, double ymin, double ymax, double zmin, double zmax) { return dmat4x4affine4x3(dmat4x3ortho(xmin, xmax, ymin, ymax, zmin, zmax)); }



// Perspective constructors

static inline dmat4x4_t dmat4x4perspectiveinternal(double fx, double fy, double znear, double zfar) {
	return dmat4x4(fx, 0, 0, 0,
	              0, fy, 0, 0,
	              0, 0, (zfar + znear) / (znear - zfar), 2 * zfar * znear / (znear - zfar),
	              0, 0, -1, 0);
}

static inline dmat4x4_t dmat4x4horizontalperspective(double fovx, double aspect, double znear, double zfar) {
	double f = 1 / tan(fovx * M_PI / 180 / 2);
	return dmat4x4perspectiveinternal(f, f * aspect, znear, zfar);
}

static inline dmat4x4_t dmat4x4verticalperspective(double fovy, double aspect, double znear, double zfar) {
	double f = 1 / tan(fovy * M_PI / 180 / 2);
	return dmat4x4perspectiveinternal(f / aspect, f, znear, zfar);
}

static inline dmat4x4_t dmat4x4minperspective(double fov, double aspect, double znear, double zfar) {
	if(aspect < 1) return dmat4x4horizontalperspective(fov, aspect, znear, zfar);
	else return dmat4x4verticalperspective(fov, aspect, znear, zfar);
}

static inline dmat4x4_t dmat4x4maxperspective(double fov, double aspect, double znear, double zfar) {
	if(aspect > 1) return dmat4x4horizontalperspective(fov, aspect, znear, zfar);
	else return dmat4x4verticalperspective(fov, aspect, znear, zfar);
}

static inline dmat4x4_t dmat4x4diagonalperspective(double fov, double aspect, double znear, double zfar) {
	double f = 1 / tan(fov * M_PI / 180 / 2);
	return dmat4x4perspectiveinternal(f * sqrt(1 / (aspect * aspect) + 1), f * sqrt(aspect * aspect + 1), znear, zfar);
}




// Prespective extractors

static inline dvec4_t dmat4x4_leftplane(dmat4x4_t m) { return dvec4add(dmat4x4_row4(m), dmat4x4_row1(m)); }
static inline dvec4_t dmat4x4_rightplane(dmat4x4_t m) { return dvec4sub(dmat4x4_row4(m), dmat4x4_row1(m)); }
static inline dvec4_t dmat4x4_bottomplane(dmat4x4_t m) { return dvec4add(dmat4x4_row4(m), dmat4x4_row2(m)); }
static inline dvec4_t dmat4x4_topplane(dmat4x4_t m) { return dvec4sub(dmat4x4_row4(m), dmat4x4_row2(m)); }
static inline dvec4_t dmat4x4_nearplane(dmat4x4_t m) { return dvec4add(dmat4x4_row4(m), dmat4x4_row3(m)); }
static inline dvec4_t dmat4x4_farplane(dmat4x4_t m) { return dvec4sub(dmat4x4_row4(m), dmat4x4_row3(m)); }

dmat4x3_t dmat4x3affineinverse(dmat4x3_t m);
static inline dvec3_t dmat4x4_cameraposition(dmat4x4_t m) { return dmat4x3_col4(dmat4x3affineinverse(dmat4x3rows(dmat4x4_row1(m), dmat4x4_row2(m), dmat4x4_row4(m)))); }



// Comparison operations

static inline bool dmat2x2equal(dmat2x2_t a, dmat2x2_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }
static inline bool dmat3x2equal(dmat3x2_t a, dmat3x2_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }
static inline bool dmat3x3equal(dmat3x3_t a, dmat3x3_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }
static inline bool dmat4x3equal(dmat4x3_t a, dmat4x3_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }
static inline bool dmat4x4equal(dmat4x4_t a, dmat4x4_t b) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(a.m[i] != b.m[i]) return false; return true; }

static inline bool dmat2x2almostequal(dmat2x2_t a, dmat2x2_t b, double epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(fabs(a.m[i] - b.m[i]) > epsilon) return false; return true; }
static inline bool dmat3x2almostequal(dmat3x2_t a, dmat3x2_t b, double epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(fabs(a.m[i] - b.m[i]) > epsilon) return false; return true; }
static inline bool dmat3x3almostequal(dmat3x3_t a, dmat3x3_t b, double epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(fabs(a.m[i] - b.m[i]) > epsilon) return false; return true; }
static inline bool dmat4x3almostequal(dmat4x3_t a, dmat4x3_t b, double epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(fabs(a.m[i] - b.m[i]) > epsilon) return false; return true; }
static inline bool dmat4x4almostequal(dmat4x4_t a, dmat4x4_t b, double epsilon) { for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) if(fabs(a.m[i] - b.m[i]) > epsilon) return false; return true; }



// Multiplication

dmat2x2_t dmat2x2mul(dmat2x2_t a, dmat2x2_t b);
dmat3x3_t dmat3x3mul(dmat3x3_t a, dmat3x3_t b);
dmat4x4_t dmat4x4mul(dmat4x4_t a, dmat4x4_t b);

dmat3x2_t dmat3x2affinemul(dmat3x2_t a, dmat3x2_t b);
dmat3x3_t dmat3x3affinemul(dmat3x3_t a, dmat3x3_t b);
dmat4x3_t dmat4x3affinemul(dmat4x3_t a, dmat4x3_t b);
dmat4x4_t dmat4x4affinemul(dmat4x4_t a, dmat4x4_t b);



// Scalar multiplication and division

static inline dmat2x2_t dmat2x2smul(dmat2x2_t a, double b) { dmat2x2_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }
static inline dmat3x2_t dmat3x2smul(dmat2x2_t a, double b) { dmat3x2_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }
static inline dmat3x3_t dmat3x3smul(dmat3x3_t a, double b) { dmat3x3_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }
static inline dmat4x3_t dmat4x3smul(dmat2x2_t a, double b) { dmat4x3_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }
static inline dmat4x4_t dmat4x4smul(dmat4x4_t a, double b) { dmat4x4_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] * b; return res; }

static inline dmat2x2_t dmat2x2sdiv(dmat2x2_t a, double b) { dmat2x2_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }
static inline dmat3x2_t dmat3x2sdiv(dmat2x2_t a, double b) { dmat3x2_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }
static inline dmat3x3_t dmat3x3sdiv(dmat3x3_t a, double b) { dmat3x3_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }
static inline dmat4x3_t dmat4x3sdiv(dmat2x2_t a, double b) { dmat4x3_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }
static inline dmat4x4_t dmat4x4sdiv(dmat4x4_t a, double b) { dmat4x4_t res = {0}; for(int i = 0; i < sizeof(a.m) / sizeof(a.m[0]); i++) res.m[i] = a.m[i] / b; return res; }



// Transpose

static inline dmat2x2_t dmat2x2transpose(dmat2x2_t m) { return dmat2x2cols(dmat2x2_row1(m), dmat2x2_row2(m)); }
static inline dmat3x3_t dmat3x3transpose(dmat3x3_t m) { return dmat3x3cols(dmat3x3_row1(m), dmat3x3_row2(m), dmat3x3_row3(m)); }
static inline dmat4x4_t dmat4x4transpose(dmat4x4_t m) { return dmat4x4cols(dmat4x4_row1(m), dmat4x4_row2(m), dmat4x4_row3(m), dmat4x4_row4(m)); }



// Determinant

static inline double dmat2x2det(dmat2x2_t m) {
	return dmat2x2_11(m) * dmat2x2_22(m) - dmat2x2_21(m) * dmat2x2_12(m);
}

static inline double dmat3x3det(dmat3x3_t m) {
	return dmat3x3_11(m) * dmat3x3_22(m) * dmat3x3_33(m)
	       - dmat3x3_11(m) * dmat3x3_32(m) * dmat3x3_23(m)
	       + dmat3x3_21(m) * dmat3x3_32(m) * dmat3x3_13(m)
	       - dmat3x3_21(m) * dmat3x3_12(m) * dmat3x3_33(m)
	       + dmat3x3_31(m) * dmat3x3_12(m) * dmat3x3_23(m)
	       - dmat3x3_31(m) * dmat3x3_22(m) * dmat3x3_13(m);
}

double dmat4x4det(dmat4x4_t m);

static inline double dmat3x2affinedet(dmat3x2_t m) {
	return dmat3x2_11(m) * dmat3x2_22(m) - dmat3x2_21(m) * dmat3x2_12(m);
}

static inline double dmat3x3affinedet(dmat3x3_t m) {
	return dmat3x3_11(m) * dmat3x3_22(m) - dmat3x3_21(m) * dmat3x3_12(m);
}

static inline double dmat4x3affinedet(dmat4x3_t m) {
	return dmat4x3_11(m) * dmat4x3_22(m) * dmat4x3_33(m)
	       - dmat4x3_11(m) * dmat4x3_32(m) * dmat4x3_23(m)
	       + dmat4x3_21(m) * dmat4x3_32(m) * dmat4x3_13(m)
	       - dmat4x3_21(m) * dmat4x3_12(m) * dmat4x3_33(m)
	       + dmat4x3_31(m) * dmat4x3_12(m) * dmat4x3_23(m)
	       - dmat4x3_31(m) * dmat4x3_22(m) * dmat4x3_13(m);
}

static inline double dmat4x4affinedet(dmat4x4_t m) {
	return dmat4x4_11(m) * dmat4x4_22(m) * dmat4x4_33(m)
	       - dmat4x4_11(m) * dmat4x4_32(m) * dmat4x4_23(m)
	       + dmat4x4_21(m) * dmat4x4_32(m) * dmat4x4_13(m)
	       - dmat4x4_21(m) * dmat4x4_12(m) * dmat4x4_33(m)
	       + dmat4x4_31(m) * dmat4x4_12(m) * dmat4x4_23(m)
	       - dmat4x4_31(m) * dmat4x4_22(m) * dmat4x4_13(m);
}



// Inverse

static inline dmat2x2_t dmat2x2inverse(dmat2x2_t m) {
	double det = dmat2x2det(m); // singular if det==0

	return dmat2x2( dmat2x2_22(m) / det, -dmat2x2_12(m) / det,
	               -dmat2x2_21(m) / det, dmat2x2_11(m) / det);
}

dmat3x3_t dmat3x3inverse(dmat3x3_t m);
dmat4x4_t dmat4x4inverse(dmat4x4_t m);

dmat3x2_t dmat3x2affineinverse(dmat3x2_t m);
dmat3x3_t dmat3x3affineinverse(dmat3x3_t m);
dmat4x3_t dmat4x3affineinverse(dmat4x3_t m);
dmat4x4_t dmat4x4affineinverse(dmat4x4_t m);



// Vector transformation

static inline dvec2_t dmat2x2transform(dmat2x2_t m, dvec2_t v) {
	return dvec2(v.x * dmat2x2_11(m) + v.y * dmat2x2_12(m),
	            v.x * dmat2x2_21(m) + v.y * dmat2x2_22(m));
}

static inline dvec2_t dmat3x2transform(dmat3x2_t m, dvec2_t v) {
	return dvec2(v.x * dmat3x2_11(m) + v.y * dmat3x2_12(m) + dmat3x2_13(m),
	            v.x * dmat3x2_21(m) + v.y * dmat3x2_22(m) + dmat3x2_23(m));
}

dvec3_t dmat3x3transform(dmat3x3_t m, dvec3_t v);
dvec3_t dmat4x3transform(dmat4x3_t m, dvec3_t v);
dvec4_t dmat4x4transform(dmat4x4_t m, dvec4_t v);

dvec2_t dmat3x3transformvec2(dmat3x3_t m, dvec2_t v);
dvec3_t dmat4x4transformvec3(dmat4x4_t m, dvec3_t v);

#endif

