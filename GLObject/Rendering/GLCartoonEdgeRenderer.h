#import "../GLObject.h"
#import "../GLBuffer.h"
#import "../Data management/GLTriangleEdges.h"
#import "GLResourceManager.h"

#define GLCartoonEdgeLineRenderer MangleClassName(GLCartoonEdgeLineRenderer)

@interface GLCartoonEdgeRenderer:NSObject
{
	GLTriangleEdges *edges;
	GLBuffer *vertexbuffer,*indexbuffer;
}

-(id)initWithTriangleEdges:(GLTriangleEdges *)triangleedges;
-(void)dealloc;

-(void)prepareWithResourceManager:(GLResourceManager *)manager;
-(void)delete;

-(void)render;

@end
