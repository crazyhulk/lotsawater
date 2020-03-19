#import "GLDirectXMesh.h"
#import "../NSDataArrayAdditions.h"

@implementation GLDirectXMesh

NSString *GLDirectXMeshException=@"GLDirectXMeshException";

static NSString *FileHeaderToken=@"FileHeader";
static NSString *OpeningBraceToken=@"OpeningBrace";
static NSString *ClosingBraceToken=@"ClosingBrace";
static NSString *OpeningBracketToken=@"OpeningBracket";
static NSString *ClosingBracketToken=@"ClosingBracket";
static NSString *CommaToken=@"Comma";
static NSString *SemicolonToken=@"Semicolon";
static NSString *ThreeDotsToken=@"ThreeDots";
static NSString *IdentifierToken=@"Identifier";
static NSString *IntegerToken=@"Integer";
static NSString *FloatToken=@"Float";
static NSString *StringToken=@"String";
static NSString *GUIDToken=@"GUID";

-(id)initWithFilename:(NSString *)objname dataManager:(GLDataManager *)datamanager
{
	if(self=[super init])
	{
		filename=[objname retain];
		tokenizer=nil;
		manager=datamanager;

		#ifdef __APPLE__
		NSData *data=[NSData dataWithContentsOfMappedFile:filename];
		#else
		NSData *data=[NSData dataWithContentsOfFile:filename];
		#endif

		if(data)
		{
			[self parseData:data];
			return self;
		}
		[self release];
	}
	return nil;
}

-(void)dealloc
{
	[filename release];
	[tokenizer release];

	[super dealloc];
}



-(void)parseData:(NSData *)data
{
	[tokenizer autorelease];
	tokenizer=[CSTokenizer new];

	[tokenizer addTokenWithValue:FileHeaderToken pattern:@"xof 0302txt 00(32|64)\r?\n"];

	[tokenizer addTokenWithValue:OpeningBraceToken pattern:@"\\{"];
	[tokenizer addTokenWithValue:ClosingBraceToken pattern:@"\\}"];
	[tokenizer addTokenWithValue:OpeningBracketToken pattern:@"\\["];
	[tokenizer addTokenWithValue:ClosingBracketToken pattern:@"\\]"];
	[tokenizer addTokenWithValue:CommaToken pattern:@","];
	[tokenizer addTokenWithValue:SemicolonToken pattern:@";"];
	[tokenizer addTokenWithValue:ThreeDotsToken pattern:@"\\.\\.\\."];

	[tokenizer addTokenWithValue:IdentifierToken pattern:@"([a-zA-Z_][a-zA-Z0-9_]*)"];

	[tokenizer addTokenWithValue:StringToken pattern:@"\"([^\"]*)\""];
	[tokenizer addTokenWithValue:FloatToken pattern:@"([-+]?[0-9]+\\.[0-9]*)"];
	[tokenizer addTokenWithValue:IntegerToken pattern:@"([-+]?[0-9]+)"];
	[tokenizer addTokenWithValue:GUIDToken pattern:@"<([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})>"];

	[tokenizer addIgnoredPattern:@"//[^\n]*(\n|$)"];
	[tokenizer addIgnoredPattern:@"#[^\n]*(\n|$)"];

	[tokenizer addIgnoreWhitespacePattern];

	[tokenizer setMaxLookAhead:64]; // Ugly hack because regmatch() is stupid and slow.

	[tokenizer startTokenizingData:data];

	[self expect:FileHeaderToken];

	[self parseRoot];
}

-(void)parseRoot
{
	NSString *token;
	while(token=[self expect:IdentifierToken or:nil])
	{
		NSString *identifier=[tokenizer stringForCapture:1];

		if([identifier isEqual:@"template"])
		{
			[self expect:IdentifierToken];
			[self expect:OpeningBraceToken];
			[self skipUnknownStruct];
		}
		else if([identifier isEqual:@"Mesh"])
		{
			[self expect:OpeningBraceToken];
			[self parseMesh];
		}
		else
		{
			[self expect:OpeningBraceToken];
			[self skipUnknownStruct];
		}
	}
}

