#import "GLWavefrontMesh.h"
#import "../NSDataArrayAdditions.h"

@implementation GLWavefrontMesh

-(id)initWithFilename:(NSString *)objname dataManager:(GLDataManager *)datamanager
{
	if(self=[super init])
	{
		filename=[objname retain];
		currmaterial=[GLMaterial defaultMaterial];
		parsematerial=nil;
		materialdict=[NSMutableDictionary new];
		manager=datamanager;

		objtokenizer=[[CSTokenDispatcher alloc] initWithDelegate:self];

		[objtokenizer addTokenWithSelector:@selector(vertex:)
		pattern:@"v +([-+0-9.e]+) +([-+0-9.e]+) +([-+0-9.e]+) *(\r?\n|$)"];
		[objtokenizer addTokenWithSelector:@selector(normal:)
		pattern:@"vn +([-+0-9.e]+) +([-+0-9.e]+) +([-+0-9.e]+) *(\r?\n|$)"];
		[objtokenizer addTokenWithSelector:@selector(textureCoordinate:)
		pattern:@"vt +([-+0-9.e]+) +([-+0-9.e]+) *(\r?\n|$)"];
		[objtokenizer addTokenWithSelector:@selector(face:)
		pattern:@"f ([^\n\r]*)(\r?\n|$)"];
		[objtokenizer addTokenWithSelector:@selector(useMaterial:)
		pattern:@"usemtl +([^\n\r]+)(\r?\n|$)"];
		[objtokenizer addTokenWithSelector:@selector(materialLibrary:)
		pattern:@"mtllib +([^\n\r]+)(\r?\n|$)"];

		[objtokenizer addIgnoredPattern:@"[^\n]*(\n|$)"]; // skip all other lines
		[objtokenizer setMaxLookAhead:128];

		mtltokenizer=[[CSTokenDispatcher alloc] initWithDelegate:self];

		[mtltokenizer addTokenWithSelector:@selector(newMaterial:)
		pattern:@"newmtl +([^\n\r]*)(\r?\n|$)"];
		[mtltokenizer addTokenWithSelector:@selector(ambientColour:)
		pattern:@"Ka +([-+0-9.e]+) +([-+0-9.e]+) +([-+0-9.e]+) *(\r?\n|$)"];
		[mtltokenizer addTokenWithSelector:@selector(diffuseColour:)
		pattern:@"Kd +([-+0-9.e]+) +([-+0-9.e]+) +([-+0-9.e]+) *(\r?\n|$)"];
		[mtltokenizer addTokenWithSelector:@selector(specularColour:)
		pattern:@"Ks +([-+0-9.e]+) +([-+0-9.e]+) +([-+0-9.e]+) *(\r?\n|$)"];
		[mtltokenizer addTokenWithSelector:@selector(phongExponent:)
		pattern:@"Ns +([-+0-9.e]+) *(\r?\n|$)"];
		[mtltokenizer addTokenWithSelector:@selector(diffuseTexture:)
		pattern:@"map_Kd +([^\n\r]*)(\r?\n|$)"];

		// custom extensions
		[mtltokenizer addTokenWithSelector:@selector(vertexShader:)
		pattern:@"gl_vertex_shader +([^\n\r]*)(\r?\n|$)"];
		[mtltokenizer addTokenWithSelector:@selector(fragmentShader:)
		pattern:@"gl_fragment_shader +([^\n\r]*)(\r?\n|$)"];

		[mtltokenizer addIgnoredPattern:@"[^\n]*(\n|$)"]; // skip all other lines
		[mtltokenizer setMaxLookAhead:128];

		facetokenizer=[CSTokenizer new];

		[facetokenizer addTokenWithValue:[NSNull null] pattern:@"([0-9]+)/([0-9]*)/([0-9]*)"];
		[facetokenizer addIgnoreWhitespacePattern];

		#ifdef __APPLE__
		NSData *data=[NSData dataWithContentsOfMappedFile:filename];
		#else
		NSData *data=[NSData dataWithContentsOfFile:filename];
		#endif

		if(data)
		{
			[objtokenizer tokenizeAndDispatchForData:data];

			[mtltokenizer release];
			[objtokenizer release];
			[facetokenizer release];
			mtltokenizer=nil;
			objtokenizer=nil;
			facetokenizer=nil;

			return self;
		}
		[self release];
	}
	return nil;
}

-(void)dealloc
{
	[mtltokenizer release];
	[objtokenizer release];
	[facetokenizer release];

	[filename release];
	[materialdict release];

	[super dealloc];
}



