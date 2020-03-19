#import "GLObject.h"
#import "GLShader.h"
#import "GLBuffer.h"
#import "Vector/Vector.h"
#import "Vector/Matrix.h"

#define GLProgram MangleClassName(GLProgram)

@interface GLProgram:NSObject
{
	NSMutableArray *shaders;
}

+(GLProgram *)programWithShaders:(GLShader *)first,...;
+(GLProgram *)programWithShaderArray:(NSArray *)shaderarray;
+(GLProgram *)linkedProgramWithShaders:(GLShader *)first,...;

-(id)init;

-(void)delete;

-(BOOL)isLinked;
-(BOOL)areShadersValid;
-(NSString *)log;
-(NSString *)fullLog;

-(void)link;
-(void)use;
-(void)remove;

-(void)attachShader:(GLShader *)shader;
-(void)attachVertexShaderFromFile:(NSString *)filename;
-(void)attachFragmentShaderFromFile:(NSString *)filename;
-(void)attachVertexShaderFromResource:(NSString *)filename;
-(void)attachFragmentShaderFromResource:(NSString *)filename;
-(void)detachShader:(GLShader *)shader;

-(void)setIndexOfVertexAttrib:(NSString *)attrib to:(int)index;
-(GLint)indexOfVertexAttrib:(NSString *)attrib;
-(void)setAndEnableVertexAttrib:(NSString *)attrib buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type;
-(void)setAndEnableVertexAttrib:(NSString *)attrib buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type normalized:(GLboolean)normalized;
-(void)setAndEnableVertexAttrib:(NSString *)attrib buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type normalized:(GLboolean)normalized stride:(GLsizei)stride offset:(GLsizeiptr)offset;
-(void)setAndEnableVertexAttribAtIndex:(GLuint)index buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type;
-(void)setAndEnableVertexAttribAtIndex:(GLuint)index buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type normalized:(GLboolean)normalized;
-(void)setAndEnableVertexAttribAtIndex:(GLuint)index buffer:(GLBuffer *)buffer size:(GLint)size
type:(GLenum)type normalized:(GLboolean)normalized stride:(GLsizei)stride offset:(GLsizeiptr)offset;

-(GLint)indexOfUniform:(NSString *)attrib;
-(void)setUniform:(NSString *)attrib value:(float)value;
-(void)setUniform:(NSString *)attrib integer:(GLint)value;
-(void)setUniform:(NSString *)attrib x:(float)x y:(float)y;
-(void)setUniform:(NSString *)attrib x:(float)x y:(float)y z:(float)z;
-(void)setUniform:(NSString *)attrib x:(float)x y:(float)y z:(float)z w:(float)w;
-(void)setUniform:(NSString *)attrib vec2:(vec2_t)v;
-(void)setUniform:(NSString *)attrib vec3:(vec3_t)v;
-(void)setUniform:(NSString *)attrib vec4:(vec4_t)v;
-(void)setUniform:(NSString *)attrib mat2x2:(mat2x2_t)m;
-(void)setUniform:(NSString *)attrib mat3x2:(mat3x2_t)m;
-(void)setUniform:(NSString *)attrib mat3x3:(mat3x3_t)m;
-(void)setUniform:(NSString *)attrib mat4x3:(mat4x3_t)m;
-(void)setUniform:(NSString *)attrib mat4x4:(mat4x4_t)m;

@end
