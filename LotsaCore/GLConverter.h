#import <Cocoa/Cocoa.h>
//#import <OpenGL/GL.h>
//#import <OpenGL/GLu.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>

#import "NameMangler.h"
#define GLConverter MangleClassName(GLConverter)

@interface GLConverter:NSObject
{
}

+(GLuint)texture2DFromRep:(NSBitmapImageRep *)bm;
+(GLuint)mipMappedTexture2DFromRep:(NSBitmapImageRep *)bm;
+(GLuint)textureRectangleFromRep:(NSBitmapImageRep *)bm;
+(GLuint)textureCubeMapFromFront:(NSBitmapImageRep *)front back:(NSBitmapImageRep *)back left:(NSBitmapImageRep *)left right:(NSBitmapImageRep *)right top:(NSBitmapImageRep *)top bottom:(NSBitmapImageRep *)bottom;

+(GLuint)uncopiedTexture2DFromRep:(NSBitmapImageRep *)bm;
+(GLuint)uncopiedMipMappedTexture2DFromRep:(NSBitmapImageRep *)bm;
+(GLuint)uncopiedTextureRectangleFromRep:(NSBitmapImageRep *)bm;
+(GLuint)uncopiedTextureCubeMapFromFront:(NSBitmapImageRep *)front back:(NSBitmapImageRep *)back left:(NSBitmapImageRep *)left right:(NSBitmapImageRep *)right top:(NSBitmapImageRep *)top bottom:(NSBitmapImageRep *)bottom;

+(void)setAlphaBlendingForRep:(NSBitmapImageRep *)bm;

+(GLuint)makeTextureWithRep:(NSBitmapImageRep *)bm target:(GLuint)textarget mipmap:(BOOL)mipmap nocopy:(BOOL)nocopy;
+(GLuint)makeCubeMapWithFront:(NSBitmapImageRep *)front back:(NSBitmapImageRep *)back left:(NSBitmapImageRep *)left right:(NSBitmapImageRep *)right top:(NSBitmapImageRep *)top bottom:(NSBitmapImageRep *)bottom nocopy:(BOOL)nocopy;

+(void)uploadRep:(NSBitmapImageRep *)bm toTarget:(GLuint)textarget mipmap:(BOOL)mipmap;

+(NSBitmapFormat)bitmapFormatFor:(NSBitmapImageRep *)bm;

@end
