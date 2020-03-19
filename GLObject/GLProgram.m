#import "GLProgram.h"

#define GLProgramARB MangleClassName(GLProgramARB)
@interface GLProgramARB:GLProgram
{
	GLhandleARB program;
	BOOL linked;
}
@end

#if OPENGL_VERSION>=20
#define GLProgramOpenGL20 MangleClassName(GLProgramOpenGL20)
@interface GLProgramOpenGL20:GLProgram
{
	GLuint program;
	BOOL linked;
}
@end
#endif



@implementation GLProgram

+(id)allocWithZone:(NSZone *)zone
{
	if(self!=[GLProgram class]) return [super allocWithZone:zone];

	#if OPENGL_VERSION>=20
	if(glCreateProgram&&glDeleteProgram&&glLinkProgram&&glUseProgram)
	return [GLProgramOpenGL20 allocWithZone:zone];
	#endif

	return [GLProgramARB allocWithZone:zone];
}

+(GLProgram *)programWithShaders:(GLShader *)first,...
{
	GLProgram *program=[[self new] autorelease];

	va_list va;
	va_start(va,first);
	for(GLShader *shader=first;shader;shader=va_arg(va,GLShader *)) [program attachShader:shader];
	va_end(va);

	return program;
}

+(GLProgram *)programWithShaderArray:(NSArray *)shaderarray
{
	GLProgram *program=[[self new] autorelease];

	NSEnumerator *enumerator=[shaderarray objectEnumerator];
	GLShader *shader;
	while((shader=[enumerator nextObject])) [program attachShader:shader];

	return program;
}

+(GLProgram *)linkedProgramWithShaders:(GLShader *)first,...
{
	GLProgram *program=[[self new] autorelease];

	va_list va;
	va_start(va,first);
	for(GLShader *shader=first;shader;shader=va_arg(va,GLShader *)) [program attachShader:shader];
	va_end(va);

	[program link];
	if(![program isLinked])
	{
		NSLog(@"Error linking program: %@",[program fullLog]);
		[program delete];
		return nil;
	}

	return program;
}



-(id)init
{
	if((self=[super init]))
	{
		shaders=[NSMutableArray new];
	}
	return self;
}

-(void)dealloc
{
	[shaders release];
	[super dealloc];
}

-(void)delete
{
	[shaders makeObjectsPerformSelector:@selector(delete)];
}



-(BOOL)isLinked { [self doesNotRecognizeSelector:_cmd]; return NO; }

-(BOOL)areShadersValid
{
	NSEnumerator *enumerator=[shaders objectEnumerator];
	GLShader *shader;
	while((shader=[enumerator nextObject])) if(![shader isValid]) return NO;
	return YES;
}

-(NSString *)log { [self doesNotRecognizeSelector:_cmd]; return nil; }

-(NSString *)fullLog
{
	NSMutableString *fulllog=[NSMutableString string];

	NSEnumerator *enumerator=[shaders objectEnumerator];
	GLShader *shader;
	while((shader=[enumerator nextObject]))
	{
		NSString *log=[shader log];
		[fulllog appendString:log];
	}
	[fulllog appendString:[self log]];

	return fulllog;
}

-(void)link { [self doesNotRecognizeSelector:_cmd]; }

-(void)use { [self doesNotRecognizeSelector:_cmd]; }

-(void)remove { [self doesNotRecognizeSelector:_cmd]; }

-(void)attachShader:(GLShader *)shader { [self doesNotRecognizeSelector:_cmd]; }

-(void)attachVertexShaderFromFile:(NSString *)filename
{
	[self attachShader:[GLShader vertexShaderFromFile:filename]];
}

-(void)attachFragmentShaderFromFile:(NSString *)filename
{
	[self attachShader:[GLShader fragmentShaderFromFile:filename]];
}

-(void)attachVertexShaderFromResource:(NSString *)filename
{
	[self attachShader:[GLShader vertexShaderFromResource:filename]];
}

-(void)attachFragmentShaderFromResource:(NSString *)filename
{
	[self attachShader:[GLShader fragmentShaderFromResource:filename]];
}

