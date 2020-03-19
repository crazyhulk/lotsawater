import Foundation

// Definitions

#if VectorLibraryCInterop

public typealias Vec2 = vec2_t
public typealias Vec3 = vec3_t
public typealias Vec4 = vec4_t

#else

public struct Vec2: Equatable, Hashable, Codable { public var x: Float, y: Float; public init(x: Float, y: Float) { self.x = x; self.y = y } }
public struct Vec3: Equatable, Hashable, Codable { public var x: Float, y: Float, z: Float; public init(x: Float, y: Float, z: Float) { self.x = x; self.y = y; self.z = z } }
public struct Vec4: Equatable, Hashable, Codable { public var x: Float, y: Float, z: Float, w: Float; public init(x: Float, y: Float, z: Float, w: Float) { self.x = x; self.y = y; self.z = z; self.w = w } }

#endif

// Constructors

extension Vec2 {
	public init(r: Float, angle: Float) {
		self.init(x: r * cos(angle), y: r * sin(angle))
	}
}

extension Vec4 {
	public init(vec3 v: Vec3) {
		self.init(x: v.x, y: v.y, z: v.z, w: 1)
	}
}

extension Vec2 { public init(x: Double, y: Double) { self.init(x: Float(x), y: Float(y)) } }
extension Vec3 { public init(x: Double, y: Double, z: Double) { self.init(x: Float(x), y: Float(y), z: Float(z)) } }
extension Vec4 { public init(x: Double, y: Double, z: Double, w: Double) { self.init(x: Float(x), y: Float(y), z: Float(z), w: Float(w)) } }

extension Vec2 { public init(x: Int, y: Int) { self.init(x: Float(x), y: Float(y)) } }
extension Vec3 { public init(x: Int, y: Int, z: Int) { self.init(x: Float(x), y: Float(y), z: Float(z)) } }
extension Vec4 { public init(x: Int, y: Int, z: Int, w: Int) { self.init(x: Float(x), y: Float(y), z: Float(z), w: Float(w)) } }

extension Vec2 { public init(_ x: Float, _ y: Float) { self.init(x: x, y: y) } }
extension Vec3 { public init(_ x: Float, _ y: Float, _ z: Float) { self.init(x: x, y: y, z: z) } }
extension Vec4 { public init(_ x: Float, _ y: Float, _ z: Float, _ w: Float) { self.init(x: x, y: y, z: z, w: w) } }

extension Vec2 { public init(_ x: Double, _ y: Double) { self.init(x: x, y: y) } }
extension Vec3 { public init(_ x: Double, _ y: Double, _ z: Double) { self.init(x: x, y: y, z: z) } }
extension Vec4 { public init(_ x: Double, _ y: Double, _ z: Double, _ w: Double) { self.init(x: x, y: y, z: z, w: w) } }

extension Vec2 { public init(_ x: Int, _ y: Int) { self.init(x: x, y: y) } }
extension Vec3 { public init(_ x: Int, _ y: Int, _ z: Int) { self.init(x: x, y: y, z: z) } }
extension Vec4 { public init(_ x: Int, _ y: Int, _ z: Int, _ w: Int) { self.init(x: x, y: y, z: z, w: w) } }

extension Vec2 { public init(_ v: Float) { self.init(x: v, y: v) } }
extension Vec3 { public init(_ v: Float) { self.init(x: v, y: v, z: v) } }
extension Vec4 { public init(_ v: Float) { self.init(x: v, y: v, z: v, w: v) } }

extension Vec2 { public init(_ v: Double) { self.init(x: v, y: v) } }
extension Vec3 { public init(_ v: Double) { self.init(x: v, y: v, z: v) } }
extension Vec4 { public init(_ v: Double) { self.init(x: v, y: v, z: v, w: v) } }

extension Vec2 { public init(_ v: Int) { self.init(x: v, y: v) } }
extension Vec3 { public init(_ v: Int) { self.init(x: v, y: v, z: v) } }
extension Vec4 { public init(_ v: Int) { self.init(x: v, y: v, z: v, w: v) } }

// Extractors

