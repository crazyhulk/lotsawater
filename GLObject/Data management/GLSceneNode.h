#import "../GLObject.h"
#import "../Vector.h"

#define GLSceneNode MangleClassName(GLSceneNode)

@interface GLSceneNode:NSObject
{
	Matrix m;
	NSMutableArray *children;
	GLSceneNode *parent;
}

-(id)init;
-(void)dealloc;

-(GLSceneNode *)parent;
-(NSArray *)children;
-(void)addChild:(id)child;
-(void)removeChild:(id)child;
-(void)removeFromParent;

-(Matrix)transformationMatrix;
-(Matrix)globalTransformationMatrix;
-(void)setTransformationMatrix:(Matrix)transformation;

@end
