#import "GLTriangleMesh.h"

typedef struct GLCartoonEdge
{
	int vertex1,vertex2;
	int triangle1,triangle2;
	int flags;
} GLCartoonEdge;

#define GLVisibleEdgeFlag 0x01
#define GLSharpEdgeFlag 0x02

#define GLTriangleEdges MangleClassName(GLTriangleEdges)

@interface GLTriangleEdges:NSObject
{
	@public
	GLTriangleMesh *mesh;
	NSMutableData *trinormalarray,*edgearray;
}

-(id)initWithTriangleMesh:(GLTriangleMesh *)trianglemesh;
-(void)dealloc;

-(void)buildFromMesh;
-(void)addEdgeForFirstVertex:(int)vertex1 second:(int)vertex2 triangle:(int)triangle;
-(void)calculateVisibilityWithCamera:(Vector)camera light:(Vector)light;

@end
