import SceneKit

extension Vec3 {
	public init(_ v: SCNVector3) {
		self.init(x: v.x, y: v.y, z: v.z)
	}
}

extension SCNVector3 {
	public init(_ v: Vec3) {
		self.init(v.x, v.y, v.z)
	}
}

extension Vec4 {
	public init(_ v: SCNVector4) {
		self.init(x: v.x, y: v.y, z: v.z, w: v.w)
	}
}

extension SCNVector4 {
	public init(_ v: Vec4) {
		self.init(v.x, v.y, v.z, v.w)
	}
}

extension SCNMatrix4 {
	public init(_ m: Mat4x4) {
		self.init(m11: m.m11, m12: m.m21, m13: m.m31, m14: m.m41,
		          m21: m.m12, m22: m.m22, m23: m.m32, m24: m.m42,
		          m31: m.m13, m32: m.m23, m33: m.m33, m34: m.m43,
		          m41: m.m14, m42: m.m24, m43: m.m34, m44: m.m44)
	}
}
