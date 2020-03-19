#import "GLSceneNode.h"

NSString *GLSceneNodeException=@"GLSceneNodeException";

@implementation GLSceneNode

-(id)init
{
	if(self=[super init])
	{
		m=IdentityMatrix;
		children=[NSMutableArray new];
		parent=nil;
	}
	return self;
}

-(void)dealloc
{
	[children release];
	[super dealloc];
}

-(GLSceneNode *)parent { return parent; }

-(NSArray *)children { return children; }

-(void)addChild:(id)child
{
	if([child isKindOfClass:[GLSceneNode class]])
	{
		GLSceneNode *nodechild=child;
		if(nodechild->parent) [NSException raise:GLSceneNodeException format:@"Attempting to add a GLSceneNode that is already a child of another node."];
		nodechild->parent=self;
	}

	[children addObject:child];
}

-(void)removeChild:(id)child
{
	[children removeObject:child];

	if([child isKindOfClass:[GLSceneNode class]])
	{
		GLSceneNode *nodechild=child;
		nodechild->parent=nil;
	}
}

-(void)removeFromParent
{
	[parent removeChild:self];
}

-(Matrix)transformationMatrix { return m; }

-(Matrix)globalTransformationMatrix
{
	Matrix res=m;

	GLSceneNode *node=self;
	while(node=node->parent) res=MatrixMul(node->m,res);

	return res;
}

-(void)setTransformationMatrix:(Matrix)transformation { m=transformation; }

@end
