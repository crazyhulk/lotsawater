import Foundation

// Definitions

#if VectorLibraryCInterop

public typealias Mat2x2 = mat2x2_t
public typealias Mat3x2 = mat3x2_t
public typealias Mat3x3 = mat3x3_t
public typealias Mat4x3 = mat4x3_t
public typealias Mat4x4 = mat4x4_t

#else

public struct Mat2x2: Equatable { public var m: (Float, Float, Float, Float); public init(_ m: (Float, Float, Float, Float)) { self.m = m } }
public struct Mat3x2: Equatable { public var m: (Float, Float, Float, Float, Float, Float); public init(_ m: (Float, Float, Float, Float, Float, Float)) { self.m = m } }
public struct Mat3x3: Equatable { public var m: (Float, Float, Float, Float, Float, Float, Float, Float, Float); public init(_ m: (Float, Float, Float, Float, Float, Float, Float, Float, Float)) { self.m = m } }
public struct Mat4x3: Equatable { public var m: (Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float); public init(_ m: (Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float)) { self.m = m } }
public struct Mat4x4: Equatable { public var m: (Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float); public init(_ m: (Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float, Float)) { self.m = m } }

#endif

// Individual element constructors

extension Mat2x2 {
	public init(
		_ a11: Float, _ a12: Float,
		_ a21: Float, _ a22: Float
	) {
		#if VectorLibraryCInterop
		self.init()
		#endif
		m = (a11, a21, a12, a22)
	}
}

extension Mat3x2 {
	public init(
		_ a11: Float, _ a12: Float, _ a13: Float,
		_ a21: Float, _ a22: Float, _ a23: Float
	) {
		#if VectorLibraryCInterop
		self.init()
		#endif
		m = (a11, a21, a12, a22, a13, a23)
	}
}

extension Mat3x3 {
	public init(
		_ a11: Float, _ a12: Float, _ a13: Float,
		_ a21: Float, _ a22: Float, _ a23: Float,
		_ a31: Float, _ a32: Float, _ a33: Float
	) {
		#if VectorLibraryCInterop
		self.init()
		#endif
		m = (a11, a21, a31, a12, a22, a32, a13, a23, a33)
	}
}

extension Mat4x3 {
	public init(
		_ a11: Float, _ a12: Float, _ a13: Float, _ a14: Float,
		_ a21: Float, _ a22: Float, _ a23: Float, _ a24: Float,
		_ a31: Float, _ a32: Float, _ a33: Float, _ a34: Float
	) {
		#if VectorLibraryCInterop
		self.init()
		#endif
		m = (a11, a21, a31, a12, a22, a32, a13, a23, a33, a14, a24, a34)
	}
}

extension Mat4x4 {
	public init(
		_ a11: Float, _ a12: Float, _ a13: Float, _ a14: Float,
		_ a21: Float, _ a22: Float, _ a23: Float, _ a24: Float,
		_ a31: Float, _ a32: Float, _ a33: Float, _ a34: Float,
		_ a41: Float, _ a42: Float, _ a43: Float, _ a44: Float
	) {
		#if VectorLibraryCInterop
		self.init()
		#endif
		m = (a11, a21, a31, a41, a12, a22, a32, a42, a13, a23, a33, a43, a14, a24, a34, a44)
	}
}

// Individual element extractors

extension Mat2x2 {
	public var m11: Float { return m.0 }
	public var m21: Float { return m.1 }
	public var m12: Float { return m.2 }
	public var m22: Float { return m.3 }
}

extension Mat3x2 {
	public var m11: Float { return m.0 }
	public var m21: Float { return m.1 }
	public var m12: Float { return m.2 }
	public var m22: Float { return m.3 }
	public var m13: Float { return m.4 }
	public var m23: Float { return m.5 }
}

extension Mat3x3 {
	public var m11: Float { return m.0 }
	public var m21: Float { return m.1 }
	public var m31: Float { return m.2 }
	public var m12: Float { return m.3 }
	public var m22: Float { return m.4 }
	public var m32: Float { return m.5 }
	public var m13: Float { return m.6 }
	public var m23: Float { return m.7 }
	public var m33: Float { return m.8 }
}

extension Mat4x3 {
	public var m11: Float { return m.0 }
	public var m21: Float { return m.1 }
	public var m31: Float { return m.2 }
	public var m12: Float { return m.3 }
	public var m22: Float { return m.4 }
	public var m32: Float { return m.5 }
	public var m13: Float { return m.6 }
	public var m23: Float { return m.7 }
	public var m33: Float { return m.8 }
	public var m14: Float { return m.9 }
	public var m24: Float { return m.10 }
	public var m34: Float { return m.11 }
}

extension Mat4x4 {
	public var m11: Float { return m.0 }
	public var m21: Float { return m.1 }
	public var m31: Float { return m.2 }
	public var m41: Float { return m.3 }
	public var m12: Float { return m.4 }
	public var m22: Float { return m.5 }
	public var m32: Float { return m.6 }
	public var m42: Float { return m.7 }
	public var m13: Float { return m.8 }
	public var m23: Float { return m.9 }
	public var m33: Float { return m.10 }
	public var m43: Float { return m.11 }
	public var m14: Float { return m.12 }
	public var m24: Float { return m.13 }
	public var m34: Float { return m.14 }
	public var m44: Float { return m.15 }
}

// Column vector constructors

extension Mat2x2 {
	public init(x: Vec2, y: Vec2) {
		self.init(x.x, y.x,
		          x.y, y.y)
	}
}

extension Mat3x2 {
	public init(x: Vec2, y: Vec2, z: Vec2) {
		self.init(x.x, y.x, z.x,
		          y.y, y.y, z.y)
	}
}

extension Mat3x3 {
	public init(x: Vec3, y: Vec3, z: Vec3) {
		self.init(x.x, y.x, z.x,
		          x.y, y.y, z.y,
		          x.z, y.z, z.z)
	}
}

extension Mat4x3 {
	public init(x: Vec3, y: Vec3, z: Vec3, w: Vec3) {
		self.init(x.x, y.x, z.x, w.x,
		          x.y, y.y, z.y, w.y,
		          x.z, y.z, z.z, w.z)
	}
}

extension Mat4x4 {
	public init(x: Vec4, y: Vec4, z: Vec4, w: Vec4) {
		self.init(x.x, y.x, z.x, w.x,
		          x.y, y.y, z.y, w.y,
		          x.z, y.z, z.z, w.z,
		          x.w, y.w, z.w, w.w)
	}
}

// Column vector extractors

extension Mat2x2 {
	public var x: Vec2 { return Vec2(x: m11, y: m21) }
	public var y: Vec2 { return Vec2(x: m12, y: m22) }
}

extension Mat3x2 {
	public var x: Vec2 { return Vec2(x: m11, y: m21) }
	public var y: Vec2 { return Vec2(x: m12, y: m22) }
	public var z: Vec2 { return Vec2(x: m13, y: m23) }
}

extension Mat3x3 {
	public var x: Vec3 { return Vec3(x: m11, y: m21, z: m31) }
	public var y: Vec3 { return Vec3(x: m12, y: m22, z: m32) }
	public var z: Vec3 { return Vec3(x: m13, y: m23, z: m33) }
}

extension Mat4x3 {
	public var x: Vec3 { return Vec3(x: m11, y: m21, z: m31) }
	public var y: Vec3 { return Vec3(x: m12, y: m22, z: m32) }
	public var z: Vec3 { return Vec3(x: m13, y: m23, z: m33) }
	public var w: Vec3 { return Vec3(x: m14, y: m24, z: m34) }
}

extension Mat4x4 {
	public var x: Vec4 { return Vec4(x: m11, y: m21, z: m31, w: m41) }
	public var y: Vec4 { return Vec4(x: m12, y: m22, z: m32, w: m42) }
	public var z: Vec4 { return Vec4(x: m13, y: m23, z: m33, w: m43) }
	public var w: Vec4 { return Vec4(x: m14, y: m24, z: m34, w: m44) }
}

// Row vector constructors

extension Mat2x2 {
	public init(row1: Vec2, row2: Vec2) {
		self.init(row1.x, row1.y,
		          row2.x, row2.y)
	}
}

