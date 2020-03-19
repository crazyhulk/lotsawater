#import "GLPolygonMesh.h"
#import "../NSDataArrayAdditions.h"



typedef struct VertexHashEntry
{
	GLPolygonVertex vertex;
	int index;
} VertexHashEntry;

typedef struct VertexHashTable
{
	int mask;
	VertexHashEntry entries[0];
} VertexHashTable;


VertexHashTable *AllocVertexHashTable(int maxsize)
{
	int mask=2*maxsize-1;
	mask|=mask>>1;
	mask|=mask>>2;
	mask|=mask>>4;
	mask|=mask>>8;
	mask|=mask>>16;
	int size=mask+1;

	VertexHashTable *self=malloc(sizeof(VertexHashTable)+sizeof(VertexHashEntry)*size);
	if(!self) return NULL;

	self->mask=mask;
	memset(self->entries,0xff,sizeof(VertexHashEntry)*size);

	return self;
}

void FreeVertexHashTable(VertexHashTable *self)
{
	free(self);
}

int FindOrSetIndex(VertexHashTable *self,GLPolygonVertex vertex,int newindex)
{
	int hash=(vertex.vertex+vertex.normal+vertex.texcoord)*69069;
	int step=(hash^0x1234abcd)|1;
	int pos=hash&self->mask;

	for(int i=0;i<=self->mask;i++)
	{
		if(self->entries[pos].index==-1) // empty
		{
			self->entries[pos].vertex=vertex;
			self->entries[pos].index=newindex;
			return -1;
		}
		else if(!memcmp(&self->entries[pos].vertex,&vertex,sizeof(GLPolygonVertex))) // found
		{
			return self->entries[pos].index;
		}

		pos=(pos+step)&self->mask;
	}

	return -1; // Only happens if the table is full.
}



@implementation GLPolygonMesh

-(id)init
{
	if(self=[super init])
	{
		vertexarray=[NSMutableData new];
		normalarray=[NSMutableData new];
		texcoordarray=[NSMutableData new];
		faces=[NSMutableArray new];
		materials=[NSMutableArray new];

		cull=YES;
	}
	return self;
}

-(void)dealloc
{
	[vertexarray release];
	[normalarray release];
	[texcoordarray release];
	[faces release];
	[materials release];

	[super dealloc];
}

-(void)calculateNormals
{
/*	int num_vertexarray=[vertexarray count];
	int num_triangles=[triangles count];

	[normalarray setCount:num_vertexarray];

	const Vector *v=[vertexarray bytes];
	Vector *n=[normalarray mutableBytes];
	GLTriangle *t=[triangles mutableBytes];

	for(int i=0;i<num_vertexarray;i++) n[i].v=ZeroVector;

	for(int i=0;i<num_triangles;i++)
	{
		t[i].n1=t[i].v1; t[i].n2=t[i].v2; t[i].n2=t[i].v2;
		Vector norm=PerpendicularVectorForTriangle(v[t[i].v1].v,v[t[i].v2].v,v[t[i].v3].v);
		n[t[i].n1].v=VectorAdd(n[t[i].n1].v,norm);
		n[t[i].n2].v=VectorAdd(n[t[i].n2].v,norm);
		n[t[i].n3].v=VectorAdd(n[t[i].n3].v,norm);
	}

	for(int i=0;i<num_vertexarray;i++) n[i].v=VectorNorm(n[i].v);*/
}

