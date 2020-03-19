#include "MatrixComplex.h"

cmat3x3_t cmat3x3rotate(complex float angle, cvec3_t axis) {
	complex float sine = csinf(angle);
	complex float cosine = ccosf(angle);
	complex float one_minus_cosine = 1 - cosine;

	axis = cvec3norm(axis);

	return cmat3x3(
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

cmat3x3_t cmat3x3inverselookat(cvec3_t eye, cvec3_t center, cvec3_t up) {
	cvec3_t backward = cvec3norm(cvec3sub(eye, center));
	cvec3_t right = cvec3norm(cvec3cross(up, backward));
	cvec3_t actualup = cvec3norm(cvec3cross(backward, right));

	return cmat3x3cols(right, actualup, backward);
}

cmat2x2_t cmat2x2mul(cmat2x2_t a, cmat2x2_t b) {
	return cmat2x2(a.m[0] * b.m[0] + a.m[2] * b.m[1],
	              a.m[0] * b.m[2] + a.m[2] * b.m[3],

	              a.m[1] * b.m[0] + a.m[3] * b.m[1],
	              a.m[1] * b.m[2] + a.m[3] * b.m[3]);
}

cmat3x3_t cmat3x3mul(cmat3x3_t a, cmat3x3_t b) {
	return cmat3x3(a.m[0] * b.m[0] + a.m[3] * b.m[1] + a.m[6] * b.m[2],
	              a.m[0] * b.m[3] + a.m[3] * b.m[4] + a.m[6] * b.m[5],
	              a.m[0] * b.m[6] + a.m[3] * b.m[7] + a.m[6] * b.m[8],

	              a.m[1] * b.m[0] + a.m[4] * b.m[1] + a.m[7] * b.m[2],
	              a.m[1] * b.m[3] + a.m[4] * b.m[4] + a.m[7] * b.m[5],
	              a.m[1] * b.m[6] + a.m[4] * b.m[7] + a.m[7] * b.m[8],

	              a.m[2] * b.m[0] + a.m[5] * b.m[1] + a.m[8] * b.m[2],
	              a.m[2] * b.m[3] + a.m[5] * b.m[4] + a.m[8] * b.m[5],
	              a.m[2] * b.m[6] + a.m[5] * b.m[7] + a.m[8] * b.m[8]);
}

cmat4x4_t cmat4x4mul(cmat4x4_t a, cmat4x4_t b) {
	cmat4x4_t res = {0};
	for(int i = 0; i < 16; i++) {
		int row = i & 3, column = i & 12;
		complex float val = 0;
		for(int j = 0; j < 4; j++) val += a.m[row + j * 4] * b.m[column + j];
		res.m[i] = val;
	}
	return res;
}

cmat3x2_t cmat3x2affinemul(cmat3x2_t a, cmat3x2_t b) {
	return cmat3x2(a.m[0] * b.m[0] + a.m[2] * b.m[1],
	              a.m[0] * b.m[2] + a.m[2] * b.m[3],
	              a.m[0] * b.m[4] + a.m[2] * b.m[5] + a.m[4],

	              a.m[1] * b.m[0] + a.m[3] * b.m[1],
	              a.m[1] * b.m[2] + a.m[3] * b.m[3],
	              a.m[1] * b.m[4] + a.m[3] * b.m[5] + a.m[5]);
}

cmat3x3_t cmat3x3affinemul(cmat3x3_t a, cmat3x3_t b) {
	return cmat3x3(a.m[0] * b.m[0] + a.m[3] * b.m[1],
	              a.m[0] * b.m[3] + a.m[3] * b.m[4],
	              a.m[0] * b.m[6] + a.m[3] * b.m[7] + a.m[6],

	              a.m[1] * b.m[0] + a.m[4] * b.m[1],
	              a.m[1] * b.m[3] + a.m[4] * b.m[4],
	              a.m[1] * b.m[6] + a.m[4] * b.m[7] + a.m[7],

	              0, 0, 1);
}

cmat4x3_t cmat4x3affinemul(cmat4x3_t a, cmat4x3_t b) {
	return cmat4x3(a.m[0] * b.m[0] + a.m[3] * b.m[1] + a.m[6] * b.m[2],
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

cmat4x4_t cmat4x4affinemul(cmat4x4_t a, cmat4x4_t b) {
	return cmat4x4(a.m[0] * b.m[0] + a.m[4] * b.m[1] + a.m[8] * b.m[2],
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

complex float cmat4x4det(cmat4x4_t m) {
	complex float a0 = m.m[0] * m.m[5] - m.m[1] * m.m[4];
	complex float a1 = m.m[0] * m.m[6] - m.m[2] * m.m[4];
	complex float a2 = m.m[0] * m.m[7] - m.m[3] * m.m[4];
	complex float a3 = m.m[1] * m.m[6] - m.m[2] * m.m[5];
	complex float a4 = m.m[1] * m.m[7] - m.m[3] * m.m[5];
	complex float a5 = m.m[2] * m.m[7] - m.m[3] * m.m[6];
	complex float b0 = m.m[8] * m.m[13] - m.m[9] * m.m[12];
	complex float b1 = m.m[8] * m.m[14] - m.m[10] * m.m[12];
	complex float b2 = m.m[8] * m.m[15] - m.m[11] * m.m[12];
	complex float b3 = m.m[9] * m.m[14] - m.m[10] * m.m[13];
	complex float b4 = m.m[9] * m.m[15] - m.m[11] * m.m[13];
	complex float b5 = m.m[10] * m.m[15] - m.m[11] * m.m[14];
	return a0 * b5 - a1 * b4 + a2 * b3 + a3 * b2 - a4 * b1 + a5 * b0;
}

cmat3x3_t cmat3x3inverse(cmat3x3_t m) {
	cmat3x3_t res;
	complex float det = cmat3x3det(m); // singular if det==0

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

cmat4x4_t cmat4x4inverse(cmat4x4_t m) {
	cmat4x4_t res;

	complex float a0 = m.m[0] * m.m[5] - m.m[1] * m.m[4];
	complex float a1 = m.m[0] * m.m[6] - m.m[2] * m.m[4];
	complex float a2 = m.m[0] * m.m[7] - m.m[3] * m.m[4];
	complex float a3 = m.m[1] * m.m[6] - m.m[2] * m.m[5];
	complex float a4 = m.m[1] * m.m[7] - m.m[3] * m.m[5];
	complex float a5 = m.m[2] * m.m[7] - m.m[3] * m.m[6];
	complex float b0 = m.m[8] * m.m[13] - m.m[9] * m.m[12];
	complex float b1 = m.m[8] * m.m[14] - m.m[10] * m.m[12];
	complex float b2 = m.m[8] * m.m[15] - m.m[11] * m.m[12];
	complex float b3 = m.m[9] * m.m[14] - m.m[10] * m.m[13];
	complex float b4 = m.m[9] * m.m[15] - m.m[11] * m.m[13];
	complex float b5 = m.m[10] * m.m[15] - m.m[11] * m.m[14];
	complex float det = a0 * b5 - a1 * b4 + a2 * b3 + a3 * b2 - a4 * b1 + a5 * b0;
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

cmat3x2_t cmat3x2affineinverse(cmat3x2_t m) {
	cmat3x2_t res;
	complex float det = cmat3x2affinedet(m); // singular if det==0

	res.m[0] = m.m[3] / det;
	res.m[2] = -m.m[2] / det;

	res.m[1] = -m.m[1] / det;
	res.m[3] = m.m[0] / det;

	res.m[4] = -(m.m[4] * res.m[0] + m.m[5] * res.m[2]);
	res.m[5] = -(m.m[4] * res.m[1] + m.m[5] * res.m[3]);

	return res;
}

cmat3x3_t cmat3x3affineinverse(cmat3x3_t m) {
	cmat3x3_t res;
	complex float det = cmat3x3affinedet(m); // singular if det==0

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

cmat4x3_t cmat4x3affineinverse(cmat4x3_t m) {
	cmat4x3_t res;
	complex float det = cmat4x3affinedet(m); // singular if det==0

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

cmat4x4_t cmat4x4affineinverse(cmat4x4_t m) {
	cmat4x4_t res;
	complex float det = cmat4x4affinedet(m);
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

cvec3_t cmat3x3transform(cmat3x3_t m, cvec3_t v) {
	return cvec3(
		v.x * m.m[0] + v.y * m.m[3] + v.z * m.m[6],
		v.x * m.m[1] + v.y * m.m[4] + v.z * m.m[7],
		v.x * m.m[2] + v.y * m.m[5] + v.z * m.m[8]);
}

cvec3_t cmat4x3transform(cmat4x3_t m, cvec3_t v) {
	return cvec3(
		v.x * m.m[0] + v.y * m.m[3] + v.z * m.m[6] + m.m[9],
		v.x * m.m[1] + v.y * m.m[4] + v.z * m.m[7] + m.m[10],
		v.x * m.m[2] + v.y * m.m[5] + v.z * m.m[8] + m.m[11]);
}

cvec4_t cmat4x4transform(cmat4x4_t m, cvec4_t v) {
	return cvec4(
		v.x * m.m[0] + v.y * m.m[4] + v.z * m.m[8] + v.w * m.m[12],
		v.x * m.m[1] + v.y * m.m[5] + v.z * m.m[9] + v.w * m.m[13],
		v.x * m.m[2] + v.y * m.m[6] + v.z * m.m[10] + v.w * m.m[14],
		v.x * m.m[3] + v.y * m.m[7] + v.z * m.m[11] + v.w * m.m[15]);
}

cvec2_t cmat3x3transformvec2(cmat3x3_t m, cvec2_t v) {
	complex float z = v.x * m.m[2] + v.y * m.m[5] + m.m[8];
	return cvec2(
		(v.x * m.m[0] + v.y * m.m[3] + m.m[6]) / z,
		(v.x * m.m[1] + v.y * m.m[4] + m.m[7]) / z);
}

cvec3_t cmat4x4transformvec3(cmat4x4_t m, cvec3_t v) {
	complex float w = v.x * m.m[3] + v.y * m.m[7] + v.z * m.m[11] + m.m[15];
	return cvec3(
		(v.x * m.m[0] + v.y * m.m[4] + v.z * m.m[8] + m.m[12]) / w,
		(v.x * m.m[1] + v.y * m.m[5] + v.z * m.m[9] + m.m[13]) / w,
		(v.x * m.m[2] + v.y * m.m[6] + v.z * m.m[10] + m.m[14]) / w);
}

