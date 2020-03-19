#import "GLObject.h"
#import "Vector.h"

#define GLMaxVertexAttribs 1024

typedef int GLVertexArrayEntry;

#define GLIllegal -1
#define GLEnd 0
#define GLVertex2f 1
#define GLVertex3f 2
#define GLNormal3f 3
#define GLTexCoord1f 4
#define GLTexCoord2f 5
#define GLTexCoord3f 6
#define GLColor3b 7
#define GLColor4b 8
#define GLVertexAttribStart 17
#define GLVertexAttribEnd (GLVertexAttribStart+GLMaxVertexAttribs*4-1)
#define GLPadStart (GLVertexAttribEnd+1)
#define GLPadEnd (GLPadStart+1023)

#define GLVertexAttribf(c,n) ((n)>=GLMaxVertexAttribs?GLIllegal:(n)<0?GLPad(4*(c)):GLVertexAttribStart+(n)+((c)-1)*GLMaxVertexAttribs)
#define GLPad(n) (GLPadStart+(n))

#define GLVertexAttrib1f(n) GLVertexAttribf(2,(n))
#define GLVertexAttrib2f(n) GLVertexAttribf(2,(n))
#define GLVertexAttrib3f(n) GLVertexAttribf(2,(n))
#define GLVertexAttrib4f(n) GLVertexAttribf(2,(n))

#define GLPad1b GLPad(1)
#define GLPad2b GLPad(2)
#define GLPad3b GLPad(3)
#define GLPad4b GLPad(4)

#define GLVertexArray MangleClassName(GLVertexArray)

@interface GLVertexArray:NSObject
{
//	NSMutableData *buffer;
	NSData *array;
	GLubyte *bufptr;
	int numelements,stride;

	int vertexoffs,vertexcomps;
	int normaloffs;
	int texcoordoffs,texcoordcomps;
	int coloroffs,colorcomps;
	int numattribs,*attriboffs,*attribcomps;
}

-(id)initWithEntries:(GLVertexArrayEntry)first,...;
-(id)initWithSize:(int)n entries:(GLVertexArrayEntry)first,...;
-(id)initWithData:(NSData *)data entries:(GLVertexArrayEntry)first,...;
-(void)dealloc;
-(void)finalize;

-(NSString *)_parseEntryListStartingWith:(GLVertexArrayEntry)first rest:(va_list)va;

-(void)lock;
-(void)lockRange:(NSRange)range;
-(void)unlock;
-(void)set;
-(void)unset;

-(int)count;
-(void *)setCount:(int)newlength;
-(void *)setCountToAtLeast:(int)newlength;
-(void *)setCountToAtLeast:(int)newlength stepSize:(int)stepsize;

-(void *)array;
-(int)stride;

-(void)setVertexAtIndex:(int)n x:(float)x y:(float)y;
-(void)setVertexAtIndex:(int)n x:(float)x y:(float)y z:(float)z;
-(void)setVertexAtIndex:(int)n vertex:(Vector)v;
-(void)setNormalAtIndex:(int)n x:(float)x y:(float)y z:(float)z;
-(void)setNormalAtIndex:(int)n normal:(Vector)norm;
-(void)setTexCoordAtIndex:(int)n u:(float)u;
-(void)setTexCoordAtIndex:(int)n u:(float)u v:(float)v;
-(void)setTexCoordAtIndex:(int)n u:(float)u v:(float)v w:(float)w;
-(void)setTexCoordAtIndex:(int)n coordinates:(Vector)v;
-(void)setColorAtIndex:(int)n r:(GLubyte)r g:(GLubyte)g b:(GLubyte)b;
-(void)setColorAtIndex:(int)n r:(GLubyte)r g:(GLubyte)g b:(GLubyte)b a:(GLubyte)a;
-(void)setVertexAttribute:(int)attrib atIndex:(int)n value:(float)val;
-(void)setVertexAttribute:(int)attrib atIndex:(int)n x:(float)x y:(float)y;
-(void)setVertexAttribute:(int)attrib atIndex:(int)n x:(float)x y:(float)y z:(float)z;
-(void)setVertexAttribute:(int)attrib atIndex:(int)n x:(float)x y:(float)y z:(float)z w:(float)w;

@end