-(void)vertex:(CSTokenDispatcher *)tokenizer
{
	[vertexarray appendVector:MakeVector([tokenizer floatForCapture:1],
	[tokenizer floatForCapture:2],[tokenizer floatForCapture:3])];
}

-(void)normal:(CSTokenDispatcher *)tokenizer
{
	[normalarray appendVector:MakeVector([tokenizer floatForCapture:1],
	[tokenizer floatForCapture:2],[tokenizer floatForCapture:3])];
}

-(void)textureCoordinate:(CSTokenDispatcher *)tokenizer
{
	[texcoordarray appendTextureCoordinateS:[tokenizer floatForCapture:1] t:1-[tokenizer floatForCapture:2]];
}

-(void)face:(CSTokenDispatcher *)tokenizer
{
	[facetokenizer startTokenizingData:[tokenizer dataForCapture:1]];

	NSMutableData *face=[NSMutableData data];

	while([facetokenizer valueOfNextToken])
	{
		int vertex=[facetokenizer intForCapture:1];
		if(vertex<0) vertex=[vertexarray countWithElementSize:sizeof(Vector)]-vertex;
		else vertex--;

		int texcoord=[facetokenizer intForCapture:2];
		if(texcoord<0) texcoord=[texcoordarray countWithElementSize:sizeof(GLTextureCoordinate)]-texcoord;
		else texcoord--;

		int normal=[facetokenizer intForCapture:3];
		if(normal<0) normal=[normalarray countWithElementSize:sizeof(Vector)]-normal;
		else normal--;

		GLPolygonVertex polyvertex={vertex,normal,texcoord};
		[face appendBytes:&polyvertex length:sizeof(polyvertex)];
	}

	[faces addObject:face];
	[materials addObject:currmaterial];
}

-(void)useMaterial:(CSTokenDispatcher *)tokenizer
{
	currmaterial=[materialdict objectForKey:[tokenizer stringForCapture:1]];
	if(!currmaterial) currmaterial=[GLMaterial defaultMaterial];
}

-(void)materialLibrary:(CSTokenDispatcher *)tokenizer
{
	libname=[[filename stringByDeletingLastPathComponent]
	stringByAppendingPathComponent:[tokenizer stringForCapture:1]];

	NSData *data=[NSData dataWithContentsOfMappedFile:libname];
	if(data) [mtltokenizer tokenizeAndDispatchForData:data];
}

-(void)newMaterial:(CSTokenDispatcher *)tokenizer
{
	NSString *name=[tokenizer stringForCapture:1];
	parsematerial=[GLMaterial materialWithName:name];
	[materialdict setObject:parsematerial forKey:name];
}

-(void)ambientColour:(CSTokenDispatcher *)tokenizer
{
	[parsematerial setAmbientRed:[tokenizer floatForCapture:1]
	green:[tokenizer floatForCapture:2] blue:[tokenizer floatForCapture:3]];
}

-(void)diffuseColour:(CSTokenDispatcher *)tokenizer
{
	[parsematerial setDiffuseRed:[tokenizer floatForCapture:1]
	green:[tokenizer floatForCapture:2] blue:[tokenizer floatForCapture:3]];
}

-(void)specularColour:(CSTokenDispatcher *)tokenizer
{
	[parsematerial setSpecularRed:[tokenizer floatForCapture:1]
	green:[tokenizer floatForCapture:2] blue:[tokenizer floatForCapture:3]];
}

-(void)phongExponent:(CSTokenDispatcher *)tokenizer
{
	[parsematerial setPhongExponent:[tokenizer floatForCapture:1]];
}

-(void)diffuseTexture:(CSTokenDispatcher *)tokenizer
{
}

-(void)vertexShader:(CSTokenDispatcher *)tokenizer
{
	NSString *shadername=[[libname stringByDeletingLastPathComponent]
	stringByAppendingPathComponent:[tokenizer stringForCapture:1]];
	NSString *code=[NSString stringWithContentsOfFile:shadername encoding:NSUTF8StringEncoding error:NULL];
	[parsematerial setVertexProgram:code];
}

-(void)fragmentShader:(CSTokenDispatcher *)tokenizer
{
	NSString *shadername=[[libname stringByDeletingLastPathComponent]
	stringByAppendingPathComponent:[tokenizer stringForCapture:1]];
	NSString *code=[NSString stringWithContentsOfFile:shadername encoding:NSUTF8StringEncoding error:NULL];
	[parsematerial setFragmentProgram:code];
}

@end
