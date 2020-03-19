#import "../GLObject.h"
#import "../GLBitmap.h"
#import "../GLBuffer.h"
#import "../GLTexture.h"
#import "GLResourceManager.h"

@interface GLSpriteRenderer:NSObject
{
	GLBitmap *spritebitmap;
	NSMutableData *spritearray;

	float width,height;

	GLTexture *spritetexture;
	GLBuffer *vertexbuffer,*texcoordbuffer;
}

-(id)initWithBitmap:(GLBitmap *)bitmap;
-(void)dealloc;

-(void)prepareWithResourceManager:(GLResourceManager *)manager;
-(void)delete;

-(void)render;
-(BOOL)createBuffers;

-(void)clearSprites;
-(void)addSpriteAtX:(float)x y:(float)y angle:(float)angle scale:(float)scale
width:(float)w height:(float)h hotX:(float)hotx hotY:(float)hoty
s:(float)s t:(float)t;

@end
