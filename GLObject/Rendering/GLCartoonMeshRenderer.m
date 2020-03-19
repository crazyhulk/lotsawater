#import "GLCartoonMeshRenderer.h"

@implementation GLCartoonMeshRenderer

-(id)initWithTriangleMesh:(GLTriangleMesh *)trianglemesh
{
	if(self=[super initWithTriangleMesh:trianglemesh])
	{
		toontextures=[NSMutableArray new];;
		program=nil;
	}
	return self;
}

-(void)dealloc
{
	[toontextures release];
	[program release];

	[super dealloc];
}

-(void)prepareWithResourceManager:(GLResourceManager *)manager
{
	[super prepareWithResourceManager:manager];

	int nummaterials=[mesh numberOfMaterials];
	for(int i=0;i<nummaterials;i++)
	{
		GLMaterial *material=[mesh materialAtIndex:i];
		GLBitmap *bitmap;
		if([material isKindOfClass:[GLCartoonMaterial class]])
		{
			GLCartoonMaterial *cartoonmaterial=(GLCartoonMaterial *)material;
			bitmap=cartoonmaterial->shading;
		}
		else bitmap=[GLCartoonMaterial defaultShadingBitmap];

		[toontextures addObject:[manager textureForBitmap:bitmap]];
	}

	program=[[GLProgram programWithShaders:
		[GLShader vertexShaderWithCode:
			@"uniform vec3 light;	\n"
			@"void main()			\n"
			@"{						\n"
			@"	gl_Position=ftransform();			\n"
			@"	gl_FrontColor=gl_Color;				\n"
			@"	gl_TexCoord[0]=vec4( 0.5,(dot(gl_Normal,light)/length(light)+1.0)/2.0,0.0,1.0);	\n"
			@"	gl_TexCoord[1]=gl_MultiTexCoord1;	\n"
			@"}"
		],
	nil] retain];

	[program link];

	if(![program isLinked]) NSLog(@"%@",[program fullLog]);
}

-(void)delete
{
	[super delete];

	[program delete];
}



-(void)renderWithOffset:(float)offset
{
	GLfloat pos[4];
	glGetLightfv(GL_LIGHT0,GL_POSITION,pos);
	Vector worldlight=MakeVector(-pos[0],-pos[1],-pos[2]);

	Matrix modelview;
	glGetFloatv(GL_MODELVIEW_MATRIX,modelview.a);

	Matrix modelview_inv=FastMatrixInverse(modelview);

	Vector light=TransformVectorDirection(modelview_inv,worldlight);

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

	[self bindBuffersWithTextureUnit:GL_TEXTURE1];

	glDisable(GL_LIGHTING);
	glShadeModel(GL_SMOOTH);

	if(offset)
	{
		glEnable(GL_POLYGON_OFFSET_FILL);
		glPolygonOffset(offset,0);
	}

	glActiveTextureARB(GL_TEXTURE0);
	glEnable(GL_TEXTURE_2D);

	[program use];
	[program setUniform:@"light" vector:light];

	int nummaterials=[mesh numberOfMaterials];
	int offs=0;
	for(int i=0;i<nummaterials;i++)
	{
		GLMaterial *material=[mesh materialAtIndex:i];

		glActiveTextureARB(GL_TEXTURE0);
		[[toontextures objectAtIndex:i] bind];
		glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);

		if(material->bitmap)
		{
			glActiveTextureARB(GL_TEXTURE1);
			[[textures objectAtIndex:i] bind];

			glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
			//glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
			//glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);

/*			glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
			glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_COMBINE);
			glTexEnvi(GL_TEXTURE_ENV,GL_COMBINE_RGB,GL_INTERPOLATE);
			glTexEnvi(GL_TEXTURE_ENV,GL_SOURCE0_RGB,GL_TEXTURE);
			glTexEnvi(GL_TEXTURE_ENV,GL_OPERAND0_RGB,GL_SRC_COLOR);
			glTexEnvi(GL_TEXTURE_ENV,GL_SOURCE1_RGB,GL_PREVIOUS);
			glTexEnvi(GL_TEXTURE_ENV,GL_OPERAND1_RGB,GL_SRC_COLOR);
			glTexEnvi(GL_TEXTURE_ENV,GL_SOURCE2_RGB,GL_PRIMARY_COLOR);
			glTexEnvi(GL_TEXTURE_ENV,GL_OPERAND2_RGB,GL_SRC_ALPHA);*/

			glEnable(GL_TEXTURE_2D);
		}
		else
		{
			glActiveTextureARB(GL_TEXTURE1);
			glDisable(GL_TEXTURE_2D);
		}

		glColor3f(material->diffuse[0],material->diffuse[1],material->diffuse[2]);

		int num=[mesh numberOfIndexesAtIndex:i];
		glDrawElements(GL_TRIANGLES,num,GL_UNSIGNED_INT,(void *)(uintptr_t)(offs*4));
		offs+=num;
	}

	[program remove];

	glPopClientAttrib();
	glPopAttrib();
}

@end
