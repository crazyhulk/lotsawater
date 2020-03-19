#include "MatrixDouble.h"

dmat3x3_t dmat3x3rotate(double angle, dvec3_t axis) {
	double sine = sin(angle);
	double cosine = cos(angle);
	double one_minus_cosine = 1 - cosine;

	axis = dvec3norm(axis);

	return dmat3x3(
		cosine + one_minus_cosine * axis.x * axis.x,
		one_minus_cosine * axis.x * axis.y + axis.z * sine,
		one_minus_cosine * axis.x * axis.z - axis.y * sine,

		one_minus_cosine * axis.x * axis.y - axis.z * sine,
		cosine + one_minus_cosine * axis.y * axis.y,
		one_minus_cosine * axis.y * axis.z + axis.x * sine,

		one_minus_cosine * axis.x * axis.z + axis.y * sine,
		one_minus_cosine * axis.y * axis.z - axis.x * sine,
		cosine + one_minus_cosine * axis.z * axis.z);
}

dmat3x3_t dmat3x3inverselookat(dvec3_t eye, dvec3_t center, dvec3_t up) {
	dvec3_t backward = dvec3norm(dvec3sub(eye, center));
	dvec3_t right = dvec3norm(dvec3cross(up, backward));
	dvec3_t actualup = dvec3norm(dvec3cross(backward, right));

	return dmat3x3cols(right, actualup, backward);
}

dmat2x2_t dmat2x2mul(dmat2x2_t a, dmat2x2_t b) {
	return dmat2x2(a.m[0] * b.m[0] + a.m[2] * b.m[1],
	              a.m[0] * b.m[2] + a.m[2] * b.m[3],

	              a.m[1] * b.m[0] + a.m[3] * b.m[1],
	              a.m[1] * b.m[2] + a.m[3] * b.m[3]);
}

dmat3x3_t dmat3x3mul(dmat3x3_t a, dmat3x3_t b) {
	return dmat3x3(a.m[0] * b.m[0] + a.m[3] * b.m[1] + a.m[6] * b.m[2],
	              a.m[0] * b.m[3] + a.m[3] * b.m[4] + a.m[6] * b.m[5],
	              a.m[0] * b.m[6] + a.m[3] * b.m[7] + a.m[6] * b.m[8],

	              a.m[1] * b.m[0] + a.m[4] * b.m[1] + a.m[7] * b.m[2],
	              a.m[1] * b.m[3] + a.m[4] * b.m[4] + a.m[7] * b.m[5],
	              a.m[1] * b.m[6] + a.m[4] * b.m[7] + a.m[7] * b.m[8],

	              a.m[2] * b.m[0] + a.m[5] * b.m[1] + a.m[8] * b.m[2],
	              a.m[2] * b.m[3] + a.m[5] * b.m[4] + a.m[8] * b.m[5],
	              a.m[2] * b.m[6] + a.m[5] * b.m[7] + a.m[8] * b.m[8]);
}

dmat4x4_t dmat4x4mul(dmat4x4_t a, dmat4x4_t b) {
	dmat4x4_t res = {0};
	for(int i = 0; i < 16; i++) {
		int row = i & 3, column = i & 12;
		double val = 0;
		for(int j = 0; j < 4; j++) val += a.m[row + j * 4] * b.m[column + j];
		res.m[i] = val;
	}
	return res;
}

dmat3x2_t dmat3x2affinemul(dmat3x2_t a, dmat3x2_t b) {
	return dmat3x2(a.m[0] * b.m[0] + a.m[2] * b.m[1],
	              a.m[0] * b.m[2] + a.m[2] * b.m[3],
	              a.m[0] * b.m[4] + a.m[2] * b.m[5] + a.m[4],

	              a.m[1] * b.m[0] + a.m[3] * b.m[1],
	              a.m[1] * b.m[2] + a.m[3] * b.m[3],
	              a.m[1] * b.m[4] + a.m[3] * b.m[5] + a.m[5]);
}