-(void)parseMesh
{
	[self expect:IntegerToken];
	int numvertices=[tokenizer intForCapture:1];
	[self expect:SemicolonToken];

	for(int i=0;i<numvertices;i++)
	{
		[self expect:IntegerToken or:FloatToken];
		float x=[tokenizer floatForCapture:1];
		[self expect:SemicolonToken];

		[self expect:IntegerToken or:FloatToken];
		float y=[tokenizer floatForCapture:1];
		[self expect:SemicolonToken];

		[self expect:IntegerToken or:FloatToken];
		float z=[tokenizer floatForCapture:1];
		[self expect:SemicolonToken];

		if(i<numvertices-1) [self expect:CommaToken];
		else [self expect:SemicolonToken];
		[vertexarray appendVector:MakeVector(x,y,z)];
	}

	[self expect:IntegerToken];
	int numfaces=[tokenizer intForCapture:1];
	[self expect:SemicolonToken];

	for(int i=0;i<numfaces;i++)
	{
		[self expect:IntegerToken];
		int numindexes=[tokenizer intForCapture:1];
		[self expect:SemicolonToken];

		NSMutableData *face=[[NSMutableData alloc] initWithCount:numindexes elementSize:sizeof(GLPolygonVertex)];
		GLPolygonVertex *vertices=[face mutableBytes];

		for(int j=0;j<numindexes;j++)
		{
			[self expect:IntegerToken];
			int index=[tokenizer intForCapture:1];

			vertices[j].vertex=index;
			vertices[j].normal=-1;
			vertices[j].texcoord=index;

			if(j<numindexes-1) [self expect:CommaToken];
			else [self expect:SemicolonToken];
		}

		[faces addObject:face];

		if(i<numfaces-1) [self expect:CommaToken];
		else [self expect:SemicolonToken];
	}

	BOOL hasnormals=NO;

	NSString *token;
	while(token=[self expect:IdentifierToken or:ClosingBraceToken])
	{
		if(token==IdentifierToken)
		{
			NSString *identifier=[tokenizer stringForCapture:1];

			[self expect:OpeningBraceToken];

			if([identifier isEqual:@"MeshMaterialList"])
			{
				[self parseMeshMaterialList];
			}
			else if([identifier isEqual:@"MeshNormals"])
			{
				[self parseMeshNormals];
				hasnormals=YES;
			}
			else if([identifier isEqual:@"MeshTextureCoords"])
			{
				[self parseMeshTextureCoords];
			}
			else
			{
				[self skipUnknownStruct];
			}
		}
		else if(token==ClosingBraceToken)
		{
			//if(!hasnormals) [self calculateNormals];
			return;
		}
	}
}

-(void)parseMeshMaterialList
{
	[self expect:IntegerToken];
	int nummaterials=[tokenizer intForCapture:1];
	[self expect:SemicolonToken];

	[self expect:IntegerToken];
	int numfaces=[tokenizer intForCapture:1];
	[self expect:SemicolonToken];

	GLMaterial *materialarray[nummaterials];
	for(int i=0;i<nummaterials;i++)
	{
		NSString *name=[NSString stringWithFormat:@"%d",i];
		materialarray[i]=[GLMaterial materialWithName:name];
	}

	for(int i=0;i<numfaces;i++)
	{
		[self expect:IntegerToken];
		int index=[tokenizer intForCapture:1];

		[materials addObject:materialarray[index]];

		if(i<numfaces-1) [self expect:CommaToken];
		else [self expect:SemicolonToken];
	}

	[self expect:SemicolonToken];

	for(int i=0;i<nummaterials;i++)
	{
		[self expect:IdentifierToken];
		//NSString *identifier=[tokenizer stringForCapture:1];

		[self expect:OpeningBraceToken];

		//if([identifier isEqual:@"Material"])
		[self parseMaterial:materialarray[i]];
	}

	[self expect:ClosingBraceToken];
}

