#import "GLTriangleMesh.h"
#import "GLPolygonMesh.h"

@implementation GLTriangleMesh

-(id)initWithNormals:(BOOL)hasnormals texcoords:(BOOL)hastexcoords colours:(BOOL)hascolours;
{
	if(self=[super init])
	{
		vertexarray=[NSMutableData new];
		indexarray=[NSMutableData new];
		materials=[NSMutableArray new];
		counts=[NSMutableArray new];

		if(hasnormals) normalarray=[NSMutableData new];
		else normalarray=nil;

		if(hastexcoords) texcoordarray=[NSMutableData new];
		else texcoordarray=nil;

		if(hascolours) colourarray=[NSMutableData new];
		else colourarray=nil;

		cull=YES;
	}
	return self;
}

-(void)dealloc
{
	[vertexarray release];
	[normalarray release];
	[texcoordarray release];
	[colourarray release];
	[indexarray release];

	[materials release];
	[counts release];

	[super dealloc];
}

-(int)numberOfTriangles { return [indexarray countWithElementSize:sizeof(uint32_t)]/3; }

-(NSData *)vertexData { return vertexarray; }

-(NSData *)normalData { return normalarray; }

-(NSData *)texcoordData { return texcoordarray; }

-(NSData *)colourData { return colourarray; }

-(NSData *)indexData { return indexarray; }

-(void)addMaterial:(GLMaterial *)material withNumberOfIndexes:(int)count
{
	[materials addObject:material];
	[counts addObject:[NSNumber numberWithInt:count]];
}

-(int)numberOfMaterials { return [materials count]; }

-(GLMaterial *)materialAtIndex:(int)index { return [materials objectAtIndex:index]; }

-(int)numberOfIndexesAtIndex:(int)index { return [[counts objectAtIndex:index] intValue]; }




-(void)optimize
{
	[self optimizeSimilarVertices];
	[self optimizeUnusuedVertices];
}

static const Vector *sorter_vertices;

#define Compare(a,b) if(a>b) return 1; else if(a<b) return -1

static int VertexSorter(const void *a,const void *b)
{
	const int *first=a;
	const int *second=b;

	Compare(sorter_vertices[*first].x,sorter_vertices[*second].x);

	return 0;
}

-(void)optimizeSimilarVertices
{
	Vector *vertices=[vertexarray mutableBytes];
	Vector *normals=[normalarray mutableBytes];
	GLTextureCoordinate *texcoords=[texcoordarray mutableBytes];
	uint8_t *colours=[colourarray mutableBytes];
	int32_t *indexes=[indexarray mutableBytes];
	int numvertices=[vertexarray countWithElementSize:sizeof(Vector)];
	int numindexes=[indexarray countWithElementSize:sizeof(uint32_t)];

	// Create a sorted index list for vertices.
	int sortedindexes[numvertices];
	for(int i=0;i<numvertices;i++) sortedindexes[i]=i;

	sorter_vertices=vertices;
	qsort(sortedindexes,numvertices,sizeof(int),VertexSorter);

	// Find similar vertices and record them in a list.
	int replacementindexes[numvertices];
	for(int i=0;i<numvertices;i++) replacementindexes[i]=-1;

	int numreplacements=0;
	int i=0;
	while(i<numvertices-1)
	{
		int first=sortedindexes[i];

		for(int j=i+1;j<numvertices;j++)
		{
			int other=sortedindexes[j];

			if(vertices[other].x>vertices[first].x+2*VectorEpsilon) break;

			if(!VectorsAreNearlyEqual(vertices[first],vertices[other])) continue;
			if(normals && !VectorsAreNearlyEqual(normals[first],normals[other])) continue;
			if(texcoords && (texcoords[first].s!=texcoords[other].s || texcoords[first].t!=texcoords[other].t)) continue;
			if(colours && (colours[4*first]!=colours[4*other] || colours[4*first+1]!=colours[4*other+1] || colours[4*first+2]!=colours[4*other+2] || colours[4*first+3]!=colours[4*other+3])) continue;

			replacementindexes[other]=first;
			numreplacements++;
		}

		i++;
		while(replacementindexes[sortedindexes[i]]>=0 && i<numvertices-1) i++;
	}

	// Update index list.
	for(int i=0;i<numindexes;i++)
	{
		if(replacementindexes[indexes[i]]>=0) indexes[i]=replacementindexes[indexes[i]];
	}
}

