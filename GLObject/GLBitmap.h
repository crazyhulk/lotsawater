#import "GLObject.h"

#define GLBitmap MangleClassName(GLBitmap)

@interface GLBitmap:NSObject
{
	void *pixels;
	int width,height;
	GLuint format,type;
	BOOL freewhendone;
}

+(GLBitmap *)RGBBitmapWithWidth:(int)pixelwidth height:(int)pixelheight;
+(GLBitmap *)RGBABitmapWithWidth:(int)pixelwidth height:(int)pixelheight;
+(GLBitmap *)bitmapWithContentsOfFile:(NSString *)filename;
+(GLBitmap *)bitmapWithContentsOfResource:(NSString *)filename;

-(id)init;
-(id)initWithWidth:(int)pixelwidth height:(int)pixelheight format:(GLuint)pixelformat
type:(GLuint)sampletype;
-(id)initWithWidth:(int)pixelwidth height:(int)pixelheight format:(GLuint)pixelformat
type:(GLuint)sampletype pixels:(void *)pixelbytes freeWhenDone:(BOOL)free;
-(id)initWithContentsOfFile:(NSString *)filename;
-(void)dealloc;

-(BOOL)allocWithWidth:(int)pixelwidth height:(int)pixelheight format:(GLuint)pixelformat type:(GLuint)sampletype;

-(void *)pixels;
-(int)width;
-(int)height;
-(GLuint)format;
-(GLuint)type;
-(int)bytesPerComponent;
-(int)numberOfComponents;
-(int)bytesPerPixel;

-(GLBitmap *)halfSizedBitmap;

-(void)blitBitmap:(GLBitmap *)other atX:(int)x y:(int)y;
-(void)_copyFromBitmap:(GLBitmap *)srcbitmap x:(int)srcx y:(int)srcy toX:(int)destx y:(int)desty
width:(int)copywidth height:(int)copyheight;

-(BOOL)saveToPPMFile:(NSString *)filename;

-(BOOL)loadDataFromFile:(NSString *)filename;

@end
