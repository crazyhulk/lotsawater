#import "GLObject.h"

#if OPENGL_VERSION<20
#define GL_VERTEX_SHADER GL_VERTEX_SHADER_ARB
#define GL_FRAGMENT_SHADER GL_FRAGMENT_SHADER_ARB
//#define GL_GEOMETRY_SHADER GL_GEOMETRY_SHADER_EXT
#endif

#define GLShader MangleClassName(GLShader)

@interface GLShader:NSObject
{
}

+(GLShader *)vertexShaderFromFile:(NSString *)filename;
+(GLShader *)vertexShaderFromResource:(NSString *)filename;
+(GLShader *)vertexShaderWithCode:(NSString *)code;
+(GLShader *)fragmentShaderFromFile:(NSString *)filename;
+(GLShader *)fragmentShaderFromResource:(NSString *)filename;
+(GLShader *)fragmentShaderWithCode:(NSString *)code;
//+(GLShader *)geometryShaderFromFile:(NSString *)filename;
//+(GLShader *)geometryShaderFromResource:(NSString *)filename;
//+(GLShader *)geometryShaderWithCode:(NSString *)code;

-(id)initWithType:(GLenum)type code:(NSString *)code;

-(void)delete;

-(BOOL)isValid;
-(NSString *)log;

@end



#define GLShaderARB MangleClassName(GLShaderARB)
@interface GLShaderARB:GLShader
{
	GLhandleARB shader;
}
-(GLhandleARB)shaderARB;
@end

#if OPENGL_VERSION>=20
#define GLShaderOpenGL20 MangleClassName(GLShaderOpenGL20)
@interface GLShaderOpenGL20:GLShader
{
	GLuint shader;
}
-(GLuint)shaderOpenGL20;
@end
#endif