extension Mat3x2 {
	public init(row1: Vec3, row2: Vec3) {
		self.init(row1.x, row1.y, row1.z,
		          row2.x, row2.y, row2.z)
	}
}

extension Mat3x3 {
	public init(row1: Vec3, row2: Vec3, row3: Vec3) {
		self.init(row1.x, row1.y, row1.z,
		          row2.x, row2.y, row2.z,
		          row3.x, row3.y, row3.z)
	}
}

extension Mat4x3 {
	public init(row1: Vec4, row2: Vec4, row3: Vec4) {
		self.init(row1.x, row1.y, row1.z, row1.w,
		          row2.x, row2.y, row2.z, row2.w,
		          row3.x, row3.y, row3.z, row3.w)
	}
}

extension Mat4x4 {
	public init(row1: Vec4, row2: Vec4, row3: Vec4, row4: Vec4) {
		self.init(row1.x, row1.y, row1.z, row1.w,
		          row2.x, row2.y, row2.z, row2.w,
		          row3.x, row3.y, row3.z, row3.w,
		          row4.x, row4.y, row4.z, row4.w)
	}
}

// Row vector extractors

extension Mat2x2 {
	public var row1: Vec2 { return Vec2(x: m11, y: m12) }
	public var row2: Vec2 { return Vec2(x: m21, y: m22) }
}

extension Mat3x2 {
	public var row1: Vec3 { return Vec3(x: m11, y: m12, z: m13); }
	public var row2: Vec3 { return Vec3(x: m21, y: m22, z: m23); }
}

extension Mat3x3 {
	public var row1: Vec3 { return Vec3(x: m11, y: m12, z: m13); }
	public var row2: Vec3 { return Vec3(x: m21, y: m22, z: m23); }
	public var row3: Vec3 { return Vec3(x: m31, y: m32, z: m33); }
}

extension Mat4x3 {
	public var row1: Vec4 { return Vec4(x: m11, y: m12, z: m13, w: m14); }
	public var row2: Vec4 { return Vec4(x: m21, y: m22, z: m23, w: m24); }
	public var row3: Vec4 { return Vec4(x: m31, y: m32, z: m33, w: m34); }
}

extension Mat4x4 {
	public var row1: Vec4 { return Vec4(x: m11, y: m12, z: m13, w: m14); }
	public var row2: Vec4 { return Vec4(x: m21, y: m22, z: m23, w: m24); }
	public var row3: Vec4 { return Vec4(x: m31, y: m32, z: m33, w: m34); }
	public var row4: Vec4 { return Vec4(x: m41, y: m42, z: m43, w: m44); }
}

// Upgrade constructors

extension Mat3x2 {
	public init(_ m: Mat2x2) {
		self.init(m.m11, m.m12, 0,
		          m.m21, m.m22, 0)
	}

	public init(linearTransform m: Mat2x2, translation z: Vec2) {
		self.init(m.m11, m.m12, z.x,
		          m.m21, m.m22, z.y)
	}
}

extension Mat3x3 {
	public init(_ m: Mat2x2) {
		self.init(m.m11, m.m12, 0,
		          m.m21, m.m22, 0,
		              0,     0, 1)
	}

	public init(linearTransform m: Mat2x2, translation z: Vec2) {
		self.init(m.m11, m.m12, z.x,
		          m.m21, m.m22, z.y,
		              0,     0,   1)
	}

	public init(_ m: Mat3x2) {
		self.init(m.m11, m.m12, m.m13,
		          m.m21, m.m22, m.m23,
		              0,     0,     1)
	}
}

extension Mat4x3 {
	public init(_ m: Mat3x3) {
		self.init(m.m11, m.m12, m.m13, 0,
		          m.m21, m.m22, m.m23, 0,
		          m.m31, m.m32, m.m33, 0)
	}

	public init(linearTransform m: Mat3x3, translation w: Vec3) {
		self.init(m.m11, m.m12, m.m13, w.x,
		          m.m21, m.m22, m.m23, w.y,
		          m.m31, m.m32, m.m33, w.z)
	}
}

extension Mat4x4 {
	public init(_ m: Mat3x3) {
		self.init(m.m11, m.m12, m.m13, 0,
		          m.m21, m.m22, m.m23, 0,
		          m.m31, m.m32, m.m33, 0,
		              0,     0,     0, 1)
	}

	public init(linearTransform m: Mat3x3, translation w: Vec3) {
		self.init(m.m11, m.m12, m.m13, w.x,
		          m.m21, m.m22, m.m23, w.y,
		          m.m31, m.m32, m.m33, w.z,
		              0,     0,     0,   1)
	}

	public init(_ m: Mat4x3) {
		self.init(m.m11, m.m12, m.m13, m.m14,
		          m.m21, m.m22, m.m23, m.m24,
		          m.m31, m.m32, m.m33, m.m34,
		              0,     0,     0,     1)
	}
}

// Downgrade extractors

extension Mat3x2 { public var linearTransform: Mat2x2 { return Mat2x2(x: x, y: y) } }
extension Mat3x3 { public var linearTransform: Mat2x2 { return Mat2x2(x: x.xy, y: y.xy) } }
extension Mat4x3 { public var linearTransform: Mat3x3 { return Mat3x3(x: x, y: y, z: z) } }
extension Mat4x4 { public var linearTransform: Mat3x3 { return Mat3x3(x: x.xyz, y: y.xyz, z: z.xyz) } }

extension Mat3x2 { public var translation: Vec2 { return z } }
extension Mat3x3 { public var translation: Vec2 { return z.xy } }
extension Mat4x3 { public var translation: Vec3 { return w } }
extension Mat4x4 { public var translation: Vec3 { return w.xyz } }

extension Mat3x3 { public var affineTransform: Mat3x2 { return Mat3x2(x: x.xy, y: y.xy, z: z.xy) } }
extension Mat4x4 { public var affineTransform: Mat4x3 { return Mat4x3(x: x.xyz, y: y.xyz, z: z.xyz, w: w.xyz) } }

// Translation constructors

extension Mat3x2 {
	public init(translateByX x: Float, y: Float) {
		self.init(1, 0, x,
		          0, 1, y)
	}

	public init(translateBy v: Vec2) { self.init(translateByX: v.x, y: v.y) }
}

extension Mat3x3 {
	public init(translateByX x: Float, y: Float) { self.init(Mat3x2(translateByX: x, y: y)) }
	public init(translateBy v: Vec2) { self.init(Mat3x2(translateBy: v)) }
}

extension Mat4x3 {
	public init(translateByX x: Float, y: Float, z: Float) {
		self.init(1, 0, 0, x,
		          0, 1, 0, y,
		          0, 0, 1, z)
	}

	public init(translateBy v: Vec3) { self.init(translateByX: v.x, y: v.y, z: v.z) }
}

extension Mat4x4 {
	public init(translateByX x: Float, y: Float, z: Float) { self.init(Mat4x3(translateByX: x, y: y, z: z)) }
	public init(translateBy v: Vec3) { self.init(Mat4x3(translateBy: v)) }
}

// Scaling constructors

extension Mat2x2 {
	public init(scaleXBy sx: Float, y sy: Float) {
		self.init(sx,  0,
		           0, sy)
	}
}

extension Mat3x2 {
	public init(scaleXBy sx: Float, y sy: Float) { self.init(Mat2x2(scaleXBy: sx, y: sx)) }
}

extension Mat3x3 {
	public init(scaleXBy sx: Float, y sy: Float) { self.init(Mat2x2(scaleXBy: sx, y: sx)) }

	public init(scaleXBy sx: Float, y sy: Float, z sz: Float) {
		self.init(sx, 0,   0,
		           0, sy,  0,
				   0,  0, sz)
	}
}

extension Mat4x3 {
	public init(scaleXBy sx: Float, y sy: Float, z sz: Float) { self.init(Mat3x3(scaleXBy: sx, y: sy, z: sz)) }
}

extension Mat4x4 {
	public init(scaleXBy sx: Float, y sy: Float, z sz: Float) { self.init(Mat3x3(scaleXBy: sx, y: sy, z: sz)) }

	public init(scaleXBy sx: Float, y sy: Float, z sz: Float, w sw: Float) {
		self.init(sx, 0,   0,  0,
		           0, sy,  0,  0,
				   0,  0, sz,  0,
				   0,  0,  0, sw)
	}
}

