#import "GLBuffer.h"



#define GLBufferARB MangleClassName(GLBufferARB)
@interface GLBufferARB:GLBuffer
{
	GLenum target;
	GLuint buffer;
}
@end

#if OPENGL_VERSION>=15
#define GLBufferOpenGL15 MangleClassName(GLBufferOpenGL15)
@interface GLBufferOpenGL15:GLBuffer
{
	GLenum target;
	GLuint buffer;
}
@end
#endif



@implementation GLBuffer

+(id)allocWithZone:(NSZone *)zone
{
	if(![self isEqual:[GLBuffer class]]) return [super allocWithZone:zone];

	#if OPENGL_VERSION>=15
	if(glGenBuffers&&glBindBuffer&&glBufferData&&glDeleteBuffers)
	return [GLBufferOpenGL15 allocWithZone:zone];
	#endif

	return [GLBufferARB allocWithZone:zone];
}

+(GLBuffer *)arrayBuffer
{
	return [[[self alloc] initWithTarget:GL_ARRAY_BUFFER] autorelease];
}

+(GLBuffer *)arrayBufferWithSize:(GLsizeiptr)size usage:(GLenum)usage
{
	return [[[self alloc] initWithTarget:GL_ARRAY_BUFFER size:size bytes:NULL usage:usage] autorelease];
}

+(GLBuffer *)arrayBufferWithSize:(GLsizeiptr)size bytes:(const void *)bytes
{
	return [[[self alloc] initWithTarget:GL_ARRAY_BUFFER size:size bytes:bytes usage:GL_STATIC_DRAW] autorelease];
}

+(GLBuffer *)arrayBufferWithSize:(GLsizeiptr)size bytes:(const void *)bytes usage:(GLenum)usage
{
	return [[[self alloc] initWithTarget:GL_ARRAY_BUFFER size:size bytes:bytes usage:usage] autorelease];
}

+(GLBuffer *)arrayBufferWithData:(NSData *)data
{
	return [[[self alloc] initWithTarget:GL_ARRAY_BUFFER
	size:[data length] bytes:[data bytes] usage:GL_STATIC_DRAW] autorelease];
}

+(GLBuffer *)arrayBufferWithData:(NSData *)data usage:(GLenum)usage
{
	return [[[self alloc] initWithTarget:GL_ARRAY_BUFFER
	size:[data length] bytes:[data bytes] usage:usage] autorelease];
}



+(GLBuffer *)elementArrayBuffer;
{
	return [[[self alloc] initWithTarget:GL_ELEMENT_ARRAY_BUFFER] autorelease];
}

+(GLBuffer *)elementArrayBufferWithSize:(GLsizeiptr)size usage:(GLenum)usage
{
	return [[[self alloc] initWithTarget:GL_ELEMENT_ARRAY_BUFFER size:size bytes:NULL usage:usage] autorelease];
}

+(GLBuffer *)elementArrayBufferWithSize:(GLsizeiptr)size bytes:(const void *)bytes
{
	return [[[self alloc] initWithTarget:GL_ELEMENT_ARRAY_BUFFER size:size bytes:bytes usage:GL_STATIC_DRAW] autorelease];
}

+(GLBuffer *)elementArrayBufferWithSize:(GLsizeiptr)size bytes:(const void *)bytes usage:(GLenum)usage
{
	return [[[self alloc] initWithTarget:GL_ELEMENT_ARRAY_BUFFER size:size bytes:bytes usage:usage] autorelease];
}

+(GLBuffer *)elementArrayBufferWithData:(NSData *)data
{
	return [[[self alloc] initWithTarget:GL_ELEMENT_ARRAY_BUFFER
	size:[data length] bytes:[data bytes] usage:GL_STATIC_DRAW] autorelease];
}

+(GLBuffer *)elementArrayBufferWithData:(NSData *)data usage:(GLenum)usage
{
	return [[[self alloc] initWithTarget:GL_ELEMENT_ARRAY_BUFFER
	size:[data length] bytes:[data bytes] usage:usage] autorelease];
}




