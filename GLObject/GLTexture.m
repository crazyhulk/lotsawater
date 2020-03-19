#import "GLTexture.h"


@implementation GLTexture

+(GLTexture *)texture2DWithWidth:(GLuint)width height:(GLuint)height
{
	return [[[self alloc] initWithTarget:GL_TEXTURE_2D internalFormat:GL_RGB8
	width:width height:height format:GL_RGB type:GL_INT] autorelease];
}

+(GLTexture *)textureRectangleWithWidth:(GLuint)width height:(GLuint)height
{
	return [[[self alloc] initWithTarget:GL_TEXTURE_RECTANGLE_EXT internalFormat:GL_RGB8
	width:width height:height format:GL_RGB type:GL_INT] autorelease];
}

+(GLTexture *)alphaTexture2DWithWidth:(GLuint)width height:(GLuint)height
{
	return [[[self alloc] initWithTarget:GL_TEXTURE_2D internalFormat:GL_RGBA8
	width:width height:height format:GL_RGBA type:GL_INT] autorelease];
}

+(GLTexture *)alphaTextureRectangleWithWidth:(GLuint)width height:(GLuint)height
{
	return [[[self alloc] initWithTarget:GL_TEXTURE_RECTANGLE_EXT internalFormat:GL_RGBA8
	width:width height:height format:GL_RGBA type:GL_INT] autorelease];
}


+(GLenum)internalFormatForBitmap:(GLBitmap *)bitmap
{
	switch([bitmap numberOfComponents])
	{
		case 1: return GL_LUMINANCE;
		case 3: return GL_RGB;
		default: return GL_RGBA;
	}
}

+(GLTexture *)texture2DWithBitmap:(GLBitmap *)bitmap
{
	return [[[self alloc] initWithTarget:GL_TEXTURE_2D bitmap:bitmap
	internalFormat:[self internalFormatForBitmap:bitmap] mipmap:NO copy:NO] autorelease];
}

+(GLTexture *)textureRectangleWithBitmap:(GLBitmap *)bitmap
{
	return [[[self alloc] initWithTarget:GL_TEXTURE_RECTANGLE_EXT bitmap:bitmap
	internalFormat:[self internalFormatForBitmap:bitmap] mipmap:NO copy:NO] autorelease];
}

+(GLTexture *)mipmappedTexture2DWithBitmap:(GLBitmap *)bitmap
{
	return [[[self alloc] initWithTarget:GL_TEXTURE_2D bitmap:bitmap
	internalFormat:[self internalFormatForBitmap:bitmap] mipmap:YES copy:NO] autorelease];
}



+(GLTexture *)texture2DWithContentsOfFile:(NSString *)filename internalFormat:(GLenum)intformat
{
	return [[[self alloc] initWithTarget:GL_TEXTURE_2D
	bitmap:[GLBitmap bitmapWithContentsOfFile:filename]
	internalFormat:intformat mipmap:NO copy:NO] autorelease];
}

+(GLTexture *)textureRectangleWithContentsOfFile:(NSString *)filename internalFormat:(GLenum)intformat
{
	return [[[self alloc] initWithTarget:GL_TEXTURE_RECTANGLE_EXT
	bitmap:[GLBitmap bitmapWithContentsOfFile:filename]
	internalFormat:intformat mipmap:NO copy:NO] autorelease];
}

+(GLTexture *)mipmappedTexture2DWithContentsOfFile:(NSString *)filename internalFormat:(GLenum)intformat
{
	return [[[self alloc] initWithTarget:GL_TEXTURE_2D
	bitmap:[GLBitmap bitmapWithContentsOfFile:filename]
	internalFormat:intformat mipmap:YES copy:NO] autorelease];
}



+(GLTexture *)texture2DWithContentsOfResource:(NSString *)filename internalFormat:(GLenum)intformat
{
	return [[[self alloc] initWithTarget:GL_TEXTURE_2D
	bitmap:[GLBitmap bitmapWithContentsOfResource:filename]
	internalFormat:intformat mipmap:NO copy:NO] autorelease];
}

+(GLTexture *)textureRectangleWithContentsOfResource:(NSString *)filename internalFormat:(GLenum)intformat
{
	return [[[self alloc] initWithTarget:GL_TEXTURE_RECTANGLE_EXT
	bitmap:[GLBitmap bitmapWithContentsOfResource:filename]
	internalFormat:intformat mipmap:NO copy:NO] autorelease];
}