extension Vec3 { public var xy: Vec2 { return Vec2(x: x, y: y) } }
extension Vec3 { public var xz: Vec2 { return Vec2(x: x, y: z) } }
extension Vec3 { public var yz: Vec2 { return Vec2(x: y, y: z) } }

extension Vec4 { public var xyz: Vec3 { return Vec3(x: x, y: y, z: z) } }

// Description

extension Vec2: CustomDebugStringConvertible { public var debugDescription: String { return "(\(x), \(y))" } }
extension Vec3: CustomDebugStringConvertible { public var debugDescription: String { return "(\(x), \(y), \(z))" } }
extension Vec4: CustomDebugStringConvertible { public var debugDescription: String { return "(\(x), \(y), \(z), \(w))" } }

// Protocol

infix operator •: MultiplicationPrecedence

public protocol VecProtocol {
	static var zero: Self { get }
	var isZero: Bool { get }
	func isAlmostZero(epsilon: Float) -> Bool

	static func ==(a: Self, b: Self) -> Bool

	prefix static func -(v: Self) -> Self
	static func +(a: Self, b: Float) -> Self
	static func +(a: Float, b: Self) -> Self
	static func +(a: Self, b: Self) -> Self
	static func -(a: Self, b: Float) -> Self
	static func -(a: Float, b: Self) -> Self
	static func -(a: Self, b: Self) -> Self
	static func *(a: Self, b: Float) -> Self
	static func *(a: Float, b: Self) -> Self
	static func *(a: Self, b: Self) -> Self
	static func /(a: Self, b: Float) -> Self
	static func /(a: Float, b: Self) -> Self
	static func /(a: Self, b: Self) -> Self
	static func •(a: Self, b: Self) -> Float
}

public func +=<T: VecProtocol>(a: inout T, b: Float) { a = a + b }
public func +=<T: VecProtocol>(a: inout T, b: T) { a = a + b }
public func -=<T: VecProtocol>(a: inout T, b: Float) { a = a - b }
public func -=<T: VecProtocol>(a: inout T, b: T) { a = a - b }
public func *=<T: VecProtocol>(a: inout T, b: Float) { a = a * b }
public func *=<T: VecProtocol>(a: inout T, b: T) { a = a * b }
public func /=<T: VecProtocol>(a: inout T, b: Float) { a = a / b }
public func /=<T: VecProtocol>(a: inout T, b: T) { a = a / b }

extension Vec2: VecProtocol {}
extension Vec3: VecProtocol {}
extension Vec4: VecProtocol {}

extension Vec2 {
	public static var zero: Vec2 { return Vec2(x: 0, y: 0) }
	public static var xAxis: Vec2 { return Vec2(x: 1, y: 0) }
	public static var yAxis: Vec2 { return Vec2(x: 0, y: 1) }
}

extension Vec3 {
	public static var zero: Vec3 { return Vec3(x: 0, y: 0, z: 0) }
	public static var xAxis: Vec3 { return Vec3(x: 1, y: 0, z: 0) }
	public static var yAxis: Vec3 { return Vec3(x: 0, y: 1, z: 0) }
	public static var zAxis: Vec3 { return Vec3(x: 0, y: 0, z: 1) }
}

extension Vec4 {
	public static var zero: Vec4 { return Vec4(x: 0, y: 0, z: 0, w: 0) }
	public static var xAxis: Vec4 { return Vec4(x: 1, y: 0, z: 0, w: 0) }
	public static var yAxis: Vec4 { return Vec4(x: 0, y: 1, z: 0, w: 0) }
	public static var zAxis: Vec4 { return Vec4(x: 0, y: 0, z: 1, w: 0) }
	public static var wAxis: Vec4 { return Vec4(x: 0, y: 0, z: 0, w: 1) }
}

extension Vec2 { public var isZero: Bool { return x == 0 && y == 0 } }
extension Vec3 { public var isZero: Bool { return x == 0 && y == 0 && z == 0 } }
extension Vec4 { public var isZero: Bool { return x == 0 && y == 0 && z == 0 && w == 0 } }

