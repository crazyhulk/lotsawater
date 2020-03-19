#import "GLVertexArray.h"
#import "NSValueArrayAdditions.h"

@implementation GLVertexArray

#if 0

static PFNGLLOCKARRAYSEXTPROC glLockArraysEXT;
static PFNGLUNLOCKARRAYSEXTPROC glUnlockArraysEXT;

+(void)initialize
{
	glLockArraysEXT=(PFNGLLOCKARRAYSEXTPROC)SDL_GL_GetProcAddress("glLockArraysEXT");
	glUnlockArraysEXT=(PFNGLUNLOCKARRAYSEXTPROC)SDL_GL_GetProcAddress("glUnlockArraysEXT");
}
#endif

-(id)initWithEntries:(GLVertexArrayEntry)first,...
{
	if(self=[super init])
	{
		va_list va;
		va_start(va,first);
		NSString *objctype=[self _parseEntryListStartingWith:first rest:va];
		va_end(va);

		array=[[NSMutableValueArray valueArrayWithObjCType:[objctype UTF8String]] retain];
		stride=[array valueSize];
		bufptr=[array mutableBytes];

		numattribs=0;
		attriboffs=attribcomps=NULL;
	}
	return self;
}

-(id)initWithSize:(int)n entries:(GLVertexArrayEntry)first,...
{
	if(self=[super init])
	{
		va_list va;
		va_start(va,first);
		NSString *objctype=[self _parseEntryListStartingWith:first rest:va];
		va_end(va);

		array=[[NSMutableValueArray valueArrayWithCount:n withObjCType:[objctype UTF8String]] retain];
		stride=[array valueSize];
		bufptr=[array mutableBytes];
	}
	return self;
}

-(id)initWithValueArray:(NSMutableValueArray *)valuearray entries:(GLVertexArrayEntry)first,...
{
	if(self=[super init])
	{
		va_list va;
		va_start(va,first);
		NSString *objctype=[self _parseEntryListStartingWith:first rest:va];
		va_end(va);

		NSUInteger size,align;
		NSGetSizeAndAlignment([objctype UTF8String],&size,&align);

		NSUInteger valuesize=[valuearray valueSize];
		if(size!=valuesize)
		{
			array=nil;
			[self release];
			[NSException raise:NSInvalidArgumentException
			format:@"Array entry size (%lu) does not match the size specified for GLVertexArray (%lu)",
			valuesize,size];
		}

		array=[valuearray retain];
		stride=[array valueSize];
		bufptr=[array mutableBytes];
	}
	return self;
}

-(void)dealloc
{
	//if(set) NSLog(@"Deleting enabled vertex array %@",self);
	free(attriboffs);
	free(attribcomps);
	[array release];

	[super dealloc];
}

-(void)finalize
{
	//if(set) NSLog(@"Finalizing enabled vertex array %@",self);
	[super finalize];
}