+(GLTexture *)mipmappedTexture2DWithContentsOfResource:(NSString *)filename internalFormat:(GLenum)intformat
{
	return [[[self alloc] initWithTarget:GL_TEXTURE_2D
	bitmap:[GLBitmap bitmapWithContentsOfResource:filename]
	internalFormat:intformat mipmap:YES copy:NO] autorelease];
}



+(GLuint)current1DTexture { return [self currentTextureForBinding:GL_TEXTURE_BINDING_1D]; }

+(GLuint)current2DTexture { return [self currentTextureForBinding:GL_TEXTURE_BINDING_2D]; }

+(GLuint)current3DTexture { return [self currentTextureForBinding:GL_TEXTURE_BINDING_3D]; }

+(GLuint)currentCubeMapTexture { return [self currentTextureForBinding:GL_TEXTURE_BINDING_CUBE_MAP]; }

+(GLuint)currentRectangleTexture { return [self currentTextureForBinding:GL_TEXTURE_BINDING_RECTANGLE_EXT]; }

+(GLuint)currentTextureForBinding:(GLenum)binding
{
	GLint curr;
	glGetIntegerv(binding,&curr);
	return (GLuint)curr;
}



-(id)initWithTarget:(GLenum)textarget
{
	if((self=[super init]))
	{
		target=textarget;
		bitmaps=nil;

		glGenTextures(1,&tex);
		if(tex) return self;
		[self release];
	}
	return nil;
}

-(id)initWithTarget:(GLenum)textarget internalFormat:(GLenum)intformat
width:(GLuint)width height:(GLuint)height format:(GLenum)format type:(GLenum)type
{
	if((self=[self initWithTarget:textarget]))
	{
		glBindTexture(target,tex);
		glTexImage2D(target,0,intformat,width,height,0,format,type,NULL);
	}

	return self;
}

-(id)initWithTarget:(GLenum)textarget bitmap:(GLBitmap *)bm
internalFormat:(GLenum)intformat mipmap:(BOOL)mipmap copy:(BOOL)copy
{
	if((self=[self initWithTarget:textarget]))
	{
		if([self uploadBitmap:bm toTarget:textarget internalFormat:intformat mipmap:mipmap copy:copy])
		return self;

		[self delete];
		[self release];
	}
	return nil;
}

-(id)initWithFront:(GLBitmap *)front back:(GLBitmap *)back left:(GLBitmap *)left
right:(GLBitmap *)right top:(GLBitmap *)top bottom:(GLBitmap *)bottom
internalFormat:(GLenum)intformat mipmap:(BOOL)mipmap copy:(BOOL)copy
{
	if((self=[self initWithTarget:GL_TEXTURE_CUBE_MAP]))
	{
		if([self uploadBitmap:front toTarget:GL_TEXTURE_CUBE_MAP_POSITIVE_Z internalFormat:intformat mipmap:mipmap copy:copy])
		if([self uploadBitmap:back toTarget:GL_TEXTURE_CUBE_MAP_NEGATIVE_Z internalFormat:intformat mipmap:mipmap copy:copy])
		if([self uploadBitmap:left toTarget:GL_TEXTURE_CUBE_MAP_NEGATIVE_X internalFormat:intformat mipmap:mipmap copy:copy])
		if([self uploadBitmap:right toTarget:GL_TEXTURE_CUBE_MAP_POSITIVE_X internalFormat:intformat mipmap:mipmap copy:copy])
		if([self uploadBitmap:top toTarget:GL_TEXTURE_CUBE_MAP_POSITIVE_Y internalFormat:intformat mipmap:mipmap copy:copy])
		if([self uploadBitmap:bottom toTarget:GL_TEXTURE_CUBE_MAP_NEGATIVE_Y internalFormat:intformat mipmap:mipmap copy:copy])
		return self;

		[self delete];
		[self release];
	}
	return self;
}

-(void)dealloc
{
	GLWarnIfNotDeleted(self,tex);
	[bitmaps release];
	[super dealloc];
}

-(void)finalize
{
	GLWarnIfNotDeleted(self,tex);
	[super finalize];
}

-(void)delete
{
	if(tex) glDeleteTextures(1,&tex);
	tex=0;
}



-(BOOL)uploadBitmap:(GLBitmap *)bm internalFormat:(GLenum)intformat
{
	return [self uploadBitmap:bm toTarget:target internalFormat:intformat mipmap:NO copy:YES];
}