extension Vec2 { public func isAlmostZero(epsilon: Float) -> Bool { return abs(x) < epsilon && abs(y) < epsilon } }
extension Vec3 { public func isAlmostZero(epsilon: Float) -> Bool { return abs(x) < epsilon && abs(y) < epsilon && abs(z) < epsilon } }
extension Vec4 { public func isAlmostZero(epsilon: Float) -> Bool { return abs(x) < epsilon && abs(y) < epsilon && abs(z) < epsilon && abs(w) < epsilon } }

// Unary operations

prefix public func -(v: Vec2) -> Vec2 { return Vec2(x: -v.x, y: -v.y) }
prefix public func -(v: Vec3) -> Vec3 { return Vec3(x: -v.x, y: -v.y, z: -v.z) }
prefix public func -(v: Vec4) -> Vec4 { return Vec4(x: -v.x, y: -v.y, z: -v.z, w: -v.w) }

// Operators

public func ==(a: Vec2, b: Vec2) -> Bool { return a.x == b.x && a.y == b.y }
public func ==(a: Vec3, b: Vec3) -> Bool { return a.x == b.x && a.y == b.y && a.z == b.z }
public func ==(a: Vec4, b: Vec4) -> Bool { return a.x == b.x && a.y == b.y && a.z == b.z && a.w == b.w }

public func isAlmostEqual(_ a: Vec2, _ b: Vec2, _ epsilon: Float) -> Bool { return abs(a.x - b.x) < epsilon && abs(a.y - b.y) < epsilon }
public func isAlmostEqual(_ a: Vec3, _ b: Vec3, _ epsilon: Float) -> Bool { return abs(a.x - b.x) < epsilon && abs(a.y - b.y) < epsilon && abs(a.z - b.z) < epsilon }
public func isAlmostEqual(_ a: Vec4, _ b: Vec4, _ epsilon: Float) -> Bool { return abs(a.x - b.x) < epsilon && abs(a.y - b.y) < epsilon && abs(a.z - b.z) < epsilon && abs(a.w - b.w) < epsilon }

public func +(a: Vec2, b: Float) -> Vec2 { return Vec2(x: a.x + b, y: a.y + b) }
public func +(a: Vec3, b: Float) -> Vec3 { return Vec3(x: a.x + b, y: a.y + b, z: a.z + b) }
public func +(a: Vec4, b: Float) -> Vec4 { return Vec4(x: a.x + b, y: a.y + b, z: a.z + b, w: a.w + b) }

public func +(a: Float, b: Vec2) -> Vec2 { return Vec2(x: a + b.x, y: a + b.y) }
public func +(a: Float, b: Vec3) -> Vec3 { return Vec3(x: a + b.x, y: a + b.y, z: a + b.z) }
public func +(a: Float, b: Vec4) -> Vec4 { return Vec4(x: a + b.x, y: a + b.y, z: a + b.z, w: a + b.w) }

public func +(a: Vec2, b: Vec2) -> Vec2 { return Vec2(x: a.x + b.x, y: a.y + b.y) }
public func +(a: Vec3, b: Vec3) -> Vec3 { return Vec3(x: a.x + b.x, y: a.y + b.y, z: a.z + b.z) }
public func +(a: Vec4, b: Vec4) -> Vec4 { return Vec4(x: a.x + b.x, y: a.y + b.y, z: a.z + b.z, w: a.w + b.w) }

public func -(a: Vec2, b: Float) -> Vec2 { return Vec2(x: a.x - b, y: a.y - b) }
public func -(a: Vec3, b: Float) -> Vec3 { return Vec3(x: a.x - b, y: a.y - b, z: a.z - b) }
public func -(a: Vec4, b: Float) -> Vec4 { return Vec4(x: a.x - b, y: a.y - b, z: a.z - b, w: a.w - b) }

public func -(a: Float, b: Vec2) -> Vec2 { return Vec2(x: a - b.x, y: a - b.y) }
public func -(a: Float, b: Vec3) -> Vec3 { return Vec3(x: a - b.x, y: a - b.y, z: a - b.z) }
public func -(a: Float, b: Vec4) -> Vec4 { return Vec4(x: a - b.x, y: a - b.y, z: a - b.z, w: a - b.w) }