dmat3x3_t dmat3x3affinemul(dmat3x3_t a, dmat3x3_t b) {
	return dmat3x3(a.m[0] * b.m[0] + a.m[3] * b.m[1],
	              a.m[0] * b.m[3] + a.m[3] * b.m[4],
	              a.m[0] * b.m[6] + a.m[3] * b.m[7] + a.m[6],

	              a.m[1] * b.m[0] + a.m[4] * b.m[1],
	              a.m[1] * b.m[3] + a.m[4] * b.m[4],
	              a.m[1] * b.m[6] + a.m[4] * b.m[7] + a.m[7],

	              0, 0, 1);
}

dmat4x3_t dmat4x3affinemul(dmat4x3_t a, dmat4x3_t b) {
	return dmat4x3(a.m[0] * b.m[0] + a.m[3] * b.m[1] + a.m[6] * b.m[2],
	              a.m[0] * b.m[3] + a.m[3] * b.m[4] + a.m[6] * b.m[5],
	              a.m[0] * b.m[6] + a.m[3] * b.m[7] + a.m[6] * b.m[8],
	              a.m[0] * b.m[9] + a.m[3] * b.m[10] + a.m[6] * b.m[11] + a.m[9],

	              a.m[1] * b.m[0] + a.m[4] * b.m[1] + a.m[7] * b.m[2],
	              a.m[1] * b.m[3] + a.m[4] * b.m[4] + a.m[7] * b.m[5],
	              a.m[1] * b.m[6] + a.m[4] * b.m[7] + a.m[7] * b.m[8],
	              a.m[1] * b.m[9] + a.m[4] * b.m[10] + a.m[7] * b.m[11] + a.m[10],

	              a.m[2] * b.m[0] + a.m[5] * b.m[1] + a.m[8] * b.m[2],
	              a.m[2] * b.m[3] + a.m[5] * b.m[4] + a.m[8] * b.m[5],
	              a.m[2] * b.m[6] + a.m[5] * b.m[7] + a.m[8] * b.m[8],
	              a.m[2] * b.m[9] + a.m[5] * b.m[10] + a.m[8] * b.m[11] + a.m[11]);
}

dmat4x4_t dmat4x4affinemul(dmat4x4_t a, dmat4x4_t b) {
	return dmat4x4(a.m[0] * b.m[0] + a.m[4] * b.m[1] + a.m[8] * b.m[2],
	              a.m[0] * b.m[4] + a.m[4] * b.m[5] + a.m[8] * b.m[6],
	              a.m[0] * b.m[8] + a.m[4] * b.m[9] + a.m[8] * b.m[10],
	              a.m[0] * b.m[12] + a.m[4] * b.m[13] + a.m[8] * b.m[14] + a.m[12],

	              a.m[1] * b.m[0] + a.m[5] * b.m[1] + a.m[9] * b.m[2],
	              a.m[1] * b.m[4] + a.m[5] * b.m[5] + a.m[9] * b.m[6],
	              a.m[1] * b.m[8] + a.m[5] * b.m[9] + a.m[9] * b.m[10],
	              a.m[1] * b.m[12] + a.m[5] * b.m[13] + a.m[9] * b.m[14] + a.m[13],

	              a.m[2] * b.m[0] + a.m[6] * b.m[1] + a.m[10] * b.m[2],
	              a.m[2] * b.m[4] + a.m[6] * b.m[5] + a.m[10] * b.m[6],
	              a.m[2] * b.m[8] + a.m[6] * b.m[9] + a.m[10] * b.m[10],
	              a.m[2] * b.m[12] + a.m[6] * b.m[13] + a.m[10] * b.m[14] + a.m[14],

	              0, 0, 0, 1);
}