// Rotation constructors

extension Mat2x2 {
	public init(rotateBy a: Float) {
		self.init(cos(a), -sin(a),
		          sin(a),  cos(a))
	}
}

extension Mat3x2 {
	public init(rotateBy a: Float) { self.init(Mat2x2(rotateBy: a)) }
}

extension Mat3x3 {
	public init(rotateBy a: Float) { self.init(Mat2x2(rotateBy: a)) }

	public init(rotateXBy a: Float) {
		self.init(1,      0,       0,
		          0, cos(a), -sin(a),
		          0, sin(a),  cos(a))
	}

	public init(rotateYBy a: Float) {
		self.init(cos(a), 0, sin(a),
		               0, 1,      0,
		         -sin(a), 0, cos(a))
	}

	public init(rotateZBy a: Float) {
		self.init(cos(a), -sin(a), 0,
		          sin(a),  cos(a), 0,
		               0,       0, 1)
	}

	public init(rotateBy a: Float, axis: Vec3) {
		let sine = sin(a)
		let cosine = cos(a)
		let one_minus_cosine = 1 - cosine

		let axis = axis.normalised

		self.init(cosine + one_minus_cosine * axis.x * axis.x,
		          one_minus_cosine * axis.x * axis.y + axis.z * sine,
		          one_minus_cosine * axis.x * axis.z - axis.y * sine,

		          one_minus_cosine * axis.x * axis.y - axis.z * sine,
		          cosine + one_minus_cosine * axis.y * axis.y,
		          one_minus_cosine * axis.y * axis.z + axis.x * sine,

		          one_minus_cosine * axis.x * axis.z + axis.y * sine,
		          one_minus_cosine * axis.y * axis.z - axis.x * sine,
		          cosine + one_minus_cosine * axis.z * axis.z);
	}
}

extension Mat4x3 {
	public init(rotateXBy a: Float) { self.init(Mat3x3(rotateXBy: a)) }
	public init(rotateYBy a: Float) { self.init(Mat3x3(rotateYBy: a)) }
	public init(rotateZBy a: Float) { self.init(Mat3x3(rotateZBy: a)) }
	public init(rotateBy a: Float, axis: Vec3) { self.init(Mat3x3(rotateBy: a, axis: axis)) }
}

extension Mat4x4 {
	public init(rotateXBy a: Float) { self.init(Mat3x3(rotateXBy: a)) }
	public init(rotateYBy a: Float) { self.init(Mat3x3(rotateYBy: a)) }
	public init(rotateZBy a: Float) { self.init(Mat3x3(rotateZBy: a)) }
	public init(rotateBy a: Float, axis: Vec3) { self.init(Mat3x3(rotateBy: a, axis: axis)) }
}

// Re-centering transformations

extension Mat3x2 {
	public func around(_ center: Vec2) -> Mat3x2 {
		return Mat3x2(translateBy: center) * self * Mat3x2(translateBy: -center)
	}
}

extension Mat4x3 {
	public func around(_ center: Vec3) -> Mat4x3 {
		return Mat4x3(translateBy: center) * self * Mat4x3(translateBy: -center)
	}
}

extension Mat4x4 {
	public func around(_ center: Vec3) -> Mat4x4 {
		return Mat4x4(translateBy: center) * self * Mat4x4(translateBy: -center)
	}
}

// Lookat constructors

extension Mat3x3 {
	public init(inverseLookFrom eye: Vec3, at: Vec3, upDirection: Vec3) {
		let backward = normalise(eye - at)
		let right = normalise(upDirection ⨯ backward)
		let up = normalise(backward ⨯ right)
		self.init(x: right, y: up, z: backward)
	}

	public init(lookFrom eye: Vec3, at: Vec3, upDirection: Vec3) {
		self = Mat3x3(inverseLookFrom: eye, at: at, upDirection: upDirection).transpose
	}
}

extension Mat4x3 {
	public init(inverseLookFrom eye: Vec3, at: Vec3, upDirection: Vec3) {
		self.init(linearTransform: Mat3x3(inverseLookFrom: eye, at: at, upDirection: upDirection), translation: eye)
	}

	public init(lookFrom eye: Vec3, at: Vec3, upDirection: Vec3) {
		let m = Mat3x3(lookFrom: eye, at: at, upDirection: upDirection)
		self.init(linearTransform: m, translation: m * eye)
	}
}

extension Mat4x4 {
	public init(inverseLookFrom eye: Vec3, at: Vec3, upDirection: Vec3) {
		self.init(linearTransform: Mat3x3(inverseLookFrom: eye, at: at, upDirection: upDirection), translation: eye)
	}
	public init(lookFrom eye: Vec3, at: Vec3, upDirection: Vec3) {
		let m = Mat3x3(lookFrom: eye, at: at, upDirection: upDirection)
		self.init(linearTransform: m, translation: m * eye)
	}
}

// Orthogonal constructors

extension Mat3x2 {
	public init(orthogonalProjectionWithXFrom xmin: Float, to xmax: Float, yFrom ymin: Float, to ymax: Float) {
		self.init(2 / (xmax - xmin),                 0, -(xmax + xmin) / (xmax - xmin),
		                          0, 2 / (ymax - ymin), -(ymax + ymin) / (ymax - ymin))
	}
}

extension Mat3x3 {
	public init(orthogonalProjectionWithXFrom xmin: Float, to xmax: Float, yFrom ymin: Float, to ymax: Float) {
		self.init(Mat3x2(orthogonalProjectionWithXFrom: xmin, to: xmax, yFrom: ymin, to: ymax))
	}
}

extension Mat4x3 {
	public init(orthogonalProjectionWithXFrom xmin: Float, to xmax: Float, yFrom ymin: Float, to ymax: Float, zFrom zmin: Float, to zmax: Float) {
		self.init(2 / (xmax - xmin),                 0,                  0, -(xmax + xmin) / (xmax - xmin),
		                          0, 2 / (ymax - ymin),                  0, -(ymax + ymin) / (ymax - ymin),
		                          0,                 0, -2 / (zmax - zmin), -(zmax + zmin) / (zmax - zmin))
		// -2 on z to match the OpenGL definition.
	}
}

extension Mat4x4 {
	public init(orthogonalProjectionWithXFrom xmin: Float, to xmax: Float, yFrom ymin: Float, to ymax: Float, zFrom zmin: Float, to zmax: Float) {
		self.init(Mat4x3(orthogonalProjectionWithXFrom: xmin, to: xmax, yFrom: ymin, to: ymax, zFrom: zmin, to: zmax))
	}
}

// Perspective constructors

extension Mat4x4 {
	private init(viewFactorX fx: Float, y fy: Float, zFrom znear: Float, to zfar: Float) {
		self.init(fx,  0,                               0,                                 0,
		           0, fy,                               0,                                 0,
		           0,  0, (zfar + znear) / (znear - zfar), 2 * zfar * znear / (znear - zfar),
		           0,  0,                              -1,                                 0)
	}

	public init(horizontalViewAngle fovx: Float, aspectRatio aspect: Float, zFrom znear: Float, to zfar: Float) {
		let f = 1 / tan(fovx * Float.pi / 180 / 2)
		self.init(viewFactorX: f, y: f * aspect, zFrom: znear, to: zfar)
	}

	public init(verticalViewAngle fovy: Float, aspectRatio aspect: Float, zFrom znear: Float, to zfar: Float) {
		let f = 1 / tan(fovy * Float.pi / 180 / 2)
		self.init(viewFactorX: f / aspect, y: f, zFrom: znear, to: zfar)
	}

	public init(minimumViewAngle fov: Float, aspectRatio aspect: Float, zFrom znear: Float, to zfar: Float) {
		if aspect >= 1 {
			self.init(verticalViewAngle: fov, aspectRatio: aspect, zFrom: znear, to: zfar)
		} else {
			self.init(horizontalViewAngle: fov, aspectRatio: aspect, zFrom: znear, to: zfar)
		}
	}

	public init(maximumViewAngle fov: Float, aspectRatio aspect: Float, zFrom znear: Float, to zfar: Float) {
		if aspect >= 1 {
			self.init(horizontalViewAngle: fov, aspectRatio: aspect, zFrom: znear, to: zfar)
		} else {
			self.init(verticalViewAngle: fov, aspectRatio: aspect, zFrom: znear, to: zfar)
		}
	}