-(void)detachShader:(GLShader *)shader { [self doesNotRecognizeSelector:_cmd]; }

-(void)setIndexOfVertexAttrib:(NSString *)attrib to:(int)index { [self doesNotRecognizeSelector:_cmd]; }

-(GLint)indexOfVertexAttrib:(NSString *)attrib { [self doesNotRecognizeSelector:_cmd]; return 0; }

-(void)setAndEnableVertexAttrib:(NSString *)attrib buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type { [self doesNotRecognizeSelector:_cmd]; }

-(void)setAndEnableVertexAttrib:(NSString *)attrib buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type normalized:(GLboolean)normalized
{ [self doesNotRecognizeSelector:_cmd]; }

-(void)setAndEnableVertexAttrib:(NSString *)attrib buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type normalized:(GLboolean)normalized stride:(GLsizei)stride offset:(GLsizeiptr)offset
{ [self doesNotRecognizeSelector:_cmd]; }

-(void)setAndEnableVertexAttribAtIndex:(GLuint)index buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type
{ [self doesNotRecognizeSelector:_cmd]; }

-(void)setAndEnableVertexAttribAtIndex:(GLuint)index buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type normalized:(GLboolean)normalized;
{ [self doesNotRecognizeSelector:_cmd]; }

-(void)setAndEnableVertexAttribAtIndex:(GLuint)index buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type normalized:(GLboolean)normalized stride:(GLsizei)stride offset:(GLsizeiptr)offset
{ [self doesNotRecognizeSelector:_cmd]; }



-(GLint)indexOfUniform:(NSString *)attrib { [self doesNotRecognizeSelector:_cmd]; return 0; }

-(void)setUniform:(NSString *)attrib value:(float)value { [self doesNotRecognizeSelector:_cmd]; }

-(void)setUniform:(NSString *)attrib integer:(GLint)value { [self doesNotRecognizeSelector:_cmd]; }

-(void)setUniform:(NSString *)attrib x:(float)x y:(float)y { [self doesNotRecognizeSelector:_cmd]; }

-(void)setUniform:(NSString *)attrib x:(float)x y:(float)y z:(float)z { [self doesNotRecognizeSelector:_cmd]; }

-(void)setUniform:(NSString *)attrib x:(float)x y:(float)y z:(float)z w:(float)w { [self doesNotRecognizeSelector:_cmd]; }

-(void)setUniform:(NSString *)attrib vec2:(vec2_t)v { [self doesNotRecognizeSelector:_cmd]; }

-(void)setUniform:(NSString *)attrib vec3:(vec3_t)v { [self doesNotRecognizeSelector:_cmd]; }

-(void)setUniform:(NSString *)attrib vec4:(vec4_t)v { [self doesNotRecognizeSelector:_cmd]; }

-(void)setUniform:(NSString *)attrib mat2x2:(mat2x2_t)m { [self doesNotRecognizeSelector:_cmd]; }

-(void)setUniform:(NSString *)attrib mat3x2:(mat3x2_t)m { [self doesNotRecognizeSelector:_cmd]; }

-(void)setUniform:(NSString *)attrib mat3x3:(mat3x3_t)m { [self doesNotRecognizeSelector:_cmd]; }

-(void)setUniform:(NSString *)attrib mat4x3:(mat4x3_t)m { [self doesNotRecognizeSelector:_cmd]; }

-(void)setUniform:(NSString *)attrib mat4x4:(mat4x4_t)m { [self doesNotRecognizeSelector:_cmd]; }

@end




@implementation GLProgramARB

-(id)init
{
	if((self=[super init]))
	{
		program=glCreateProgramObjectARB();
		linked=NO;

		if(program) return self;

		[self release];
	}
	return nil;
}

-(void)dealloc
{
	GLWarnIfNotDeleted(self,program);
	[super dealloc];
}

-(void)finalize
{
	GLWarnIfNotDeleted(self,program);
	[super finalize];
}

-(void)delete
{
	if(program) glDeleteObjectARB(program);
	program=0;
	[super delete];
}



-(BOOL)isLinked
{
	GLAssertNotDeleted(self,program);

	GLint status;
	glGetObjectParameterivARB(program,GL_OBJECT_LINK_STATUS_ARB,&status);
	return status?YES:NO;
}

