#import "../GLObject.h"
#import "../GLBitmap.h"
#import "GLTriangleMesh.h"

#define GLDataManager MangleClassName(GLDataManager)

@interface GLDataManager:NSObject
{
	NSMutableDictionary *files;
}

-(id)init;
-(void)dealloc;

-(id)contentsForFilename:(NSString *)filename;
-(void)setContents:(id)contents forFilename:(NSString *)filename;

-(GLBitmap *)bitmapWithContentsOfFile:(NSString *)filename;
-(GLBitmap *)bitmapWithContentsOfResource:(NSString *)resourcename;
-(GLTriangleMesh *)triangleMeshWithContentsOfWavefrontFile:(NSString *)filename;
-(GLTriangleMesh *)triangleMeshWithContentsOfWavefrontResource:(NSString *)resourcename;
-(GLTriangleMesh *)triangleMeshWithContentsOfDirectXFile:(NSString *)filename;
-(GLTriangleMesh *)triangleMeshWithContentsOfDirectXResource:(NSString *)resourcename;
-(GLTriangleMesh *)triangleMeshWithContentsOfPMDFile:(NSString *)filename;
-(GLTriangleMesh *)triangleMeshWithContentsOfPMDResource:(NSString *)resourcename;

@end