double dmat4x4det(dmat4x4_t m) {
	double a0 = m.m[0] * m.m[5] - m.m[1] * m.m[4];
	double a1 = m.m[0] * m.m[6] - m.m[2] * m.m[4];
	double a2 = m.m[0] * m.m[7] - m.m[3] * m.m[4];
	double a3 = m.m[1] * m.m[6] - m.m[2] * m.m[5];
	double a4 = m.m[1] * m.m[7] - m.m[3] * m.m[5];
	double a5 = m.m[2] * m.m[7] - m.m[3] * m.m[6];
	double b0 = m.m[8] * m.m[13] - m.m[9] * m.m[12];
	double b1 = m.m[8] * m.m[14] - m.m[10] * m.m[12];
	double b2 = m.m[8] * m.m[15] - m.m[11] * m.m[12];
	double b3 = m.m[9] * m.m[14] - m.m[10] * m.m[13];
	double b4 = m.m[9] * m.m[15] - m.m[11] * m.m[13];
	double b5 = m.m[10] * m.m[15] - m.m[11] * m.m[14];
	return a0 * b5 - a1 * b4 + a2 * b3 + a3 * b2 - a4 * b1 + a5 * b0;
}

dmat3x3_t dmat3x3inverse(dmat3x3_t m) {
	dmat3x3_t res;
	double det = dmat3x3det(m); // singular if det==0

	res.m[0] = (m.m[4] * m.m[8] - m.m[5] * m.m[7]) / det;
	res.m[3] = -(m.m[3] * m.m[8] - m.m[5] * m.m[6]) / det;
	res.m[6] = (m.m[3] * m.m[7] - m.m[4] * m.m[6]) / det;

	res.m[1] = -(m.m[1] * m.m[8] - m.m[2] * m.m[7]) / det;
	res.m[4] = (m.m[0] * m.m[8] - m.m[2] * m.m[6]) / det;
	res.m[7] = -(m.m[0] * m.m[7] - m.m[1] * m.m[6]) / det;

	res.m[2] = (m.m[1] * m.m[5] - m.m[2] * m.m[4]) / det;
	res.m[5] = -(m.m[0] * m.m[5] - m.m[2] * m.m[3]) / det;
	res.m[8] = (m.m[0] * m.m[4] - m.m[1] * m.m[3]) / det;

	return res;
}

dmat4x4_t dmat4x4inverse(dmat4x4_t m) {
	dmat4x4_t res;

	double a0 = m.m[0] * m.m[5] - m.m[1] * m.m[4];
	double a1 = m.m[0] * m.m[6] - m.m[2] * m.m[4];
	double a2 = m.m[0] * m.m[7] - m.m[3] * m.m[4];
	double a3 = m.m[1] * m.m[6] - m.m[2] * m.m[5];
	double a4 = m.m[1] * m.m[7] - m.m[3] * m.m[5];
	double a5 = m.m[2] * m.m[7] - m.m[3] * m.m[6];
	double b0 = m.m[8] * m.m[13] - m.m[9] * m.m[12];
	double b1 = m.m[8] * m.m[14] - m.m[10] * m.m[12];
	double b2 = m.m[8] * m.m[15] - m.m[11] * m.m[12];
	double b3 = m.m[9] * m.m[14] - m.m[10] * m.m[13];
	double b4 = m.m[9] * m.m[15] - m.m[11] * m.m[13];
	double b5 = m.m[10] * m.m[15] - m.m[11] * m.m[14];
	double det = a0 * b5 - a1 * b4 + a2 * b3 + a3 * b2 - a4 * b1 + a5 * b0;
	// singular if det==0

	res.m[0] = (m.m[5] * b5 - m.m[6] * b4 + m.m[7] * b3) / det;
	res.m[4] = -(m.m[4] * b5 - m.m[6] * b2 + m.m[7] * b1) / det;
	res.m[8] = (m.m[4] * b4 - m.m[5] * b2 + m.m[7] * b0) / det;
	res.m[12] = -(m.m[4] * b3 - m.m[5] * b1 + m.m[6] * b0) / det;

	res.m[1] = -(m.m[1] * b5 - m.m[2] * b4 + m.m[3] * b3) / det;
	res.m[5] = (m.m[0] * b5 - m.m[2] * b2 + m.m[3] * b1) / det;
	res.m[9] = -(m.m[0] * b4 - m.m[1] * b2 + m.m[3] * b0) / det;
	res.m[13] = (m.m[0] * b3 - m.m[1] * b1 + m.m[2] * b0) / det;

	res.m[2] = (m.m[13] * a5 - m.m[14] * a4 + m.m[15] * a3) / det;
	res.m[6] = -(m.m[12] * a5 - m.m[14] * a2 + m.m[15] * a1) / det;
	res.m[10] = (m.m[12] * a4 - m.m[13] * a2 + m.m[15] * a0) / det;
	res.m[14] = -(m.m[12] * a3 - m.m[13] * a1 + m.m[14] * a0) / det;

	res.m[3] = -(m.m[9] * a5 - m.m[10] * a4 + m.m[11] * a3) / det;
	res.m[7] = (m.m[8] * a5 - m.m[10] * a2 + m.m[11] * a1) / det;
	res.m[11] = -(m.m[8] * a4 - m.m[9] * a2 + m.m[11] * a0) / det;
	res.m[15] = (m.m[8] * a3 - m.m[9] * a1 + m.m[10] * a0) / det;

	return res;
}