-(NSString *)log
{
	GLAssertNotDeleted(self,program);

	char buffer[8192];
	glGetInfoLogARB(program,sizeof(buffer),NULL,buffer);
	return [NSString stringWithUTF8String:buffer];
}

-(void)link
{
	GLAssertNotDeleted(self,program);

	glLinkProgramARB(program);
	linked=YES;
}

-(void)use
{
	GLAssertNotDeleted(self,program);

	if(!linked) [self link];
	glUseProgramObjectARB(program);
}

-(void)remove
{
	glUseProgramObjectARB(0);
}

-(void)attachShader:(GLShader *)shader
{
	GLAssertNotDeleted(self,program);

	if(!shader) return;
	[shaders addObject:shader];
	glAttachObjectARB(program,[(GLShaderARB *)shader shaderARB]);
	linked=NO;
}

-(void)detachShader:(GLShader *)shader
{
	GLAssertNotDeleted(self,program);

	glDetachObjectARB(program,[(GLShaderARB *)shader shaderARB]);
	[shaders removeObject:shader];
	linked=NO;
}

-(void)setIndexOfVertexAttrib:(NSString *)attrib to:(int)index
{
	GLAssertNotDeleted(self,program);

	glBindAttribLocationARB(program,index,[attrib UTF8String]);
}

-(GLint)indexOfVertexAttrib:(NSString *)attrib
{
	GLAssertNotDeleted(self,program);

	return glGetAttribLocationARB(program,[attrib UTF8String]);
}

-(void)setAndEnableVertexAttrib:(NSString *)attrib buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type
{
	[buffer bind];
	GLuint index=[self indexOfVertexAttrib:attrib];
	glVertexAttribPointerARB([self indexOfVertexAttrib:attrib],size,type,GL_FALSE,0,0);
	glEnableVertexAttribArrayARB(index);
}

-(void)setAndEnableVertexAttrib:(NSString *)attrib buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type normalized:(GLboolean)normalized
{
	[buffer bind];
	GLuint index=[self indexOfVertexAttrib:attrib];
	glVertexAttribPointerARB(index,size,type,normalized,0,0);
	glEnableVertexAttribArrayARB(index);
}

-(void)setAndEnableVertexAttrib:(NSString *)attrib buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type normalized:(GLboolean)normalized stride:(GLsizei)stride offset:(GLsizeiptr)offset
{
	[buffer bind];
	GLuint index=[self indexOfVertexAttrib:attrib];
	glVertexAttribPointerARB([self indexOfVertexAttrib:attrib],size,type,normalized,stride,(const void *)offset);
	glEnableVertexAttribArrayARB(index);
}

-(void)setAndEnableVertexAttribAtIndex:(GLuint)index buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type
{
	[buffer bind];
	glVertexAttribPointerARB(index,size,type,GL_FALSE,0,0);
	glEnableVertexAttribArrayARB(index);
}

-(void)setAndEnableVertexAttribAtIndex:(GLuint)index buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type normalized:(GLboolean)normalized;
{
	[buffer bind];
	glVertexAttribPointerARB(index,size,type,normalized,0,0);
	glEnableVertexAttribArrayARB(index);
}

-(void)setAndEnableVertexAttribAtIndex:(GLuint)index buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type normalized:(GLboolean)normalized stride:(GLsizei)stride offset:(GLsizeiptr)offset
{
	[buffer bind];
	glVertexAttribPointerARB(index,size,type,normalized,stride,(const void *)offset);
	glEnableVertexAttribArrayARB(index);
}



-(GLint)indexOfUniform:(NSString *)attrib
{
	GLAssertNotDeleted(self,program);
	return glGetUniformLocationARB(program,[attrib UTF8String]);
}

-(void)setUniform:(NSString *)attrib value:(float)value
{ glUniform1fARB([self indexOfUniform:attrib],value); }

-(void)setUniform:(NSString *)attrib integer:(GLint)value
{ glUniform1iARB([self indexOfUniform:attrib],value); }