-(void)optimizeUnusuedVertices
{
	Vector *vertices=[vertexarray mutableBytes];
	Vector *normals=[normalarray mutableBytes];
	GLTextureCoordinate *texcoords=[texcoordarray mutableBytes];
	uint8_t *colours=[colourarray mutableBytes];
	int32_t *indexes=[indexarray mutableBytes];
	int numvertices=[vertexarray countWithElementSize:sizeof(Vector)];
	int numindexes=[indexarray countWithElementSize:sizeof(uint32_t)];

	// Mark which vertices are used.
	BOOL isused[numvertices];
	memset(isused,0,sizeof(isused));

	for(int i=0;i<numindexes;i++) if(indexes[i]<numvertices) isused[indexes[i]]=YES;

	// Move vertices from the end into the spots occupied by unusued vertices,
	// and make a list of replacements.
	int replacementindexes[numvertices];
	memset(replacementindexes,0xff,sizeof(replacementindexes));

	int head=-1;
	int tail=numvertices;
	while(head<tail)
	{
		do head++; while(isused[head] && head<tail);
		if(head==tail) break;

		do tail--; while(!isused[tail] && head<tail);
		if(head==tail) break;

		replacementindexes[tail]=head;

		vertices[head]=vertices[tail];
		if(normals) normals[head]=normals[tail];
		if(texcoords) texcoords[head]=texcoords[tail];
		if(colours) memcpy(&colours[4*head],&colours[4*tail],4);
	}

	// Update index list.
	for(int i=0;i<numindexes;i++)
	{
		if(replacementindexes[indexes[i]]>=0) indexes[i]=replacementindexes[indexes[i]];
	}

	[vertexarray setCount:tail elementSize:sizeof(Vector)];
	[normalarray setCount:tail elementSize:sizeof(Vector)];
	[texcoordarray setCount:tail elementSize:sizeof(GLTextureCoordinate)];
	[colourarray setCount:tail elementSize:4];
}




-(void)calculateNormals
{
	if(!normalarray) normalarray=[[NSMutableData alloc] initWithLength:[vertexarray length]];

	const Vector *vertices=[vertexarray bytes];
	Vector *normals=[normalarray mutableBytes];
	const int32_t *indexes=[indexarray bytes];
	int numvertices=[vertexarray countWithElementSize:sizeof(Vector)];
	int numindexes=[indexarray countWithElementSize:sizeof(uint32_t)];

	for(int i=0;i<numvertices;i++) normals[i]=ZeroVector;

	for(int i=0;i<numindexes;i+=3)
	{
		int i1=indexes[i];
		int i2=indexes[i+1];
		int i3=indexes[i+2];
		Vector norm=PerpendicularVectorForTriangle(vertices[i1],vertices[i2],vertices[i3]);

		normals[i1]=VectorAdd(normals[i1],norm);
		normals[i2]=VectorAdd(normals[i2],norm);
		normals[i3]=VectorAdd(normals[i3],norm);
	}

	for(int i=0;i<numvertices;i++)
	{
		float length=VectorAbs(normals[i]);
		if(length!=0) normals[i]=VectorDiv(normals[i],length);
	}
}

-(void)calculateNormalsForCartoonOutline
{
	[self calculateNormals];
}




