#import "GLPolygonMesh.h"
#import "GLDataManager.h"
#import "CSTokenizer.h"

#define GLDirectXMesh MangleClassName(GLDirectXMesh)

extern NSString *GLDirectXMeshException;

@interface GLDirectXMesh:GLPolygonMesh
{
	NSString *filename;
	CSTokenizer *tokenizer;
	GLDataManager *manager;
}

-(id)initWithFilename:(NSString *)objname dataManager:(GLDataManager *)datamanager; 
-(void)dealloc;

-(void)parseData:(NSData *)data;
-(void)parseRoot;
-(void)parseMesh;
-(void)parseMeshMaterialList;
-(void)parseMaterial:(GLMaterial *)material;
-(void)parseMeshNormals;
-(void)parseMeshTextureCoords;

-(void)skipUnknownStruct;

-(void)expect:(NSString *)token;
-(NSString *)expect:(NSString *)token1 or:(NSString *)token2;
-(NSString *)expectAnything;

@end

