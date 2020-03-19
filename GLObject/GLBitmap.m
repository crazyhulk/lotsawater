#import "GLBitmap.h"

#ifndef USE_LIBPNG
#import <AppKit/AppKit.h>
#endif

@implementation GLBitmap

+(GLBitmap *)RGBBitmapWithWidth:(int)pixelwidth height:(int)pixelheight
{
	return [[[self alloc] initWithWidth:pixelwidth height:pixelheight
	format:GL_RGB type:GL_UNSIGNED_BYTE pixels:NULL freeWhenDone:YES] autorelease];
}

+(GLBitmap *)RGBABitmapWithWidth:(int)pixelwidth height:(int)pixelheight
{
	return [[[self alloc] initWithWidth:pixelwidth height:pixelheight
	format:GL_RGBA type:GL_UNSIGNED_BYTE pixels:NULL freeWhenDone:YES] autorelease];
}

+(GLBitmap *)bitmapWithContentsOfFile:(NSString *)filename
{
	return [[[self alloc] initWithContentsOfFile:filename] autorelease];
}

+(GLBitmap *)bitmapWithContentsOfResource:(NSString *)filename
{
	return [[[self alloc] initWithContentsOfFile:
	[[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:nil]]
	autorelease];
}

-(id)init
{
	if((self=[super init]))
	{
		pixels=NULL;
		width=height=0;
		type=format=0;
	}
	return self;
}

-(id)initWithWidth:(int)pixelwidth height:(int)pixelheight format:(GLuint)pixelformat
type:(GLuint)sampletype;
{
	return [self initWithWidth:pixelwidth height:pixelheight format:pixelformat
	type:sampletype pixels:NULL freeWhenDone:YES];
}

-(id)initWithWidth:(int)pixelwidth height:(int)pixelheight format:(GLuint)pixelformat
type:(GLuint)sampletype pixels:(void *)pixelbytes freeWhenDone:(BOOL)free
{
	if((self=[self init]))
	{
		if(pixelbytes)
		{
			width=pixelwidth;
			height=pixelheight;
			type=sampletype;
			format=pixelformat;

			pixels=pixelbytes;
			freewhendone=free;

			return self;
		}
		else
		{
			if([self allocWithWidth:pixelwidth height:pixelheight format:pixelformat type:sampletype])
			return self;
		}

		[self release];
	}
	return nil;
}

-(id)initWithContentsOfFile:(NSString *)filename
{
	if((self=[self init]))
	{
		if([self loadDataFromFile:filename]) return self;

		[self release];
	}
	return nil;
}

-(void)dealloc
{
	if(freewhendone) free(pixels);
	[super dealloc];
}

-(BOOL)allocWithWidth:(int)pixelwidth height:(int)pixelheight format:(GLuint)pixelformat type:(GLuint)sampletype
{
	free(pixels);
	pixels=NULL;
	width=height=0;

	type=sampletype;
	format=pixelformat;

	int numbytes=pixelwidth*pixelheight*[self bytesPerPixel];
	pixels=calloc(numbytes,1);
	if(!pixels) return NO;

	width=pixelwidth;
	height=pixelheight;
	freewhendone=YES;

	return YES;
}

-(void *)pixels { return pixels; }

-(int)width { return width; }

-(int)height { return height; }

-(GLuint)format { return format; }

-(GLuint)type { return type; }

-(int)bytesPerComponent
{
	switch(type)
	{
		case GL_BYTE:
		case GL_UNSIGNED_BYTE:
		case GL_UNSIGNED_INT_8_8_8_8:
		case GL_UNSIGNED_INT_8_8_8_8_REV:
			return 1;

		case GL_SHORT:
		case GL_UNSIGNED_SHORT:
			return 2;

		case GL_INT:
		case GL_UNSIGNED_INT:
			return 4;

		case GL_FLOAT:
			return 4;

		#ifdef GL_HALF_FLOAT_ARB
		case GL_HALF_FLOAT_ARB:
		#else
		#ifdef GL_HALF_APPLE
		case GL_HALF_APPLE:
		#endif
		#endif
			return 2;

		default:
			[NSException raise:@"GLBitmapException" format:@"Unsupported data type %d",type];
			return 0;
	}
}

-(int)numberOfComponents
{
	switch(format)
	{
		case GL_LUMINANCE:
		case GL_ALPHA:
			return 1;

		case GL_RGB:
			return 3;

		case GL_BGRA:
		case GL_RGBA:
			return 4;

		default:
			[NSException raise:@"GLBitmapException" format:@"Unsupported pixel format %d",format];
			return 0;
	}
}

-(int)bytesPerPixel
{
	return [self bytesPerComponent]*[self numberOfComponents];
}

-(GLBitmap *)halfSizedBitmap
{
	if(width==1&&height==1) return nil;

	int comps=[self numberOfComponents];
	int halfwidth=width/2,halfheight=height/2;
	if(halfwidth==0) halfwidth=1;
	if(halfheight==0) halfheight=1;

	GLBitmap *half=[[[GLBitmap alloc] initWithWidth:halfwidth height:halfheight
	format:format type:type pixels:NULL freeWhenDone:YES] autorelease];

	// TODO: This code is kind of incomplete. Add more logic for more type/format combinations.
	int alphaindex=-1;
	switch(format)
	{
		case GL_BGRA:
			#ifdef __BIG_ENDIAN__
			if(type==GL_UNSIGNED_INT_8_8_8_8_REV) alphaindex=0;
			else if(type==GL_UNSIGNED_INT_8_8_8_8) alphaindex=3;
			#else
			if(type==GL_UNSIGNED_INT_8_8_8_8) alphaindex=0;
			else if(type==GL_UNSIGNED_INT_8_8_8_8_REV) alphaindex=3;
			#endif
			if(type==GL_UNSIGNED_BYTE) alphaindex=3;
		break;

		case GL_RGBA:
			if(type==GL_UNSIGNED_BYTE) alphaindex=3;
		break;

		case GL_LUMINANCE_ALPHA:
			if(type==GL_UNSIGNED_BYTE) alphaindex=1;
		break;
	}

	switch(type)
	{
		case GL_UNSIGNED_BYTE:
		case GL_UNSIGNED_INT_8_8_8_8:
		case GL_UNSIGNED_INT_8_8_8_8_REV:
			if(width>1&&height>1)
			{
				GLubyte *src=pixels;
				GLubyte *dest=[half pixels];
				int compsperrow=width*comps;

				for(int y=0;y<halfheight;y++)
				{
					for(int x=0;x<halfwidth;x++)
					{
						if(alphaindex>=0)
						{
							int alpha1=src[alphaindex],alpha2=src[alphaindex+comps],alpha3=src[alphaindex+compsperrow],alpha4=src[alphaindex+compsperrow+comps];
							int alphasum=alpha1+alpha2+alpha3+alpha4;
							dest[alphaindex]=alphasum/4;

							if(alphasum==0) alphasum=1;
							for(int i=0;i<comps;i++)
							{
								if(i!=alphaindex)
								dest[i]=(src[i]*alpha1+src[i+comps]*alpha2+src[i+compsperrow]*alpha3+src[i+compsperrow+comps]*alpha4)/alphasum;
							}
						}
						else
						{
							for(int i=0;i<comps;i++)
							{
								dest[i]=(src[i]+src[i+comps]+src[i+compsperrow]+src[i+compsperrow+comps])/4;
							}
						}
						src+=2*comps;
						dest+=comps;
					}
					src+=compsperrow;
					if(width%2) src+=comps;
				}
			}
			else
			{
				GLubyte *src=pixels;
				GLubyte *dest=[half pixels];
				int num=halfwidth*halfheight;

				for(int j=0;j<num;j++)
				{
					if(alphaindex>=0)
					{
						int alpha1=src[alphaindex],alpha2=src[alphaindex+comps];
						int alphasum=alpha1+alpha2;
						dest[alphaindex]=alphasum/2;

						if(alphasum==0) alphasum=1;
						for(int i=0;i<comps;i++)
						{
							if(i!=alphaindex)
							dest[i]=(src[i]*alpha1+src[i+comps]*alpha2)/alphasum;
						}
					}
					else
					{
						for(int i=0;i<comps;i++)
						{
							dest[i]=(src[i]+src[i+comps])/2;
						}
					}
					src+=2*comps;
					dest+=comps;
				}
			}
		break;

//		case GL_UNSIGNED_SHORT:
//		break;

		default:
			[NSException raise:@"GLBitmapException" format:@"Cannot scale data type %d",type];
			return nil;
	}

	return half;
}

-(void)blitBitmap:(GLBitmap *)other atX:(int)x y:(int)y
{
	if(format!=[other format]) return;
	if(type!=[other type]) return;

	int srcx=0,srcy=0;
	int destx=x,desty=y;
	int copywidth=[other width],copyheight=[other height];

	if(destx+copywidth<=0) return;
	if(desty+copyheight<=0) return;
	if(destx>=width) return;
	if(desty>=height) return;

	if(destx+copywidth>width) copywidth=width-destx;
	if(desty+copyheight>height) copyheight=height-desty;
	if(destx<0) { copywidth+=destx; destx=0; }
	if(desty<0) { copyheight+=desty; desty=0; }

	[self _copyFromBitmap:other x:srcx y:srcy toX:destx y:desty width:copywidth height:copyheight];
}

-(void)_copyFromBitmap:(GLBitmap *)srcbitmap x:(int)srcx y:(int)srcy toX:(int)destx y:(int)desty
width:(int)copywidth height:(int)copyheight
{
	int bytesperpixel=[self bytesPerPixel];
	int srcwidth=[srcbitmap width];
	uint8_t *srcpixels=[srcbitmap pixels];
	uint8_t *destpixels=pixels;
	uint8_t *src=&srcpixels[(srcx+srcy*srcwidth)*bytesperpixel];
	uint8_t *dest=&destpixels[(destx+desty*width)*bytesperpixel];

	for(int row=0;row<copyheight;row++)
	{
		memcpy(dest,src,copywidth*bytesperpixel);
		src+=srcwidth*bytesperpixel;
		dest+=width*bytesperpixel;
	}
}



-(BOOL)saveToPPMFile:(NSString *)filename
{
	return NO;
}


#ifndef USE_LIBPNG

-(BOOL)loadDataFromFile:(NSString *)filename
{
	NSBitmapImageRep *bm=[NSBitmapImageRep imageRepWithContentsOfFile:filename];
	if([bm isPlanar]) return NO;

	int bytesperpixel;

	NSBitmapFormat bmformat=0;
	if([bm respondsToSelector:@selector(bitmapFormat)]) bmformat=[bm bitmapFormat];

	switch([bm bitsPerPixel])
	{
		case 8:
			format=GL_LUMINANCE;
			type=GL_UNSIGNED_BYTE;
			bytesperpixel=1;
		break;

		case 24:
			format=GL_RGB;
			type=GL_UNSIGNED_BYTE;
			bytesperpixel=3;
		break;

		case 32:
			if(bmformat&NSAlphaFirstBitmapFormat)
			{
				format=GL_BGRA;
				#ifdef __BIG_ENDIAN__
				type=GL_UNSIGNED_INT_8_8_8_8_REV;
				#else
				type=GL_UNSIGNED_INT_8_8_8_8;
				#endif
			}
			else
			{
				format=GL_RGBA;
				type=GL_UNSIGNED_BYTE;
			}
			bytesperpixel=4;
		break;

		default: return NO;
	}

	int pixelwidth=[bm pixelsWide];
	int pixelheight=[bm pixelsHigh];
	int bytesperrow=[bm bytesPerRow];

	if(![self allocWithWidth:pixelwidth height:pixelheight format:format type:type]) return NO;

	uint8_t *srcpixels=[bm bitmapData];
	uint8_t *destpixels=(uint8_t *)pixels;

	for(int y=0;y<pixelheight;y++)
	{
		memcpy(&destpixels[y*pixelwidth*bytesperpixel],&srcpixels[y*bytesperrow],pixelwidth*bytesperpixel);
	}

	return YES;
}

+(NSBitmapFormat)bitmapFormatFor:(NSBitmapImageRep *)bm
{
	if([bm respondsToSelector:@selector(bitmapFormat)]) return [bm bitmapFormat];
	return 0;
}

#else

#ifdef __APPLE__
#import "png.h"
#else
#import <png.h>
#endif

-(BOOL)loadDataFromFile:(NSString *)filename
{
	FILE *fh=fopen([filename fileSystemRepresentation],"rb");
	if(!fh) return NO;

	png_structp png=png_create_read_struct(PNG_LIBPNG_VER_STRING,NULL,NULL,NULL);
	if(!png)
	{
		fclose(fh);
		return NO;
	}

	png_infop info=png_create_info_struct(png);
	if(!info)
	{
		png_destroy_read_struct(&png,NULL,NULL);
		fclose(fh);
		return NO;
	}

	if(setjmp(png_jmpbuf(png)))
	{
		png_destroy_read_struct(&png,&info,NULL);
		fclose(fh);
		return NO;
	}

	png_init_io(png,fh);
	png_read_info(png,info); // read all PNG info up to image data

	int pixelwidth=png_get_image_width(png,info);
	int pixelheight=png_get_image_height(png,info);
	int bit_depth=png_get_bit_depth(png,info);

	switch(png_get_color_type(png,info))
	{
		case PNG_COLOR_TYPE_GRAY:
			if(bit_depth<8) png_set_expand(png); // expand low-bit-depth grayscale images to 8 bits
			format=GL_LUMINANCE;
		break;

		case PNG_COLOR_TYPE_GRAY_ALPHA:
			format=GL_LUMINANCE_ALPHA;
		break;

		case PNG_COLOR_TYPE_PALETTE:
			png_set_expand(png); // expand palette images to RGB, transparency to alpha
			if(png_get_valid(png,info,PNG_INFO_tRNS)) format=GL_RGBA;
			else format=GL_RGB;
		break;

		case PNG_COLOR_TYPE_RGB:
			format=GL_RGB;
		break;

		case PNG_COLOR_TYPE_RGB_ALPHA:
			format=GL_RGBA;
		break;
	}

	if(bit_depth==16)
	{
		type=GL_UNSIGNED_SHORT;
		#ifndef __BIG_ENDIAN__
		png_set_swap(png);
		#endif
	}
	else
	{
		// This code does not work at all? Not sure why.
/*		if(format==GL_RGBA)
		{
			png_set_swap_alpha(png); // make ARGB values instead of RGBA
			format=GL_BGRA;
			#ifdef __BIG_ENDIAN__
			type=GL_UNSIGNED_INT_8_8_8_8_REV;
			#else
			type=GL_UNSIGNED_INT_8_8_8_8;
			#endif
		}
		else*/
		{
			type=GL_UNSIGNED_BYTE;
		}
	}

//	if(png_get_gAMA(png_ptr,info_ptr,&gamma)) png_set_gamma(png_ptr,display_exponent,gamma);

	png_set_interlace_handling(png);
	png_read_update_info(png,info);

	if(![self allocWithWidth:pixelwidth height:pixelheight format:format type:type])
	{
		png_destroy_read_struct(&png,&info,NULL);
		png_destroy_read_struct(&png,NULL,NULL);
		fclose(fh);
		return NO;
	}

	int bytesperrow=width*[self bytesPerPixel];
	if(bytesperrow<png_get_rowbytes(png,info)) [NSException raise:@"GLBitmapException" format:@"Can't happen #1"];

	png_bytep rows[height];
	for(int y=0;y<height;y++) rows[y]=(png_bytep)pixels+y*bytesperrow;

	png_read_image(png,rows);

	png_destroy_read_struct(&png,&info,NULL);
	fclose(fh);

	return YES;
}

#endif

-(NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %dx%d, format %d, type %d>",[self class],width,height,format,type];
}

@end
