#import "GLShader.h"




@implementation GLShader

+(id)allocWithZone:(NSZone *)zone
{
	if(![self isEqual:[GLShader class]]) return [super allocWithZone:zone];

	#if OPENGL_VERSION>=20
	if(glCreateShader&&glDeleteShader&&glAttachShader&&glDetachShader)
	return [GLShaderOpenGL20 allocWithZone:zone];
	#endif

	return [GLShaderARB allocWithZone:zone];
}

+(GLShader *)vertexShaderFromFile:(NSString *)filename
{
	return [[[self alloc] initWithType:GL_VERTEX_SHADER
	code:[NSString stringWithContentsOfFile:filename
	encoding:NSUTF8StringEncoding error:NULL]] autorelease];
}

+(GLShader *)vertexShaderFromResource:(NSString *)filename
{
	return [[[self alloc] initWithType:GL_VERTEX_SHADER
	code:[NSString stringWithContentsOfFile:
	[[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:nil]
	encoding:NSUTF8StringEncoding error:NULL]] autorelease];
}

+(GLShader *)vertexShaderWithCode:(NSString *)code
{
	return [[[self alloc] initWithType:GL_VERTEX_SHADER code:code] autorelease];
}



+(GLShader *)fragmentShaderFromFile:(NSString *)filename
{
	return [[[self alloc] initWithType:GL_FRAGMENT_SHADER
	code:[NSString stringWithContentsOfFile:filename
	encoding:NSUTF8StringEncoding error:NULL]] autorelease];
}

+(GLShader *)fragmentShaderFromResource:(NSString *)filename
{
	return [[[self alloc] initWithType:GL_FRAGMENT_SHADER
	code:[NSString stringWithContentsOfFile:
	[[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:nil]
	encoding:NSUTF8StringEncoding error:NULL]] autorelease];
}

+(GLShader *)fragmentShaderWithCode:(NSString *)code
{
	return [[[self alloc] initWithType:GL_FRAGMENT_SHADER code:code] autorelease];
}



-(id)initWithType:(GLenum)type code:(NSString *)code
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

-(void)delete
{
	[self doesNotRecognizeSelector:_cmd];
}



-(BOOL)isValid { [self doesNotRecognizeSelector:_cmd]; return NO; }

-(NSString *)log { [self doesNotRecognizeSelector:_cmd]; return nil; }

@end



@implementation GLShaderARB

-(id)initWithType:(GLenum)type code:(NSString *)code
{
	if((self=[super init]))
	{
		shader=0;
		if(code)
		{
			shader=glCreateShaderObjectARB(type);
			if(shader)
			{
				const char *str=[code UTF8String];
				glShaderSourceARB(shader,1,&str,NULL);
				glCompileShaderARB(shader);
				return self;
			}
		}
		[self release];
	}
	return nil;
}

-(void)dealloc
{
	GLWarnIfNotDeleted(self,shader);
	[super dealloc];
}

-(void)finalize
{
	GLWarnIfNotDeleted(self,shader);
	[super finalize];
}

-(void)delete
{
	if(shader) glDeleteObjectARB(shader);
	shader=0;
}



-(GLhandleARB)shaderARB { return shader; }

-(BOOL)isValid
{
	GLAssertNotDeleted(self,shader);

	GLint status;
	glGetObjectParameterivARB(shader,GL_OBJECT_COMPILE_STATUS_ARB,&status);
	return status?YES:NO;
}

-(NSString *)log
{
	GLAssertNotDeleted(self,shader);

	char buffer[8192];
	glGetInfoLogARB(shader,sizeof(buffer),NULL,buffer);
	return [NSString stringWithUTF8String:buffer];
}

@end




#if OPENGL_VERSION>=20
@implementation GLShaderOpenGL20

-(id)initWithType:(GLenum)type code:(NSString *)code
{
	if((self=[super init]))
	{
		shader=0;
		if(code)
		{
			shader=glCreateShader(type);
			if(shader)
			{
				const char *str=[code UTF8String];
				glShaderSource(shader,1,&str,NULL);
				glCompileShader(shader);
				return self;
			}
		}
		[self release];
	}
	return nil;
}

-(void)dealloc
{
	GLWarnIfNotDeleted(self,shader);
	[super dealloc];
}

-(void)finalize
{
	GLWarnIfNotDeleted(self,shader);
	[super finalize];
}

-(void)delete
{
	if(shader) glDeleteShader(shader);
	shader=0;
}



-(GLuint)shaderOpenGL20 { return shader; }

-(BOOL)isValid
{
	GLAssertNotDeleted(self,shader);

	GLint status;
	glGetShaderiv(shader,GL_COMPILE_STATUS,&status);
	return status?YES:NO;
}

-(NSString *)log
{
	GLAssertNotDeleted(self,shader);

	char buffer[8192];
	glGetShaderInfoLog(shader,sizeof(buffer),NULL,buffer);
	return [NSString stringWithUTF8String:buffer];
}

@end
#endif
