#import "GLCartoonEdgeRenderer.h"

@implementation GLCartoonEdgeRenderer

-(id)initWithTriangleEdges:(GLTriangleEdges *)triangleedges
{
	if(self=[super init])
	{
		edges=[triangleedges retain];
		vertexbuffer=indexbuffer=nil;
	}
	return self;
}

-(void)dealloc
{
	[edges release];
	[vertexbuffer release];
	[indexbuffer release];

	[super dealloc];
}

-(void)prepareWithResourceManager:(GLResourceManager *)manager
{
	vertexbuffer=[[manager arrayBufferForData:edges->mesh->vertexarray] retain];
	indexbuffer=[[manager elementArrayBufferForData:edges->mesh->indexarray] retain];
}

-(void)delete
{
}



-(void)render
{
	GLfloat pos[4];
	glGetLightfv(GL_LIGHT0,GL_POSITION,pos);
	Vector worldlight=MakeVector(-pos[0],-pos[1],-pos[2]);

	Matrix modelview;
	glGetFloatv(GL_MODELVIEW_MATRIX,modelview.a);

	Matrix projection;
	glGetFloatv(GL_PROJECTION_MATRIX,projection.a);

	Matrix modelview_inv=FastMatrixInverse(modelview);
	Matrix full_inv=FastMatrixInverse(MatrixMul(projection,modelview));

	Vector light=TransformVectorDirection(modelview_inv,worldlight);
	Vector camera=MatrixOrigin(full_inv);

	glPushAttrib(GL_LIGHTING_BIT|GL_CURRENT_BIT|GL_ENABLE_BIT|GL_POLYGON_BIT);
	glPushClientAttrib(GL_CLIENT_VERTEX_ARRAY_BIT);

	glCullFace(GL_FRONT);
	glFrontFace(GL_CCW);
	glEnable(GL_CULL_FACE);

	[vertexbuffer bind];
	glVertexPointer(3,GL_FLOAT,0,NULL);
	glEnableClientState(GL_VERTEX_ARRAY);

	[indexbuffer bind];

	[edges calculateVisibilityWithCamera:camera light:light];

	const GLCartoonEdge *edgeptr=[edges->edgearray bytes];
	int numedges=[edges->edgearray countWithElementSize:sizeof(GLCartoonEdge)];

	glDisable(GL_LIGHTING);

	glBegin(GL_LINES);
	glColor3f(0,0,0);

	for(int i=0;i<numedges;i++)
	{
		if(edgeptr[i].flags&GLVisibleEdgeFlag)
		{
			glArrayElement(edgeptr[i].vertex1);
			glArrayElement(edgeptr[i].vertex2);
		}
	}

	glEnd();

	glPopClientAttrib();
	glPopAttrib();
}



@end