-(NSString *)_parseEntryListStartingWith:(GLVertexArrayEntry)first rest:(va_list)va
{
	vertexoffs=normaloffs=texcoordoffs=coloroffs=-1;
	numattribs=0;
	attriboffs=attribcomps=NULL;

	NSMutableString *typestr=[NSMutableString stringWithString:@"{?="];
	const char *type;
	char strbuf[128];
	int offs=0;

	GLVertexArrayEntry entry=first;
	do
	{
		switch(entry)
		{
			case GLVertex2f:
				if(vertexoffs>=0) [NSException raise:NSInvalidArgumentException format:@"GLVertexArray can only have one vertex entry"];
				vertexoffs=offs;
				vertexcomps=2;
				type=@encode(GLfloat[2]);
			break;

			case GLVertex3f:
				if(vertexoffs>=0) [NSException raise:NSInvalidArgumentException format:@"GLVertexArray can only have one vertex entry"];
				vertexoffs=offs;
				vertexcomps=3;
				type=@encode(Vector);
			break;

			case GLNormal3f:
				if(normaloffs>=0) [NSException raise:NSInvalidArgumentException format:@"GLVertexArray can only have one normal entry"];
				normaloffs=offs;
				type=@encode(Vector);
			break;

			case GLTexCoord1f:
				if(texcoordoffs>=0) [NSException raise:NSInvalidArgumentException format:@"GLVertexArray can only have one texture coordinate entry"];
				texcoordoffs=offs;
				texcoordcomps=1;
				type=@encode(GLfloat);
			break;

			case GLTexCoord2f:
				if(texcoordoffs>=0) [NSException raise:NSInvalidArgumentException format:@"GLVertexArray can only have one texture coordinate entry"];
				texcoordoffs=offs;
				texcoordcomps=2;
				type=@encode(GLfloat[2]);
			break;

			case GLTexCoord3f:
				if(texcoordoffs>=0) [NSException raise:NSInvalidArgumentException format:@"GLVertexArray can only have one texture coordinate entry"];
				texcoordoffs=offs;
				texcoordcomps=3;
				type=@encode(GLfloat[3]);
			break;

			case GLColor3b:
				if(coloroffs>=0) [NSException raise:NSInvalidArgumentException format:@"GLVertexArray can only have one colour entry"];
				coloroffs=offs;
				colorcomps=3;
				type=@encode(GLubyte[3]);
			break;

			case GLColor4b:
				if(coloroffs>=0) [NSException raise:NSInvalidArgumentException format:@"GLVertexArray can only have one colour entry"];
				coloroffs=offs;
				colorcomps=4;
				type=@encode(GLubyte[4]);
			break;

			default:
				if(entry>=GLVertexAttribStart&&entry<=GLVertexAttribEnd)
				{
					int index=(entry-GLVertexAttribStart)%GLMaxVertexAttribs;
					int comps=(entry-GLVertexAttribStart)%GLMaxVertexAttribs;

					if(index>=numattribs)
					{
						attriboffs=realloc(attriboffs,(index+1)*sizeof(int));
						attribcomps=realloc(attribcomps,(index+1)*sizeof(int));
						for(int i=numattribs;i<=index-1;i++) attriboffs[i]=-1;
						numattribs=index+1;
					}

					attriboffs[index]=offs;
					attribcomps[index]=comps;

					sprintf(strbuf,"[%df]",comps);
					type=strbuf;
				}
				else if(entry>=GLPadStart&&entry<=GLPadEnd)
				{
					sprintf(strbuf,"[%dC]",entry-GLPadStart);
					type=strbuf;
				}
				else [NSException raise:NSInvalidArgumentException format:@"Unknown vertex array entry type for GLVertexArray"];
			break;
		}

		[typestr appendFormat:@"%s",type];

		NSUInteger size,align;
		NSGetSizeAndAlignment(type,&size,&align);
		offs+=size;
	}
	while(entry=va_arg(va,GLVertexArrayEntry));

	[typestr appendString:@"}"];
	return typestr;
}

-(void)set
{
	if(vertexoffs>=0)
	{
		glVertexPointer(vertexcomps,GL_FLOAT,stride,bufptr+vertexoffs);
		glEnableClientState(GL_VERTEX_ARRAY);
	}

	if(normaloffs>=0)
	{
		glNormalPointer(GL_FLOAT,stride,bufptr+normaloffs);
		glEnableClientState(GL_NORMAL_ARRAY);
	}

	if(texcoordoffs>=0)
	{
		glTexCoordPointer(texcoordcomps,GL_FLOAT,stride,bufptr+texcoordoffs);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	}

	if(coloroffs>=0)
	{
		glColorPointer(colorcomps,GL_UNSIGNED_BYTE,stride,bufptr+coloroffs);
		glEnableClientState(GL_COLOR_ARRAY);
	}

	for(int i=0;i<numattribs;i++) if(attriboffs[i]>=0)
	{
		glVertexAttribPointerARB(i,attribcomps[i],GL_FLOAT,NO,stride,bufptr+attriboffs[i]);
		glEnableVertexAttribArrayARB(i);
	}
}

-(void)unset
{
	if(vertexoffs>=0) glDisableClientState(GL_VERTEX_ARRAY);
	if(normaloffs>=0) glDisableClientState(GL_NORMAL_ARRAY);
	if(texcoordoffs>=0) glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	if(coloroffs>=0) glDisableClientState(GL_COLOR_ARRAY);
	for(int i=0;i<numattribs;i++) if(attriboffs[i]>=0) glDisableVertexAttribArrayARB(i);
}

-(void)lock
{
	[self set];
	glLockArraysEXT(0,numelements);
}

-(void)lockRange:(NSRange)range
{
	[self set];
	glLockArraysEXT(range.location,range.length);
}

-(void)unlock
{
//	if(glUnlockArraysEXT_ptr) glUnlockArraysEXT_ptr();
	glUnlockArraysEXT();
	[self unset];
}

