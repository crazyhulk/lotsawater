#import "GLRenderBuffer.h"

@implementation GLRenderBuffer

+(id)allocWithZone:(NSZone *)zone
{
	if(![self isEqual:[GLRenderBuffer class]]) return [super allocWithZone:zone];

	#if OPENGL_VERSION>=30
	if(glGenRenderbuffers&&glDeleteRenderbuffers&&glBindRenderbuffer&&glRenderbufferStorage)
	return [GLRenderBufferOpenGL30 allocWithZone:zone];
	#endif

	return [GLRenderBufferEXT allocWithZone:zone];
}

+(GLuint)currentRenderBuffer
{
	GLint curr;
	#if OPENGL_VERSION>=30
	glGetIntegerv(GL_RENDERBUFFER_BINDING,&curr);
	#else
	glGetIntegerv(GL_RENDERBUFFER_BINDING_EXT,&curr);
	#endif
	return (GLuint)curr;
}

-(id)initWithInternalFormat:(GLenum)internalformat width:(GLsizei)width height:(GLsizei)height
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

-(void)delete { [self doesNotRecognizeSelector:_cmd]; }

-(void)bind { [self doesNotRecognizeSelector:_cmd]; }

@end



@implementation GLRenderBufferEXT

-(id)initWithInternalFormat:(GLenum)internalformat width:(GLsizei)width height:(GLsizei)height
{
	if((self=[super init]))
	{
		glGenRenderbuffersEXT(1,&buffer);
		if(buffer)
		{
			glBindRenderbufferEXT(GL_RENDERBUFFER_EXT,buffer);
			glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT,internalformat,width,height);
			// doesn't check for success
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
	if(buffer) glDeleteRenderbuffersEXT(1,&buffer);
	buffer=0;
}

-(void)bind
{
	GLAssertNotDeleted(self,buffer);
	glBindRenderbufferEXT(GL_RENDERBUFFER_EXT,buffer);
}

-(GLuint)renderBufferEXT { return buffer; }

@end




#if OPENGL_VERSION>=30
@implementation GLRenderBufferOpenGL30

-(id)initWithInternalFormat:(GLenum)internalformat width:(GLsizei)width height:(GLsizei)height
{
	if((self=[super init]))
	{
		glGenRenderbuffers(1,&buffer);
		if(buffer)
		{
			glBindRenderbuffer(GL_RENDERBUFFER,buffer);
			glRenderbufferStorage(GL_RENDERBUFFER,internalformat,width,height);
			// doesn't check for success
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
	if(buffer) glDeleteRenderbuffers(1,&buffer);
	buffer=0;
}

-(void)bind
{
	GLAssertNotDeleted(self,buffer);
	glBindRenderbuffer(GL_RENDERBUFFER,buffer);
}

-(GLuint)renderBufferOpenGL30 { return buffer; }

@end
#endif