-(void)setUniform:(NSString *)attrib x:(float)x y:(float)y
{ glUniform2fARB([self indexOfUniform:attrib],x,y); }

-(void)setUniform:(NSString *)attrib x:(float)x y:(float)y z:(float)z
{ glUniform3fARB([self indexOfUniform:attrib],x,y,z); }

-(void)setUniform:(NSString *)attrib x:(float)x y:(float)y z:(float)z w:(float)w
{ glUniform4fARB([self indexOfUniform:attrib],x,y,z,w); }

-(void)setUniform:(NSString *)attrib vec2:(vec2_t)v
{ glUniform2fARB([self indexOfUniform:attrib],v.x,v.y); }

-(void)setUniform:(NSString *)attrib vec3:(vec3_t)v
{ glUniform3fARB([self indexOfUniform:attrib],v.x,v.y,v.z); }

-(void)setUniform:(NSString *)attrib vec4:(vec4_t)v
{ glUniform4fARB([self indexOfUniform:attrib],v.x,v.y,v.z,v.w); }

-(void)setUniform:(NSString *)attrib mat2x2:(mat2x2_t)m
{ glUniformMatrix2fvARB([self indexOfUniform:attrib],1,GL_FALSE,m.m); }

-(void)setUniform:(NSString *)attrib mat3x3:(mat3x3_t)m
{ glUniformMatrix3fvARB([self indexOfUniform:attrib],1,GL_FALSE,m.m); }

-(void)setUniform:(NSString *)attrib mat4x4:(mat4x4_t)m;
{ glUniformMatrix4fvARB([self indexOfUniform:attrib],1,GL_FALSE,m.m); }

@end



#if OPENGL_VERSION>=20
@implementation GLProgramOpenGL20

-(id)init
{
	if((self=[super init]))
	{
		program=glCreateProgram();
		linked=NO;

		if(program) return self;

		[self release];
	}
	return nil;
}

-(void)dealloc
{
	GLWarnIfNotDeleted(self,program);
	[super dealloc];
}

-(void)finalize
{
	GLWarnIfNotDeleted(self,program);
	[super finalize];
}

-(void)delete
{
	if(program) glDeleteProgram(program);
	program=0;
	[super delete];
}



-(BOOL)isLinked
{
	GLAssertNotDeleted(self,program);

	GLint status;
	glGetProgramiv(program,GL_LINK_STATUS,&status);
	return status?YES:NO;
}

-(NSString *)log
{
	GLAssertNotDeleted(self,program);

	char buffer[8192];
	glGetProgramInfoLog(program,sizeof(buffer),NULL,buffer);
	return [NSString stringWithUTF8String:buffer];
}

-(void)link
{
	GLAssertNotDeleted(self,program);

	glLinkProgram(program);
	linked=YES;
}

-(void)use
{
	GLAssertNotDeleted(self,program);

	if(!linked) [self link];
	glUseProgram(program);
}

-(void)remove
{
	glUseProgram(0);
}

-(void)attachShader:(GLShader *)shader
{
	GLAssertNotDeleted(self,program);

	if(!shader) return;
	[shaders addObject:shader];
	glAttachShader(program,[(GLShaderOpenGL20 *)shader shaderOpenGL20]);
	linked=NO;
}

-(void)detachShader:(GLShader *)shader
{
	GLAssertNotDeleted(self,program);

	glDetachShader(program,[(GLShaderOpenGL20 *)shader shaderOpenGL20]);
	[shaders removeObject:shader];
	linked=NO;
}

-(void)setIndexOfVertexAttrib:(NSString *)attrib to:(int)index
{
	GLAssertNotDeleted(self,program);

	glBindAttribLocation(program,index,[attrib UTF8String]);
}

-(GLint)indexOfVertexAttrib:(NSString *)attrib
{
	GLAssertNotDeleted(self,program);

	return glGetAttribLocation(program,[attrib UTF8String]);
}

-(void)setAndEnableVertexAttrib:(NSString *)attrib buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type
{
	[buffer bind];
	GLuint index=[self indexOfVertexAttrib:attrib];
	glVertexAttribPointer([self indexOfVertexAttrib:attrib],size,type,GL_FALSE,0,0);
	glEnableVertexAttribArray(index);
}