-(int)count
{
	return numelements;
}

-(void *)setCount:(int)newlength
{
	[array setCount:newlength];
	numelements=newlength;
	bufptr=[array mutableBytes];
	return bufptr;
}

-(void *)setCountToAtLeast:(int)newlength
{
	if(newlength>numelements) [self setCount:newlength];
	return bufptr;
}

-(void *)setCountToAtLeast:(int)newlength stepSize:(int)stepsize
{
	if(newlength>numelements) [self setCount:(((newlength-1)/stepsize)+1)*stepsize];
	return bufptr;
}

-(void *)array { return bufptr; }

-(int)stride { return stride; }

-(void)setVertexAtIndex:(int)n x:(float)x y:(float)y
{
	if(n<0||n>=numelements) [NSException raise:NSRangeException format:@"Index %d is out of bounds for GLVertexArray of size %d",n,numelements];
	if(vertexoffs<0) [NSException raise:NSInvalidArgumentException format:@"Cannot set a vertex for a GLVertexArray which does not contain vertices"];
	if(vertexcomps!=2) [NSException raise:NSInvalidArgumentException format:@"Cannot set a 2-component vertex for GLVertexArray using %d-element vertices",vertexcomps];

	((GLfloat *)(bufptr+n*stride+vertexoffs))[0]=x;
	((GLfloat *)(bufptr+n*stride+vertexoffs))[1]=y;
}

-(void)setVertexAtIndex:(int)n x:(float)x y:(float)y z:(float)z
{
	if(n<0||n>=numelements) [NSException raise:NSRangeException format:@"Index %d is out of bounds for GLVertexArray of size %d",n,numelements];
	if(vertexoffs<0) [NSException raise:NSInvalidArgumentException format:@"Cannot set a vertex for a GLVertexArray which does not contain vertices"];
	if(vertexcomps!=3) [NSException raise:NSInvalidArgumentException format:@"Cannot set a 3-component vertex for GLVertexArray using %d-element vertices",vertexcomps];

	((GLfloat *)(bufptr+n*stride+vertexoffs))[0]=x;
	((GLfloat *)(bufptr+n*stride+vertexoffs))[1]=y;
	((GLfloat *)(bufptr+n*stride+vertexoffs))[2]=z;
}

-(void)setVertexAtIndex:(int)n vertex:(Vector)v
{
	if(n<0||n>=numelements) [NSException raise:NSRangeException format:@"Index %d is out of bounds for GLVertexArray of size %d",n,numelements];
	if(vertexoffs<0) [NSException raise:NSInvalidArgumentException format:@"Cannot set a vertex for a GLVertexArray which does not contain vertices"];
	if(vertexcomps!=3) [NSException raise:NSInvalidArgumentException format:@"Cannot set a 3-component vertex for GLVertexArray using %d-element vertices",vertexcomps];

	((GLfloat *)(bufptr+n*stride+vertexoffs))[0]=v.x;
	((GLfloat *)(bufptr+n*stride+vertexoffs))[1]=v.y;
	((GLfloat *)(bufptr+n*stride+vertexoffs))[2]=v.z;
}

-(void)setNormalAtIndex:(int)n x:(float)x y:(float)y z:(float)z
{
	if(n<0||n>=numelements) [NSException raise:NSRangeException format:@"Index %d is out of bounds for GLVertexArray of size %d",n,numelements];
	if(normaloffs<0) [NSException raise:NSInvalidArgumentException format:@"Cannot set a normal for a GLVertexArray which does not contain normals"];
	((GLfloat *)(bufptr+n*stride+normaloffs))[0]=x;
	((GLfloat *)(bufptr+n*stride+normaloffs))[1]=y;
	((GLfloat *)(bufptr+n*stride+normaloffs))[2]=z;
}

-(void)setNormalAtIndex:(int)n normal:(Vector)norm;
{
	if(n<0||n>=numelements) [NSException raise:NSRangeException format:@"Index %d is out of bounds for GLVertexArray of size %d",n,numelements];
	if(normaloffs<0) [NSException raise:NSInvalidArgumentException format:@"Cannot set a normal for a GLVertexArray which does not contain normals"];
	((GLfloat *)(bufptr+n*stride+normaloffs))[0]=norm.x;
	((GLfloat *)(bufptr+n*stride+normaloffs))[1]=norm.y;
	((GLfloat *)(bufptr+n*stride+normaloffs))[2]=norm.z;
}

