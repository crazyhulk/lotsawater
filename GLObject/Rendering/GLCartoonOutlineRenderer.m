#import "GLCartoonOutlineRenderer.h"

@implementation GLCartoonOutlineRenderer

-(id)initWithTriangleMesh:(GLTriangleMesh *)trianglemesh
{
	if(self=[super init])
	{
		mesh=[trianglemesh retain];
		vertexbuffer=normalbuffer=indexbuffer=nil;
		program=nil;
	}
	return self;
}

-(void)dealloc
{
	[mesh release];
	[vertexbuffer release];
	[normalbuffer release];
	[indexbuffer release];
	[program release];

	[super dealloc];
}

-(void)prepareWithResourceManager:(GLResourceManager *)manager
{
	vertexbuffer=[[manager arrayBufferForData:mesh->vertexarray] retain];
	normalbuffer=[[manager arrayBufferForData:mesh->normalarray] retain];
	indexbuffer=[[manager elementArrayBufferForData:mesh->indexarray] retain];

	program=[[GLProgram programWithShaders:
		[GLShader vertexShaderWithCode:
			@"uniform float offset;	\n"
			@"uniform vec4 colour;	\n"
			@"void main()			\n"
			@"{						\n"
			@"	float w=(gl_ModelViewProjectionMatrix*gl_Vertex).w; \n"
			@"	gl_Position=gl_ModelViewProjectionMatrix*			\n"
			@"	vec4(vec3(gl_Vertex)+offset*w*gl_Normal,1.0);		\n"
			@"	gl_FrontColor=colour;								\n"
			@"}"
		],
	nil] retain];

	[program link];

	if(![program isLinked]) NSLog(@"%@",[program fullLog]);
}

-(void)delete
{
	[program delete];
}

-(void)renderWithThickness:(float)thickness red:(float)r green:(float)g blue:(float)b
{
	glPushAttrib(GL_LIGHTING_BIT|GL_CURRENT_BIT|GL_ENABLE_BIT|GL_TEXTURE_BIT|GL_POLYGON_BIT);
	glPushClientAttrib(GL_CLIENT_VERTEX_ARRAY_BIT);

	glCullFace(GL_FRONT);
	glFrontFace(GL_CCW);
	glEnable(GL_CULL_FACE);

	[vertexbuffer bind];
	glVertexPointer(3,GL_FLOAT,0,NULL);
	glEnableClientState(GL_VERTEX_ARRAY);

	[normalbuffer bind];
	glNormalPointer(GL_FLOAT,0,NULL);
	glEnableClientState(GL_NORMAL_ARRAY);

	[indexbuffer bind];

	glDisable(GL_LIGHTING);
	glShadeModel(GL_FLAT);

	[program use];
	[program setUniform:@"offset" value:thickness];
	[program setUniform:@"colour" x:r y:g z:b w:1];

	int numindexes=[mesh->indexarray countWithElementSize:sizeof(uint32_t)];
	glDrawElements(GL_TRIANGLES,numindexes,GL_UNSIGNED_INT,NULL);

	[program remove];

	glPopClientAttrib();
	glPopAttrib();
}

@end
