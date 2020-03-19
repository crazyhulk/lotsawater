#import "GLPMDMesh.h"
#import "CSBinaryReader.h"
#import "../NSDataArrayAdditions.h"

static NSData *TrimStringData(NSData *data);

@implementation GLPMDMesh

-(id)initWithFilename:(NSString *)objname dataManager:(GLDataManager *)datamanager
{
	if(self=[super initWithNormals:YES texcoords:YES colours:NO])
	{
		filename=[objname retain];
		name=comment=nil;
		manager=datamanager;

		if([self readFile:objname]) return self;

		[self release];
	}
	return nil;
}

-(void)dealloc
{
	[filename release];
	[name release];
	[comment release];

	[super dealloc];
}

-(BOOL)readFile:(NSString *)path
{
	CSBinaryReader *reader=[CSBinaryReader binaryReaderForPath:path];

	if([reader readUInt8]!='P') return NO;
	if([reader readUInt8]!='m') return NO;
	if([reader readUInt8]!='d') return NO;

	[reader skipBytes:4]; // skip version

	NSData *namedata=[reader readDataOfLength:20];
	NSData *commentdata=[reader readDataOfLength:256];
	name=[[NSString alloc] initWithData:TrimStringData(namedata) encoding:NSShiftJISStringEncoding];
	comment=[[NSString alloc] initWithData:TrimStringData(commentdata) encoding:NSShiftJISStringEncoding];

	int numvertices=[reader readUInt32LE];

	for(int i=0;i<numvertices;i++)
	{
		float x=[reader readFloatLE];
		float y=[reader readFloatLE];
		float z=[reader readFloatLE];
		float nx=[reader readFloatLE];
		float ny=[reader readFloatLE];
		float nz=[reader readFloatLE];
		float s=[reader readFloatLE];
		float t=[reader readFloatLE];
		/*int boneindex1=*/[reader readUInt16LE];
		/*int boneindex2=*/[reader readUInt16LE];
		/*int weight=*/[reader readUInt8];
		/*int flags=*/[reader readUInt8];

		[vertexarray appendVector:MakeVector(x,y,z)];
		[normalarray appendVector:MakeVector(nx,ny,nz)];
		[texcoordarray appendTextureCoordinateS:s t:t];
	}

	int numfaceindexes=[reader readUInt32LE];

	for(int i=0;i<numfaceindexes;i++)
	{
		int index=[reader readUInt16LE];
		[indexarray appendUInt32:index];
	}

	int nummaterials=[reader readUInt32LE];
	uint8_t shadingindexes[nummaterials];

	for(int i=0;i<nummaterials;i++)
	{
		float dr=[reader readFloatLE];
		float dg=[reader readFloatLE];
		float db=[reader readFloatLE];
		float da=[reader readFloatLE];
		float phong=[reader readFloatLE];
		float sr=[reader readFloatLE];
		float sg=[reader readFloatLE];
		float sb=[reader readFloatLE];
		float ar=[reader readFloatLE];
		float ag=[reader readFloatLE];
		float ab=[reader readFloatLE];
		int toon=[reader readUInt8];
		int edge=[reader readUInt8];
		int numindexes=[reader readUInt32LE];
		NSData *texturedata=TrimStringData([reader readDataOfLength:20]);

		NSString *matname=[NSString stringWithFormat:@"%d",i];
		GLCartoonMaterial *material=[GLCartoonMaterial cartoonMaterialWithName:matname];

		[material setDiffuseRed:dr green:dg blue:db alpha:da];
		[material setPhongExponent:phong];
		[material setSpecularRed:sr green:sg blue:sb];
		[material setAmbientRed:ar green:ag blue:ab];
		[material setHasEdges:edge];

		if([texturedata length])
		{
			NSString *texname=[self pathForNameData:texturedata];
			GLBitmap *bitmap=[manager bitmapWithContentsOfFile:texname];
			[material setTextureBitmap:bitmap];
		}

		shadingindexes[i]=toon;

		[self addMaterial:material withNumberOfIndexes:numindexes];
	}

	int numbones=[reader readUInt16LE];

	for(int i=0;i<numbones;i++)
	{
		/*NSData *namedata=*/TrimStringData([reader readDataOfLength:20]);
		/*int parent=*/[reader readUInt16LE]; // ?
		/*int child=*/[reader readUInt16LE]; // ?
		/*int kind=*/[reader readUInt8];
		/*int influenced_ik=*/[reader readUInt16LE];
		/*float pos_x=*/[reader readFloatLE];
		/*float pos_y=*/[reader readFloatLE];
		/*float pos_z=*/[reader readFloatLE];
	}

	int numik=[reader readUInt16LE];

	for(int i=0;i<numik;i++)
	{
		/*int bone=*/[reader readUInt16LE];
		/*int target=*/[reader readUInt16LE];
		int numbones=[reader readUInt8];
		/*int rotation_limit_degree=*/[reader readUInt16LE];
		/*float rotation_limit_influence=*/[reader readFloatLE];

		for(int j=0;j<numbones;j++)
		{
			/*int bone=*/[reader readUInt16LE];
		}
	}


	int numshapes=[reader readUInt16LE];

	for(int i=0;i<numshapes;i++)
	{
		/*NSData *namedata=*/TrimStringData([reader readDataOfLength:20]);
		int numvertices=[reader readUInt32LE];
		/*int blocknumber=*/[reader readUInt8];

		for(int j=0;j<numvertices;j++)
		{
			/*float a=*/[reader readFloatLE];
			/*float b=*/[reader readFloatLE];
			/*float c=*/[reader readFloatLE];
			/*float d=*/[reader readFloatLE];
		}
	}

	int numthings1=[reader readUInt8];

	for(int i=0;i<numthings1;i++)
	{
		/*int thing=*/[reader readUInt16LE];
	}

	int numthings2=[reader readUInt8];

	for(int i=0;i<numthings2;i++)
	{
		[reader skipBytes:50];
	}

	int numthings3=[reader readUInt32LE];

	[reader skipBytes:numthings3*3];

	int flag4=[reader readUInt8];

	if(flag4)
	{
		[reader skipBytes:20];
		[reader skipBytes:256];

		for(int i=0;i<numbones;i++)
		{
			[reader skipBytes:20];
		}

		for(int i=0;i<numthings1;i++)
		{
			[reader skipBytes:20];
		}

		for(int i=0;i<numthings2;i++)
		{
			[reader skipBytes:50];
		}
	}

	GLBitmap *shadingbitmaps[10];
	for(int i=0;i<10;i++)
	{
		NSData *toonnamedata=TrimStringData([reader readDataOfLength:100]);
		NSString *toonname=[self pathForNameData:toonnamedata];
		shadingbitmaps[i]=[manager bitmapWithContentsOfFile:toonname];
	}

	for(int i=0;i<nummaterials;i++)
	{
		if(shadingindexes[i]<10 && shadingbitmaps[shadingindexes[i]])
		[[materials objectAtIndex:i] setShadingBitmap:shadingbitmaps[shadingindexes[i]]];
	}

NSLog(@"%d %d %d %d %d %d",numbones,numik,numshapes,numthings1,numthings2,numthings3);

// 7880/20=394
// 550/50=11
// 1000/100=10

NSLog(@"%lld",[reader currentOffset]);

	cull=NO;

	[self optimize];

	return YES;
}

-(NSString *)pathForNameData:(NSData *)namedata
{
	NSString *path=[[[NSString alloc] initWithData:namedata encoding:NSShiftJISStringEncoding] autorelease];
	path=[path stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
	path=[[filename stringByDeletingLastPathComponent] stringByAppendingPathComponent:path];
	return path;
}

@end

static NSData *TrimStringData(NSData *data)
{
	const uint8_t *bytes=[data bytes];
	int length=[data length];

	for(int i=0;i<length;i++)
	{
		if(bytes[i]==0) return [data subdataWithRange:NSMakeRange(0,i)];
	}
	return data;
}