	public init(diagonalViewAngle fov: Float, aspectRatio aspect: Float, zFrom znear: Float, to zfar: Float) {
		let f = 1 / tan(fov * Float.pi / 180 / 2)
		let aspect2 = aspect * aspect
		self.init(viewFactorX: f * sqrt(1 / aspect2 + 1), y: f * sqrt(aspect2 + 1), zFrom: znear, to: zfar)
	}
}

// Prespective extractors

extension Mat4x4 {
	public var leftPlane: Vec4 { return row4 + row1 }
	public var rightPlane: Vec4 { return row4 - row1 }
	public var bottomPlane: Vec4 { return row4 + row2 }
	public var topPlane: Vec4 { return row4 - row2 }
	public var nearPlane: Vec4 { return row4 + row3 }
	public var farPlane: Vec4 { return row4 + row3 }

	public var cameraPosition: Vec3 {
		let m = Mat4x3(row1: row1, row2: row2, row3: row4)
		return m.affineInverse.translation
 	}
}

// Protocol

public protocol MatProtocol {
	associatedtype V: VecProtocol

	static var one: Self { get }
	var isZero: Bool { get }
	func isAlmostZero(epsilon: Float) -> Bool

	subscript(index: (Int, Int)) -> Float { get }
	subscript(index: Int) -> V { get }

	static func ==(a: Self, b: Self) -> Bool

	static prefix func -(v: Self) -> Self
	static func +(a: Self, b: Self) -> Self
	static func -(a: Self, b: Self) -> Self
	static func *(a: Self, b: Float) -> Self
	static func *(a: Float, b: Self) -> Self
	static func /(a: Self, b: Float) -> Self
	static func /(a: Float, b: Self) -> Self

	static func *(a: Self, b: V) -> V
	static func *(a: Self, b: Self) -> Self

	var affineDeterminant: Float { get }
	var affineInverse: Self { get }
}

public protocol SquareMatProtocol: MatProtocol {
	var determinant: Float { get }
	var transpose: Self { get }
	var inverse: Self { get }
}

public func affineDeterminant<T: MatProtocol>(_ m: T) -> Float { return m.affineDeterminant }
public func affineInverse<T: MatProtocol>(_ m: T) -> T { return m.affineInverse }
public func determinant<T: SquareMatProtocol>(_ m: T) -> Float { return m.determinant }
public func transpose<T: SquareMatProtocol>(_ m: T) -> T { return m.transpose }
public func inverse<T: SquareMatProtocol>(_ m: T) -> T { return m.inverse }

extension Mat2x2: SquareMatProtocol { public typealias V = Vec2 }
extension Mat3x2: MatProtocol { public typealias V = Vec2 }
extension Mat3x3: SquareMatProtocol { public typealias V = Vec3 }
extension Mat4x3: MatProtocol { public typealias V = Vec3 }
extension Mat4x4: SquareMatProtocol { public typealias V = Vec4 }

extension Mat2x2 { public static var one: Mat2x2 { return Mat2x2(1, 0, 0, 1) } }
extension Mat3x2 { public static var one: Mat3x2 { return Mat3x2(1, 0, 0, 0, 1, 0) } }
extension Mat3x3 { public static var one: Mat3x3 { return Mat3x3(1, 0, 0, 0, 1, 0, 0, 0, 1) } }
extension Mat4x3 { public static var one: Mat4x3 { return Mat4x3(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0) } }
extension Mat4x4 { public static var one: Mat4x4 { return Mat4x4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1) } }

extension Mat2x2 { public var isZero: Bool { return m.0 == 0 && m.1 == 0 && m.2 == 0 && m.3 == 0 } }
extension Mat3x2 { public var isZero: Bool { return m.0 == 0 && m.1 == 0 && m.2 == 0 && m.3 == 0 && m.4 == 0 && m.5 == 0 } }
extension Mat3x3 { public var isZero: Bool { return m.0 == 0 && m.1 == 0 && m.2 == 0 && m.3 == 0 && m.4 == 0 && m.5 == 0 && m.6 == 0 && m.7 == 0 && m.8 == 0 } }
extension Mat4x3 { public var isZero: Bool { return m.0 == 0 && m.1 == 0 && m.2 == 0 && m.3 == 0 && m.4 == 0 && m.5 == 0 && m.6 == 0 && m.7 == 0 && m.8 == 0 && m.9 == 0 && m.10 == 0 && m.11 == 0 } }
extension Mat4x4 { public var isZero: Bool { return m.0 == 0 && m.1 == 0 && m.2 == 0 && m.3 == 0 && m.4 == 0 && m.5 == 0 && m.6 == 0 && m.7 == 0 && m.8 == 0 && m.9 == 0 && m.10 == 0 && m.11 == 0 && m.12 == 0 && m.13 == 0 && m.14 == 0 && m.15 == 0 } }

extension Mat2x2 { public func isAlmostZero(epsilon: Float) -> Bool { return abs(m.0) < epsilon && abs(m.1) < epsilon && abs(m.2) < epsilon && abs(m.3) < epsilon } }
extension Mat3x2 { public func isAlmostZero(epsilon: Float) -> Bool { return abs(m.0) < epsilon && abs(m.1) < epsilon && abs(m.2) < epsilon && abs(m.3) < epsilon && abs(m.4) < epsilon && abs(m.5) < epsilon } }
extension Mat3x3 { public func isAlmostZero(epsilon: Float) -> Bool { return abs(m.0) < epsilon && abs(m.1) < epsilon && abs(m.2) < epsilon && abs(m.3) < epsilon && abs(m.4) < epsilon && abs(m.5) < epsilon && abs(m.6) < epsilon && abs(m.7) < epsilon && abs(m.8) < epsilon } }
extension Mat4x3 { public func isAlmostZero(epsilon: Float) -> Bool { return abs(m.0) < epsilon && abs(m.1) < epsilon && abs(m.2) < epsilon && abs(m.3) < epsilon && abs(m.4) < epsilon && abs(m.5) < epsilon && abs(m.6) < epsilon && abs(m.7) < epsilon && abs(m.8) < epsilon && abs(m.9) < epsilon && abs(m.10) < epsilon && abs(m.11) < epsilon } }
extension Mat4x4 { public func isAlmostZero(epsilon: Float) -> Bool { return abs(m.0) < epsilon && abs(m.1) < epsilon && abs(m.2) < epsilon && abs(m.3) < epsilon && abs(m.4) < epsilon && abs(m.5) < epsilon && abs(m.6) < epsilon && abs(m.7) < epsilon && abs(m.8) < epsilon && abs(m.9) < epsilon && abs(m.10) < epsilon && abs(m.11) < epsilon && abs(m.12) < epsilon && abs(m.13) < epsilon && abs(m.14) < epsilon && abs(m.15) < epsilon } }

// Subscripting

extension Mat2x2 {
	public subscript(index: (Int, Int)) -> Float {
		switch index {
			case (1, 1): return m11
			case (2, 1): return m21
			case (1, 2): return m12
			case (2, 2): return m22
			default: fatalError()
		}
	}
}

extension Mat3x2 {
	public subscript(index: (Int, Int)) -> Float {
		switch index {
			case (1, 1): return m11
			case (2, 1): return m21
			case (1, 2): return m12
			case (2, 2): return m22
			case (1, 3): return m13
			case (2, 3): return m23
			default: fatalError()
		}
	}
}

extension Mat3x3 {
	public subscript(index: (Int, Int)) -> Float {
		switch index {
			case (1, 1): return m11
			case (2, 1): return m21
			case (3, 1): return m31
			case (1, 2): return m12
			case (2, 2): return m22
			case (3, 2): return m32
			case (1, 3): return m13
			case (2, 3): return m23
			case (3, 3): return m33
			default: fatalError()
		}
	}
}

extension Mat4x3 {
	public subscript(index: (Int, Int)) -> Float {
		switch index {
			case (1, 1): return m11
			case (2, 1): return m21
			case (3, 1): return m31
			case (1, 2): return m12
			case (2, 2): return m22
			case (3, 2): return m32
			case (1, 3): return m13
			case (2, 3): return m23
			case (3, 3): return m33
			case (1, 4): return m14
			case (2, 4): return m24
			case (3, 4): return m34
			default: fatalError()
		}
	}
}

