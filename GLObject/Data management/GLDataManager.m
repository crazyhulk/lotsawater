#import "GLDataManager.h"
#import "GLWavefrontMesh.h"
#import "GLDirectXMesh.h"
#import "GLPMDMesh.h"

@implementation GLDataManager

-(id)init
{
	if(self=[super init])
	{
		files=[NSMutableDictionary new];
	}
	return self;
}

-(void)dealloc
{
	[files release];
	[super dealloc];
}




-(id)contentsForFilename:(NSString *)filename
{
	return [files objectForKey:filename];
}

-(void)setContents:(id)contents forFilename:(NSString *)filename
{
	if(contents) [files setObject:contents forKey:filename];
}



-(GLBitmap *)bitmapWithContentsOfFile:(NSString *)filename
{
	GLBitmap *bitmap=[self contentsForFilename:filename];
	if(!bitmap)
	{
		bitmap=[GLBitmap bitmapWithContentsOfFile:filename];
		[self setContents:bitmap forFilename:filename];
	}
	return bitmap;
}

-(GLBitmap *)bitmapWithContentsOfResource:(NSString *)resourcename
{
	return [self bitmapWithContentsOfFile:
	[[NSBundle bundleForClass:[self class]] pathForResource:resourcename ofType:nil]];
}

-(GLTriangleMesh *)triangleMeshWithContentsOfWavefrontFile:(NSString *)filename
{
	GLTriangleMesh *mesh=[self contentsForFilename:filename];
	if(!mesh)
	{
		GLWavefrontMesh *objmesh=[[GLWavefrontMesh alloc] initWithFilename:filename dataManager:self];
		mesh=[objmesh triangleMesh];
		[objmesh release];
		[self setContents:mesh forFilename:filename];
	}
	return mesh;
}

-(GLTriangleMesh *)triangleMeshWithContentsOfWavefrontResource:(NSString *)resourcename
{
	return [self triangleMeshWithContentsOfWavefrontFile:
	[[NSBundle bundleForClass:[self class]] pathForResource:resourcename ofType:nil]];
}

-(GLTriangleMesh *)triangleMeshWithContentsOfDirectXFile:(NSString *)filename
{
	GLTriangleMesh *mesh=[self contentsForFilename:filename];
	if(!mesh)
	{
		GLDirectXMesh *xmesh=[[GLDirectXMesh alloc] initWithFilename:filename dataManager:self];
		mesh=[xmesh triangleMesh];
		[xmesh release];
		[self setContents:mesh forFilename:filename];
	}
	return mesh;
}

-(GLTriangleMesh *)triangleMeshWithContentsOfDirectXResource:(NSString *)resourcename
{
	return [self triangleMeshWithContentsOfDirectXFile:
	[[NSBundle bundleForClass:[self class]] pathForResource:resourcename ofType:nil]];
}

-(GLTriangleMesh *)triangleMeshWithContentsOfPMDFile:(NSString *)filename
{
	GLTriangleMesh *mesh=[self contentsForFilename:filename];
	if(!mesh)
	{
		mesh=[[[GLPMDMesh alloc] initWithFilename:filename dataManager:self] autorelease];
		[self setContents:mesh forFilename:filename];
	}
	return mesh;
}

-(GLTriangleMesh *)triangleMeshWithContentsOfPMDResource:(NSString *)resourcename
{
	return [self triangleMeshWithContentsOfPMDFile:
	[[NSBundle bundleForClass:[self class]] pathForResource:resourcename ofType:nil]];
}


@end
