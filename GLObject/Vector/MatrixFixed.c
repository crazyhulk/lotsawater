#include "MatrixFixed.h"

imat3x3_t imat3x3rotate(int angle, ivec3_t axis) {
	int32_t sine = isin(angle);
	int32_t cosine = icos(angle);
	int32_t one_minus_cosine = F(1) - cosine;

	axis = ivec3norm(axis);

	return imat3x3(
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

imat3x3_t imat3x3inverselookat(ivec3_t eye, ivec3_t center, ivec3_t up) {
	ivec3_t backward = ivec3norm(ivec3sub(eye, center));
	ivec3_t right = ivec3norm(ivec3cross(up, backward));
	ivec3_t actualup = ivec3norm(ivec3cross(backward, right));

	return imat3x3cols(right, actualup, backward);
}

imat2x2_t imat2x2mul(imat2x2_t a, imat2x2_t b) {
	return imat2x2(a.m[0] * b.m[0] + a.m[2] * b.m[1],
	              a.m[0] * b.m[2] + a.m[2] * b.m[3],

	              a.m[1] * b.m[0] + a.m[3] * b.m[1],
	              a.m[1] * b.m[2] + a.m[3] * b.m[3]);
}

imat3x3_t imat3x3mul(imat3x3_t a, imat3x3_t b) {
	return imat3x3(a.m[0] * b.m[0] + a.m[3] * b.m[1] + a.m[6] * b.m[2],
	              a.m[0] * b.m[3] + a.m[3] * b.m[4] + a.m[6] * b.m[5],
	              a.m[0] * b.m[6] + a.m[3] * b.m[7] + a.m[6] * b.m[8],

	              a.m[1] * b.m[0] + a.m[4] * b.m[1] + a.m[7] * b.m[2],
	              a.m[1] * b.m[3] + a.m[4] * b.m[4] + a.m[7] * b.m[5],
	              a.m[1] * b.m[6] + a.m[4] * b.m[7] + a.m[7] * b.m[8],

	              a.m[2] * b.m[0] + a.m[5] * b.m[1] + a.m[8] * b.m[2],
	              a.m[2] * b.m[3] + a.m[5] * b.m[4] + a.m[8] * b.m[5],
	              a.m[2] * b.m[6] + a.m[5] * b.m[7] + a.m[8] * b.m[8]);
}

imat4x4_t imat4x4mul(imat4x4_t a, imat4x4_t b) {
	imat4x4_t res = {0};
	for(int i = 0; i < 16; i++) {
		int row = i & 3, column = i & 12;
		int32_t val = 0;
		for(int j = 0; j < 4; j++) val += a.m[row + j * 4] * b.m[column + j];
		res.m[i] = val;
	}
	return res;
}

imat3x2_t imat3x2affinemul(imat3x2_t a, imat3x2_t b) {
	return imat3x2(a.m[0] * b.m[0] + a.m[2] * b.m[1],
	              a.m[0] * b.m[2] + a.m[2] * b.m[3],
	              a.m[0] * b.m[4] + a.m[2] * b.m[5] + a.m[4],

	              a.m[1] * b.m[0] + a.m[3] * b.m[1],
	              a.m[1] * b.m[2] + a.m[3] * b.m[3],
	              a.m[1] * b.m[4] + a.m[3] * b.m[5] + a.m[5]);
}

imat3x3_t imat3x3affinemul(imat3x3_t a, imat3x3_t b) {
	return imat3x3(a.m[0] * b.m[0] + a.m[3] * b.m[1],
	              a.m[0] * b.m[3] + a.m[3] * b.m[4],
	              a.m[0] * b.m[6] + a.m[3] * b.m[7] + a.m[6],

	              a.m[1] * b.m[0] + a.m[4] * b.m[1],
	              a.m[1] * b.m[3] + a.m[4] * b.m[4],
	              a.m[1] * b.m[6] + a.m[4] * b.m[7] + a.m[7],

	              0, 0, F(1));
}

imat4x3_t imat4x3affinemul(imat4x3_t a, imat4x3_t b) {
	return imat4x3(a.m[0] * b.m[0] + a.m[3] * b.m[1] + a.m[6] * b.m[2],
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

imat4x4_t imat4x4affinemul(imat4x4_t a, imat4x4_t b) {
	return imat4x4(a.m[0] * b.m[0] + a.m[4] * b.m[1] + a.m[8] * b.m[2],
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

	              0, 0, 0, F(1));
}

int32_t imat4x4det(imat4x4_t m) {
	int32_t a0 = m.m[0] * m.m[5] - m.m[1] * m.m[4];
	int32_t a1 = m.m[0] * m.m[6] - m.m[2] * m.m[4];
	int32_t a2 = m.m[0] * m.m[7] - m.m[3] * m.m[4];
	int32_t a3 = m.m[1] * m.m[6] - m.m[2] * m.m[5];
	int32_t a4 = m.m[1] * m.m[7] - m.m[3] * m.m[5];
	int32_t a5 = m.m[2] * m.m[7] - m.m[3] * m.m[6];
	int32_t b0 = m.m[8] * m.m[13] - m.m[9] * m.m[12];
	int32_t b1 = m.m[8] * m.m[14] - m.m[10] * m.m[12];
	int32_t b2 = m.m[8] * m.m[15] - m.m[11] * m.m[12];
	int32_t b3 = m.m[9] * m.m[14] - m.m[10] * m.m[13];
	int32_t b4 = m.m[9] * m.m[15] - m.m[11] * m.m[13];
	int32_t b5 = m.m[10] * m.m[15] - m.m[11] * m.m[14];
	return a0 * b5 - a1 * b4 + a2 * b3 + a3 * b2 - a4 * b1 + a5 * b0;
}

imat3x3_t imat3x3inverse(imat3x3_t m) {
	imat3x3_t res;
	int32_t det = imat3x3det(m); // singular if det==0

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

imat4x4_t imat4x4inverse(imat4x4_t m) {
	imat4x4_t res;

	int32_t a0 = m.m[0] * m.m[5] - m.m[1] * m.m[4];
	int32_t a1 = m.m[0] * m.m[6] - m.m[2] * m.m[4];
	int32_t a2 = m.m[0] * m.m[7] - m.m[3] * m.m[4];
	int32_t a3 = m.m[1] * m.m[6] - m.m[2] * m.m[5];
	int32_t a4 = m.m[1] * m.m[7] - m.m[3] * m.m[5];
	int32_t a5 = m.m[2] * m.m[7] - m.m[3] * m.m[6];
	int32_t b0 = m.m[8] * m.m[13] - m.m[9] * m.m[12];
	int32_t b1 = m.m[8] * m.m[14] - m.m[10] * m.m[12];
	int32_t b2 = m.m[8] * m.m[15] - m.m[11] * m.m[12];
	int32_t b3 = m.m[9] * m.m[14] - m.m[10] * m.m[13];
	int32_t b4 = m.m[9] * m.m[15] - m.m[11] * m.m[13];
	int32_t b5 = m.m[10] * m.m[15] - m.m[11] * m.m[14];
	int32_t det = a0 * b5 - a1 * b4 + a2 * b3 + a3 * b2 - a4 * b1 + a5 * b0;
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

imat3x2_t imat3x2affineinverse(imat3x2_t m) {
	imat3x2_t res;
	int32_t det = imat3x2affinedet(m); // singular if det==0

	res.m[0] = m.m[3] / det;
	res.m[2] = -m.m[2] / det;

	res.m[1] = -m.m[1] / det;
	res.m[3] = m.m[0] / det;

	res.m[4] = -(m.m[4] * res.m[0] + m.m[5] * res.m[2]);
	res.m[5] = -(m.m[4] * res.m[1] + m.m[5] * res.m[3]);

	return res;
}

imat3x3_t imat3x3affineinverse(imat3x3_t m) {
	imat3x3_t res;
	int32_t det = imat3x3affinedet(m); // singular if det==0

	res.m[0] = m.m[4] / det;
	res.m[3] = -m.m[3] / det;

	res.m[1] = -m.m[1] / det;
	res.m[4] = m.m[0] / det;

	res.m[2] = 0;
	res.m[5] = 0;

	res.m[6] = -(m.m[6] * res.m[0] + m.m[7] * res.m[3]);
	res.m[7] = -(m.m[6] * res.m[1] + m.m[7] * res.m[4]);
	res.m[8] = F(1);

	return res;
}

imat4x3_t imat4x3affineinverse(imat4x3_t m) {
	imat4x3_t res;
	int32_t det = imat4x3affinedet(m); // singular if det==0

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

imat4x4_t imat4x4affineinverse(imat4x4_t m) {
	imat4x4_t res;
	int32_t det = imat4x4affinedet(m);
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
	res.m[15] = F(1);

	return res;
}

ivec3_t imat3x3transform(imat3x3_t m, ivec3_t v) {
	return ivec3(
		v.x * m.m[0] + v.y * m.m[3] + v.z * m.m[6],
		v.x * m.m[1] + v.y * m.m[4] + v.z * m.m[7],
		v.x * m.m[2] + v.y * m.m[5] + v.z * m.m[8]);
}

ivec3_t imat4x3transform(imat4x3_t m, ivec3_t v) {
	return ivec3(
		v.x * m.m[0] + v.y * m.m[3] + v.z * m.m[6] + m.m[9],
		v.x * m.m[1] + v.y * m.m[4] + v.z * m.m[7] + m.m[10],
		v.x * m.m[2] + v.y * m.m[5] + v.z * m.m[8] + m.m[11]);
}

ivec4_t imat4x4transform(imat4x4_t m, ivec4_t v) {
	return ivec4(
		v.x * m.m[0] + v.y * m.m[4] + v.z * m.m[8] + v.w * m.m[12],
		v.x * m.m[1] + v.y * m.m[5] + v.z * m.m[9] + v.w * m.m[13],
		v.x * m.m[2] + v.y * m.m[6] + v.z * m.m[10] + v.w * m.m[14],
		v.x * m.m[3] + v.y * m.m[7] + v.z * m.m[11] + v.w * m.m[15]);
}

ivec2_t imat3x3transformvec2(imat3x3_t m, ivec2_t v) {
	int32_t z = v.x * m.m[2] + v.y * m.m[5] + m.m[8];
	return ivec2(
		(v.x * m.m[0] + v.y * m.m[3] + m.m[6]) / z,
		(v.x * m.m[1] + v.y * m.m[4] + m.m[7]) / z);
}

ivec3_t imat4x4transformvec3(imat4x4_t m, ivec3_t v) {
	int32_t w = v.x * m.m[3] + v.y * m.m[7] + v.z * m.m[11] + m.m[15];
	return ivec3(
		(v.x * m.m[0] + v.y * m.m[4] + v.z * m.m[8] + m.m[12]) / w,
		(v.x * m.m[1] + v.y * m.m[5] + v.z * m.m[9] + m.m[13]) / w,
		(v.x * m.m[2] + v.y * m.m[6] + v.z * m.m[10] + m.m[14]) / w);
}