public func -(a: Vec2, b: Vec2) -> Vec2 { return Vec2(x: a.x - b.x, y: a.y - b.y) }
public func -(a: Vec3, b: Vec3) -> Vec3 { return Vec3(x: a.x - b.x, y: a.y - b.y, z: a.z - b.z) }
public func -(a: Vec4, b: Vec4) -> Vec4 { return Vec4(x: a.x - b.x, y: a.y - b.y, z: a.z - b.z, w: a.w - b.w) }

public func *(a: Vec2, b: Float) -> Vec2 { return Vec2(x: a.x * b, y: a.y * b) }
public func *(a: Vec3, b: Float) -> Vec3 { return Vec3(x: a.x * b, y: a.y * b, z: a.z * b) }
public func *(a: Vec4, b: Float) -> Vec4 { return Vec4(x: a.x * b, y: a.y * b, z: a.z * b, w: a.w * b) }

public func *(a: Float, b: Vec2) -> Vec2 { return Vec2(x: a * b.x, y: a * b.y) }
public func *(a: Float, b: Vec3) -> Vec3 { return Vec3(x: a * b.x, y: a * b.y, z: a * b.z) }
public func *(a: Float, b: Vec4) -> Vec4 { return Vec4(x: a * b.x, y: a * b.y, z: a * b.z, w: a * b.w) }

public func *(a: Vec2, b: Vec2) -> Vec2 { return Vec2(x: a.x * b.x, y: a.y * b.y) }
public func *(a: Vec3, b: Vec3) -> Vec3 { return Vec3(x: a.x * b.x, y: a.y * b.y, z: a.z * b.z) }
public func *(a: Vec4, b: Vec4) -> Vec4 { return Vec4(x: a.x * b.x, y: a.y * b.y, z: a.z * b.z, w: a.w * b.w) }

public func /(a: Vec2, b: Float) -> Vec2 { return Vec2(x: a.x / b, y: a.y / b) }
public func /(a: Vec3, b: Float) -> Vec3 { return Vec3(x: a.x / b, y: a.y / b, z: a.z / b) }
public func /(a: Vec4, b: Float) -> Vec4 { return Vec4(x: a.x / b, y: a.y / b, z: a.z / b, w: a.w / b) }

public func /(a: Float, b: Vec2) -> Vec2 { return Vec2(x: a / b.x, y: a / b.y) }
public func /(a: Float, b: Vec3) -> Vec3 { return Vec3(x: a / b.x, y: a / b.y, z: a / b.z) }
public func /(a: Float, b: Vec4) -> Vec4 { return Vec4(x: a / b.x, y: a / b.y, z: a / b.z, w: a / b.w) }

public func /(a: Vec2, b: Vec2) -> Vec2 { return Vec2(x: a.x / b.x, y: a.y / b.y) }
public func /(a: Vec3, b: Vec3) -> Vec3 { return Vec3(x: a.x / b.x, y: a.y / b.y, z: a.z / b.z) }
public func /(a: Vec4, b: Vec4) -> Vec4 { return Vec4(x: a.x / b.x, y: a.y / b.y, z: a.z / b.z, w: a.w / b.w) }

public func •(a: Vec2, b: Vec2) -> Float { return a.x * b.x + a.y * b.y }
public func •(a: Vec3, b: Vec3) -> Float { return a.x * b.x + a.y * b.y + a.z * b.z }
public func •(a: Vec4, b: Vec4) -> Float { return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w }

// Norm and length extensions

extension VecProtocol {
	public var square: Float { return dot(self, self) }
	public var length: Float { return sqrt(square) }

	public var normalised: Self {
		let abs = length
		guard abs != 0 else { return Self.zero }
		return self / abs
	}

	public func with(length: Float) -> Self { return normalised * length }
}

public func dot<T: VecProtocol>(_ a: T, _ b: T) -> Float { return a • b }
public func abs<T: VecProtocol>(_ v: T) -> Float { return v.length }
public func normalise<T: VecProtocol>(_ v: T) -> T { return v.normalised }
public func distanceSquared<T: VecProtocol>(from a: T, to b: T) -> Float { return (a - b).square }
public func distance<T: VecProtocol>(from a: T, to b: T) -> Float { return (a - b).length }