-(void)parseMaterial:(GLMaterial *)material
{
	for(int i=0;i<4;i++)
	{
		[self expect:IntegerToken or:FloatToken];
		material->diffuse[i]=material->ambient[i]=[tokenizer floatForCapture:1];
		[self expect:SemicolonToken];
	}

	[self expect:SemicolonToken];

	[self expect:IntegerToken or:FloatToken];
	material->phong=[tokenizer floatForCapture:1];
	[self expect:SemicolonToken];

	for(int i=0;i<3;i++)
	{
		[self expect:IntegerToken or:FloatToken];
		material->specular[i]=[tokenizer floatForCapture:1];
		[self expect:SemicolonToken];
	}

	[self expect:SemicolonToken];

	for(int i=0;i<3;i++)
	{
		[self expect:IntegerToken or:FloatToken];
		material->emission[i]=[tokenizer floatForCapture:1];
		[self expect:SemicolonToken];
	}

	[self expect:SemicolonToken];

	NSString *token;
	while(token=[self expect:IdentifierToken or:ClosingBraceToken])
	{
		if(token==IdentifierToken)
		{
			NSString *identifier=[tokenizer stringForCapture:1];

			[self expect:OpeningBraceToken];

			if([identifier isEqual:@"TextureFilename"])
			{
				[self expect:StringToken];

				NSString *texname=[[tokenizer stringForCapture:1]
				stringByReplacingOccurrencesOfString:@"\\\\" withString:@"/"];
				NSString *fullpath=[[filename stringByDeletingLastPathComponent]
				stringByAppendingPathComponent:texname];
				GLBitmap *bitmap=[manager bitmapWithContentsOfFile:fullpath];
				[material setTextureBitmap:bitmap];

				[self expect:SemicolonToken];
				[self expect:ClosingBraceToken];
			}
			else
			{
				[self skipUnknownStruct];
			}
		}
		else if(token==ClosingBraceToken)
		{
			return;
		}
	}
}

-(void)parseMeshNormals
{
	[self expect:IntegerToken];
	int numnormals=[tokenizer intForCapture:1];
	[self expect:SemicolonToken];

	for(int i=0;i<numnormals;i++)
	{
		[self expect:IntegerToken or:FloatToken];
		float x=[tokenizer floatForCapture:1];
		[self expect:SemicolonToken];

		[self expect:IntegerToken or:FloatToken];
		float y=[tokenizer floatForCapture:1];
		[self expect:SemicolonToken];

		[self expect:IntegerToken or:FloatToken];
		float z=[tokenizer floatForCapture:1];
		[self expect:SemicolonToken];

		if(i<numnormals-1) [self expect:CommaToken];
		else [self expect:SemicolonToken];
		[normalarray appendVector:MakeVector(x,y,z)];
	}

	[self expect:IntegerToken];
	int numfaces=[tokenizer intForCapture:1];
	[self expect:SemicolonToken];

	for(int i=0;i<numfaces;i++)
	{
		GLPolygonVertex *vertices=[[faces objectAtIndex:i] mutableBytes];

		[self expect:IntegerToken];
		int numindexes=[tokenizer intForCapture:1];
		[self expect:SemicolonToken];

		for(int j=0;j<numindexes;j++)
		{
			[self expect:IntegerToken];
			int index=[tokenizer intForCapture:1];

			vertices[j].normal=index;

			if(j<numindexes-1) [self expect:CommaToken];
			else [self expect:SemicolonToken];
		}

		if(i<numfaces-1) [self expect:CommaToken];
		else [self expect:SemicolonToken];
	}

	[self expect:ClosingBraceToken];
}

-(void)parseMeshTextureCoords
{
	[self expect:IntegerToken];
	int numtexcoords=[tokenizer intForCapture:1];
	[self expect:SemicolonToken];

	for(int i=0;i<numtexcoords;i++)
	{
		[self expect:IntegerToken or:FloatToken];
		float s=[tokenizer floatForCapture:1];
		[self expect:SemicolonToken];

		[self expect:IntegerToken or:FloatToken];
		float t=[tokenizer floatForCapture:1];
		[self expect:SemicolonToken];

		if(i<numtexcoords-1) [self expect:CommaToken];
		else [self expect:SemicolonToken];

		[texcoordarray appendTextureCoordinateS:s t:t];
	}

	[self expect:ClosingBraceToken];
}

-(void)skipUnknownStruct
{
	NSString *token;
	while(token=[self expectAnything])
	{
		if(token==OpeningBraceToken) [self skipUnknownStruct];
		else if(token==ClosingBraceToken) return;
	}
}

-(void)expect:(NSString *)token
{
	if([tokenizer valueOfNextToken]!=token) [NSException raise:GLDirectXMeshException
	format:@"Parse error on line %d of file \"%@\": Expected %@",
	[tokenizer line],filename,token];
}

-(NSString *)expect:(NSString *)token1 or:(NSString *)token2
{
	NSString *token=[tokenizer valueOfNextToken];
	if(token!=token1 && token!=token2) [NSException raise:GLDirectXMeshException
	format:@"Parse error on line %d of file \"%@\": Expected %@ or %@",
	[tokenizer line],filename,token1,token2];
	return token;
}

-(NSString *)expectAnything
{
	NSString *token=[tokenizer valueOfNextToken];
	if(!token) [NSException raise:GLDirectXMeshException
	format:@"Premature end of file \"%@\"",filename];
	return token;
}

@end
