#import "../GLObject.h"
#import "GLMaterial.h"
#import "GLTriangleMesh.h"

typedef struct GLPolygonVertex
{
	int vertex,normal,texcoord;
} GLPolygonVertex;

#define GLPolygonMesh MangleClassName(GLPolygonMesh)

@interface GLPolygonMesh:NSObject
{
	@public
	NSMutableData *vertexarray,*normalarray,*texcoordarray;
	NSMutableArray *faces,*materials;

	BOOL cull;
}

-(id)init;
-(void)dealloc;

-(void)calculateNormals;
-(GLTriangleMesh *)triangleMesh;

-(Vector)maximumComponentsWithMatrix:(Matrix)matrix;
-(Vector)minimumComponentsWithMatrix:(Matrix)matrix;

@end