// Homogenous conversion functions

extension Vec3 {
	public var unhomogenised4: Vec4 { return Vec4(vec3: self) }
}

extension Vec4 {
	public var homogenised3: Vec3 { return Vec3(x: x / w, y: y / w, z: z / w) }
	public var homogenised4: Vec4 { return Vec4(x: x / w, y: y / w, z: z / w , w: 1) }
}

// Blending

public func midpoint<T: VecProtocol>(_ a: T, _ b: T) -> T { return (a + b) / 2 }

public func mix<T: VecProtocol>(_ a: T, _ b: T, _ x: Float) -> T { return a + (b - a) * x }

public func slerp<T: VecProtocol>(_ a: T, _ b: T, _ x: Float) -> T {
	let cos_angle = dot(a, b)
	if cos_angle > 0.9999 {
		return mix(a, b, x).normalised
	}

	let angle = acos(cos_angle)
	let sin_angle = sin(angle)
	let aFactor = sinf((1 - x) * angle) / sin_angle
	let bFactor = sin(x * angle) / sin_angle
	return a * aFactor + b * bFactor
}

// 2D specifics

extension Vec2 {
	public init(perpendicularTo v: Vec2) {
		self.init(x: -v.y, y: v.x)
	}

	public func rotated(angle: Float) -> Vec2 {
		return Vec2(
			x: x * cos(angle) - y * sin(angle),
			y: x * sin(angle) + y * cos(angle)
		)
	}
}

public func dot(_ a: Vec2, perpendicularTo b: Vec2) -> Float { return dot(a, Vec2(perpendicularTo: b)) }

// 3D specifics

infix operator ⨯: MultiplicationPrecedence

public func ⨯(a: Vec3, b: Vec3) -> Vec3 { return cross(a, b) }

public func cross(_ a: Vec3, _ b: Vec3) -> Vec3 {
	return Vec3(
		x: a.y * b.z - a.z * b.y,
		y: a.z * b.x - a.x * b.z,
		z: a.x * b.y - a.y * b.x
	)
}

// Plane functions

extension Vec4 {
	public init(planeNormal p: Vec4) {
		let absValue = abs(p.planeNormal)
		if absValue != 0 {
			self = p / absValue
		} else {
			self = Vec4.zero
		}
	}

	public var planeNormal: Vec3 { return xyz }

	public var plane3: Vec3 { return homogenised3 }

	public func distanceFromPlane(toPoint v: Vec3) -> Float {
		return dot(self, v.unhomogenised4) / abs(planeNormal)
	}
}

extension Vec3 {
	public func distanceFromPlane(toPoint v: Vec3) -> Float {
		return (dot(self, v) + 1) / abs(self)
	}
}

public func project(_ p: Vec3, ontoUnitLine line: Vec3) -> Vec3 {
	return line * dot(p, line)
}

public func project(_ p: Vec3, ontoPlaneWithUnitNormal normal: Vec3) -> Vec3 {
	return p - project(p, ontoUnitLine: normal)
}


public func reflect(_ p: Vec3, inPlaneWithUnitNormal normal: Vec3) -> Vec3 {
	return p - project(p, ontoUnitLine: normal) * 2
}

public func triangleNormal(_ v1: Vec3, _ v2: Vec3, _ v3: Vec3) -> Vec3 {
	return normalise(cross(v2 - v1, v3 - v1))
}

// Modulo and friends

public func floor(_ v: Vec2) -> Vec2 { return Vec2(x: floor(v.x), y: floor(v.y)) }
public func floor(_ v: Vec3) -> Vec3 { return Vec3(x: floor(v.x), y: floor(v.y), z: floor(v.z)) }
public func floor(_ v: Vec4) -> Vec4 { return Vec4(x: floor(v.x), y: floor(v.y), z: floor(v.z), w: floor(v.w)) }

