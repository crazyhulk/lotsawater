#import "NSDataArrayAdditions.h"

@implementation NSData (ArrayAdditions)

-(NSUInteger)countWithElementSize:(NSUInteger)size
{
	return [self length]/size;
}

-(NSUInteger)countWithObjCType:(const char *)type
{
	NSUInteger size,alignment;
	NSGetSizeAndAlignment(type,&size,&alignment);
	return [self length]/size;
}

@end



@implementation NSMutableData (ArrayAdditions)

-(id)initWithCount:(NSUInteger)count elementSize:(NSUInteger)elementsize
{
	return [self initWithLength:count*elementsize];
}

-(id)initWithCount:(NSUInteger)count objCType:(const char *)type
{
	NSUInteger size,alignment;
	NSGetSizeAndAlignment(type,&size,&alignment);
	return [self initWithLength:count*size];
}

-(void)setCount:(NSUInteger)count elementSize:(NSUInteger)size
{
	[self setLength:count*size];
}

-(void)setCount:(NSUInteger)count objCType:(const char *)type
{
	NSUInteger size,alignment;
	NSGetSizeAndAlignment(type,&size,&alignment);
	[self setLength:count*size];
}

-(void)appendBytes:(const void *)bytes objCType:(const char *)type
{
	NSUInteger size,alignment;
	NSGetSizeAndAlignment(type,&size,&alignment);
	[self appendBytes:bytes length:size];
}

-(void)appendChar:(char)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendShort:(short)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendInt:(int)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendLong:(long)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendLongLong:(long long)val { [self appendBytes:&val length:sizeof(val)]; }

-(void)appendUnsignedChar:(unsigned char)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendUnsignedShort:(unsigned short)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendUnsignedInt:(unsigned int)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendUnsignedLong:(unsigned long)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendUnsignedLongLong:(unsigned long long)val { [self appendBytes:&val length:sizeof(val)]; }

-(void)appendInt8:(int8_t)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendInt16:(int16_t)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendInt32:(int32_t)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendInt64:(int64_t)val { [self appendBytes:&val length:sizeof(val)]; }

-(void)appendUInt8:(uint8_t)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendUInt16:(uint16_t)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendUInt32:(uint32_t)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendUInt64:(uint64_t)val { [self appendBytes:&val length:sizeof(val)]; }

-(void)appendFloat:(float)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendDouble:(double)val { [self appendBytes:&val length:sizeof(val)]; }

-(void)appendVec2:(vec2_t)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendVec3:(vec3_t)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendVec4:(vec4_t)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendMat2x2:(mat2x2_t)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendMat3x2:(mat3x2_t)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendMat3x3:(mat3x3_t)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendMat4x3:(mat4x3_t)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendMat4x4:(mat4x4_t)val { [self appendBytes:&val length:sizeof(val)]; }
-(void)appendQuat:(quat_t)val { [self appendBytes:&val length:sizeof(val)]; }

@end