extension Mat4x4 {
	public subscript(index: (Int, Int)) -> Float {
		switch index {
			case (1, 1): return m11
			case (2, 1): return m21
			case (3, 1): return m31
			case (4, 1): return m41
			case (1, 2): return m12
			case (2, 2): return m22
			case (3, 2): return m32
			case (4, 2): return m42
			case (1, 3): return m13
			case (2, 3): return m23
			case (3, 3): return m33
			case (4, 3): return m43
			case (1, 4): return m14
			case (2, 4): return m24
			case (3, 4): return m34
			case (4, 4): return m44
			default: fatalError()
		}
	}
}

extension Mat2x2 {
	public subscript(index: Int) -> Vec2 {
		switch index {
			case 1: return x
			case 2: return y
			default: fatalError()
		}
	}
}

extension Mat3x2 {
	public subscript(index: Int) -> Vec2 {
		switch index {
			case 1: return x
			case 2: return y
			case 3: return z
			default: fatalError()
		}
	}
}

extension Mat3x3 {
	public subscript(index: Int) -> Vec3 {
		switch index {
			case 1: return x
			case 2: return y
			case 3: return z
			default: fatalError()
		}
	}
}

extension Mat4x3 {
	public subscript(index: Int) -> Vec3 {
		switch index {
			case 1: return x
			case 2: return y
			case 3: return z
			case 4: return w
			default: fatalError()
		}
	}
}

extension Mat4x4 {
	public subscript(index: Int) -> Vec4 {
		switch index {
			case 1: return x
			case 2: return y
			case 3: return z
			case 4: return w
			default: fatalError()
		}
	}
}

// Operators

public func ==(a: Mat2x2, b: Mat2x2) -> Bool { return a.m.0 == b.m.0 && a.m.1 == b.m.1 && a.m.2 == b.m.2 && a.m.3 == b.m.3 }
public func ==(a: Mat3x2, b: Mat3x2) -> Bool { return a.m.0 == b.m.0 && a.m.1 == b.m.1 && a.m.2 == b.m.2 && a.m.3 == b.m.3 && a.m.4 == b.m.4 && a.m.5 == b.m.5 }
public func ==(a: Mat3x3, b: Mat3x3) -> Bool { return a.m.0 == b.m.0 && a.m.1 == b.m.1 && a.m.2 == b.m.2 && a.m.3 == b.m.3 && a.m.4 == b.m.4 && a.m.5 == b.m.5 && a.m.6 == b.m.6 && a.m.7 == b.m.7 && a.m.8 == b.m.8 }
public func ==(a: Mat4x3, b: Mat4x3) -> Bool { return a.m.0 == b.m.0 && a.m.1 == b.m.1 && a.m.2 == b.m.2 && a.m.3 == b.m.3 && a.m.4 == b.m.4 && a.m.5 == b.m.5 && a.m.6 == b.m.6 && a.m.7 == b.m.7 && a.m.8 == b.m.8 && a.m.9 == b.m.9 && a.m.10 == b.m.10 && a.m.11 == b.m.11 }
public func ==(a: Mat4x4, b: Mat4x4) -> Bool { return a.m.0 == b.m.0 && a.m.1 == b.m.1 && a.m.2 == b.m.2 && a.m.3 == b.m.3 && a.m.4 == b.m.4 && a.m.5 == b.m.5 && a.m.6 == b.m.6 && a.m.7 == b.m.7 && a.m.8 == b.m.8 && a.m.9 == b.m.9 && a.m.10 == b.m.10 && a.m.11 == b.m.11 && a.m.12 == b.m.12 && a.m.13 == b.m.13 && a.m.14 == b.m.14 && a.m.15 == b.m.15 }

/*private public func isAlmostEqual(a: Float, _ b: Float, _ epsilon: Float) -> Bool { return abs(a - b) < epsilon }
public func isAlmostEqual(a: Vec2, _ b: Vec2, _ epsilon: Float) -> Bool { return abs(a.x - b.x) < epsilon && abs(a.y - b.y) < epsilon }
public func isAlmostEqual(a: Vec3, _ b: Vec3, _ epsilon: Float) -> Bool { return abs(a.x - b.x) < epsilon && abs(a.y - b.y) < epsilon && abs(a.z - b.z) < epsilon }
public func isAlmostEqual(a: Vec4, _ b: Vec4, _ epsilon: Float) -> Bool { return abs(a.x - b.x) < epsilon && abs(a.y - b.y) < epsilon && abs(a.z - b.z) < epsilon && abs(a.w - b.w) < epsilon }
*/

prefix public func -(a: Mat2x2) -> Mat2x2 {
	return Mat2x2(-a.m11, -a.m12,
	              -a.m21, -a.m22)
}
prefix public func -(a: Mat3x2) -> Mat3x2 {
	return Mat3x2(-a.m11, -a.m12, -a.m13,
	              -a.m21, -a.m22, -a.m23)
}
prefix public func -(a: Mat3x3) -> Mat3x3 {
	return Mat3x3(-a.m11, -a.m12, -a.m13,
	              -a.m21, -a.m22, -a.m23,
				  -a.m31, -a.m32, -a.m33)
}
prefix public func -(a: Mat4x3) -> Mat4x3 {
	return Mat4x3(-a.m11, -a.m12, -a.m13, -a.m14,
	              -a.m21, -a.m22, -a.m23, -a.m24,
				  -a.m31, -a.m32, -a.m33, -a.m34)
}
prefix public func -(a: Mat4x4) -> Mat4x4 {
	return Mat4x4(-a.m11, -a.m12, -a.m13, -a.m14,
	              -a.m21, -a.m22, -a.m23, -a.m24,
				  -a.m31, -a.m32, -a.m33, -a.m34,
				  -a.m41, -a.m42, -a.m43, -a.m44)
}

public func +(a: Mat2x2, b: Mat2x2) -> Mat2x2 {
	return Mat2x2(a.m11 + b.m11, a.m12 + b.m12,
	              a.m21 + b.m21, a.m22 + b.m22)
}
public func +(a: Mat3x2, b: Mat3x2) -> Mat3x2 {
	return Mat3x2(a.m11 + b.m11, a.m12 + b.m12, a.m13 + b.m13,
	              a.m21 + b.m21, a.m22 + b.m22, a.m23 + b.m23)
}
public func +(a: Mat3x3, b: Mat3x3) -> Mat3x3 {
	return Mat3x3(a.m11 + b.m11, a.m12 + b.m12, a.m13 + b.m13,
	              a.m21 + b.m21, a.m22 + b.m22, a.m23 + b.m23,
				  a.m31 + b.m31, a.m32 + b.m32, a.m33 + b.m33)
}
public func +(a: Mat4x3, b: Mat4x3) -> Mat4x3 {
	return Mat4x3(a.m11 + b.m11, a.m12 + b.m12, a.m13 + b.m13, a.m14 + b.m14,
	              a.m21 + b.m21, a.m22 + b.m22, a.m23 + b.m23, a.m24 + b.m24,
				  a.m31 + b.m31, a.m32 + b.m32, a.m33 + b.m33, a.m34 + b.m34)
}
public func +(a: Mat4x4, b: Mat4x4) -> Mat4x4 {
	return Mat4x4(a.m11 + b.m11, a.m12 + b.m12, a.m13 + b.m13, a.m14 + b.m14,
	              a.m21 + b.m21, a.m22 + b.m22, a.m23 + b.m23, a.m24 + b.m24,
				  a.m31 + b.m31, a.m32 + b.m32, a.m33 + b.m33, a.m34 + b.m34,
				  a.m41 + b.m41, a.m42 + b.m42, a.m43 + b.m43, a.m44 + b.m44)
}