public func ceil(_ v: Vec2) -> Vec2 { return Vec2(x: ceil(v.x), y: ceil(v.y)) }
public func ceil(_ v: Vec3) -> Vec3 { return Vec3(x: ceil(v.x), y: ceil(v.y), z: ceil(v.z)) }
public func ceil(_ v: Vec4) -> Vec4 { return Vec4(x: ceil(v.x), y: ceil(v.y), z: ceil(v.z), w: ceil(v.w)) }

public func fract(_ x: Float) -> Float { return x - floor(x) }
public func fract(_ v: Vec2) -> Vec2 { return Vec2(x: fract(v.x), y: fract(v.y)) }
public func fract(_ v: Vec3) -> Vec3 { return Vec3(x: fract(v.x), y: fract(v.y), z: fract(v.z)) }
public func fract(_ v: Vec4) -> Vec4 { return Vec4(x: fract(v.x), y: fract(v.y), z: fract(v.z), w: fract(v.w)) }

public func fmod(_ v: Vec2, _ d: Float) -> Vec2 { return Vec2(x: fmod(v.x, d), y: fmod(v.y, d)) }
public func fmod(_ v: Vec3, _ d: Float) -> Vec3 { return Vec3(x: fmod(v.x, d), y: fmod(v.y, d), z: fmod(v.z, d)) }
public func fmod(_ v: Vec4, _ d: Float) -> Vec4 { return Vec4(x: fmod(v.x, d), y: fmod(v.y, d), z: fmod(v.z, d), w: fmod(v.w, d)) }

// Random

extension Float {
	public static func randomNormalPair<RandomType: RandomNumberGenerator>(using rng: inout RandomType) -> (Float, Float) {
		let r = sqrt(-2 * log(Float.random(in: 0 ..< 1, using: &rng)))
		let a = Float.random(in: 0 ..< 2 * .pi, using: &rng)

		return (r * sin(a), r * cos(a))
	}
}

extension Vec2 {
/*	public static func random() -> CGPoint {
		return CGPoint(x: CGFloat.random(), y: CGFloat.random())
	}

	public static func signedRandom() -> CGPoint {
		return CGPoint(x: CGFloat.signedRandom(), y: CGFloat.signedRandom())
	}*/

	static func normalRandom<RandomType: RandomNumberGenerator>(using rng: inout RandomType) -> Vec2 {
		let (x, y) = Float.randomNormalPair(using: &rng)
		return Vec2(x: x, y: y)
	}

	public static func discRandom<RandomType: RandomNumberGenerator>(using rng: inout RandomType) -> Vec2 {
		let r = sqrt(Float.random(in: 0 ..< 1, using: &rng))
		let a = Float.random(in: 0 ..< 2 * .pi, using: &rng)
		return Vec2(r: r, angle: a)
	}

	public static func polarRandom<RandomType: RandomNumberGenerator>(using rng: inout RandomType) -> Vec2 {
		let r = Float.random(in: 0 ..< 1,using: &rng)
		let a = Float.random(in: 0 ..< 2 * .pi, using: &rng)
		return Vec2(r: r, angle: a)
	}

	static func normalRandom() -> Vec2 {
		var rng = SystemRandomNumberGenerator()
		return normalRandom(using: &rng)
	}

	public static func discRandom() -> Vec2 {
		var rng = SystemRandomNumberGenerator()
		return discRandom(using: &rng)
	}

	public static func polarRandom() -> Vec2 {
		var rng = SystemRandomNumberGenerator()
		return polarRandom(using: &rng)
	}
}

extension Vec3 {
	public static func normalRandom<RandomType: RandomNumberGenerator>(using rng: inout RandomType) -> Vec3 {
		let (x, y) = Float.randomNormalPair(using: &rng)
		let (z, _) = Float.randomNormalPair(using: &rng)
		return Vec3(x, y, z)
	}
}

extension Vec4 {
	public static func normalRandom<RandomType: RandomNumberGenerator>(using rng: inout RandomType) -> Vec4 {
		let (x, y) = Float.randomNormalPair(using: &rng)
		let (z, w) = Float.randomNormalPair(using: &rng)
		return Vec4(x, y, z, w)
	}
}