dmat3x2_t dmat3x2affineinverse(dmat3x2_t m) {
	dmat3x2_t res;
	double det = dmat3x2affinedet(m); // singular if det==0

	res.m[0] = m.m[3] / det;
	res.m[2] = -m.m[2] / det;

	res.m[1] = -m.m[1] / det;
	res.m[3] = m.m[0] / det;

	res.m[4] = -(m.m[4] * res.m[0] + m.m[5] * res.m[2]);
	res.m[5] = -(m.m[4] * res.m[1] + m.m[5] * res.m[3]);

	return res;
}

dmat3x3_t dmat3x3affineinverse(dmat3x3_t m) {
	dmat3x3_t res;
	double det = dmat3x3affinedet(m); // singular if det==0

	res.m[0] = m.m[4] / det;
	res.m[3] = -m.m[3] / det;

	res.m[1] = -m.m[1] / det;
	res.m[4] = m.m[0] / det;

	res.m[2] = 0;
	res.m[5] = 0;

	res.m[6] = -(m.m[6] * res.m[0] + m.m[7] * res.m[3]);
	res.m[7] = -(m.m[6] * res.m[1] + m.m[7] * res.m[4]);
	res.m[8] = 1;

	return res;
}

dmat4x3_t dmat4x3affineinverse(dmat4x3_t m) {
	dmat4x3_t res;
	double det = dmat4x3affinedet(m); // singular if det==0

	res.m[0] = (m.m[4] * m.m[8] - m.m[5] * m.m[7]) / det;
	res.m[3] = -(m.m[3] * m.m[8] - m.m[5] * m.m[6]) / det;
	res.m[6] = (m.m[3] * m.m[7] - m.m[4] * m.m[6]) / det;

	res.m[1] = -(m.m[1] * m.m[8] - m.m[2] * m.m[7]) / det;
	res.m[4] = (m.m[0] * m.m[8] - m.m[2] * m.m[6]) / det;
	res.m[7] = -(m.m[0] * m.m[7] - m.m[1] * m.m[6]) / det;

	res.m[2] = (m.m[1] * m.m[5] - m.m[2] * m.m[4]) / det;
	res.m[5] = -(m.m[0] * m.m[5] - m.m[2] * m.m[3]) / det;
	res.m[8] = (m.m[0] * m.m[4] - m.m[1] * m.m[3]) / det;

	res.m[9] = -(m.m[9] * res.m[0] + m.m[10] * res.m[3] + m.m[11] * res.m[6]);
	res.m[10] = -(m.m[9] * res.m[1] + m.m[10] * res.m[4] + m.m[11] * res.m[7]);
	res.m[11] = -(m.m[9] * res.m[2] + m.m[10] * res.m[5] + m.m[11] * res.m[8]);


	return res;
}

