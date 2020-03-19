#import "GLObject.h"
#import "GLTexture.h"
#import "GLRenderBuffer.h"

#if OPENGL_VERSION<30
#define GL_COLOR_ATTACHMENT0 GL_COLOR_ATTACHMENT0_EXT
#define GL_DEPTH_ATTACHMENT GL_DEPTH_ATTACHMENT_EXT
#define GL_STENCIL_ATTACHMENT GL_STENCIL_ATTACHMENT_EXT
#endif

#define GLFrameBuffer MangleClassName(GLFrameBuffer)

@interface GLFrameBuffer:NSObject
{
	NSMutableArray *buffers;
}

+(GLFrameBuffer *)frameBufferWithTexture2D:(GLTexture *)tex;

+(GLuint)currentFrameBuffer;

-(id)init;

-(void)delete;

-(void)attachTexture:(GLTexture *)tex to:(GLenum)attachment level:(GLint)level;
-(void)attachTexture:(GLTexture *)tex;
-(void)attachRenderBuffer:(GLRenderBuffer *)buffer to:(GLenum)attachment;
-(void)attachDepthBuffer:(GLRenderBuffer *)buffer;
-(void)attachStencilBuffer:(GLRenderBuffer *)buffer;

-(void)bind;
-(void)bindDefault;

-(BOOL)complete;
-(BOOL)unsupported;

@end
