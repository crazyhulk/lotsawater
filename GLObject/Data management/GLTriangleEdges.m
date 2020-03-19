#import "GLTriangleEdges.h"
#import "../NSDataArrayAdditions.h"

@implementation GLTriangleEdges

-(id)initWithTriangleMesh:(GLTriangleMesh *)trianglemesh;
{
	if(self=[super init])
	{
		mesh=[trianglemesh retain];
		trinormalarray=nil;
		edgearray=nil;

		[self buildFromMesh];
	}
	return self;
}

-(void)dealloc
{
	[mesh release];
	[trinormalarray release];
	[edgearray release];

	[super dealloc];
}

-(void)buildFromMesh
{
	int numtriangles=[mesh numberOfTriangles];

	trinormalarray=[[NSMutableData alloc] initWithCount:numtriangles elementSize:sizeof(Vector)];
	edgearray=[NSMutableData new];

	const Vector *vertices=[mesh->vertexarray bytes];
	const int *indexes=[mesh->indexarray bytes];
	Vector *trinormals=[trinormalarray mutableBytes];

	for(int i=0;i<numtriangles;i++)
	{
		[self addEdgeForFirstVertex:indexes[3*i+0] second:indexes[3*i+1] triangle:i];
		[self addEdgeForFirstVertex:indexes[3*i+1] second:indexes[3*i+2] triangle:i];
		[self addEdgeForFirstVertex:indexes[3*i+2] second:indexes[3*i+0] triangle:i];

		trinormals[i]=NormalVectorForTriangle(vertices[indexes[3*i]],
		vertices[indexes[3*i+1]],vertices[indexes[3*i+2]]);
	}
}

-(void)addEdgeForFirstVertex:(int)vertex1 second:(int)vertex2 triangle:(int)triangle
{
	GLCartoonEdge *edges=[edgearray mutableBytes];

	int numedges=[edgearray countWithElementSize:sizeof(GLCartoonEdge)];
	for(int i=0;i<numedges;i++)
	{
		//if((e->v1==v1&&e->v2==v2)||(e->v1==v2&&e->v2==v1))
		if(edges[i].vertex1==vertex2&&edges[i].vertex2==vertex1)
		{
			if(edges[i].triangle2==-1)
			{
				edges[i].triangle2=triangle;
				//if(!VectorsAreNearlyEqual(n[e[i].n1].v,n[n2].v)||!VectorsAreNearlyEqual(n[e[i].n2].v,n[n1].v))
				//e[i].flags|=GLSharpEdgeFlag;
			}
			else // broken surface
			{
				edges[i].flags|=GLSharpEdgeFlag;
			}

			return;
		}
		else if(edges[i].vertex1==vertex1&&edges[i].vertex2==vertex2) // broken surface
		{
			edges[i].flags|=GLSharpEdgeFlag;
			return;
		}
	}

	GLCartoonEdge edge={
		.vertex1=vertex1, .vertex2=vertex2,
		.triangle1=triangle, .triangle2=-1,
		.flags=0
	};

	[edgearray appendBytes:&edge length:sizeof(edge)];
}

-(void)calculateVisibilityWithCamera:(Vector)camera light:(Vector)light
{
	const Vector *vertices=[mesh->vertexarray bytes];
	const int32_t *indexes=[mesh->indexarray bytes];
	const Vector *trinormals=[trinormalarray bytes];
	GLCartoonEdge *edges=[edgearray mutableBytes];
	int numtriangles=[mesh numberOfTriangles];
	int numedges=[edgearray countWithElementSize:sizeof(GLCartoonEdge)];

	BOOL visible[numtriangles];

	for(int i=0;i<numtriangles;i++)
	{
		if(VectorDot(trinormals[i],VectorSub(camera,vertices[indexes[3*i]]))>0) visible[i]=YES;
		else visible[i]=NO;
	}

	for(int i=0;i<numedges;i++)
	{
		if(edges[i].triangle2==-1)
		{
			if(visible[edges[i].triangle1]||!mesh->cull) edges[i].flags|=GLVisibleEdgeFlag;
			else edges[i].flags&=~GLVisibleEdgeFlag;
		}
		else if(edges[i].flags&GLSharpEdgeFlag)
		{
			if(visible[edges[i].triangle1]||visible[edges[i].triangle2]) edges[i].flags|=GLVisibleEdgeFlag;
			else edges[i].flags&=~GLVisibleEdgeFlag;
		}
		else if(visible[edges[i].triangle1]!=visible[edges[i].triangle2])
		{
			edges[i].flags|=GLVisibleEdgeFlag;
		}
		else
		{
			edges[i].flags&=~GLVisibleEdgeFlag;
		}
	}
}

@end
