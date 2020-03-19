import SceneKit

extension Vec3 {
	init(_ v: SCNVector3) {
		self.init(x: v.x, y: v.y, z: v.z)
	}
}

extension SCNVector3 {
	init(_ v: Vec3) {
		self.init(v.x, v.y, v.z)
	}
}

extension Vec4 {
	init(_ v: SCNVector4) {
		self.init(x: v.x, y: v.y, z: v.z, w: v.w)
	}
}

extension SCNVector4 {
	init(_ v: Vec4) {
		self.init(v.x, v.y, v.z, v.w)
	}
}
