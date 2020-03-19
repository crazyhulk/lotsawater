#import "NSColorOpenGLAdditions.h"

@implementation NSColor (OpenGL)

-(void)glColor3f
{
	CGFloat r,g,b,a;
	[[self colorUsingColorSpaceName:NSDeviceRGBColorSpace] getRed:&r green:&g blue:&b alpha:&a];
	glColor3f(r,g,b);
}

-(void)glColor4f
{
	CGFloat r,g,b,a;
	[[self colorUsingColorSpaceName:NSDeviceRGBColorSpace] getRed:&r green:&g blue:&b alpha:&a];
	glColor4f(r,g,b,a);
}

-(void)glMaterialForFace:(GLuint)face parameter:(GLuint)param
{
	CGFloat c[4];
	[[self colorUsingColorSpaceName:NSDeviceRGBColorSpace] getComponents:c];
	GLfloat glc[4]={c[0],c[1],c[2],c[3]};
	glMaterialfv(face,param,glc);
}

-(void)glLightForLight:(GLuint)light parameter:(GLuint)param
{
	CGFloat c[4];
	[[self colorUsingColorSpaceName:NSDeviceRGBColorSpace] getComponents:c];
	GLfloat glc[4]={c[0],c[1],c[2],c[3]};
	glLightfv(light,param,glc);
}

@end
