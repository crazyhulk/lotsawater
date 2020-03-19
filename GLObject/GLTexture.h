#import "GLObject.h"
#import "GLBitmap.h"

#if OPENGL_VERSION<13
#define GL_TEXTURE0 GL_TEXTURE0_ARB
#define GL_TEXTURE1 GL_TEXTURE1_ARB
#define GL_TEXTURE2 GL_TEXTURE2_ARB
#define GL_TEXTURE3 GL_TEXTURE3_ARB
#endif

#define GLTexture MangleClassName(GLTexture)

@interface GLTexture:NSObject
{
	NSMutableArray *bitmaps;
	GLenum target;

	@public
	GLuint tex;
}

+(GLTexture *)texture2DWithWidth:(GLuint)width height:(GLuint)height;
+(GLTexture *)textureRectangleWithWidth:(GLuint)width height:(GLuint)height;
+(GLTexture *)alphaTexture2DWithWidth:(GLuint)width height:(GLuint)height;
+(GLTexture *)alphaTextureRectangleWithWidth:(GLuint)width height:(GLuint)height;

// TODO: clean up internalformat parameters

+(GLenum)internalFormatForBitmap:(GLBitmap *)bitmap;
+(GLTexture *)texture2DWithBitmap:(GLBitmap *)bitmap;
+(GLTexture *)textureRectangleWithBitmap:(GLBitmap *)bitmap;
+(GLTexture *)mipmappedTexture2DWithBitmap:(GLBitmap *)bitmap;

+(GLTexture *)texture2DWithContentsOfFile:(NSString *)filename internalFormat:(GLenum)intformat;
+(GLTexture *)textureRectangleWithContentsOfFile:(NSString *)filename internalFormat:(GLenum)intformat;
+(GLTexture *)mipmappedTexture2DWithContentsOfFile:(NSString *)filename internalFormat:(GLenum)intformat;

+(GLTexture *)texture2DWithContentsOfResource:(NSString *)filename internalFormat:(GLenum)intformat;
+(GLTexture *)textureRectangleWithContentsOfResource:(NSString *)filename internalFormat:(GLenum)intformat;
+(GLTexture *)mipmappedTexture2DWithContentsOfResource:(NSString *)filename internalFormat:(GLenum)intformat;

+(GLuint)current1DTexture;
+(GLuint)current2DTexture;
+(GLuint)current3DTexture;
+(GLuint)currentCubeMapTexture;
+(GLuint)currentRectangleTexture;
+(GLuint)currentTextureForBinding:(GLenum)binding;

-(id)initWithTarget:(GLenum)textarget;
-(id)initWithTarget:(GLenum)textarget internalFormat:(GLenum)intformat
width:(GLuint)width height:(GLuint)height format:(GLenum)format type:(GLenum)type;
-(id)initWithTarget:(GLenum)textarget bitmap:(GLBitmap *)bm
internalFormat:(GLenum)intformat mipmap:(BOOL)mipmap copy:(BOOL)copy;
-(id)initWithFront:(GLBitmap *)front back:(GLBitmap *)back left:(GLBitmap *)left
right:(GLBitmap *)right top:(GLBitmap *)top bottom:(GLBitmap *)bottom
internalFormat:(GLenum)intformat mipmap:(BOOL)mipmap copy:(BOOL)copy;

-(void)dealloc;
-(void)finalize;
-(void)delete;

-(BOOL)uploadBitmap:(GLBitmap *)bm internalFormat:(GLenum)intformat;
-(BOOL)uploadBitmap:(GLBitmap *)bm internalFormat:(GLenum)intformat mipmap:(BOOL)mipmap;
-(BOOL)uploadBitmap:(GLBitmap *)bm internalFormat:(GLenum)intformat mipmap:(BOOL)mipmap copy:(BOOL)copy;
-(BOOL)uploadBitmap:(GLBitmap *)bm toTarget:(GLenum)target internalFormat:(GLenum)intformat mipmap:(BOOL)mipmap copy:(BOOL)copy;

-(void)bind;
-(void)bindToTextureUnit:(GLenum)unit;

-(GLenum)target;
-(GLuint)texture;
-(GLuint)width;
-(GLuint)height;

-(unsigned)hash;

@end

