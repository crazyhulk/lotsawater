#import "GLObject.h"

#define GLRenderBuffer MangleClassName(GLRenderBuffer)

@interface GLRenderBuffer:NSObject
{
}

+(GLuint)currentRenderBuffer;

-(id)initWithInternalFormat:(GLenum)internalformat width:(GLsizei)width height:(GLsizei)height;

-(void)delete;

-(void)bind;

@end



#define GLRenderBufferEXT MangleClassName(GLRenderBufferEXT)
@interface GLRenderBufferEXT:GLRenderBuffer
{
	GLuint buffer;
}
-(GLuint)renderBufferEXT;
@end

#if OPENGL_VERSION>=30
#define GLRenderBufferOpenGL30 MangleClassName(GLRenderBufferOpenGL30)
@interface GLRenderBufferOpenGL30:GLRenderBuffer
{
	GLuint buffer;
}
-(GLuint)renderBufferOpenGL30;
@end
#endif
