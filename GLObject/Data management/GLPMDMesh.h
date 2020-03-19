#import "GLTriangleMesh.h"
#import "GLDataManager.h"

#define GLPMDMesh MangleClassName(GLPMDMesh)

@interface GLPMDMesh:GLTriangleMesh
{
	NSString *filename;
	NSString *name,*comment;
	GLDataManager *manager;
}

-(id)initWithFilename:(NSString *)objname dataManager:(GLDataManager *)datamanager; 
-(void)dealloc;

-(BOOL)readFile:(NSString *)filename;

-(NSString *)pathForNameData:(NSData *)namedata;

@end

