import CoreGraphics

extension Vec2 { public init(x: CGFloat, y: CGFloat) { self.init(x: Float(x), y: Float(y)) } }
extension Vec3 { public init(x: CGFloat, y: CGFloat, z: CGFloat) { self.init(x: Float(x), y: Float(y), z: Float(z)) } }
extension Vec4 { public init(x: CGFloat, y: CGFloat, z: CGFloat, w: CGFloat) { self.init(x: Float(x), y: Float(y), z: Float(z), w: Float(w)) } }

extension Vec2 {
	public init(_ p: CGPoint) {
		self.init(x: p.x, y: p.y)
	}
}

extension CGPoint {
	public init(_ v: Vec2) {
		self.init(x: CGFloat(v.x), y: CGFloat(v.y))
	}
}

extension Vec2 {
	public init(_ p: CGVector) {
		self.init(x: p.dx, y: p.dy)
	}
}

extension CGVector {
	public init(_ v: Vec2) {
		self.init(dx: CGFloat(v.x), dy: CGFloat(v.y))
	}
}

extension Vec2 {
	public init(_ p: CGSize) {
		self.init(x: p.width, y: p.height)
	}
}

extension CGSize {
	public init(_ v: Vec2) {
		self.init(width: CGFloat(v.x), height: CGFloat(v.y))
	}
}

extension Mat3x2 {
	public init(_ t: CGAffineTransform) {
		self.init(Float(t.a), Float(t.c), Float(t.tx),
		          Float(t.b), Float(t.d), Float(t.ty))
	}
}

extension Mat3x3 { public init(_ t: CGAffineTransform) { self.init(Mat3x2(t)) } }

extension CGAffineTransform {
	public init(_ m: Mat3x2) {
		self.init(a:  CGFloat(m.m11), b:  CGFloat(m.m21),
		          c:  CGFloat(m.m12), d:  CGFloat(m.m22),
				  tx: CGFloat(m.m13), ty: CGFloat(m.m23))
	}
}