-(GLTriangleMesh *)triangleMesh
{
	GLTriangleMesh *mesh=[[[GLTriangleMesh alloc] initWithNormals:YES
	texcoords:YES colours:NO] autorelease];

	NSAutoreleasePool *pool=[NSAutoreleasePool new];

	NSMutableDictionary *materialdict=[NSMutableDictionary dictionary];

	int numvertices=[vertexarray countWithElementSize:sizeof(Vector)];
	int numnormals=[normalarray countWithElementSize:sizeof(Vector)];
	int numtexcoords=[texcoordarray countWithElementSize:sizeof(GLTextureCoordinate)];
	int numfaces=[faces count];
	const Vector *vertices=[vertexarray bytes];
	const Vector *normals=[normalarray bytes];
	const GLTextureCoordinate *texcoords=[texcoordarray bytes];

	int maxvertices=0;
	for(int i=0;i<numfaces;i++) maxvertices+=[[faces objectAtIndex:i] countWithElementSize:sizeof(uint32_t)];

	VertexHashTable *hash=AllocVertexHashTable(maxvertices);

	for(int i=0;i<numfaces;i++)
	{
		NSData *face=[faces objectAtIndex:i];
		GLMaterial *material=[materials objectAtIndex:i];

		NSValue *materialvalue=[NSValue valueWithNonretainedObject:material];
		NSMutableData *materialindexes=[materialdict objectForKey:materialvalue];
		if(!materialindexes)
		{
			materialindexes=[NSMutableData data];
			[materialdict setObject:materialindexes forKey:materialvalue];
		}

		int count=[face countWithElementSize:sizeof(GLPolygonVertex)];
		const GLPolygonVertex *polyvertices=[face bytes];
		int firstindex,previndex;

		for(int j=0;j<count;j++)
		{
			int newindex=[mesh->vertexarray countWithElementSize:sizeof(Vector)];
			int index=FindOrSetIndex(hash,polyvertices[j],newindex);
			if(index<0)
			{
				const GLPolygonVertex *vertex=&polyvertices[j];

				if(vertex->vertex>=0&&vertex->vertex<numvertices)
				[mesh->vertexarray appendVector:vertices[vertex->vertex]];
				else [mesh->vertexarray appendVector:MakeVector(0,0,0)];

				if(vertex->normal>=0&&vertex->normal<numnormals)
				[mesh->normalarray appendVector:normals[vertex->normal]];
				else [mesh->normalarray appendVector:MakeVector(0,0,0)];

				if(vertex->texcoord>=0&&vertex->texcoord<numtexcoords)
				[mesh->texcoordarray appendTextureCoordinateS:texcoords[vertex->texcoord].s t:texcoords[vertex->texcoord].t];
				else [mesh->texcoordarray appendTextureCoordinateS:0 t:0];

				index=newindex;
			}

			if(j==0) firstindex=index;
			else if(j==1) previndex=index;
			else
			{
				[materialindexes appendUInt32:firstindex];
				[materialindexes appendUInt32:previndex];
				[materialindexes appendUInt32:index];
				previndex=index;
			}
		}
	}

	NSEnumerator *enumerator=[materialdict keyEnumerator];
	NSValue *materialvalue;
	while(materialvalue=[enumerator nextObject])
	{
		GLMaterial *material=[materialvalue nonretainedObjectValue];
		NSData *materialindexes=[materialdict objectForKey:materialvalue];
		int count=[materialindexes countWithElementSize:sizeof(uint32_t)];

		[mesh addMaterial:material withNumberOfIndexes:count];
		[mesh->indexarray appendData:materialindexes];
	}

	FreeVertexHashTable(hash);

	[mesh optimize];

	[pool release];

	return mesh;
}

-(Vector)maximumComponentsWithMatrix:(Matrix)matrix
{
	const Vector *verts=[vertexarray bytes];
	int numvertexarray=[vertexarray countWithElementSize:sizeof(Vector)];
	if(!numvertexarray) return MakeVector(1,1,1);

	Vector max=verts[0];
	for(int i=1;i<numvertexarray;i++)
	{
		Vector v=TransformVector(matrix,verts[i]);
		max.x=fmaxf(v.x,max.x);
		max.y=fmaxf(v.y,max.y);
		max.z=fmaxf(v.z,max.z);
	}
	return max;
}

-(Vector)minimumComponentsWithMatrix:(Matrix)matrix
{
	const Vector *verts=[vertexarray bytes];
	int numvertexarray=[vertexarray countWithElementSize:sizeof(Vector)];
	if(!numvertexarray) return MakeVector(-1,-1,-1);

	Vector min=verts[0];
	for(int i=1;i<numvertexarray;i++)
	{
		Vector v=TransformVector(matrix,verts[i]);
		min.x=fminf(v.x,min.x);
		min.y=fminf(v.y,min.y);
		min.z=fminf(v.z,min.z);
	}
	return min;
}

@end
