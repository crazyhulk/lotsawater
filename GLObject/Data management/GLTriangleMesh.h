#import "../GLObject.h"
#import "../NSDataArrayAdditions.h"
#import "GLMaterial.h"



typedef struct GLTextureCoordinate
{
	float s,t;
} GLTextureCoordinate;



#define GLPolygonMesh MangleClassName(GLPolygonMesh)

@interface GLTriangleMesh:NSObject
{
	@public
	NSMutableData *vertexarray,*normalarray,*texcoordarray,*colourarray,*indexarray;
	NSMutableArray *materials,*counts;

	BOOL cull;
}

-(id)initWithNormals:(BOOL)hasnormals texcoords:(BOOL)hastexcoords colours:(BOOL)hascolours;
-(void)dealloc;

-(int)numberOfTriangles;

-(NSData *)vertexData;
-(NSData *)normalData;
-(NSData *)texcoordData;
-(NSData *)colourData;
-(NSData *)indexData;

-(void)addMaterial:(GLMaterial *)material withNumberOfIndexes:(int)count;

-(int)numberOfMaterials;
-(GLMaterial *)materialAtIndex:(int)index;
-(int)numberOfIndexesAtIndex:(int)index;

-(void)optimize;
-(void)optimizeUnusuedVertices;
-(void)optimizeSimilarVertices;

-(void)calculateNormals;
-(void)calculateNormalsForCartoonOutline;

-(GLTriangleMesh *)meshWithNormals:(BOOL)hasnormals texcoords:(BOOL)hastexcoords
colours:(BOOL)hascolours;
-(GLTriangleMesh *)meshWithNormals:(BOOL)hasnormals texcoords:(BOOL)hastexcoords
colours:(BOOL)hascolours materials:(NSIndexSet *)materialset;
-(GLTriangleMesh *)cartoonOutlineMesh;

-(Vector)maximumComponentsWithMatrix:(Matrix)matrix;
-(Vector)minimumComponentsWithMatrix:(Matrix)matrix;

@end



@interface NSMutableData (GLTriangleMeshAdditions)

-(void)appendTextureCoordinateS:(float)s t:(float)t;

@end