+(GLuint)currentArrayBuffer
{
	#if OPENGL_VERSION>=15
	return [self currentBufferForBinding:GL_ARRAY_BUFFER_BINDING];
	#else
	return [self currentBufferForBinding:GL_ARRAY_BUFFER_BINDING_ARB];
	#endif
}

+(GLuint)currentElementArrayBuffer
{
	#if OPENGL_VERSION>=15
	return [self currentBufferForBinding:GL_ELEMENT_ARRAY_BUFFER_BINDING];
	#else
	return [self currentBufferForBinding:GL_ELEMENT_ARRAY_BUFFER_BINDING_ARB];
	#endif
}

+(GLuint)currentPixelPackBuffer
{
	#if OPENGL_VERSION>=21
	return [self currentBufferForBinding:GL_PIXEL_PACK_BUFFER_BINDING];
	#elif defned(GL_PIXEL_PACK_BUFFER_BINDING_ARB)
	return [self currentBufferForBinding:GL_PIXEL_PACK_BUFFER_BINDING_ARB];
	#elif defned(GL_PIXEL_PACK_BUFFER_BINDING_EXT)
	return [self currentBufferForBinding:GL_PIXEL_PACK_BUFFER_BINDING_EXT];
	#else
	return 0;
	#endif
}

+(GLuint)currentPixelUnpackBuffer
{
	#if OPENGL_VERSION>=21
	return [self currentBufferForBinding:GL_PIXEL_UNPACK_BUFFER_BINDING];
	#elif defned(GL_PIXEL_UNPACK_BUFFER_BINDING_ARB)
	return [self currentBufferForBinding:GL_PIXEL_UNPACK_BUFFER_BINDING_ARB];
	#elif defned(GL_PIXEL_UNPACK_BUFFER_BINDING_EXT)
	return [self currentBufferForBinding:GL_PIXEL_UNPACK_BUFFER_BINDING_EXT];
	#else
	return 0;
	#endif
}

+(GLuint)currentBufferForBinding:(GLenum)binding
{
	GLint curr;
	glGetIntegerv(binding,&curr);
	return (GLuint)curr;
}



-(id)initWithTarget:(GLenum)buffertarget
{
	return [self initWithTarget:buffertarget size:0 bytes:NULL usage:0];
}

-(id)initWithTarget:(GLenum)buffertarget size:(GLsizeiptr)size usage:(GLenum)usage
{
	return [self initWithTarget:buffertarget size:size bytes:NULL usage:usage];
}

-(id)initWithTarget:(GLenum)buffertarget size:(GLsizeiptr)size bytes:(const void *)bytes
{
	return [self initWithTarget:buffertarget size:size bytes:bytes usage:GL_STATIC_DRAW];
}

-(id)initWithTarget:(GLenum)buffertarget size:(GLsizeiptr)size bytes:(const void *)bytes usage:(GLenum)usage
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

-(void)delete { [self doesNotRecognizeSelector:_cmd]; }

-(void)bind { [self doesNotRecognizeSelector:_cmd]; }

-(void)setSize:(GLsizeiptr)size usage:(GLenum)usage { [self doesNotRecognizeSelector:_cmd]; }

-(void)setSize:(GLsizeiptr)size bytes:(const void *)bytes usage:(GLenum)usage { [self doesNotRecognizeSelector:_cmd]; }

-(const void *)mapForReading { [self doesNotRecognizeSelector:_cmd]; return NULL; }

-(void *)mapForWriting { [self doesNotRecognizeSelector:_cmd]; return NULL; }

-(void *)mapForReadingAndWriting { [self doesNotRecognizeSelector:_cmd]; return NULL; }

-(BOOL)unmap { [self doesNotRecognizeSelector:_cmd]; return NO; }

@end



@implementation GLBufferARB

-(id)initWithTarget:(GLenum)buffertarget size:(GLsizeiptr)size bytes:(const void *)bytes usage:(GLenum)usage
{
	if((self=[super init]))
	{
		target=buffertarget;

		glGenBuffersARB(1,&buffer);

		if(buffer)
		{
			if(size)
			{
				glBindBufferARB(target,buffer);
				glBufferDataARB(target,size,bytes,usage);
			}

			return self;
		}
		[self release];
	}
	return nil;
}

