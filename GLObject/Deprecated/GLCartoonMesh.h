#import "GLObject.h"
#import "NSValueArray.h"
#import "GLTriangleMesh.h"
#import "GLVertexArray.h"

#define GLCartoonMesh MangleClassName(GLCartoonMesh)

@interface GLCartoonMesh:NSObject
{
	NSMutableData *vertices,*normals,*texcoords;
	NSMutableData *faces,*edges,*dots;
	NSDictionary *materials;
	GLVertexArray *vertexarray;
}

+(GLCartoonMesh *)cartoonMeshWithMesh:(GLTriangleMesh *)mesh;

-(id)init;
-(id)initWithMesh:(GLTriangleMesh *)mesh;
-(void)dealloc;

-(void)buildFromMesh:(GLTriangleMesh *)mesh;
-(int)findEdgeForFirstVertex:(int)v1 second:(int)v2 firstNormal:(int)n1 second:(int)n2 face:(int)f;

-(void)calculateVisibilityWithCamera:(Vector)camera light:(Vector)light;
-(void)drawWithSubdivision;
//-(void)drawWithTexture;
-(void)drawEdges;

-(void)drawWithCamera:(Vector)camera light:(Vector)light inverseTransform:(Matrix)transform;
-(void)drawWithCamera:(Vector)camera light:(Vector)light;

@end