public func -(a: Mat2x2, b: Mat2x2) -> Mat2x2 {
	return Mat2x2(a.m11 - b.m11, a.m12 - b.m12,
	              a.m21 - b.m21, a.m22 - b.m22)
}
public func -(a: Mat3x2, b: Mat3x2) -> Mat3x2 {
	return Mat3x2(a.m11 - b.m11, a.m12 - b.m12, a.m13 - b.m13,
	              a.m21 - b.m21, a.m22 - b.m22, a.m23 - b.m23)
}
public func -(a: Mat3x3, b: Mat3x3) -> Mat3x3 {
	return Mat3x3(a.m11 - b.m11, a.m12 - b.m12, a.m13 - b.m13,
	              a.m21 - b.m21, a.m22 - b.m22, a.m23 - b.m23,
				  a.m31 - b.m31, a.m32 - b.m32, a.m33 - b.m33)
}
public func -(a: Mat4x3, b: Mat4x3) -> Mat4x3 {
	return Mat4x3(a.m11 - b.m11, a.m12 - b.m12, a.m13 - b.m13, a.m14 - b.m14,
	              a.m21 - b.m21, a.m22 - b.m22, a.m23 - b.m23, a.m24 - b.m24,
				  a.m31 - b.m31, a.m32 - b.m32, a.m33 - b.m33, a.m34 - b.m34)
}
public func -(a: Mat4x4, b: Mat4x4) -> Mat4x4 {
	return Mat4x4(a.m11 - b.m11, a.m12 - b.m12, a.m13 - b.m13, a.m14 - b.m14,
	              a.m21 - b.m21, a.m22 - b.m22, a.m23 - b.m23, a.m24 - b.m24,
				  a.m31 - b.m31, a.m32 - b.m32, a.m33 - b.m33, a.m34 - b.m34,
				  a.m41 - b.m41, a.m42 - b.m42, a.m43 - b.m43, a.m44 - b.m44)
}

public func *(a: Mat2x2, b: Float) -> Mat2x2 {
	return Mat2x2(a.m11 * b, a.m12 * b,
	              a.m21 * b, a.m22 * b)
}
public func *(a: Mat3x2, b: Float) -> Mat3x2 {
	return Mat3x2(a.m11 * b, a.m12 * b, a.m13 * b,
	              a.m21 * b, a.m22 * b, a.m23 * b)
}
public func *(a: Mat3x3, b: Float) -> Mat3x3 {
	return Mat3x3(a.m11 * b, a.m12 * b, a.m13 * b,
	              a.m21 * b, a.m22 * b, a.m23 * b,
				  a.m31 * b, a.m32 * b, a.m33 * b)
}
public func *(a: Mat4x3, b: Float) -> Mat4x3 {
	return Mat4x3(a.m11 * b, a.m12 * b, a.m13 * b, a.m14 * b,
	              a.m21 * b, a.m22 * b, a.m23 * b, a.m24 * b,
				  a.m31 * b, a.m32 * b, a.m33 * b, a.m34 * b)
}
public func *(a: Mat4x4, b: Float) -> Mat4x4 {
	return Mat4x4(a.m11 * b, a.m12 * b, a.m13 * b, a.m14 * b,
	              a.m21 * b, a.m22 * b, a.m23 * b, a.m24 * b,
				  a.m31 * b, a.m32 * b, a.m33 * b, a.m34 * b,
				  a.m41 * b, a.m42 * b, a.m43 * b, a.m44 * b)
}

public func *(a: Float, b: Mat2x2) -> Mat2x2 {
	return Mat2x2(a * b.m11, a * b.m12,
	              a * b.m21, a * b.m22)
}
public func *(a: Float, b: Mat3x2) -> Mat3x2 {
	return Mat3x2(a * b.m11, a * b.m12, a * b.m13,
	              a * b.m21, a * b.m22, a * b.m23)
}
public func *(a: Float, b: Mat3x3) -> Mat3x3 {
	return Mat3x3(a * b.m11, a * b.m12, a * b.m13,
	              a * b.m21, a * b.m22, a * b.m23,
				  a * b.m31, a * b.m32, a * b.m33)
}
public func *(a: Float, b: Mat4x3) -> Mat4x3 {
	return Mat4x3(a * b.m11, a * b.m12, a * b.m13, a * b.m14,
	              a * b.m21, a * b.m22, a * b.m23, a * b.m24,
				  a * b.m31, a * b.m32, a * b.m33, a * b.m34)
}
public func *(a: Float, b: Mat4x4) -> Mat4x4 {
	return Mat4x4(a * b.m11, a * b.m12, a * b.m13, a * b.m14,
	              a * b.m21, a * b.m22, a * b.m23, a * b.m24,
				  a * b.m31, a * b.m32, a * b.m33, a * b.m34,
				  a * b.m41, a * b.m42, a * b.m43, a * b.m44)
}

public func /(a: Mat2x2, b: Float) -> Mat2x2 {
	return Mat2x2(a.m11 / b, a.m12 / b,
	              a.m21 / b, a.m22 / b)
}
public func /(a: Mat3x2, b: Float) -> Mat3x2 {
	return Mat3x2(a.m11 / b, a.m12 / b, a.m13 / b,
	              a.m21 / b, a.m22 / b, a.m23 / b)
}
public func /(a: Mat3x3, b: Float) -> Mat3x3 {
	return Mat3x3(a.m11 / b, a.m12 / b, a.m13 / b,
	              a.m21 / b, a.m22 / b, a.m23 / b,
				  a.m31 / b, a.m32 / b, a.m33 / b)
}
public func /(a: Mat4x3, b: Float) -> Mat4x3 {
	return Mat4x3(a.m11 / b, a.m12 / b, a.m13 / b, a.m14 / b,
	              a.m21 / b, a.m22 / b, a.m23 / b, a.m24 / b,
				  a.m31 / b, a.m32 / b, a.m33 / b, a.m34 / b)
}
public func /(a: Mat4x4, b: Float) -> Mat4x4 {
	return Mat4x4(a.m11 / b, a.m12 / b, a.m13 / b, a.m14 / b,
	              a.m21 / b, a.m22 / b, a.m23 / b, a.m24 / b,
				  a.m31 / b, a.m32 / b, a.m33 / b, a.m34 / b,
				  a.m41 / b, a.m42 / b, a.m43 / b, a.m44 / b)
}

public func /(a: Float, b: Mat2x2) -> Mat2x2 {
	return Mat2x2(a / b.m11, a / b.m12,
	              a / b.m21, a / b.m22)
}
public func /(a: Float, b: Mat3x2) -> Mat3x2 {
	return Mat3x2(a / b.m11, a / b.m12, a / b.m13,
	              a / b.m21, a / b.m22, a / b.m23)
}
public func /(a: Float, b: Mat3x3) -> Mat3x3 {
	return Mat3x3(a / b.m11, a / b.m12, a / b.m13,
	              a / b.m21, a / b.m22, a / b.m23,
				  a / b.m31, a / b.m32, a / b.m33)
}
public func /(a: Float, b: Mat4x3) -> Mat4x3 {
	return Mat4x3(a / b.m11, a / b.m12, a / b.m13, a / b.m14,
	              a / b.m21, a / b.m22, a / b.m23, a / b.m24,
				  a / b.m31, a / b.m32, a / b.m33, a / b.m34)
}
public func /(a: Float, b: Mat4x4) -> Mat4x4 {
	return Mat4x4(a / b.m11, a / b.m12, a / b.m13, a / b.m14,
	              a / b.m21, a / b.m22, a / b.m23, a / b.m24,
				  a / b.m31, a / b.m32, a / b.m33, a / b.m34,
				  a / b.m41, a / b.m42, a / b.m43, a / b.m44)
}

// Vector transformation

public func *(m: Mat2x2, v: Vec2) -> Vec2 {
	return Vec2(x: v.x * m.m11 + v.y * m.m12,
	            y: v.x * m.m21 + v.y * m.m22)
}

public func *(m: Mat3x2, v: Vec2) -> Vec2 {
	return Vec2(x: v.x * m.m11 + v.y * m.m12 + m.m13,
	            y: v.x * m.m21 + v.y * m.m22 + m.m23)
}

public func *(m: Mat3x3, v: Vec3) -> Vec3 {
	return Vec3(x: v.x * m.m11 + v.y * m.m12 + v.z * m.m13,
	            y: v.x * m.m21 + v.y * m.m22 + v.z * m.m23,
	            z: v.x * m.m31 + v.y * m.m32 + v.z * m.m33)
}

