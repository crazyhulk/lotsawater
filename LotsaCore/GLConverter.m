#import "GLConverter.h"


@implementation GLConverter

+(GLuint)texture2DFromRep:(NSBitmapImageRep *)bm
{
	return [self makeTextureWithRep:bm target:GL_TEXTURE_2D mipmap:NO nocopy:NO];
}

+(GLuint)mipMappedTexture2DFromRep:(NSBitmapImageRep *)bm
{
	return [self makeTextureWithRep:bm target:GL_TEXTURE_2D mipmap:YES nocopy:NO];
}

+(GLuint)textureRectangleFromRep:(NSBitmapImageRep *)bm
{
	return [self makeTextureWithRep:bm target:GL_TEXTURE_RECTANGLE_EXT mipmap:NO nocopy:NO];
}

+(GLuint)textureCubeMapFromFront:(NSBitmapImageRep *)front back:(NSBitmapImageRep *)back left:(NSBitmapImageRep *)left right:(NSBitmapImageRep *)right top:(NSBitmapImageRep *)top bottom:(NSBitmapImageRep *)bottom
{
	return [self makeCubeMapWithFront:front back:back left:left right:right top:top bottom:bottom nocopy:NO];
}

+(GLuint)uncopiedTexture2DFromRep:(NSBitmapImageRep *)bm
{
	return [self makeTextureWithRep:bm target:GL_TEXTURE_2D mipmap:NO nocopy:YES];
}

+(GLuint)uncopiedMipMappedTexture2DFromRep:(NSBitmapImageRep *)bm
{
	return [self makeTextureWithRep:bm target:GL_TEXTURE_2D mipmap:YES nocopy:YES];
}

+(GLuint)uncopiedTextureRectangleFromRep:(NSBitmapImageRep *)bm
{
	return [self makeTextureWithRep:bm target:GL_TEXTURE_RECTANGLE_EXT mipmap:NO nocopy:YES];
}

+(GLuint)uncopiedTextureCubeMapFromFront:(NSBitmapImageRep *)front back:(NSBitmapImageRep *)back left:(NSBitmapImageRep *)left right:(NSBitmapImageRep *)right top:(NSBitmapImageRep *)top bottom:(NSBitmapImageRep *)bottom
{
	return [self makeCubeMapWithFront:front back:back left:left right:right top:top bottom:bottom nocopy:YES];
}

+(void)setAlphaBlendingForRep:(NSBitmapImageRep *)bm
{
	if([self bitmapFormatFor:bm]&NSAlphaNonpremultipliedBitmapFormat)
	{
		glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	}
	else
	{
		glBlendFunc(GL_ONE,GL_ONE_MINUS_SRC_ALPHA);
	}
}




+(GLuint)makeTextureWithRep:(NSBitmapImageRep *)bm target:(GLuint)textarget mipmap:(BOOL)mipmap nocopy:(BOOL)nocopy
{
	GLuint tex;

	glPushClientAttrib(GL_CLIENT_PIXEL_STORE_BIT);
	glPixelStorei(GL_UNPACK_CLIENT_STORAGE_APPLE,nocopy?GL_TRUE:GL_FALSE);

	glGenTextures(1,&tex);
	if(!tex) return 0;

	glBindTexture(textarget,tex);

	[self uploadRep:bm toTarget:textarget mipmap:mipmap];

	glPopClientAttrib();

	return tex;
}