-(void)setAndEnableVertexAttrib:(NSString *)attrib buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type normalized:(GLboolean)normalized
{
	[buffer bind];
	GLuint index=[self indexOfVertexAttrib:attrib];
	glVertexAttribPointer(index,size,type,normalized,0,0);
	glEnableVertexAttribArray(index);
}

-(void)setAndEnableVertexAttrib:(NSString *)attrib buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type normalized:(GLboolean)normalized stride:(GLsizei)stride offset:(GLsizeiptr)offset
{
	[buffer bind];
	GLuint index=[self indexOfVertexAttrib:attrib];
	glVertexAttribPointer([self indexOfVertexAttrib:attrib],size,type,normalized,stride,(const void *)offset);
	glEnableVertexAttribArray(index);
}

-(void)setAndEnableVertexAttribAtIndex:(GLuint)index buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type
{
	[buffer bind];
	glVertexAttribPointer(index,size,type,GL_FALSE,0,0);
	glEnableVertexAttribArray(index);
}

-(void)setAndEnableVertexAttribAtIndex:(GLuint)index buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type normalized:(GLboolean)normalized;
{
	[buffer bind];
	glVertexAttribPointer(index,size,type,normalized,0,0);
	glEnableVertexAttribArray(index);
}

-(void)setAndEnableVertexAttribAtIndex:(GLuint)index buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type normalized:(GLboolean)normalized stride:(GLsizei)stride offset:(GLsizeiptr)offset
{
	[buffer bind];
	glVertexAttribPointer(index,size,type,normalized,stride,(const void *)offset);
	glEnableVertexAttribArray(index);
}



-(GLint)indexOfUniform:(NSString *)attrib
{
	GLAssertNotDeleted(self,program);
	return glGetUniformLocation(program,[attrib UTF8String]);
}

-(void)setUniform:(NSString *)attrib value:(float)value
{ glUniform1f([self indexOfUniform:attrib],value); }

-(void)setUniform:(NSString *)attrib integer:(GLint)value
{ glUniform1i([self indexOfUniform:attrib],value); }

-(void)setUniform:(NSString *)attrib x:(float)x y:(float)y
{ glUniform2f([self indexOfUniform:attrib],x,y); }

-(void)setUniform:(NSString *)attrib x:(float)x y:(float)y z:(float)z
{ glUniform3f([self indexOfUniform:attrib],x,y,z); }

-(void)setUniform:(NSString *)attrib x:(float)x y:(float)y z:(float)z w:(float)w
{ glUniform4f([self indexOfUniform:attrib],x,y,z,w); }

-(void)setUniform:(NSString *)attrib vec2:(vec2_t)v
{ glUniform2f([self indexOfUniform:attrib],v.x,v.y); }

-(void)setUniform:(NSString *)attrib vec3:(vec3_t)v
{ glUniform3f([self indexOfUniform:attrib],v.x,v.y,v.z); }

-(void)setUniform:(NSString *)attrib vec4:(vec4_t)v
{ glUniform4f([self indexOfUniform:attrib],v.x,v.y,v.z,v.w); }

-(void)setUniform:(NSString *)attrib mat2x2:(mat2x2_t)m
{ glUniformMatrix2fv([self indexOfUniform:attrib],1,GL_FALSE,m.m); }

-(void)setUniform:(NSString *)attrib mat3x2:(mat3x2_t)m
{ glUniformMatrix3x2fv([self indexOfUniform:attrib],1,GL_FALSE,m.m); }

-(void)setUniform:(NSString *)attrib mat3x3:(mat3x3_t)m
{ glUniformMatrix3fv([self indexOfUniform:attrib],1,GL_FALSE,m.m); }

-(void)setUniform:(NSString *)attrib mat4x3:(mat4x3_t)m
{ glUniformMatrix4x3fv([self indexOfUniform:attrib],1,GL_FALSE,m.m); }

-(void)setUniform:(NSString *)attrib mat4x4:(mat4x4_t)m;
{ glUniformMatrix4fv([self indexOfUniform:attrib],1,GL_FALSE,m.m); }

@end
#endif

