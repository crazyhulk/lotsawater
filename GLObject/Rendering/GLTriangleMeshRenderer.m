#import "GLTriangleMeshRenderer.h"

@implementation GLTriangleMeshRenderer

-(id)initWithTriangleMesh:(GLTriangleMesh *)trianglemesh
{
	if(self=[super init])
	{
		mesh=[trianglemesh retain];
		vertexbuffer=normalbuffer=texcoordbuffer=colourbuffer=indexbuffer=nil;
		textures=[NSMutableArray new];
	}
	return self;
}

-(void)dealloc
{
	[mesh release];
	[vertexbuffer release];
	[normalbuffer release];
	[texcoordbuffer release];
	[colourbuffer release];
	[indexbuffer release];
	[textures release];

	[super dealloc];
}

-(void)prepareWithResourceManager:(GLResourceManager *)manager
{
	int nummaterials=[mesh numberOfMaterials];
	for(int i=0;i<nummaterials;i++)
	{
		GLMaterial *material=[mesh materialAtIndex:i];
		if(material->bitmap) [textures addObject:[manager textureForBitmap:material->bitmap]];
		else [textures addObject:[NSNull null]];
	}

	vertexbuffer=[[manager arrayBufferForData:mesh->vertexarray] retain];
	indexbuffer=[[manager elementArrayBufferForData:mesh->indexarray] retain];

	if(mesh->normalarray) normalbuffer=[[manager arrayBufferForData:mesh->normalarray] retain];
	if(mesh->texcoordarray) texcoordbuffer=[[manager arrayBufferForData:mesh->texcoordarray] retain];
	if(mesh->colourarray) colourbuffer=[[manager arrayBufferForData:mesh->colourarray] retain];

/*	vertexbuffer=[[GLBuffer arrayBufferWithValueArray:mesh->vertexarray] retain];
	indexbuffer=[[GLBuffer elementArrayBufferWithValueArray:mesh->indexarray] retain];

	if(mesh->normalarray) normalbuffer=[[GLBuffer arrayBufferWithValueArray:mesh->normalarray] retain];
	if(mesh->texcoordarray) texcoordbuffer=[[GLBuffer arrayBufferWithValueArray:mesh->texcoordarray] retain];
	if(mesh->colourarray) colourbuffer=[[GLBuffer arrayBufferWithValueArray:mesh->colourarray] retain];*/
}

-(void)delete
{
/*	[vertexbuffer delete];
	[normalbuffer delete];
	[texcoordbuffer delete];
	[colourbuffer delete];
	[indexbuffer delete];*/
}

-(void)render
{
	[self renderWithFlags:0];
}

-(void)renderWithFlags:(int)flags
{
	glPushAttrib(GL_LIGHTING_BIT|GL_CURRENT_BIT|GL_ENABLE_BIT|GL_TEXTURE_BIT|GL_POLYGON_BIT);
	glPushClientAttrib(GL_CLIENT_VERTEX_ARRAY_BIT);

	if(mesh->cull)
	{
		glCullFace(GL_BACK);
		glFrontFace(GL_CCW);
		glEnable(GL_CULL_FACE);
	}
	else
	{
		glDisable(GL_CULL_FACE);
	}

	[self bindBuffersWithTextureUnit:GL_TEXTURE0];

	[self drawFacesWithFlags:flags];

//	[GLProgram removeCurrentProgram];
	glPopClientAttrib();
	glPopAttrib();
}

-(void)bindBuffersWithTextureUnit:(GLenum)textureunit
{
	[vertexbuffer bind];
	glVertexPointer(3,GL_FLOAT,0,NULL);
	glEnableClientState(GL_VERTEX_ARRAY);

	if(normalbuffer)
	{
		[normalbuffer bind];
		glNormalPointer(GL_FLOAT,0,NULL);
		glEnableClientState(GL_NORMAL_ARRAY);
	}

	if(texcoordbuffer)
	{
        glClientActiveTexture(textureunit);
		[texcoordbuffer bind];
		glTexCoordPointer(2,GL_FLOAT,0,NULL);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	}

	if(colourbuffer)
	{
		[colourbuffer bind];
		glColorPointer(4,GL_UNSIGNED_BYTE,0,NULL); // TODO: what should this be?
		glEnableClientState(GL_COLOR_ARRAY);
	}

	[indexbuffer bind];
}

-(void)drawFacesWithFlags:(int)flags
{
	glShadeModel(GL_SMOOTH);

	int nummaterials=[mesh numberOfMaterials];
	int offs=0;
	for(int i=0;i<nummaterials;i++)
	{
		GLMaterial *material=[mesh materialAtIndex:i];
		if(material->bitmap && !(flags&GLNoTexturesFlag))
		{
			[[textures objectAtIndex:i] bind];
			glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
			glEnable(GL_TEXTURE_2D);
		}
		else glDisable(GL_TEXTURE_2D);

		if(!colourbuffer)
		{
			glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,material->ambient);
			glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,material->diffuse);
			glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,material->specular);
			glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,material->emission);
			glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,material->phong);

			glColor3f(material->diffuse[0],material->diffuse[1],material->diffuse[2]);
		}

		int num=[mesh numberOfIndexesAtIndex:i];

		glDrawElements(GL_TRIANGLES,num,GL_UNSIGNED_INT,(void *)(uintptr_t)(offs*4));

		offs+=num;
	}
}

@end
