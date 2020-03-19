import CoreImage

extension CIVector {
	public convenience init(_ v: Vec2) {
		var values: [CGFloat] = [
			CGFloat(v.x), CGFloat(v.y),
		]
		self.init(values: &values, count: 2)
	}

	public convenience init(_ v: Vec3) {
		var values: [CGFloat] = [
			CGFloat(v.x), CGFloat(v.y), CGFloat(v.z),
		]
		self.init(values: &values, count: 3)
	}

	public convenience init(_ v: Vec4) {
		var values: [CGFloat] = [
			CGFloat(v.x), CGFloat(v.y), CGFloat(v.z), CGFloat(v.w),
		]
		self.init(values: &values, count: 4)
	}
}

extension CIVector {
	public convenience init(_ q: Quat) {
		var values: [CGFloat] = [
			CGFloat(q.i.x), CGFloat(q.i.y), CGFloat(q.i.z), CGFloat(q.r),
		]
		self.init(values: &values, count: 4)
	}
}

extension CIVector {
	public convenience init(_ m: Mat2x2) {
		var values: [CGFloat] = [
			CGFloat(m.m.0), CGFloat(m.m.1),
			CGFloat(m.m.2), CGFloat(m.m.3),
		]
		self.init(values: &values, count: 4)
	}

	public convenience init(_ m: Mat3x2) {
		var values: [CGFloat] = [
			CGFloat(m.m.0), CGFloat(m.m.1), CGFloat(m.m.2),
			CGFloat(m.m.3), CGFloat(m.m.4), CGFloat(m.m.5),
		]
		self.init(values: &values, count: 6)
	}

	public convenience init(_ m: Mat3x3) {
		var values: [CGFloat] = [
			CGFloat(m.m.0), CGFloat(m.m.1), CGFloat(m.m.2),
			CGFloat(m.m.3), CGFloat(m.m.4), CGFloat(m.m.5),
			CGFloat(m.m.6), CGFloat(m.m.7), CGFloat(m.m.8),
		]
		self.init(values: &values, count: 9)
	}

	public convenience init(_ m: Mat4x3) {
		var values: [CGFloat] = [
			CGFloat(m.m.0), CGFloat(m.m.1), CGFloat(m.m.2), CGFloat(m.m.3),
			CGFloat(m.m.4), CGFloat(m.m.5), CGFloat(m.m.6), CGFloat(m.m.7),
			CGFloat(m.m.8), CGFloat(m.m.9), CGFloat(m.m.10), CGFloat(m.m.11),
		]
		self.init(values: &values, count: 12)
	}

	public convenience init(_ m: Mat4x4) {
		var values: [CGFloat] = [
			CGFloat(m.m.0), CGFloat(m.m.1), CGFloat(m.m.2), CGFloat(m.m.3),
			CGFloat(m.m.4), CGFloat(m.m.5), CGFloat(m.m.6), CGFloat(m.m.7),
			CGFloat(m.m.8), CGFloat(m.m.9), CGFloat(m.m.10), CGFloat(m.m.11),
			CGFloat(m.m.12), CGFloat(m.m.13), CGFloat(m.m.14), CGFloat(m.m.15),
		]
		self.init(values: &values, count: 16)
	}
}
