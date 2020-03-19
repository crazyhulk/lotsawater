#import "GLFrameBuffer.h"

#define GLFrameBufferEXT MangleClassName(GLFrameBufferEXT)
@interface GLFrameBufferEXT:GLFrameBuffer
{
	GLuint buffer;
}
@end

#if OPENGL_VERSION>=30
#define GLFrameBufferOpenGL30 MangleClassName(GLFrameBufferOpenGL30)
@interface GLFrameBufferOpenGL30:GLFrameBuffer
{
	GLuint buffer;
}
@end
#endif



@implementation GLFrameBuffer

+(id)allocWithZone:(NSZone *)zone
{
	if(![self isEqual:[GLFrameBuffer class]]) return [super allocWithZone:zone];

	#if OPENGL_VERSION>=30
	if(glGenFramebuffers&&glDeleteFramebuffers&&glBindFramebuffer)
	return [GLFrameBufferOpenGL30 allocWithZone:zone];
	#endif

	return [GLFrameBufferEXT allocWithZone:zone];
}

+(GLFrameBuffer *)frameBufferWithTexture2D:(GLTexture *)tex
{
	GLFrameBuffer *framebuf=[[GLFrameBuffer new] autorelease];
	GLRenderBuffer *depthbuf=[[[GLRenderBuffer alloc] initWithInternalFormat:GL_DEPTH_COMPONENT16
	width:[tex width] height:[tex height]] autorelease];

	if(!depthbuf) return nil;

	[framebuf attachDepthBuffer:depthbuf];
	[framebuf attachTexture:tex];
	return framebuf;
}

+(GLuint)currentFrameBuffer
{
	GLint curr;
	#if OPENGL_VERSION>=30
	glGetIntegerv(GL_FRAMEBUFFER_BINDING,&curr);
	#else
	glGetIntegerv(GL_FRAMEBUFFER_BINDING_EXT,&curr);
	#endif
	return (GLuint)curr;
}

-(id)init
{
	if((self=[super init]))
	{
		buffers=[NSMutableArray new];
	}
	return self;
}

-(void)dealloc
{
	[buffers release];
	[super dealloc];
}

-(void)delete
{
	[buffers makeObjectsPerformSelector:@selector(delete)];
}




-(void)attachTexture:(GLTexture *)tex to:(GLenum)attachment level:(GLint)level
{ [self doesNotRecognizeSelector:_cmd];  }

-(void)attachTexture:(GLTexture *)tex
{
	[self attachTexture:tex to:GL_COLOR_ATTACHMENT0 level:0];
}

-(void)attachRenderBuffer:(GLRenderBuffer *)buf to:(GLenum)attachment
{ [self doesNotRecognizeSelector:_cmd];  }

-(void)attachDepthBuffer:(GLRenderBuffer *)buf
{
	[self attachRenderBuffer:buf to:GL_DEPTH_ATTACHMENT];
}

-(void)attachStencilBuffer:(GLRenderBuffer *)buf
{
	[self attachRenderBuffer:buf to:GL_STENCIL_ATTACHMENT];
}

-(void)bind { [self doesNotRecognizeSelector:_cmd]; }

-(void)bindDefault { [self doesNotRecognizeSelector:_cmd]; }

-(BOOL)complete { [self doesNotRecognizeSelector:_cmd]; return NO; }

-(BOOL)unsupported { [self doesNotRecognizeSelector:_cmd]; return NO; }

@end



@implementation GLFrameBufferEXT

-(id)init
{
	if((self=[super init]))
	{
		glGenFramebuffersEXT(1,&buffer);
		if(buffer) return self;

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
	if(buffer) glDeleteFramebuffersEXT(1,&buffer);
	buffer=0;
	[super delete];
}

-(void)attachTexture:(GLTexture *)tex to:(GLenum)attachment level:(GLint)level
{
	GLAssertNotDeleted(self,buffer);

	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT,buffer);
	glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT,attachment,[tex target],[tex texture],level);
	[buffers addObject:tex];
}

-(void)attachRenderBuffer:(GLRenderBuffer *)buf to:(GLenum)attachment
{
	GLAssertNotDeleted(self,buffer);

	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT,buffer);
	glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT,attachment,GL_RENDERBUFFER_EXT,
	[(GLRenderBufferEXT *)buf renderBufferEXT]);
	[buffers addObject:buf];
}

-(void)bind
{
	GLAssertNotDeleted(self,buffer);

	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT,buffer);
}

-(void)bindDefault { glBindFramebufferEXT(GL_FRAMEBUFFER_EXT,0); }

-(BOOL)complete
{
	GLAssertNotDeleted(self,buffer);

	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT,buffer);
	return glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT)==GL_FRAMEBUFFER_COMPLETE_EXT;
}

-(BOOL)unsupported
{
	GLAssertNotDeleted(self,buffer);

	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT,buffer);
	return glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT)==GL_FRAMEBUFFER_UNSUPPORTED_EXT;
}

@end




#if OPENGL_VERSION>=30
@implementation GLFrameBufferOpenGL30

-(id)init
{
	if((self=[super init]))
	{
		glGenFramebuffers(1,&buffer);
		if(buffer) return self;

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
	if(buffer) glDeleteFramebuffers(1,&buffer);
	buffer=0;
	[super delete];
}

-(void)attachTexture:(GLTexture *)tex to:(GLenum)attachment level:(GLint)level
{
	GLAssertNotDeleted(self,buffer);

	glBindFramebuffer(GL_FRAMEBUFFER,buffer);
	glFramebufferTexture2D(GL_FRAMEBUFFER,attachment,[tex target],[tex texture],level);
	[buffers addObject:tex];
}

-(void)attachRenderBuffer:(GLRenderBuffer *)buf to:(GLenum)attachment
{
	GLAssertNotDeleted(self,buffer);

	glBindFramebuffer(GL_FRAMEBUFFER,buffer);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER,attachment,GL_RENDERBUFFER,
	[(GLRenderBufferOpenGL30 *)buf renderBufferOpenGL30]);
	[buffers addObject:buf];
}

-(void)bind
{
	GLAssertNotDeleted(self,buffer);

	glBindFramebuffer(GL_FRAMEBUFFER,buffer);
}

-(void)bindDefault { glBindFramebuffer(GL_FRAMEBUFFER,0); }

-(BOOL)complete
{
	GLAssertNotDeleted(self,buffer);

	glBindFramebuffer(GL_FRAMEBUFFER,buffer);
	return glCheckFramebufferStatus(GL_FRAMEBUFFER)==GL_FRAMEBUFFER_COMPLETE;
}

-(BOOL)unsupported
{
	GLAssertNotDeleted(self,buffer);

	glBindFramebuffer(GL_FRAMEBUFFER,buffer);
	return glCheckFramebufferStatus(GL_FRAMEBUFFER)==GL_FRAMEBUFFER_UNSUPPORTED;
}

@end
#endif