public func *(m: Mat4x3, v: Vec3) -> Vec3 {
	return Vec3(x: v.x * m.m11 + v.y * m.m12 + v.z * m.m13 + m.m14,
	            y: v.x * m.m21 + v.y * m.m22 + v.z * m.m23 + m.m24,
	            z: v.x * m.m31 + v.y * m.m32 + v.z * m.m33 + m.m34)
}

public func *(m: Mat4x4, v: Vec4) -> Vec4 {
	return Vec4(x: v.x * m.m11 + v.y * m.m12 + v.z * m.m13 + v.w * m.m14,
	            y: v.x * m.m21 + v.y * m.m22 + v.z * m.m23 + v.w * m.m24,
	            z: v.x * m.m31 + v.y * m.m32 + v.z * m.m33 + v.w * m.m34,
	            w: v.x * m.m41 + v.y * m.m42 + v.z * m.m43 + v.w * m.m44)
}

// Homogenous vector transformation

public func *(m: Mat3x3, v: Vec2) -> Vec2 {
	let x = v.x * m.m11 + v.y * m.m12 + m.m13
	let y = v.x * m.m21 + v.y * m.m22 + m.m23
	let z = v.x * m.m31 + v.y * m.m32 + m.m33
	return Vec2(x: x / z, y: y / z)
}

public func *(m: Mat4x4, v: Vec3) -> Vec3 {
	let x = v.x * m.m11 + v.y * m.m12 + v.z * m.m13 + m.m14
	let y = v.x * m.m21 + v.y * m.m22 + v.z * m.m23 + m.m24
	let z = v.x * m.m31 + v.y * m.m32 + v.z * m.m33 + m.m34
	let w = v.x * m.m41 + v.y * m.m42 + v.z * m.m43 + m.m44
	return Vec3(x: x / w, y: y / w, z: z / w)
}

// Matrix multiplication

public func *(a: Mat2x2, b: Mat2x2) -> Mat2x2 {
	return Mat2x2(a.m11 * b.m11 + a.m12 * b.m21,
	              a.m11 * b.m12 + a.m12 * b.m22,

	              a.m21 * b.m11 + a.m22 * b.m21,
	              a.m21 * b.m12 + a.m22 * b.m22)
}

public func *(a: Mat3x2, b: Mat3x2) -> Mat3x2 {
	return Mat3x2(a.m11 * b.m11 + a.m12 * b.m21,
	              a.m11 * b.m12 + a.m12 * b.m22,
	              a.m11 * b.m13 + a.m12 * b.m23 + a.m13,

	              a.m21 * b.m11 + a.m22 * b.m21,
	              a.m21 * b.m12 + a.m22 * b.m22,
	              a.m21 * b.m13 + a.m22 * b.m23 + a.m23)
}


public func *(a: Mat3x3, b: Mat3x3) -> Mat3x3 {
	return Mat3x3(a.m11 * b.m11 + a.m12 * b.m21 + a.m13 * b.m31,
	              a.m11 * b.m12 + a.m12 * b.m22 + a.m13 * b.m32,
	              a.m11 * b.m13 + a.m12 * b.m23 + a.m13 * b.m33,

	              a.m21 * b.m11 + a.m22 * b.m21 + a.m23 * b.m31,
	              a.m21 * b.m12 + a.m22 * b.m22 + a.m23 * b.m32,
	              a.m21 * b.m13 + a.m22 * b.m23 + a.m23 * b.m33,

	              a.m31 * b.m11 + a.m32 * b.m21 + a.m33 * b.m31,
	              a.m31 * b.m12 + a.m32 * b.m22 + a.m33 * b.m32,
	              a.m31 * b.m13 + a.m32 * b.m23 + a.m33 * b.m33)
}

public func *(a: Mat4x3, b: Mat4x3) -> Mat4x3 {
	return Mat4x3(a.m11 * b.m11 + a.m12 * b.m21 + a.m13 * b.m31,
	              a.m11 * b.m12 + a.m12 * b.m22 + a.m13 * b.m32,
	              a.m11 * b.m13 + a.m12 * b.m23 + a.m13 * b.m33,
	              a.m11 * b.m14 + a.m12 * b.m24 + a.m13 * b.m34 + a.m14,

	              a.m21 * b.m11 + a.m22 * b.m21 + a.m23 * b.m31,
	              a.m21 * b.m12 + a.m22 * b.m22 + a.m23 * b.m32,
	              a.m21 * b.m13 + a.m22 * b.m23 + a.m23 * b.m33,
	              a.m21 * b.m14 + a.m22 * b.m24 + a.m23 * b.m34 + a.m24,

	              a.m31 * b.m11 + a.m32 * b.m21 + a.m33 * b.m31,
	              a.m31 * b.m12 + a.m32 * b.m22 + a.m33 * b.m32,
	              a.m31 * b.m13 + a.m32 * b.m23 + a.m33 * b.m33,
	              a.m31 * b.m14 + a.m32 * b.m24 + a.m33 * b.m34 + a.m34)
}

public func *(a: Mat4x4, b: Mat4x4) -> Mat4x4 {
	return Mat4x4(a.m11 * b.m11 + a.m12 * b.m21 + a.m13 * b.m31 + a.m14 * b.m41,
	              a.m11 * b.m12 + a.m12 * b.m22 + a.m13 * b.m32 + a.m14 * b.m42,
	              a.m11 * b.m13 + a.m12 * b.m23 + a.m13 * b.m33 + a.m14 * b.m43,
	              a.m11 * b.m14 + a.m12 * b.m24 + a.m13 * b.m34 + a.m14 * b.m44,

	              a.m21 * b.m11 + a.m22 * b.m21 + a.m23 * b.m31 + a.m24 * b.m41,
	              a.m21 * b.m12 + a.m22 * b.m22 + a.m23 * b.m32 + a.m24 * b.m42,
	              a.m21 * b.m13 + a.m22 * b.m23 + a.m23 * b.m33 + a.m24 * b.m43,
	              a.m21 * b.m14 + a.m22 * b.m24 + a.m23 * b.m34 + a.m24 * b.m44,

	              a.m31 * b.m11 + a.m32 * b.m21 + a.m33 * b.m31 + a.m34 * b.m41,
	              a.m31 * b.m12 + a.m32 * b.m22 + a.m33 * b.m32 + a.m34 * b.m42,
	              a.m31 * b.m13 + a.m32 * b.m23 + a.m33 * b.m33 + a.m34 * b.m43,
	              a.m31 * b.m14 + a.m32 * b.m24 + a.m33 * b.m34 + a.m34 * b.m44,

	              a.m41 * b.m11 + a.m42 * b.m21 + a.m43 * b.m31 + a.m44 * b.m41,
	              a.m41 * b.m12 + a.m42 * b.m22 + a.m43 * b.m32 + a.m44 * b.m42,
	              a.m41 * b.m13 + a.m42 * b.m23 + a.m43 * b.m33 + a.m44 * b.m43,
	              a.m41 * b.m14 + a.m42 * b.m24 + a.m43 * b.m34 + a.m44 * b.m44)
}

public func +=(a: inout Mat2x2, b: Mat2x2) { a = a + b }
public func +=(a: inout Mat3x2, b: Mat3x2) { a = a + b }
public func +=(a: inout Mat3x3, b: Mat3x3) { a = a + b }
public func +=(a: inout Mat4x3, b: Mat4x3) { a = a + b }
public func +=(a: inout Mat4x4, b: Mat4x4) { a = a + b }

public func -=(a: inout Mat2x2, b: Mat2x2) { a = a - b }
public func -=(a: inout Mat3x2, b: Mat3x2) { a = a - b }
public func -=(a: inout Mat3x3, b: Mat3x3) { a = a - b }
public func -=(a: inout Mat4x3, b: Mat4x3) { a = a - b }
public func -=(a: inout Mat4x4, b: Mat4x4) { a = a - b }

public func *=(a: inout Mat2x2, b: Float) { a = a * b }
public func *=(a: inout Mat3x2, b: Float) { a = a * b }
public func *=(a: inout Mat3x3, b: Float) { a = a * b }
public func *=(a: inout Mat4x3, b: Float) { a = a * b }
public func *=(a: inout Mat4x4, b: Float) { a = a * b }

