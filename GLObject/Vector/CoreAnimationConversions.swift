import QuartzCore

extension Mat4x4 {
	public init(_ t: CATransform3D) {
		self.init(Float(t.m11), Float(t.m21), Float(t.m31), Float(t.m41),
		          Float(t.m12), Float(t.m22), Float(t.m32), Float(t.m42),
		          Float(t.m13), Float(t.m23), Float(t.m33), Float(t.m43),
		          Float(t.m14), Float(t.m24), Float(t.m34), Float(t.m44))
	}
}

extension CATransform3D {
	public init(_ m: Mat4x4) {
		self.init(m11: CGFloat(m.m11), m12: CGFloat(m.m21), m13: CGFloat(m.m31), m14: CGFloat(m.m41),
		          m21: CGFloat(m.m12), m22: CGFloat(m.m22), m23: CGFloat(m.m32), m24: CGFloat(m.m42),
		          m31: CGFloat(m.m13), m32: CGFloat(m.m23), m33: CGFloat(m.m33), m34: CGFloat(m.m43),
		          m41: CGFloat(m.m14), m42: CGFloat(m.m24), m43: CGFloat(m.m34), m44: CGFloat(m.m44))
	}
}
