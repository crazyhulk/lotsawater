#import "GLDisplayList.h"

@implementation GLDisplayList

-(id)init
{
	if(self=[super init])
	{
		resources=nil;
		list=glGenLists(1);
		if(list) return self;

		[self release];
	}
	return nil;
}

-(void)dealloc
{
	GLWarnIfNotDeleted(self,list);
	[resources release];
	[super dealloc];
}

-(void)finalize
{
	GLWarnIfNotDeleted(self,list);
	[super finalize];
}

-(void)delete
{
	if(list) glDeleteLists(list,1);
	list=0;

	[resources makeObjectsPerformSelector:@selector(delete)];
}



-(void)compile
{
	GLAssertNotDeleted(self,list);
	glNewList(list,GL_COMPILE);
}

-(void)end { glEndList(); }

-(void)call
{
	GLAssertNotDeleted(self,list);
	glCallList(list);
}

-(void)addResource:(NSObject *)resource
{
	if(!resources) resources=[NSMutableArray new];
	[resources addObject:resource];
}

@end
