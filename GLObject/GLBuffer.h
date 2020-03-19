#import "GLObject.h"

#if OPENGL_VERSION<15
#define GL_ARRAY_BUFFER GL_ARRAY_BUFFER_ARB
#define GL_ELEMENT_ARRAY_BUFFER GL_ELEMENT_ARRAY_BUFFER_ARB
#define GL_STREAM_DRAW GL_STREAM_DRAW_ARB
#define GL_STREAM_READ GL_STREAM_READ_ARB
#define GL_STREAM_COPY GL_STREAM_COPY_ARB
#define GL_STATIC_DRAW GL_STATIC_DRAW_ARB
#define GL_STATIC_READ GL_STATIC_READ_ARB
#define GL_STATIC_COPY GL_STATIC_COPY_ARB
#define GL_DYNAMIC_DRAW GL_DYNAMIC_DRAW_ARB
#define GL_DYNAMIC_READ GL_DYNAMIC_READ_ARB
#define GL_DYNAMIC_COPY GL_DYNAMIC_COPY_ARB
#endif

#if OPENGL_VERSION<21
#ifdef GL_PIXEL_PACK_BUFFER_ARB
#define GL_PIXEL_PACK_BUFFER GL_PIXEL_PACK_BUFFER_ARB
#define GL_PIXEL_UNPACK_BUFFER GL_PIXEL_UNPACK_BUFFER_ARB
#else
#define GL_PIXEL_PACK_BUFFER GL_PIXEL_PACK_BUFFER_EXT
#define GL_PIXEL_UNPACK_BUFFER GL_PIXEL_UNPACK_BUFFER_EXT
#endif
#endif

#define GLBuffer MangleClassName(GLBuffer)

@interface GLBuffer:NSObject
{
}

+(GLBuffer *)arrayBuffer;
+(GLBuffer *)arrayBufferWithSize:(GLsizeiptr)size usage:(GLenum)usage;
+(GLBuffer *)arrayBufferWithSize:(GLsizeiptr)size bytes:(const void *)bytes;
+(GLBuffer *)arrayBufferWithSize:(GLsizeiptr)size bytes:(const void *)bytes usage:(GLenum)usage;
+(GLBuffer *)arrayBufferWithData:(NSData *)data;
+(GLBuffer *)arrayBufferWithData:(NSData *)data usage:(GLenum)usage;
+(GLBuffer *)elementArrayBuffer;
+(GLBuffer *)elementArrayBufferWithSize:(GLsizeiptr)size usage:(GLenum)usage;
+(GLBuffer *)elementArrayBufferWithSize:(GLsizeiptr)size bytes:(const void *)bytes;
+(GLBuffer *)elementArrayBufferWithSize:(GLsizeiptr)size bytes:(const void *)bytes usage:(GLenum)usage;
+(GLBuffer *)elementArrayBufferWithData:(NSData *)data;
+(GLBuffer *)elementArrayBufferWithData:(NSData *)data usage:(GLenum)usage;

+(GLuint)currentArrayBuffer;
+(GLuint)currentElementArrayBuffer;
+(GLuint)currentPixelPackBuffer;
+(GLuint)currentPixelUnpackBuffer;
+(GLuint)currentBufferForBinding:(GLenum)binding;

-(id)initWithTarget:(GLenum)buffertarget;
-(id)initWithTarget:(GLenum)buffertarget size:(GLsizeiptr)size usage:(GLenum)usage;
-(id)initWithTarget:(GLenum)buffertarget size:(GLsizeiptr)size bytes:(const void *)bytes;
-(id)initWithTarget:(GLenum)buffertarget size:(GLsizeiptr)size bytes:(const void *)bytes usage:(GLenum)usage;

-(void)delete;

-(void)bind;

-(void)setSize:(GLsizeiptr)size usage:(GLenum)usage;
-(void)setSize:(GLsizeiptr)size bytes:(const void *)bytes usage:(GLenum)usage;

-(const void *)mapForReading;
-(void *)mapForWriting;
-(void *)mapForReadingAndWriting;
-(BOOL)unmap;

@end