+(GLuint)makeCubeMapWithFront:(NSBitmapImageRep *)front back:(NSBitmapImageRep *)back left:(NSBitmapImageRep *)left right:(NSBitmapImageRep *)right top:(NSBitmapImageRep *)top bottom:(NSBitmapImageRep *)bottom nocopy:(BOOL)nocopy
{
	GLuint tex;
	BOOL mipmap=YES;

	glPushClientAttrib(GL_CLIENT_PIXEL_STORE_BIT);
	glPixelStorei(GL_UNPACK_CLIENT_STORAGE_APPLE,nocopy?GL_TRUE:GL_FALSE);

	glGenTextures(1,&tex);
	if(!tex) return 0;

	glBindTexture(GL_TEXTURE_CUBE_MAP,tex);

	[self uploadRep:front toTarget:GL_TEXTURE_CUBE_MAP_POSITIVE_Z mipmap:mipmap];
	[self uploadRep:back toTarget:GL_TEXTURE_CUBE_MAP_NEGATIVE_Z mipmap:mipmap];
	[self uploadRep:left toTarget:GL_TEXTURE_CUBE_MAP_NEGATIVE_X mipmap:mipmap];
	[self uploadRep:right toTarget:GL_TEXTURE_CUBE_MAP_POSITIVE_X mipmap:mipmap];
	[self uploadRep:top toTarget:GL_TEXTURE_CUBE_MAP_POSITIVE_Y mipmap:mipmap];
	[self uploadRep:bottom toTarget:GL_TEXTURE_CUBE_MAP_NEGATIVE_Y mipmap:mipmap];

	glPopClientAttrib();

	return tex;
}

+(void)uploadRep:(NSBitmapImageRep *)bm toTarget:(GLuint)textarget mipmap:(BOOL)mipmap
{
	if([bm isPlanar]) return;

	GLuint texintformat,texformat,textype;
	int pixelsize;

	switch([bm bitsPerPixel])
	{
		case 8:
			texintformat=GL_LUMINANCE8;
			texformat=GL_LUMINANCE;
			textype=GL_UNSIGNED_BYTE;
			pixelsize=1;
		break;

		case 24:
			texintformat=GL_RGB8;
			texformat=GL_RGB;
			textype=GL_UNSIGNED_BYTE;
			pixelsize=3;
		break;

		case 32:
			if([self bitmapFormatFor:bm]&NSAlphaFirstBitmapFormat)
			{
				texintformat=GL_RGBA8;
				texformat=GL_BGRA;
				#ifdef __BIG_ENDIAN__
				textype=GL_UNSIGNED_INT_8_8_8_8_REV;
				#else
				textype=GL_UNSIGNED_INT_8_8_8_8;
				#endif
				pixelsize=4;
			}
			else
			{
				texintformat=GL_RGBA8;
				texformat=GL_RGBA;
				textype=GL_UNSIGNED_BYTE;
				pixelsize=4;
			}
		break;

		default: return;
	}

	if(mipmap) glTexParameteri(textarget,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST);
	else glTexParameteri(textarget,GL_TEXTURE_MIN_FILTER,GL_LINEAR);

	glTexParameteri(textarget,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(textarget,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
	glTexParameteri(textarget,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
	//glTexParameteri(textarget,GL_TEXTURE_WRAP_S,GL_CLAMP);
	//glTexParameteri(textarget,GL_TEXTURE_WRAP_T,GL_CLAMP);

	int width=[bm pixelsWide];
	int height=[bm pixelsHigh];
	int bytesperrow=[bm bytesPerRow];
	void *pixels=[bm bitmapData];
	int align;

	if((bytesperrow&7)==0) align=8;
	else if((bytesperrow&3)==0) align=4;
	else if((bytesperrow&1)==0) align=2;
	else align=1;

	glPixelStorei(GL_UNPACK_ROW_LENGTH,bytesperrow/pixelsize);
	glPixelStorei(GL_UNPACK_ALIGNMENT,align);

	glPixelStorei(GL_UNPACK_SKIP_PIXELS,0);
	glPixelStorei(GL_UNPACK_SKIP_ROWS,0);
	glPixelStorei(GL_UNPACK_SKIP_IMAGES,0);

	if(mipmap) gluBuild2DMipmaps(textarget,texintformat,width,height,texformat,textype,pixels);
	else glTexImage2D(textarget,0,texintformat,width,height,0,texformat,textype,pixels);
}

+(NSBitmapFormat)bitmapFormatFor:(NSBitmapImageRep *)bm
{
	if([bm respondsToSelector:@selector(bitmapFormat)]) return [bm bitmapFormat];
	return 0;
}

@end
