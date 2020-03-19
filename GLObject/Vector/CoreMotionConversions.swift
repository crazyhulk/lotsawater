import CoreMotion

extension Quat {
	public init(_ q: CMQuaternion) {
		self.init(r: Float(q.w), ix: Float(q.x), iy: Float(q.y), iz: Float(q.z))
	}
}

extension CMQuaternion {
	public init(_ q: Quat) {
		self.init(x: Double(q.i.x), y: Double(q.i.y), z: Double(q.i.z), w: Double(q.r))
	}
}

extension Mat3x3 {
	public init(_ m: CMRotationMatrix) {
		self.init(Float(m.m11), Float(m.m21), Float(m.m31),
		          Float(m.m12), Float(m.m22), Float(m.m32),
		          Float(m.m13), Float(m.m23), Float(m.m33))
	}
}

extension Mat4x3 { public init(_ m: CMRotationMatrix) { self.init(Mat3x3(m)) } }
extension Mat4x4 { public init(_ m: CMRotationMatrix) { self.init(Mat3x3(m)) } }

extension CMRotationMatrix {
	public init(_ m: Mat3x3) {
		self.init(m11: Double(m.m11), m12: Double(m.m21), m13: Double(m.m31),
		          m21: Double(m.m12), m22: Double(m.m22), m23: Double(m.m32),
		          m31: Double(m.m13), m32: Double(m.m23), m33: Double(m.m33))
	}
}
