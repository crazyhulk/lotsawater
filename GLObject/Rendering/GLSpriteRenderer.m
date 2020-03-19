#import "GLSpriteRenderer.h"
#import "../NSDataArrayAdditions.h"

typedef struct Sprite
{
	float x,y,angle,scale;
	float width,height,dx,dy;
	float s,t;
} Sprite;

@implementation GLSpriteRenderer

-(id)initWithBitmap:(GLBitmap *)bitmap
{
	if(self=[super init])
	{
		spritebitmap=[bitmap retain];
		spritearray=[NSMutableData new];
		width=[bitmap width];
		height=[bitmap height];
		spritetexture=nil;
		vertexbuffer=texcoordbuffer=nil;
	}
	return self;
}

-(void)dealloc
{
	[spritebitmap release];
	[spritearray release];
	[spritetexture release];
	[vertexbuffer release];
	[texcoordbuffer release];

	[super dealloc];
}

-(void)prepareWithResourceManager:(GLResourceManager *)manager
{
	spritetexture=[[manager textureForBitmap:spritebitmap] retain];

	vertexbuffer=[[GLBuffer arrayBuffer] retain];
	texcoordbuffer=[[GLBuffer arrayBuffer] retain];
}

-(void)delete
{
	[vertexbuffer delete];
	[texcoordbuffer delete];
}

-(void)render
{
	glPushAttrib(GL_LIGHTING_BIT|GL_CURRENT_BIT|GL_ENABLE_BIT|GL_TEXTURE_BIT|GL_POLYGON_BIT);
	glPushClientAttrib(GL_CLIENT_VERTEX_ARRAY_BIT);

	glClientActiveTexture(GL_TEXTURE0);

	glDisable(GL_CULL_FACE);
	glEnable(GL_TEXTURE_2D);

	[spritetexture bind];

	/*while(!*/[self createBuffers]/*)*/;

	[vertexbuffer bind];
	glVertexPointer(2,GL_FLOAT,0,NULL);
	glEnableClientState(GL_VERTEX_ARRAY);

	[texcoordbuffer bind];
	glTexCoordPointer(2,GL_FLOAT,0,NULL);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

	glColor3f(1,1,1);

	int numsprites=[spritearray countWithElementSize:sizeof(Sprite)];
	glDrawArrays(GL_QUADS,0,numsprites*4);

	// TODO: should I kill the buffers?

	glPopClientAttrib();
	glPopAttrib();
}

-(BOOL)createBuffers
{
	const Sprite *sprites=[spritearray bytes];
	int numsprites=[spritearray countWithElementSize:sizeof(Sprite)];

	[vertexbuffer setSize:numsprites*4*4*2 usage:GL_STREAM_DRAW];
	float *vertices=[vertexbuffer mapForWriting];

	[texcoordbuffer setSize:numsprites*4*4*2 usage:GL_STREAM_DRAW];
	float *texcoords=[texcoordbuffer mapForWriting];

	for(int i=0;i<numsprites;i++)
	{
		float x0=sprites[i].x,y0=sprites[i].y;
		float a=sprites[i].angle,s=sprites[i].scale;
		float dx1=sprites[i].dx,dy1=sprites[i].dy;
		float dx2=sprites[i].width-dx1,dy2=sprites[i].height-dy1;
		
		float sin_a=s*sinf(a),cos_a=s*cosf(a);

		vertices[8*i+0]=x0-cos_a*dx1-sin_a*dy1;
		vertices[8*i+1]=y0-sin_a*dx1+cos_a*dy1;
		vertices[8*i+2]=x0+cos_a*dx2-sin_a*dy1;
		vertices[8*i+3]=y0+sin_a*dx2+cos_a*dy1;
		vertices[8*i+4]=x0+cos_a*dx2+sin_a*dy2;
		vertices[8*i+5]=y0+sin_a*dx2-cos_a*dy2;
		vertices[8*i+6]=x0-cos_a*dx1+sin_a*dy2;
		vertices[8*i+7]=y0-sin_a*dx1-cos_a*dy2;

		float s1=sprites[i].s/width,t1=sprites[i].t/width;
		float s2=s1+sprites[i].width/width,t2=t1+sprites[i].height/height;

		texcoords[8*i+0]=s1;
		texcoords[8*i+1]=t1;
		texcoords[8*i+2]=s2;
		texcoords[8*i+3]=t1;
		texcoords[8*i+4]=s2;
		texcoords[8*i+5]=t2;
		texcoords[8*i+6]=s1;
		texcoords[8*i+7]=t2;
	}

	return [vertexbuffer unmap]&&[texcoordbuffer unmap];
}

-(void)clearSprites
{
	[spritearray setLength:0];
}

-(void)addSpriteAtX:(float)x y:(float)y angle:(float)angle scale:(float)scale
width:(float)w height:(float)h hotX:(float)hotx hotY:(float)hoty
s:(float)s t:(float)t
{
	Sprite sprite=
	{
		.x=x, .y=y, .angle=angle, .scale=scale,
		.width=w, .height=h, .dx=hotx, .dy=hoty,
		.s=s, .t=t,
	};

	[spritearray appendBytes:&sprite length:sizeof(sprite)];
}

@end