public func /=(a: inout Mat2x2, b: Float) { a = a / b }
public func /=(a: inout Mat3x2, b: Float) { a = a / b }
public func /=(a: inout Mat3x3, b: Float) { a = a / b }
public func /=(a: inout Mat4x3, b: Float) { a = a / b }
public func /=(a: inout Mat4x4, b: Float) { a = a / b }

public func *=(a: inout Mat2x2, b: Mat2x2) { a = a * b }
public func *=(a: inout Mat3x2, b: Mat3x2) { a = a * b }
public func *=(a: inout Mat3x3, b: Mat3x3) { a = a * b }
public func *=(a: inout Mat4x3, b: Mat4x3) { a = a * b }
public func *=(a: inout Mat4x4, b: Mat4x4) { a = a * b }

public func affineMul(_ a: Mat3x3, _ b: Mat3x3) -> Mat3x3 {
	return Mat3x3(a.m11 * b.m11 + a.m12 * b.m21,
	              a.m11 * b.m12 + a.m12 * b.m22,
	              a.m11 * b.m13 + a.m12 * b.m23 + a.m13,

	              a.m21 * b.m11 + a.m22 * b.m21,
	              a.m21 * b.m12 + a.m22 * b.m22,
	              a.m21 * b.m13 + a.m22 * b.m23 + a.m23,

	              0, 0, 1)
}

public func affineMul(_ a: Mat4x4, _ b: Mat4x4) -> Mat4x4 {
	return Mat4x4(a.m11 * b.m11 + a.m12 * b.m21 + a.m13 * b.m31,
	              a.m11 * b.m12 + a.m12 * b.m22 + a.m13 * b.m32,
	              a.m11 * b.m13 + a.m12 * b.m23 + a.m13 * b.m33,
	              a.m11 * b.m14 + a.m12 * b.m24 + a.m13 * b.m34 + a.m14,

	              a.m21 * b.m11 + a.m22 * b.m21 + a.m23 * b.m31,
	              a.m21 * b.m12 + a.m22 * b.m22 + a.m23 * b.m32,
	              a.m21 * b.m13 + a.m22 * b.m23 + a.m23 * b.m33,
	              a.m21 * b.m14 + a.m22 * b.m24 + a.m23 * b.m34 + a.m24,

	              a.m31 * b.m11 + a.m32 * b.m21 + a.m33 * b.m31,
	              a.m31 * b.m12 + a.m32 * b.m22 + a.m33 * b.m32,
	              a.m31 * b.m13 + a.m32 * b.m23 + a.m33 * b.m33,
	              a.m31 * b.m14 + a.m32 * b.m24 + a.m33 * b.m34 + a.m34,

	              0, 0, 0, 1)
}

// Determinant

extension Mat2x2 {
	public var affineDeterminant: Float { fatalError() }

	public var determinant: Float {
		return m11 * m22 - m21 * m12
	}
}

extension Mat3x2 {
	public var affineDeterminant: Float { return linearTransform.determinant }
}

extension Mat3x3 {
	public var affineDeterminant: Float { return linearTransform.determinant }

	public var determinant: Float {
		return m11 * m22 * m33 +
		      -m11 * m32 * m23 +
		       m21 * m32 * m13 +
		      -m21 * m12 * m33 +
		       m31 * m12 * m23 +
		      -m31 * m22 * m13
	}
}

extension Mat4x3 {
	public var affineDeterminant: Float { return linearTransform.determinant }
}

extension Mat4x4 {
	public var affineDeterminant: Float { return linearTransform.determinant }

	public var determinant: Float {
		let a0 = m11 * m22 - m21 * m12
		let a1 = m11 * m32 - m31 * m12
		let a2 = m11 * m42 - m41 * m12
		let a3 = m21 * m32 - m31 * m22
		let a4 = m21 * m42 - m41 * m22
		let a5 = m31 * m42 - m41 * m32
		let b0 = m13 * m24 - m23 * m14
		let b1 = m13 * m34 - m33 * m14
		let b2 = m13 * m44 - m43 * m14
		let b3 = m23 * m34 - m33 * m24
		let b4 = m23 * m44 - m43 * m24
		let b5 = m33 * m44 - m43 * m34
		return a0 * b5 - a1 * b4 + a2 * b3 + a3 * b2 - a4 * b1 + a5 * b0
	}
}

// Transpose

extension Mat2x2 { public var transpose: Mat2x2 { return Mat2x2(x: row1, y: row2) } }
extension Mat3x3 { public var transpose: Mat3x3 { return Mat3x3(x: row1, y: row2, z: row3) } }
extension Mat4x4 { public var transpose: Mat4x4 { return Mat4x4(x: row1, y: row2, z: row3, w: row4) } }

// Inverse

extension Mat2x2 {
	public var affineInverse: Mat2x2 { fatalError() }

	public var inverse: Mat2x2 {
		return Mat2x2(m22, -m12,
		             -m21,  m11) / determinant // singular if == 0
	}
}

extension Mat3x2 {
	public var affineInverse: Mat3x2 {
		let inv = linearTransform.inverse
		return Mat3x2(linearTransform: inv, translation: -(inv * z))
	}
}

extension Mat3x3 {
	public var affineInverse: Mat3x3 {
		let inv = linearTransform.inverse
		return Mat3x3(linearTransform: inv, translation: -(inv * z.xy))
	}

	public var inverse: Mat3x3 {
		return Mat3x3(m.4 * m.8 - m.5 * m.7,
		             -m.3 * m.8 + m.5 * m.6,
		              m.3 * m.7 - m.4 * m.6,

		             -m.1 * m.8 + m.2 * m.7,
		              m.0 * m.8 - m.2 * m.6,
		             -m.0 * m.7 + m.1 * m.6,

		              m.1 * m.5 - m.2 * m.4,
		             -m.0 * m.5 + m.2 * m.3,
		              m.0 * m.4 - m.1 * m.3) / determinant // singular if == 0
	}
}

extension Mat4x3 {
	public var affineInverse: Mat4x3 {
		let inv = linearTransform.inverse
		return Mat4x3(linearTransform: inv, translation: -(inv * w))
	}
}

extension Mat4x4 {
	public var affineInverse: Mat4x4 {
		let inv = linearTransform.inverse
		return Mat4x4(linearTransform: inv, translation: -(inv * w.xyz))
	}

	public var inverse: Mat4x4 {
		let a0 = m11 * m22 - m21 * m12
		let a1 = m11 * m32 - m31 * m12
		let a2 = m11 * m42 - m41 * m12
		let a3 = m21 * m32 - m31 * m22
		let a4 = m21 * m42 - m41 * m22
		let a5 = m31 * m42 - m41 * m32
		let b0 = m13 * m24 - m23 * m14
		let b1 = m13 * m34 - m33 * m14
		let b2 = m13 * m44 - m43 * m14
		let b3 = m23 * m34 - m33 * m24
		let b4 = m23 * m44 - m43 * m24
		let b5 = m33 * m44 - m43 * m34
		let det = a0 * b5 - a1 * b4 + a2 * b3 + a3 * b2 - a4 * b1 + a5 * b0

		// Singular if det == 0
		return Mat4x4(m22 * b5 - m32 * b4 + m42 * b3,
		             -m12 * b5 + m32 * b2 - m42 * b1,
		              m12 * b4 - m22 * b2 + m42 * b0,
		             -m12 * b3 + m22 * b1 - m32 * b0,

		             -m21 * b5 + m31 * b4 - m41 * b3,
		              m11 * b5 - m31 * b2 + m41 * b1,
		             -m11 * b4 + m21 * b2 - m41 * b0,
		              m11 * b3 - m21 * b1 + m31 * b0,

		              m24 * a5 - m34 * a4 + m44 * a3,
		             -m14 * a5 + m34 * a2 - m44 * a1,
		              m14 * a4 - m24 * a2 + m44 * a0,
		             -m14 * a3 + m24 * a1 - m34 * a0,

		             -m23 * a5 + m33 * a4 - m43 * a3,
		              m13 * a5 - m33 * a2 + m43 * a1,
		             -m13 * a4 + m23 * a2 - m43 * a0,
		              m13 * a3 - m23 * a1 + m33 * a0) / det
	}
}
