#import "../GLObject.h"
#import "../GLBuffer.h"
#import "../Data management/GLTriangleMesh.h"
#import "GLResourceManager.h"

#define GLNoShadersFlag 0x0001
#define GLNoTexturesFlag 0x0002

#define GLTriangleMeshRenderer MangleClassName(GLTriangleMeshRenderer)

@interface GLTriangleMeshRenderer:NSObject
{
	GLTriangleMesh *mesh;
	GLBuffer *vertexbuffer,*normalbuffer,*texcoordbuffer,*colourbuffer;
	GLBuffer *indexbuffer;
	NSMutableArray *textures;
}

-(id)initWithTriangleMesh:(GLTriangleMesh *)trianglemesh;
-(void)dealloc;

-(void)prepareWithResourceManager:(GLResourceManager *)manager;
-(void)delete;

-(void)render;
-(void)renderWithFlags:(int)flags;

-(void)bindBuffersWithTextureUnit:(GLenum)textureunit;
-(void)drawFacesWithFlags:(int)flags;

@end
