#import "GLObject.h"

#define GLDisplayList MangleClassName(GLDisplayList)

@interface GLDisplayList:NSObject
{
	NSMutableArray *resources;

	@public
	GLuint list;
}

-(id)init;
-(void)dealloc;
-(void)finalize;
-(void)delete;

-(void)compile;
-(void)end;
-(void)call;

-(void)addResource:(NSObject *)resource;

@end
