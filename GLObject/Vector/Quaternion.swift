import Foundation

// Definitions

#if VectorLibraryCInterop

public typealias Quat = quat_t

#else

public struct Quat: Equatable, Hashable, Codable {
	public var r: Float
	public var i: Vec3

	public init(r: Float, i: Vec3) {
		self.r = r
		self.i = i
	}
}

#endif

// Constructors

extension Quat {
	private init(_ q: Quat) {
		self = q
	}

	#if VectorLibraryCInterop
	public init(r: Float, i: Vec3) {
		self.init()
		self.r = r
		self.i = i
	}
	#endif

	public init(r: Float, ix: Float, iy: Float, iz: Float) { self.init(r: r, i: Vec3(x: ix, y: iy, z: iz)) }
	public init(r: Float) { self.init(r: r, i: Vec3.zero) }
	public init(i: Vec3) { self.init(r: 0, i: i) }

	public init(angle: Float, axis: Vec3) {
		self.init(r: cos(angle / 2), i: axis.with(length: sin(angle / 2)))
	}

	public init(rotatingFrom from: Vec3, to: Vec3) {
		let fromLength: Float = from.length
		let toLength: Float = to.length
		let half: Vec3 = ((from / fromLength) as Vec3 + (to / toLength) as Vec3) / Float(2)
		let halfLength: Float = half.length
		self.init(
			r: dot(from, half) / (fromLength * halfLength),
			i: cross(from, half) / (fromLength * halfLength)
		)
	}

	public init(_ m: Mat3x3) {
		if m.m11 > m.m22 && m.m11 > m.m33 {
			let r = sqrt(1 + m.m11 - m.m22 - m.m33)
			if r == 0 {
				self.init(Quat.one)
			} else {
				self.init(r: (m.m32 - m.m23) / (2 * r),
				          ix: r / 2,
				          iy: (m.m12 + m.m21) / (2 * r),
				          iz: (m.m31 + m.m13) / (2 * r))
			}
		} else if m.m22 > m.m11 && m.m22 > m.m33 {
			let r = sqrt(1 + m.m22 - m.m33 - m.m11)
			if r == 0 {
				self.init(Quat.one)
			} else {
				self.init(r: (m.m13 - m.m31) / (2 * r),
				          ix: (m.m12 + m.m21) / (2 * r),
				          iy: r / 2,
				          iz: (m.m23 + m.m32) / (2 * r))
			}
		} else {
			let r = sqrt(1 + m.m33 - m.m11 - m.m22)
			if r == 0 {
				self.init(Quat.one)
			} else {
				self.init(r: (m.m21 - m.m12) / (2 * r),
				          ix: (m.m31 + m.m13) / (2 * r),
				          iy: (m.m23 + m.m32) / (2 * r),
				          iz: r / 2)
			}
		}
	}

	public init(_ m: Mat4x3) { self.init(m.linearTransform) }
	public init(_ m: Mat4x4) { self.init(m.linearTransform) }

	public static let zero = Quat(r: 0)
	public static let one = Quat(r: 1)
}

// Extractors

extension Quat {
	public var ix: Float { return i.x }
	public var iy: Float { return i.y }
	public var iz: Float { return i.z }
}

// Description

extension Quat: CustomDebugStringConvertible { public var debugDescription: String { return "\(r) + \(i.x)i + \(i.y)j + \(i.z)k" } }

// Unary operations

extension Quat {
	public var square: Float { return dot(self, self) }
	public var length: Float { return sqrt(square) }
	public var conjugate: Quat { return Quat(r: r, i: -i) }
	public var inverse: Quat { return conjugate / square }
	public var normalised: Quat {
		let absValue = abs(self)
		guard absValue != 0 else { return Quat.zero }
		return self / absValue
	}
}

prefix public func -(q: Quat) -> Quat { return Quat(r: -q.r, i: -q.i) }
prefix public func ~(q: Quat) -> Quat { return q.conjugate }
public func dot(_ a: Quat, _ b: Quat) -> Float { return a • b }
public func abs(_ q: Quat) -> Float { return q.length }
public func normalise(_ q: Quat) -> Quat { return q.normalised }

// Comparison operations

public func ==(a: Quat, b: Quat) -> Bool { return a.r == b.r && a.i == b.i }
fileprivate func isAlmostEqual(_ a: Float, _ b: Float, _ epsilon: Float) -> Bool { return abs(a - b) < epsilon }
public func isAlmostEqual(_ a: Quat, _ b: Quat, _ epsilon: Float) -> Bool { return abs(a.r - b.r) < epsilon && abs(a.i - b.i) < epsilon }

