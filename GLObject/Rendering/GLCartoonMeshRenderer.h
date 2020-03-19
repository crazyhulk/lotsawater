#import "../GLProgram.h"
#import "GLTriangleMeshRenderer.h"
#import "GLResourceManager.h"

#define GLCartoonMeshRenderer MangleClassName(GLCartoonMeshRenderer)

@interface GLCartoonMeshRenderer:GLTriangleMeshRenderer
{
	GLProgram *program;
	NSMutableArray *toontextures;
}

-(id)initWithTriangleMesh:(GLTriangleMesh *)trianglemesh;
-(void)dealloc;

-(void)prepareWithResourceManager:(GLResourceManager *)manager;
-(void)delete;

-(void)renderWithOffset:(float)offset;

@end