-(GLTriangleMesh *)meshWithNormals:(BOOL)hasnormals texcoords:(BOOL)hastexcoords
colours:(BOOL)hascolours
{
	return [self meshWithNormals:hasnormals texcoords:hastexcoords colours:hascolours
	materials:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,[self numberOfMaterials])]];
}

-(GLTriangleMesh *)meshWithNormals:(BOOL)hasnormals texcoords:(BOOL)hastexcoords
colours:(BOOL)hascolours materials:(NSIndexSet *)materialset
{
	if(!normalarray) hasnormals=NO;
	if(!texcoordarray) hastexcoords=NO;
	if(!colourarray) hascolours=NO;

	GLTriangleMesh *mesh=[[[GLTriangleMesh alloc] initWithNormals:hasnormals
	texcoords:hastexcoords colours:hascolours] autorelease];

	[mesh->vertexarray appendData:vertexarray];
	if(hasnormals) [mesh->normalarray appendData:normalarray];
	if(hastexcoords) [mesh->texcoordarray appendData:texcoordarray];
	if(hascolours) [mesh->colourarray appendData:colourarray];

	const int *indexes=[indexarray bytes];
	int nummaterials=[self numberOfMaterials];
	int offs=0;
	for(int i=0;i<nummaterials;i++)
	{
		GLMaterial *material=[self materialAtIndex:i];
		int num=[self numberOfIndexesAtIndex:i];

		if([materialset containsIndex:i])
		{
			[mesh->indexarray appendBytes:&indexes[offs] length:num*sizeof(uint32_t)];
			[mesh addMaterial:material withNumberOfIndexes:num];
		}

		offs+=num;
	}

	[mesh optimize];

	return mesh;
}

-(GLTriangleMesh *)cartoonOutlineMesh
{
	NSMutableIndexSet *set=[NSMutableIndexSet indexSet];

	int nummaterials=[self numberOfMaterials];
	for(int i=0;i<nummaterials;i++)
	{
		GLMaterial *material=[self materialAtIndex:i];
		BOOL isedged=YES;

		if([material isKindOfClass:[GLCartoonMaterial class]])
		{
			GLCartoonMaterial *cartoonmaterial=(GLCartoonMaterial *)material;
			isedged=cartoonmaterial->edged;
		}

		if(isedged) [set addIndex:i];
	}

	GLTriangleMesh *mesh=[self meshWithNormals:NO texcoords:NO colours:NO materials:set];

	[mesh calculateNormalsForCartoonOutline];

	return mesh;
}




-(Vector)maximumComponentsWithMatrix:(Matrix)matrix
{
	const Vector *vertices=[vertexarray bytes];
	int numvertices=[vertexarray countWithElementSize:sizeof(Vector)];
	if(!numvertices) return MakeVector(1,1,1);

	Vector max=vertices[0];
	for(int i=1;i<numvertices;i++)
	{
		Vector v=TransformVector(matrix,vertices[i]);
		max.x=fmaxf(v.x,max.x);
		max.y=fmaxf(v.y,max.y);
		max.z=fmaxf(v.z,max.z);
	}
	return max;
}

-(Vector)minimumComponentsWithMatrix:(Matrix)matrix
{
	const Vector *vertices=[vertexarray bytes];
	int numvertices=[vertexarray countWithElementSize:sizeof(Vector)];
	if(!numvertices) return MakeVector(-1,-1,-1);

	Vector min=vertices[0];
	for(int i=1;i<numvertices;i++)
	{
		Vector v=TransformVector(matrix,vertices[i]);
		min.x=fminf(v.x,min.x);
		min.y=fminf(v.y,min.y);
		min.z=fminf(v.z,min.z);
	}
	return min;
}

@end




@implementation NSMutableData (GLTriangleMeshAdditions)

-(void)appendTextureCoordinateS:(float)s t:(float)t
{
	[self appendBytes:&(GLTextureCoordinate){s,t} length:sizeof(GLTextureCoordinate)];
}

@end