-(void)dealloc
{
	GLWarnIfNotDeleted(self,buffer);
	[super dealloc];
}

-(void)finalize
{
	GLWarnIfNotDeleted(self,buffer);
	[super finalize];
}

-(void)delete
{
	if(buffer) glDeleteBuffersARB(1,&buffer);
	buffer=0;
}

-(void)bind
{
	GLAssertNotDeleted(self,buffer);
	glBindBufferARB(target,buffer);
}

-(void)setSize:(GLsizeiptr)size usage:(GLenum)usage
{
	GLAssertNotDeleted(self,buffer);
	glBindBufferARB(target,buffer);
	glBufferDataARB(target,size,NULL,usage);
}

-(void)setSize:(GLsizeiptr)size bytes:(const void *)bytes usage:(GLenum)usage
{
	GLAssertNotDeleted(self,buffer);
	glBindBufferARB(target,buffer);
	glBufferDataARB(target,size,bytes,usage);
}

-(const void *)mapForReading
{
	GLAssertNotDeleted(self,buffer);
	glBindBufferARB(target,buffer);
	return glMapBufferARB(target,GL_READ_ONLY_ARB);
}

-(void *)mapForWriting
{
	GLAssertNotDeleted(self,buffer);
	glBindBufferARB(target,buffer);
	return glMapBufferARB(target,GL_WRITE_ONLY_ARB);
}

-(void *)mapForReadingAndWriting
{
	GLAssertNotDeleted(self,buffer);
	glBindBufferARB(target,buffer);
	return glMapBufferARB(target,GL_READ_WRITE_ARB);
}

-(BOOL)unmap
{
	GLAssertNotDeleted(self,buffer);
	glBindBufferARB(target,buffer);
	return glUnmapBufferARB(target);
}

@end



#if OPENGL_VERSION>=15

@implementation GLBufferOpenGL15

-(id)initWithTarget:(GLenum)buffertarget size:(GLsizeiptr)size bytes:(const void *)bytes usage:(GLenum)usage
{
	if((self=[super init]))
	{
		target=buffertarget;

		glGenBuffers(1,&buffer);

		if(buffer)
		{
			if(size)
			{
				glBindBuffer(target,buffer);
				glBufferData(target,size,bytes,usage);
			}

			return self;
		}
		[self release];
	}
	return nil;
}

-(void)dealloc
{
	GLWarnIfNotDeleted(self,buffer);
	[super dealloc];
}

-(void)finalize
{
	GLWarnIfNotDeleted(self,buffer);
	[super finalize];
}

-(void)delete
{
	if(buffer) glDeleteBuffers(1,&buffer);
	buffer=0;
}

-(void)bind
{
	GLAssertNotDeleted(self,buffer);
	glBindBuffer(target,buffer);
}

-(void)setSize:(GLsizeiptr)size usage:(GLenum)usage
{
	GLAssertNotDeleted(self,buffer);
	glBindBuffer(target,buffer);
	glBufferData(target,size,NULL,usage);
}

-(void)setSize:(GLsizeiptr)size bytes:(const void *)bytes usage:(GLenum)usage
{
	GLAssertNotDeleted(self,buffer);
	glBindBuffer(target,buffer);
	glBufferData(target,size,bytes,usage);
}

-(const void *)mapForReading
{
	GLAssertNotDeleted(self,buffer);
	glBindBuffer(target,buffer);
	return glMapBuffer(target,GL_READ_ONLY);
}

-(void *)mapForWriting
{
	GLAssertNotDeleted(self,buffer);
	glBindBuffer(target,buffer);
	return glMapBuffer(target,GL_WRITE_ONLY);
}

-(void *)mapForReadingAndWriting
{
	GLAssertNotDeleted(self,buffer);
	glBindBuffer(target,buffer);
	return glMapBuffer(target,GL_READ_WRITE);
}

-(BOOL)unmap
{
	GLAssertNotDeleted(self,buffer);
	glBindBuffer(target,buffer);
	return glUnmapBuffer(target);
}

@end

#endif
