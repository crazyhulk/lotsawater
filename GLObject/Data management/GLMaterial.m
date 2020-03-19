#import "GLMaterial.h"


@implementation GLMaterial

+(GLMaterial *)materialWithName:(NSString *)materialname
{
	return [[[self alloc] initWithName:materialname] autorelease];
}

+(GLMaterial *)defaultMaterial
{
	static GLMaterial *defmat=nil;
	if(!defmat) defmat=[[self alloc] initWithName:@"__defaultmaterial__"];
	return defmat;
}

-(id)init { return [self initWithName:nil]; }

-(id)initWithName:(NSString *)materialname
{
	if(self=[super init])
	{
		name=[materialname retain];

		ambient[0]=1;
		ambient[1]=1;
		ambient[2]=1;
		ambient[3]=1;
		diffuse[0]=1;
		diffuse[1]=1;
		diffuse[2]=1;
		diffuse[3]=1;
		specular[0]=1;
		specular[1]=1;
		specular[2]=1;
		specular[3]=1;
		emission[0]=0;
		emission[1]=0;
		emission[2]=0;
		emission[3]=1;
		phong=16;
		bitmap=nil;
		vertexcode=nil;
		fragmentcode=nil;

//		texture=nil;
//		program=nil;
	}
	return self;
}

-(void)dealloc
{
	[name release];
	[vertexcode release];
	[fragmentcode release];
	[bitmap release];
//	[texture release];
//	[program release];

	[super dealloc];
}

/*-(void)delete
{
	[texture delete];
	[program delete];
}*/



-(NSString *)name { return name; }

-(void)setName:(NSString *)newname { [name autorelease]; name=[newname retain]; }



-(float)diffuseRed { return diffuse[0]; }
-(float)diffuseGreen { return diffuse[1]; }
-(float)diffuseBlue { return diffuse[2]; }
-(float)diffuseAlpha { return diffuse[3]; }



-(void)setAmbientRed:(float)red green:(float)green blue:(float)blue { [self setAmbientRed:red green:green blue:blue alpha:1]; }

-(void)setAmbientRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha
{
	ambient[0]=red; ambient[1]=green; ambient[2]=blue; ambient[3]=alpha;
}

-(void)setDiffuseRed:(float)red green:(float)green blue:(float)blue { [self setDiffuseRed:red green:green blue:blue alpha:1]; }

-(void)setDiffuseRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha
{
	diffuse[0]=red; diffuse[1]=green; diffuse[2]=blue; diffuse[3]=alpha;
}

-(void)setSpecularRed:(float)red green:(float)green blue:(float)blue { [self setSpecularRed:red green:green blue:blue alpha:1]; }

-(void)setSpecularRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha
{
	specular[0]=red; specular[1]=green; specular[2]=blue; specular[3]=alpha;
}

-(void)setEmissionRed:(float)red green:(float)green blue:(float)blue { [self setEmissionRed:red green:green blue:blue alpha:1]; }

-(void)setEmissionRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha
{
	emission[0]=red; emission[1]=green; emission[2]=blue; emission[3]=alpha;
}

-(void)setPhongExponent:(float)phongexponent
{
	phong=phongexponent;
}

-(void)setTextureBitmap:(GLBitmap *)texbitmap
{
	[bitmap autorelease];
	bitmap=[texbitmap retain];
}

-(void)setVertexProgram:(NSString *)code
{
	[vertexcode autorelease];
	vertexcode=[code retain];
}

-(void)setFragmentProgram:(NSString *)code
{
	[fragmentcode autorelease];
	fragmentcode=[code retain];
}

@end



@implementation GLCartoonMaterial

+(GLCartoonMaterial *)cartoonMaterialWithName:(NSString *)materialname
{
	return [[[self alloc] initWithName:materialname] autorelease];
}

+(GLBitmap *)defaultShadingBitmap
{
	static GLBitmap *bitmap=nil;
	if(!bitmap)
	{
		const int size=128;
		bitmap=[[GLBitmap alloc] initWithWidth:16 height:size format:GL_LUMINANCE type:GL_UNSIGNED_BYTE];
		uint8_t *pixels=[bitmap pixels];
		for(int y=0;y<size;y++)
		{
			int slope=(128*(size-1-y))/size;
			int step=64*(y<size/2?1:0);

			uint8_t c=slope+step+64;

			for(int x=0;x<16;x++) pixels[y*16+x]=c;
		}
	}

	return bitmap;
}

-(id)initWithName:(NSString *)materialname
{
	if(self=[super initWithName:materialname])
	{
		shading=[[GLCartoonMaterial defaultShadingBitmap] retain];
		edged=YES;
	}
	return self;
}

-(void)dealloc
{
	[shading release];
	[super dealloc];
}

-(void)setHasEdges:(BOOL)hasedges
{
	edged=hasedges;
}

-(void)setShadingBitmap:(GLBitmap *)shadingbitmap
{
	[shading autorelease];
	shading=[shadingbitmap retain];
}

@end