-(void)setTexCoordAtIndex:(int)n u:(float)u
{
	if(n<0||n>=numelements) [NSException raise:NSRangeException format:@"Index %d is out of bounds for GLVertexArray of size %d",n,numelements];
	if(texcoordoffs<0) [NSException raise:NSInvalidArgumentException format:@"Cannot set a texture coordinate for a GLVertexArray which does not contain texture coordinates"];
	if(texcoordcomps!=1) [NSException raise:NSInvalidArgumentException format:@"Cannot set a 1-component texture coordinate for GLVertexArray using %d-element texture coordinates",texcoordcomps];

	((GLfloat *)(bufptr+n*stride+texcoordoffs))[0]=u;
}

-(void)setTexCoordAtIndex:(int)n u:(float)u v:(float)v
{
	if(n<0||n>=numelements) [NSException raise:NSRangeException format:@"Index %d is out of bounds for GLVertexArray of size %d",n,numelements];
	if(texcoordoffs<0) [NSException raise:NSInvalidArgumentException format:@"Cannot set a texture coordinate for a GLVertexArray which does not contain texture coordinates"];
	if(texcoordcomps!=2) [NSException raise:NSInvalidArgumentException format:@"Cannot set a 2-component texture coordinate for GLVertexArray using %d-element texture coordinates",texcoordcomps];

	((GLfloat *)(bufptr+n*stride+texcoordoffs))[0]=u;
	((GLfloat *)(bufptr+n*stride+texcoordoffs))[1]=v;
}

-(void)setTexCoordAtIndex:(int)n u:(float)u v:(float)v w:(float)w
{
	if(n<0||n>=numelements) [NSException raise:NSRangeException format:@"Index %d is out of bounds for GLVertexArray of size %d",n,numelements];
	if(texcoordoffs<0) [NSException raise:NSInvalidArgumentException format:@"Cannot set a texture coordinate for a GLVertexArray which does not contain texture coordinates"];
	if(texcoordcomps!=3) [NSException raise:NSInvalidArgumentException format:@"Cannot set a 3-component texture coordinate for GLVertexArray using %d-element texture coordinates",texcoordcomps];

	((GLfloat *)(bufptr+n*stride+texcoordoffs))[0]=u;
	((GLfloat *)(bufptr+n*stride+texcoordoffs))[1]=v;
	((GLfloat *)(bufptr+n*stride+texcoordoffs))[2]=w;
}

-(void)setTexCoordAtIndex:(int)n coordinates:(Vector)v
{
	if(n<0||n>=numelements) [NSException raise:NSRangeException format:@"Index %d is out of bounds for GLVertexArray of size %d",n,numelements];
	if(texcoordoffs<0) [NSException raise:NSInvalidArgumentException format:@"Cannot set a texture coordinate for a GLVertexArray which does not contain texture coordinates"];
	if(texcoordcomps!=3) [NSException raise:NSInvalidArgumentException format:@"Cannot set a 3-component texture coordinate for GLVertexArray using %d-element texture coordinates",texcoordcomps];

	((GLfloat *)(bufptr+n*stride+texcoordoffs))[0]=v.x;
	((GLfloat *)(bufptr+n*stride+texcoordoffs))[1]=v.y;
	((GLfloat *)(bufptr+n*stride+texcoordoffs))[2]=v.z;
}

-(void)setColorAtIndex:(int)n r:(GLubyte)r g:(GLubyte)g b:(GLubyte)b
{
	if(n<0||n>=numelements) [NSException raise:NSRangeException format:@"Index %d is out of bounds for GLVertexArray of size %d",n,numelements];
	if(coloroffs<0) [NSException raise:NSInvalidArgumentException format:@"Cannot set a colour for a GLVertexArray which does not contain colours"];
	if(colorcomps!=3) [NSException raise:NSInvalidArgumentException format:@"Cannot set a 3-component colour for GLVertexArray using %d-element colours",colorcomps];

	((GLubyte *)(bufptr+n*stride+coloroffs))[0]=r;
	((GLubyte *)(bufptr+n*stride+coloroffs))[1]=g;
	((GLubyte *)(bufptr+n*stride+coloroffs))[2]=b;
}

