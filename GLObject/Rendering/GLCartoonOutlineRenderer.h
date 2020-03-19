#import "../GLObject.h"
#import "../GLBuffer.h"
#import "../GLProgram.h"
#import "../Data management/GLTriangleMesh.h"
#import "GLResourceManager.h"

#define GLCartoonOutlineRenderer MangleClassName(GLCartoonOutlineRenderer)

@interface GLCartoonOutlineRenderer:NSObject
{
	GLTriangleMesh *mesh;
	GLBuffer *vertexbuffer,*normalbuffer,*indexbuffer;
	GLProgram *program;
}

-(id)initWithTriangleMesh:(GLTriangleMesh *)trianglemesh;
-(void)dealloc;

-(void)prepareWithResourceManager:(GLResourceManager *)manager;
-(void)delete;

-(void)renderWithThickness:(float)thickness red:(float)r green:(float)g blue:(float)b;

@end
