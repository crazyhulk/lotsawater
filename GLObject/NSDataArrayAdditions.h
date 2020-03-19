#import <Foundation/Foundation.h>

#import "Vector/Vector.h"
#import "Vector/Matrix.h"
#import "Vector/Quaternion.h"

@interface NSData (ArrayAdditions)

-(NSUInteger)countWithElementSize:(NSUInteger)size;
-(NSUInteger)countWithObjCType:(const char *)type;

@end

@interface NSMutableData (ArrayAdditions)

-(id)initWithCount:(NSUInteger)count elementSize:(NSUInteger)elementsize;
-(id)initWithCount:(NSUInteger)count objCType:(const char *)type;

-(void)setCount:(NSUInteger)count elementSize:(NSUInteger)size;
-(void)setCount:(NSUInteger)count objCType:(const char *)type;

-(void)appendBytes:(const void *)bytes objCType:(const char *)type;

-(void)appendChar:(char)val;
-(void)appendShort:(short)val;
-(void)appendInt:(int)val;
-(void)appendLong:(long)val;
-(void)appendLongLong:(long long)val;

-(void)appendUnsignedChar:(unsigned char)val;
-(void)appendUnsignedShort:(unsigned short)val;
-(void)appendUnsignedInt:(unsigned int)val;
-(void)appendUnsignedLong:(unsigned long)val;
-(void)appendUnsignedLongLong:(unsigned long long)val;

-(void)appendInt8:(int8_t)val;
-(void)appendInt16:(int16_t)val;
-(void)appendInt32:(int32_t)val;
-(void)appendInt64:(int64_t)val;

-(void)appendUInt8:(uint8_t)val;
-(void)appendUInt16:(uint16_t)val;
-(void)appendUInt32:(uint32_t)val;
-(void)appendUInt64:(uint64_t)val;

-(void)appendFloat:(float)val;
-(void)appendDouble:(double)val;

-(void)appendVec2:(vec2_t)val;
-(void)appendVec3:(vec3_t)val;
-(void)appendVec4:(vec4_t)val;
-(void)appendMat2x2:(mat2x2_t)val;
-(void)appendMat3x2:(mat3x2_t)val;
-(void)appendMat3x3:(mat3x3_t)val;
-(void)appendMat4x3:(mat4x3_t)val;
-(void)appendMat4x4:(mat4x4_t)val;
-(void)appendQuat:(quat_t)val;

@end