// Arithmetic operations

public func +(a: Quat, b: Float) -> Quat { return Quat(r: a.r + b, i: a.i) }
public func +(a: Float, b: Quat) -> Quat { return Quat(r: a + b.r, i: b.i) }
public func +(a: Quat, b: Quat) -> Quat { return Quat(r: a.r + b.r, i: a.i + b.i) }
public func -(a: Quat, b: Float) -> Quat { return Quat(r: a.r - b, i: a.i) }
public func -(a: Float, b: Quat) -> Quat { return Quat(r: a - b.r, i: -b.i) }
public func -(a: Quat, b: Quat) -> Quat { return Quat(r: a.r - b.r, i: a.i - b.i) }
public func *(a: Quat, b: Float) -> Quat { return Quat(r: a.r * b, i: a.i * b) }
public func *(a: Float, b: Quat) -> Quat { return Quat(r: a * b.r, i: a * b.i) }
public func *(a: Quat, b: Quat) -> Quat { return Quat(r: (a.r * b.r) as Float - (a.i • b.i) as Float, i: (a.r * b.i) as Vec3 + (a.i * b.r) as Vec3 + (a.i ⨯ b.i) as Vec3) }
public func /(a: Quat, b: Float) -> Quat { return Quat(r: a.r / b, i: a.i / b) }
public func /(a: Float, b: Quat) -> Quat { return Quat(r: a) * b.inverse }
public func /(a: Quat, b: Quat) -> Quat { return a * b.inverse }
public func •(a: Quat, b: Quat) -> Float { return a.r * b.r + a.i • b.i }

public func +=(a: inout Quat, b: Float) { a = a + b }
public func +=(a: inout Quat, b: Quat) { a = a + b }
public func -=(a: inout Quat, b: Float) { a = a - b }
public func -=(a: inout Quat, b: Quat) { a = a - b }
public func *=(a: inout Quat, b: Float) { a = a * b }
public func *=(a: inout Quat, b: Quat) { a = a * b }
public func /=(a: inout Quat, b: Float) { a = a / b }
public func /=(a: inout Quat, b: Quat) { a = a / b }

// Blending

public func mix(_ a: Quat, _ b: Quat, _ x: Float) -> Quat { return a + (b - a) * x }

public func slerp(_ a: Quat, _ b: Quat, _ x: Float) -> Quat {
	var a2 = a
	var cos_angle = dot(a, b)
	if cos_angle < 0 {
		a2 = -a2
		cos_angle = -cos_angle
	}
	if cos_angle > 0.9999 {
		return mix(a, b, x).normalised
	}

	let angle = acos(cos_angle)
	let sin_angle = sin(angle)
	let aFactor = sinf((1 - x) * angle) / sin_angle
	let bFactor = sin(x * angle) / sin_angle
	return a2 * aFactor + b * bFactor
}

// Vector transformation

public func transform(_ q: Quat, _ v: Vec3) -> Vec3 {
	return (q * Quat(i: v) * ~q).i
}

// Matrix conversion

extension Mat3x3 {
	public init(_ q: Quat) {
		let s2 = q.r * q.r
		let x2 = q.i.x * q.i.x
		let y2 = q.i.y * q.i.y
		let z2 = q.i.z * q.i.z

		self.init(s2 + x2 - y2 - z2,
		          2 * (q.i.x * q.i.y - q.r * q.i.z),
	              2 * (q.i.x * q.i.z + q.r * q.i.y),

	              2 * (q.i.x * q.i.y + q.r * q.i.z),
	              s2 - x2 + y2 - z2,
	              2 * (q.i.y * q.i.z - q.r * q.i.x),

	              2 * (q.i.x * q.i.z - q.r * q.i.y),
	              2 * (q.i.y * q.i.z + q.r * q.i.x),
	              s2 - x2 - y2 + z2)
	}
}

extension Mat4x3 { public init(_ q: Quat) { self.init(Mat3x3(q)) } }
extension Mat4x4 { public init(_ q: Quat) { self.init(Mat3x3(q)) } }

extension Mat4x3 { public init(linearTransform q: Quat, translation: Vec3) { self.init(linearTransform: Mat3x3(q), translation: translation) } }
extension Mat4x4 { public init(linearTransform q: Quat, translation: Vec3) { self.init(linearTransform: Mat3x3(q), translation: translation) } }
