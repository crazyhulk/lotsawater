#import "../GLObject.h"
#import "../GLTexture.h"
#import "../GLProgram.h"

#define GLMaterial MangleClassName(GLMaterial)

@interface GLMaterial:NSObject
{
	@public
	NSString *name;
	float ambient[4],diffuse[4],specular[4],emission[4];
	float phong;
	GLBitmap *bitmap;
	NSString *vertexcode,*fragmentcode;
}

+(GLMaterial *)materialWithName:(NSString *)materialname;
+(GLMaterial *)defaultMaterial;

-(id)init;
-(id)initWithName:(NSString *)materialname;
-(void)dealloc;

-(NSString *)name;
-(void)setName:(NSString *)newname;

-(float)diffuseRed;
-(float)diffuseGreen;
-(float)diffuseBlue;
-(float)diffuseAlpha;

-(void)setAmbientRed:(float)red green:(float)green blue:(float)blue;
-(void)setAmbientRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;
-(void)setDiffuseRed:(float)red green:(float)green blue:(float)blue;
-(void)setDiffuseRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;
-(void)setSpecularRed:(float)red green:(float)green blue:(float)blue;
-(void)setSpecularRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;
-(void)setEmissionRed:(float)red green:(float)green blue:(float)blue;
-(void)setEmissionRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;
-(void)setPhongExponent:(float)phongexponent;

-(void)setTextureBitmap:(GLBitmap *)texbitmap;
-(void)setVertexProgram:(NSString *)code;
-(void)setFragmentProgram:(NSString *)code;

@end

#define GLCartoonMaterial MangleClassName(GLCartoonMaterial)

@interface GLCartoonMaterial:GLMaterial
{
	@public
	GLBitmap *shading;
	BOOL edged;
}

+(GLCartoonMaterial *)cartoonMaterialWithName:(NSString *)materialname;

+(GLBitmap *)defaultShadingBitmap;

-(void)setHasEdges:(BOOL)hasedges;
-(void)setShadingBitmap:(GLBitmap *)shadingbitmap;

@end
