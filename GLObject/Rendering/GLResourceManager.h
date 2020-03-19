#import "../GLObject.h"
#import "../GLTexture.h"
#import "../GLBuffer.h"

#define GLResourceManager MangleClassName(GLResourceManager)

@interface GLResourceManager:NSObject
{
	NSMutableDictionary *resources;
}

-(id)init;
-(void)dealloc;
-(void)delete;

-(id)resourceForObject:(id)object;
-(void)setResource:(id)resource forObject:(id)object;

-(GLTexture *)textureForBitmap:(GLBitmap *)bitmap;
-(GLBuffer *)arrayBufferForData:(NSData *)data;
-(GLBuffer *)elementArrayBufferForData:(NSData *)data;

@end
