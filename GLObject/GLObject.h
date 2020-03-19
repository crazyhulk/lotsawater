#import <Foundation/Foundation.h>

#import "NameMangler.h"

#ifdef __APPLE__

#import <OpenGL/gl.h>
#import <OpenGL/glu.h>

#ifndef OPENGL_VERSION
#define OPENGL_VERSION 30
#endif

#else

#define GLEW_STATIC
#import <GL/glew.h>

#ifndef OPENGL_VERSION
#define OPENGL_VERSION 32
#endif

#endif



#ifdef ClassNamePrefix
#define __Combine1(A,B) A##B
#define __Combine2(A,B) __Combine1(A,B)
#define MangleClassName(ClassName) __Combine2(ClassNamePrefix,ClassName)
#else
#define MangleClassName(ClassName) ClassName
#endif



extern NSString *GLDeletedException;

void _GLRaiseDeleted(id self);
void _GLWarnNotDeleted(id self);

#define GLAssertNotDeleted(self,res) { if(!res) _GLRaiseDeleted(self); }
#define GLWarnIfNotDeleted(self,res) { if(res) _GLWarnNotDeleted(self); }
