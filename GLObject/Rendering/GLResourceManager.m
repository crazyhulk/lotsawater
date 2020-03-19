#import "GLResourceManager.h"

@implementation GLResourceManager

-(id)init
{
	if(self=[super init])
	{
		resources=[NSMutableDictionary new];
	}
	return self;
}

-(void)dealloc
{
	[resources release];
	[super dealloc];
}

-(void)delete
{
	[[resources allValues] makeObjectsPerformSelector:@selector(delete)];
}



-(id)resourceForObject:(id)object
{
	return [resources objectForKey:[NSValue valueWithNonretainedObject:object]];
}

-(void)setResource:(id)resource forObject:(id)object
{
	[resources setObject:resource forKey:[NSValue valueWithNonretainedObject:object]];
}



-(GLTexture *)textureForBitmap:(GLBitmap *)bitmap
{
	GLTexture *tex=[self resourceForObject:bitmap];
	if(!tex)
	{
		tex=[GLTexture texture2DWithBitmap:bitmap];
		[self setResource:tex forObject:bitmap];
	}
	return tex;
}

-(GLBuffer *)arrayBufferForData:(NSData *)data
{
	GLBuffer *buffer=[self resourceForObject:data];
	if(!buffer)
	{
		buffer=[GLBuffer arrayBufferWithData:data];
		[self setResource:buffer forObject:data];
	}
	return buffer;
}

-(GLBuffer *)elementArrayBufferForData:(NSData *)data
{
	GLBuffer *buffer=[self resourceForObject:data];
	if(!buffer)
	{
		buffer=[GLBuffer elementArrayBufferWithData:data];
		[self setResource:buffer forObject:data];
	}
	return buffer;
}


@end
