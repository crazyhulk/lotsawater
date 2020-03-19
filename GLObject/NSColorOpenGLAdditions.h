#import "GLObject.h"
#import <Cocoa/Cocoa.h>

@interface NSColor (OpenGL)

-(void)glColor3f;
-(void)glColor4f;
-(void)glMaterialForFace:(GLuint)face parameter:(GLuint)param;
-(void)glLightForLight:(GLuint)light parameter:(GLuint)param;

@end