-(void)setColorAtIndex:(int)n r:(GLubyte)r g:(GLubyte)g b:(GLubyte)b a:(GLubyte)a
{
	if(n<0||n>=numelements) [NSException raise:NSRangeException format:@"Index %d is out of bounds for GLVertexArray of size %d",n,numelements];
	if(coloroffs<0) [NSException raise:NSInvalidArgumentException format:@"Cannot set a colour for a GLVertexArray which does not contain colours"];
	if(colorcomps!=4) [NSException raise:NSInvalidArgumentException format:@"Cannot set a 4-component colour for GLVertexArray using %d-element colours",colorcomps];

	((GLubyte *)(bufptr+n*stride+coloroffs))[0]=r;
	((GLubyte *)(bufptr+n*stride+coloroffs))[1]=g;
	((GLubyte *)(bufptr+n*stride+coloroffs))[2]=b;
	((GLubyte *)(bufptr+n*stride+coloroffs))[3]=a;
}

-(void)setVertexAttribute:(int)attrib atIndex:(int)n value:(float)val
{
	if(n<0||n>=numelements) [NSException raise:NSRangeException format:@"Index %d is out of bounds for GLVertexArray of size %d",n,numelements];
	if(attrib<0||attrib>=numattribs||attriboffs[attrib]<0) [NSException raise:NSInvalidArgumentException format:@"Cannot set a vertex attribute not contained in a GLVertexArray"];
	if(attribcomps[attrib]!=1) [NSException raise:NSInvalidArgumentException format:@"Cannot set a 1-component vertex attribute for GLVertexArray using %d-element attributes for this index",attribcomps[attrib]];

	((GLfloat *)(bufptr+n*stride+attribcomps[attrib]))[0]=val;
}

-(void)setVertexAttribute:(int)attrib atIndex:(int)n x:(float)x y:(float)y
{
	if(n<0||n>=numelements) [NSException raise:NSRangeException format:@"Index %d is out of bounds for GLVertexArray of size %d",n,numelements];
	if(attrib<0||attrib>=numattribs||attriboffs[attrib]<0) [NSException raise:NSInvalidArgumentException format:@"Cannot set a vertex attribute not contained in a GLVertexArray"];
	if(attribcomps[attrib]!=2) [NSException raise:NSInvalidArgumentException format:@"Cannot set a 2-component vertex attribute for GLVertexArray using %d-element attributes for this index",attribcomps[attrib]];

	((GLfloat *)(bufptr+n*stride+attribcomps[attrib]))[0]=x;
	((GLfloat *)(bufptr+n*stride+attribcomps[attrib]))[1]=y;
}

-(void)setVertexAttribute:(int)attrib atIndex:(int)n x:(float)x y:(float)y z:(float)z
{
	if(n<0||n>=numelements) [NSException raise:NSRangeException format:@"Index %d is out of bounds for GLVertexArray of size %d",n,numelements];
	if(attrib<0||attrib>=numattribs||attriboffs[attrib]<0) [NSException raise:NSInvalidArgumentException format:@"Cannot set a vertex attribute not contained in a GLVertexArray"];
	if(attribcomps[attrib]!=3) [NSException raise:NSInvalidArgumentException format:@"Cannot set a 3-component vertex attribute for GLVertexArray using %d-element attributes for this index",attribcomps[attrib]];

	((GLfloat *)(bufptr+n*stride+attribcomps[attrib]))[0]=x;
	((GLfloat *)(bufptr+n*stride+attribcomps[attrib]))[1]=y;
	((GLfloat *)(bufptr+n*stride+attribcomps[attrib]))[2]=z;
}

-(void)setVertexAttribute:(int)attrib atIndex:(int)n x:(float)x y:(float)y z:(float)z w:(float)w
{
	if(n<0||n>=numelements) [NSException raise:NSRangeException format:@"Index %d is out of bounds for GLVertexArray of size %d",n,numelements];
	if(attrib<0||attrib>=numattribs||attriboffs[attrib]<0) [NSException raise:NSInvalidArgumentException format:@"Cannot set a vertex attribute not contained in a GLVertexArray"];
	if(attribcomps[attrib]!=4) [NSException raise:NSInvalidArgumentException format:@"Cannot set a 4-component vertex attribute for GLVertexArray using %d-element attributes for this index",attribcomps[attrib]];

	((GLfloat *)(bufptr+n*stride+attribcomps[attrib]))[0]=x;
	((GLfloat *)(bufptr+n*stride+attribcomps[attrib]))[1]=y;
	((GLfloat *)(bufptr+n*stride+attribcomps[attrib]))[2]=z;
	((GLfloat *)(bufptr+n*stride+attribcomps[attrib]))[3]=w;
}

@end