-(BOOL)uploadBitmap:(GLBitmap *)bm internalFormat:(GLenum)intformat mipmap:(BOOL)mipmap
{
	return [self uploadBitmap:bm toTarget:target internalFormat:intformat mipmap:mipmap copy:YES];
}

-(BOOL)uploadBitmap:(GLBitmap *)bm internalFormat:(GLenum)intformat mipmap:(BOOL)mipmap copy:(BOOL)copy
{
	return [self uploadBitmap:bm toTarget:target internalFormat:intformat mipmap:mipmap copy:copy];
}

-(BOOL)uploadBitmap:(GLBitmap *)bm toTarget:(GLenum)textarget internalFormat:(GLenum)intformat mipmap:(BOOL)mipmap copy:(BOOL)copy
{
	GLAssertNotDeleted(self,tex);

	if(!bm) return NO;

	glBindTexture(target,tex);

	if(mipmap) glTexParameteri(textarget,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR);
	else glTexParameteri(textarget,GL_TEXTURE_MIN_FILTER,GL_LINEAR);

	glTexParameteri(textarget,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(textarget,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
	glTexParameteri(textarget,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
	//glTexParameteri(textarget,GL_TEXTURE_WRAP_S,GL_CLAMP);
	//glTexParameteri(textarget,GL_TEXTURE_WRAP_T,GL_CLAMP);

	int width=[bm width];
	int height=[bm height];
	GLuint format=[bm format];
	GLuint type=[bm type];
	void *pixels=[bm pixels];

	//glPixelStorei(GL_UNPACK_ROW_LENGTH,bytesperrow/pixelsize);
	//glPixelStorei(GL_UNPACK_ALIGNMENT,align);

	//glPixelStorei(GL_UNPACK_SKIP_PIXELS,0);
	//glPixelStorei(GL_UNPACK_SKIP_ROWS,0);
	//glPixelStorei(GL_UNPACK_SKIP_IMAGES,0);

	if(copy)
	{
		while(glGetError()!=GL_NO_ERROR); // Clear error flags
		if(mipmap) gluBuild2DMipmaps(textarget,intformat,width,height,format,type,pixels);
		else glTexImage2D(textarget,0,intformat,width,height,0,format,type,pixels);
		if(glGetError()!=GL_NO_ERROR) return NO;
	}
	else
	{
		glPixelStorei(GL_UNPACK_CLIENT_STORAGE_APPLE,GL_TRUE);

		while(glGetError()!=GL_NO_ERROR); // Clear error flags
		glTexImage2D(textarget,0,intformat,width,height,0,format,type,pixels);
		if(glGetError()!=GL_NO_ERROR) return NO;

		if(!bitmaps) bitmaps=[NSMutableArray new];
		[bitmaps addObject:bm];

		if(mipmap)
		{
			int level=1;
			while(width>1||height>1)
			{
				bm=[bm halfSizedBitmap];
				width=[bm width];
				height=[bm height];
				pixels=[bm pixels];

				while(glGetError()!=GL_NO_ERROR); // Clear error flags
				glTexImage2D(textarget,level++,intformat,width,height,0,format,type,pixels);
				if(glGetError()!=GL_NO_ERROR) return NO;

				[bitmaps addObject:bm];
			}
		}
	}
	return YES;
}

-(void)bind
{
	GLAssertNotDeleted(self,tex);
	glBindTexture(target,tex);
}

-(void)bindToTextureUnit:(GLenum)unit
{
	GLAssertNotDeleted(self,tex);
	glActiveTexture(unit);
	glBindTexture(target,tex);
}



-(GLenum)target { return target; }

-(GLuint)texture { return tex; }

-(GLuint)width
{
	GLAssertNotDeleted(self,tex);

	glBindTexture(target,tex);

	GLint width;
	glGetTexLevelParameteriv(target,0,GL_TEXTURE_WIDTH,&width);

	return (GLuint)width;
}

-(GLuint)height
{
	GLAssertNotDeleted(self,tex);

	glBindTexture(target,tex);

	GLint height;
	glGetTexLevelParameteriv(target,0,GL_TEXTURE_HEIGHT,&height);

	return (GLuint)height;
}

-(NSString *)description
{
	if(!tex) return [NSString stringWithFormat:@"<%@: deleted texture, bitmap data %@>",[self class],bitmaps];
	return [NSString stringWithFormat:@"<%@: texture number %d, bitmap data %@>",[self class],tex,bitmaps];
}

-(unsigned)hash { return tex; }

@end
