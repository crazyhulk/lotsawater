#import "GLObject.h"

NSString *GLDeletedException=@"GLDeletedException";

void _GLRaiseDeleted(id self)
{
	[NSException raise:GLDeletedException format:@"Attempted to use GL resource %@ after it was deleted",self];
}

void _GLWarnNotDeleted(id self)
{
	NSLog(@"Warning: GL resource leaked because the object %@ was freed without being deleted.\n",self);
}
