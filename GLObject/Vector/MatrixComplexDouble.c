#include "MatrixComplexDouble.h"

cdmat3x3_t cdmat3x3rotate(complex double angle, cdvec3_t axis) {
	complex double sine = csin(angle);
	complex double cosine = ccos(angle);
	complex double one_minus_cosine = 1 - cosine;

	axis = cdvec3norm(axis);

	return cdmat3x3(
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

cdmat3x3_t cdmat3x3inverselookat(cdvec3_t eye, cdvec3_t center, cdvec3_t up) {
	cdvec3_t backward = cdvec3norm(cdvec3sub(eye, center));
	cdvec3_t right = cdvec3norm(cdvec3cross(up, backward));
	cdvec3_t actualup = cdvec3norm(cdvec3cross(backward, right));

	return cdmat3x3cols(right, actualup, backward);
}

cdmat2x2_t cdmat2x2mul(cdmat2x2_t a, cdmat2x2_t b) {
	return cdmat2x2(a.m[0] * b.m[0] + a.m[2] * b.m[1],
	              a.m[0] * b.m[2] + a.m[2] * b.m[3],

	              a.m[1] * b.m[0] + a.m[3] * b.m[1],
	              a.m[1] * b.m[2] + a.m[3] * b.m[3]);
}

cdmat3x3_t cdmat3x3mul(cdmat3x3_t a, cdmat3x3_t b) {
	return cdmat3x3(a.m[0] * b.m[0] + a.m[3] * b.m[1] + a.m[6] * b.m[2],
	              a.m[0] * b.m[3] + a.m[3] * b.m[4] + a.m[6] * b.m[5],
	              a.m[0] * b.m[6] + a.m[3] * b.m[7] + a.m[6] * b.m[8],

	              a.m[1] * b.m[0] + a.m[4] * b.m[1] + a.m[7] * b.m[2],
	              a.m[1] * b.m[3] + a.m[4] * b.m[4] + a.m[7] * b.m[5],
	              a.m[1] * b.m[6] + a.m[4] * b.m[7] + a.m[7] * b.m[8],

	              a.m[2] * b.m[0] + a.m[5] * b.m[1] + a.m[8] * b.m[2],
	              a.m[2] * b.m[3] + a.m[5] * b.m[4] + a.m[8] * b.m[5],
	              a.m[2] * b.m[6] + a.m[5] * b.m[7] + a.m[8] * b.m[8]);
}

cdmat4x4_t cdmat4x4mul(cdmat4x4_t a, cdmat4x4_t b) {
	cdmat4x4_t res = {0};
	for(int i = 0; i < 16; i++) {
		int row = i & 3, column = i & 12;
		complex double val = 0;
		for(int j = 0; j < 4; j++) val += a.m[row + j * 4] * b.m[column + j];
		res.m[i] = val;
	}
	return res;
}

cdmat3x2_t cdmat3x2affinemul(cdmat3x2_t a, cdmat3x2_t b) {
	return cdmat3x2(a.m[0] * b.m[0] + a.m[2] * b.m[1],
	              a.m[0] * b.m[2] + a.m[2] * b.m[3],
	              a.m[0] * b.m[4] + a.m[2] * b.m[5] + a.m[4],

	              a.m[1] * b.m[0] + a.m[3] * b.m[1],
	              a.m[1] * b.m[2] + a.m[3] * b.m[3],
	              a.m[1] * b.m[4] + a.m[3] * b.m[5] + a.m[5]);
}

cdmat3x3_t cdmat3x3affinemul(cdmat3x3_t a, cdmat3x3_t b) {
	return cdmat3x3(a.m[0] * b.m[0] + a.m[3] * b.m[1],
	              a.m[0] * b.m[3] + a.m[3] * b.m[4],
	              a.m[0] * b.m[6] + a.m[3] * b.m[7] + a.m[6],

	              a.m[1] * b.m[0] + a.m[4] * b.m[1],
	              a.m[1] * b.m[3] + a.m[4] * b.m[4],
	              a.m[1] * b.m[6] + a.m[4] * b.m[7] + a.m[7],

	              0, 0, 1);
}

cdmat4x3_t cdmat4x3affinemul(cdmat4x3_t a, cdmat4x3_t b) {
	return cdmat4x3(a.m[0] * b.m[0] + a.m[3] * b.m[1] + a.m[6] * b.m[2],
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

cdmat4x4_t cdmat4x4affinemul(cdmat4x4_t a, cdmat4x4_t b) {
	return cdmat4x4(a.m[0] * b.m[0] + a.m[4] * b.m[1] + a.m[8] * b.m[2],
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

complex double cdmat4x4det(cdmat4x4_t m) {
	complex double a0 = m.m[0] * m.m[5] - m.m[1] * m.m[4];
	complex double a1 = m.m[0] * m.m[6] - m.m[2] * m.m[4];
	complex double a2 = m.m[0] * m.m[7] - m.m[3] * m.m[4];
	complex double a3 = m.m[1] * m.m[6] - m.m[2] * m.m[5];
	complex double a4 = m.m[1] * m.m[7] - m.m[3] * m.m[5];
	complex double a5 = m.m[2] * m.m[7] - m.m[3] * m.m[6];
	complex double b0 = m.m[8] * m.m[13] - m.m[9] * m.m[12];
	complex double b1 = m.m[8] * m.m[14] - m.m[10] * m.m[12];
	complex double b2 = m.m[8] * m.m[15] - m.m[11] * m.m[12];
	complex double b3 = m.m[9] * m.m[14] - m.m[10] * m.m[13];
	complex double b4 = m.m[9] * m.m[15] - m.m[11] * m.m[13];
	complex double b5 = m.m[10] * m.m[15] - m.m[11] * m.m[14];
	return a0 * b5 - a1 * b4 + a2 * b3 + a3 * b2 - a4 * b1 + a5 * b0;
}

cdmat3x3_t cdmat3x3inverse(cdmat3x3_t m) {
	cdmat3x3_t res;
	complex double det = cdmat3x3det(m); // singular if det==0

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

cdmat4x4_t cdmat4x4inverse(cdmat4x4_t m) {
	cdmat4x4_t res;

	complex double a0 = m.m[0] * m.m[5] - m.m[1] * m.m[4];
	complex double a1 = m.m[0] * m.m[6] - m.m[2] * m.m[4];
	complex double a2 = m.m[0] * m.m[7] - m.m[3] * m.m[4];
	complex double a3 = m.m[1] * m.m[6] - m.m[2] * m.m[5];
	complex double a4 = m.m[1] * m.m[7] - m.m[3] * m.m[5];
	complex double a5 = m.m[2] * m.m[7] - m.m[3] * m.m[6];
	complex double b0 = m.m[8] * m.m[13] - m.m[9] * m.m[12];
	complex double b1 = m.m[8] * m.m[14] - m.m[10] * m.m[12];
	complex double b2 = m.m[8] * m.m[15] - m.m[11] * m.m[12];
	complex double b3 = m.m[9] * m.m[14] - m.m[10] * m.m[13];
	complex double b4 = m.m[9] * m.m[15] - m.m[11] * m.m[13];
	complex double b5 = m.m[10] * m.m[15] - m.m[11] * m.m[14];
	complex double det = a0 * b5 - a1 * b4 + a2 * b3 + a3 * b2 - a4 * b1 + a5 * b0;
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

cdmat3x2_t cdmat3x2affineinverse(cdmat3x2_t m) {
	cdmat3x2_t res;
	complex double det = cdmat3x2affinedet(m); // singular if det==0

	res.m[0] = m.m[3] / det;
	res.m[2] = -m.m[2] / det;

	res.m[1] = -m.m[1] / det;
	res.m[3] = m.m[0] / det;

	res.m[4] = -(m.m[4] * res.m[0] + m.m[5] * res.m[2]);
	res.m[5] = -(m.m[4] * res.m[1] + m.m[5] * res.m[3]);

	return res;
}

cdmat3x3_t cdmat3x3affineinverse(cdmat3x3_t m) {
	cdmat3x3_t res;
	complex double det = cdmat3x3affinedet(m); // singular if det==0

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

cdmat4x3_t cdmat4x3affineinverse(cdmat4x3_t m) {
	cdmat4x3_t res;
	complex double det = cdmat4x3affinedet(m); // singular if det==0

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

cdmat4x4_t cdmat4x4affineinverse(cdmat4x4_t m) {
	cdmat4x4_t res;
	complex double det = cdmat4x4affinedet(m);
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

cdvec3_t cdmat3x3transform(cdmat3x3_t m, cdvec3_t v) {
	return cdvec3(
		v.x * m.m[0] + v.y * m.m[3] + v.z * m.m[6],
		v.x * m.m[1] + v.y * m.m[4] + v.z * m.m[7],
		v.x * m.m[2] + v.y * m.m[5] + v.z * m.m[8]);
}

cdvec3_t cdmat4x3transform(cdmat4x3_t m, cdvec3_t v) {
	return cdvec3(
		v.x * m.m[0] + v.y * m.m[3] + v.z * m.m[6] + m.m[9],
		v.x * m.m[1] + v.y * m.m[4] + v.z * m.m[7] + m.m[10],
		v.x * m.m[2] + v.y * m.m[5] + v.z * m.m[8] + m.m[11]);
}

cdvec4_t cdmat4x4transform(cdmat4x4_t m, cdvec4_t v) {
	return cdvec4(
		v.x * m.m[0] + v.y * m.m[4] + v.z * m.m[8] + v.w * m.m[12],
		v.x * m.m[1] + v.y * m.m[5] + v.z * m.m[9] + v.w * m.m[13],
		v.x * m.m[2] + v.y * m.m[6] + v.z * m.m[10] + v.w * m.m[14],
		v.x * m.m[3] + v.y * m.m[7] + v.z * m.m[11] + v.w * m.m[15]);
}

cdvec2_t cdmat3x3transformvec2(cdmat3x3_t m, cdvec2_t v) {
	complex double z = v.x * m.m[2] + v.y * m.m[5] + m.m[8];
	return cdvec2(
		(v.x * m.m[0] + v.y * m.m[3] + m.m[6]) / z,
		(v.x * m.m[1] + v.y * m.m[4] + m.m[7]) / z);
}

cdvec3_t cdmat4x4transformvec3(cdmat4x4_t m, cdvec3_t v) {
	complex double w = v.x * m.m[3] + v.y * m.m[7] + v.z * m.m[11] + m.m[15];
	return cdvec3(
		(v.x * m.m[0] + v.y * m.m[4] + v.z * m.m[8] + m.m[12]) / w,
		(v.x * m.m[1] + v.y * m.m[5] + v.z * m.m[9] + m.m[13]) / w,
		(v.x * m.m[2] + v.y * m.m[6] + v.z * m.m[10] + m.m[14]) / w);
}

