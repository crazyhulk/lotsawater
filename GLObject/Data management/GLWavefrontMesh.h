#import "GLPolygonMesh.h"
#import "GLDataManager.h"
#import "CSTokenizer.h"

#define GLWavefrontMesh MangleClassName(GLWavefrontMesh)

@interface GLWavefrontMesh:GLPolygonMesh
{
	CSTokenDispatcher *objtokenizer,*mtltokenizer;
	CSTokenizer *facetokenizer;

	NSString *filename,*libname;
	GLMaterial *currmaterial,*parsematerial;
	NSMutableDictionary *materialdict;

	GLDataManager *manager;
}

-(id)initWithFilename:(NSString *)objname dataManager:(GLDataManager *)datamanager; 
-(void)dealloc;

@end