dmat4x4_t dmat4x4affineinverse(dmat4x4_t m) {
	dmat4x4_t res;
	double det = dmat4x4affinedet(m);
	// singular if det==0

	res.m[0] = (m.m[5] * m.m[10] - m.m[6] * m.m[9]) / det;
	res.m[4] = -(m.m[4] * m.m[10] - m.m[6] * m.m[8]) / det;
	res.m[8] = (m.m[4] * m.m[9] - m.m[5] * m.m[8]) / det;

	res.m[1] = -(m.m[1] * m.m[10] - m.m[2] * m.m[9]) / det;
	res.m[5] = (m.m[0] * m.m[10] - m.m[2] * m.m[8]) / det;
	res.m[9] = -(m.m[0] * m.m[9] - m.m[1] * m.m[8]) / det;

	res.m[2] = (m.m[1] * m.m[6] - m.m[2] * m.m[5]) / det;
	res.m[6] = -(m.m[0] * m.m[6] - m.m[2] * m.m[4]) / det;
	res.m[10] = (m.m[0] * m.m[5] - m.m[1] * m.m[4]) / det;

	res.m[3] = 0;
	res.m[7] = 0;
	res.m[11] = 0;

	res.m[12] = -(m.m[12] * res.m[0] + m.m[13] * res.m[4] + m.m[14] * res.m[8]);
	res.m[13] = -(m.m[12] * res.m[1] + m.m[13] * res.m[5] + m.m[14] * res.m[9]);
	res.m[14] = -(m.m[12] * res.m[2] + m.m[13] * res.m[6] + m.m[14] * res.m[10]);
	res.m[15] = 1;

	return res;
}

dvec3_t dmat3x3transform(dmat3x3_t m, dvec3_t v) {
	return dvec3(
		v.x * m.m[0] + v.y * m.m[3] + v.z * m.m[6],
		v.x * m.m[1] + v.y * m.m[4] + v.z * m.m[7],
		v.x * m.m[2] + v.y * m.m[5] + v.z * m.m[8]);
}

dvec3_t dmat4x3transform(dmat4x3_t m, dvec3_t v) {
	return dvec3(
		v.x * m.m[0] + v.y * m.m[3] + v.z * m.m[6] + m.m[9],
		v.x * m.m[1] + v.y * m.m[4] + v.z * m.m[7] + m.m[10],
		v.x * m.m[2] + v.y * m.m[5] + v.z * m.m[8] + m.m[11]);
}

dvec4_t dmat4x4transform(dmat4x4_t m, dvec4_t v) {
	return dvec4(
		v.x * m.m[0] + v.y * m.m[4] + v.z * m.m[8] + v.w * m.m[12],
		v.x * m.m[1] + v.y * m.m[5] + v.z * m.m[9] + v.w * m.m[13],
		v.x * m.m[2] + v.y * m.m[6] + v.z * m.m[10] + v.w * m.m[14],
		v.x * m.m[3] + v.y * m.m[7] + v.z * m.m[11] + v.w * m.m[15]);
}

dvec2_t dmat3x3transformvec2(dmat3x3_t m, dvec2_t v) {
	double z = v.x * m.m[2] + v.y * m.m[5] + m.m[8];
	return dvec2(
		(v.x * m.m[0] + v.y * m.m[3] + m.m[6]) / z,
		(v.x * m.m[1] + v.y * m.m[4] + m.m[7]) / z);
}

dvec3_t dmat4x4transformvec3(dmat4x4_t m, dvec3_t v) {
	double w = v.x * m.m[3] + v.y * m.m[7] + v.z * m.m[11] + m.m[15];
	return dvec3(
		(v.x * m.m[0] + v.y * m.m[4] + v.z * m.m[8] + m.m[12]) / w,
		(v.x * m.m[1] + v.y * m.m[5] + v.z * m.m[9] + m.m[13]) / w,
		(v.x * m.m[2] + v.y * m.m[6] + v.z * m.m[10] + m.m[14]) / w);
}

