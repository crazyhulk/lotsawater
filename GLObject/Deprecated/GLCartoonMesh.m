#import "GLCartoonMesh.h"


#define GLVisibleEdgeFlag 1
#define GLSharpEdgeFlag 2

#define GLVisibleFaceFlag 1



#ifdef ClassNamePrefix
#define GLCartoonMaterial ClassNamePrefix ## GLCartoonMaterial
#endif

@interface GLCartoonMaterial:NSObject
{
	@public
	float diffuse[3];
}

+(NSDictionary *)convertMaterials:(NSDictionary *)materials;
+(GLCartoonMaterial *)defaultMaterial;

-(id)initWithMaterial:(GLMaterial *)material;
-(void)dealloc;

@end

typedef struct GLCartoonTriangle
{
	int v1,v2,v3;
	int n1,n2,n3;
	int t1,t2,t3;
	GLCartoonMaterial *material;

	int e1,e2,e3;
	Vector n;
	int flags;
} GLCartoonTriangle;

typedef struct GLCartoonEdge
{
	int v1,v2;
	int n1,n2;
	int f1,f2;
	int flags;
} GLCartoonEdge;



@implementation GLCartoonMesh

+(GLCartoonMesh *)cartoonMeshWithMesh:(GLTriangleMesh *)mesh
{
	return [[[self alloc] initWithMesh:mesh] autorelease];
}

-(id)init
{
	if(self=[super init])
	{
		vertices=nil;
		normals=nil;
		texcoords=nil;
		faces=nil;
		edges=nil;
		dots=nil;
		materials=nil;
		vertexarray=nil;
	}
	return self;
}

-(id)initWithMesh:(GLTriangleMesh *)mesh
{
	if(self=[self init])
	{
		[self buildFromMesh:mesh];
	}
	return self;
}

-(void)dealloc
{
	[vertices release];
	[normals release];
	[texcoords release];
	[faces release];
	[edges release];
	[dots release];
	[materials release];
	[vertexarray release];

	[super dealloc];
}

-(void)buildFromMesh:(GLTriangleMesh *)mesh
{
	vertices=[[mesh vertices] retain];
	normals=[[mesh normals] retain];
	texcoords=[[mesh textureCoordinates] retain];
	materials=[[GLCartoonMaterial convertMaterials:[mesh materials]] retain];

	int num_faces=[[mesh triangles] count];

	faces=[[NSMutableValueArray valueArrayWithCount:num_faces withObjCType:@encode(GLCartoonTriangle)] retain];
	edges=[[NSMutableValueArray valueArrayWithObjCType:@encode(GLCartoonEdge)] retain];
	dots=[[NSMutableValueArray valueArrayWithCount:[normals count] withObjCType:@encode(float)] retain];
	vertexarray=[[GLVertexArray alloc] initWithValueArray:vertices entries:GLVertex3f,GLPad4b,GLEnd];

	const PaddedVector *v=[vertices bytes];
	const GLTriangle *t=[[mesh triangles] bytes];
	GLCartoonTriangle *f=[faces mutableBytes];

	for(int i=0;i<num_faces;i++)
	{
		f[i].v1=t[i].v1; f[i].v2=t[i].v2; f[i].v3=t[i].v3;
		f[i].n1=t[i].n1; f[i].n2=t[i].n2; f[i].n3=t[i].n3;
		f[i].t1=t[i].t1; f[i].t2=t[i].t2; f[i].t3=t[i].t3;

		if(!t[i].material) f[i].material=[GLCartoonMaterial defaultMaterial]; // unlikely
		else f[i].material=[materials objectForKey:[t[i].material name]];

		f[i].e1=[self findEdgeForFirstVertex:f[i].v1 second:f[i].v2 firstNormal:f[i].n1 second:f[i].n2 face:i];
		f[i].e2=[self findEdgeForFirstVertex:f[i].v2 second:f[i].v3 firstNormal:f[i].n2 second:f[i].n3 face:i];
		f[i].e3=[self findEdgeForFirstVertex:f[i].v3 second:f[i].v1 firstNormal:f[i].n3 second:f[i].n1 face:i];
		f[i].n=NormalVectorForTriangle(v[f[i].v1].v,v[f[i].v2].v,v[f[i].v3].v);
		f[i].flags=0;
	}
}

-(int)findEdgeForFirstVertex:(int)v1 second:(int)v2 firstNormal:(int)n1 second:(int)n2 face:(int)f
{
	GLCartoonEdge *e=[edges mutableBytes];
	const PaddedVector *n=[normals bytes];

	int num_edges=[edges count];
	for(int i=0;i<num_edges;i++)
	{
		//if((e->v1==v1&&e->v2==v2)||(e->v1==v2&&e->v2==v1))
		if(e[i].v1==v2&&e[i].v2==v1)
		{
			if(e[i].f2==-1)
			{
				e[i].f2=f;
//				if(e[i].n1!=n2||e[i].n2!=n1) e[i].flags|=GLSharpEdgeFlag;
				if(!VectorsAreNearlyEqual(n[e[i].n1].v,n[n2].v)||!VectorsAreNearlyEqual(n[e[i].n2].v,n[n1].v))
				e[i].flags|=GLSharpEdgeFlag;
			}
			else // broken surface
			{
				e[i].flags|=GLSharpEdgeFlag;
			}

			return i;
		}
		else if(e[i].v1==v1&&e[i].v2==v2) // broken surface
		{
			e[i].flags|=GLSharpEdgeFlag;
			return i;
		}
	}

	GLCartoonEdge edge;
	edge.v1=v1; edge.v2=v2;
	edge.n1=n1; edge.n2=n2;
	edge.f1=f; edge.f2=-1;
	edge.flags=0;

	[edges addValue:&edge];

	return num_edges;
}


-(void)calculateVisibilityWithCamera:(Vector)camera light:(Vector)light
{
	const PaddedVector *v=[vertices bytes];
	const PaddedVector *n=[normals bytes];
	GLCartoonTriangle *f=[faces mutableBytes];
	GLCartoonEdge *e=[edges mutableBytes];
	float *dp=[dots mutableBytes];

//	GLCartoonTriangle *f=[faces bytes];
//	float *dp=[dots bytes];
	int num_normals=[normals count];
	for(int i=0;i<num_normals;i++) dp[i]=VectorDot(n[i].v,light);

	int num_faces=[faces count];
	for(int i=0;i<num_faces;i++)
	{
		if(VectorDot(f[i].n,VectorSub(camera,v[f[i].v1].v))>0) f[i].flags|=GLVisibleFaceFlag;
		else f[i].flags&=~GLVisibleFaceFlag;
	}

	int num_edges=[edges count];
	for(int i=0;i<num_edges;i++)
	{
		if(e[i].f2==-1)
		{
			if(f[e[i].f1].flags&GLVisibleFaceFlag) e[i].flags|=GLVisibleEdgeFlag;
			else e[i].flags&=~GLVisibleEdgeFlag;
		}
		else if(e[i].flags&GLSharpEdgeFlag)
		{
			if((f[e[i].f1].flags&GLVisibleFaceFlag)||(f[e[i].f2].flags&GLVisibleFaceFlag)) e[i].flags|=GLVisibleEdgeFlag;
			else e[i].flags&=~GLVisibleEdgeFlag;
		}
		else if( (f[e[i].f1].flags&GLVisibleFaceFlag) != (f[e[i].f2].flags&GLVisibleFaceFlag) )
		{
			e[i].flags|=GLVisibleEdgeFlag;
		}
		else
		{
			e[i].flags&=~GLVisibleEdgeFlag;
		}
	}
}

-(void)drawWithSubdivision
{
	const PaddedVector *v=[vertices bytes];
	const GLTextureCoordinate *tc=[texcoords bytes];
	const GLCartoonTriangle *f=[faces bytes];
	const float *dp=[dots bytes];

	glEnable(GL_POLYGON_OFFSET_FILL);
	glPolygonOffset(1.5,0);

	glBegin(GL_TRIANGLES);

	GLCartoonMaterial *currmaterial=[GLCartoonMaterial defaultMaterial];
	glColor3f(0,0,0);

	int num_faces=[faces count];
	for(int i=0;i<num_faces;i++)
	{
		if(f[i].flags&GLVisibleFaceFlag)
		{
			BOOL lit1=dp[f[i].n1]>0;
			BOOL lit2=dp[f[i].n2]>0;
			BOOL lit3=dp[f[i].n3]>0;

			if(f[i].material!=currmaterial)
			{
				currmaterial=f[i].material;
/*				if(m[f[i].m].tex)
				{
					glEnd();
					glBindTexture(GL_TEXTURE_2D,m[f[i].m].tex->tex);
					glEnable(GL_TEXTURE_2D);
					glBegin(GL_TRIANGLES);
				}
				else
				{
					glDisable(GL_TEXTURE_2D);
				}*/
			}

			if(lit1==lit2&&lit2==lit3) // fully lit, or dark
			{
				if(lit1) glColor3f(currmaterial->diffuse[0],currmaterial->diffuse[1],currmaterial->diffuse[2]);
				else glColor3f(currmaterial->diffuse[0]/2,currmaterial->diffuse[1]/2,currmaterial->diffuse[2]/2);

				if(f[i].t1>=0) glTexCoord2f(tc[f[i].t1].s,tc[f[i].t1].t);
				glArrayElement(f[i].v1);
				if(f[i].t2>=0) glTexCoord2f(tc[f[i].t2].s,tc[f[i].t2].t);
				glArrayElement(f[i].v2);
				if(f[i].t3>=0) glTexCoord2f(tc[f[i].t3].s,tc[f[i].t3].t);
				glArrayElement(f[i].v3);
			}
			else
			{
				int v1,v2,v3;
				int t1,t2,t3;
				float dp1,dp2,dp3;
				Vector m1,m3;
				BOOL lit;

				if(lit2==lit3)
				{
					v1=f[i].v1; v2=f[i].v2; v3=f[i].v3;
					t1=f[i].t1; t2=f[i].t2; t3=f[i].t3;
					dp1=dp[f[i].n1]; dp2=dp[f[i].n2]; dp3=dp[f[i].n3];
					lit=lit1;
				}
				else if(lit1==lit3)
				{
					v1=f[i].v2; v2=f[i].v3; v3=f[i].v1;
					t1=f[i].t2; t2=f[i].t3; t3=f[i].t1;
					dp1=dp[f[i].n2]; dp2=dp[f[i].n3]; dp3=dp[f[i].n1];
					lit=lit2;
				}
				else
				{
					v1=f[i].v3; v2=f[i].v1; v3=f[i].v2;
					t1=f[i].t3; t2=f[i].t1; t3=f[i].t2;
					dp1=dp[f[i].n3]; dp2=dp[f[i].n1]; dp3=dp[f[i].n2];
					lit=lit3;
				}

				m1=VectorDiv(VectorSub(VectorMul(v[v2].v,dp1),VectorMul(v[v1].v,dp2)),dp1-dp2);
				m3=VectorDiv(VectorSub(VectorMul(v[v1].v,dp3),VectorMul(v[v3].v,dp1)),dp3-dp1);

				glEnd();
				glBegin(GL_TRIANGLE_STRIP);

				if(lit) glColor3f(currmaterial->diffuse[0],currmaterial->diffuse[1],currmaterial->diffuse[2]);
				else glColor3f(currmaterial->diffuse[0]/2,currmaterial->diffuse[1]/2,currmaterial->diffuse[2]/2);

				if(t1>=0) glTexCoord2f(tc[t1].s,tc[t1].t);
				glArrayElement(v1);
				if(t1>=0&&t2>=0) glTexCoord2f((tc[t2].s*dp1-tc[t1].s*dp2)/(dp1-dp2),(tc[t2].t*dp1-tc[t1].t*dp2)/(dp1-dp2));
				glVertex3f(m1.x,m1.y,m1.z);
				if(t3>=0&&t1>=0) glTexCoord2f((tc[t1].s*dp3-tc[t3].s*dp1)/(dp3-dp1),(tc[t1].t*dp3-tc[t3].t*dp1)/(dp3-dp1));
				glVertex3f(m3.x,m3.y,m3.z);

				if(!lit) glColor3f(currmaterial->diffuse[0],currmaterial->diffuse[1],currmaterial->diffuse[2]);
				else glColor3f(currmaterial->diffuse[0]/2,currmaterial->diffuse[1]/2,currmaterial->diffuse[2]/2);

				if(t2>=0) glTexCoord2f(tc[t2].s,tc[t2].t);
				glArrayElement(v2);
				if(t3>=0) glTexCoord2f(tc[t3].s,tc[t3].t);
				glArrayElement(v3);

				glEnd();
				glBegin(GL_TRIANGLES);
			}
		}
	}

	glEnd();

	glDisable(GL_TEXTURE_2D);

	glDisable(GL_POLYGON_OFFSET_FILL);
}

/*
-(void)drawWithTexture
{
	vector *v=vertices->v;
	vector *n=normals->v;
	texcoord *tc=texcoords->t;
	material *m=materials->m;
	cmaterial *cm=cmaterials->m;

	glEnable(GL_POLYGON_OFFSET_FILL);
	glPolygonOffset(2,0);

	glEnable(GL_TEXTURE_1D);

	glBegin(GL_TRIANGLES);

	int curr_m=-1;
	glColor3f(1,1,1);

	for(int i=0;i<num_faces;i++)
	{
		if(f[i].flags&GLVisibleFaceFlag)
		{
			if(f[i].m!=-1&&f[i].m!=curr_m)
			{
				glEnd();
				glBindTexture(GL_TEXTURE_1D,cm[f[i].m].tex);
				glBegin(GL_TRIANGLES);
				curr_m=f[i].m;
			}

			glTexCoord1f((dp[f[i].n1]+1)/2);
			glArrayElement(f[i].v1);
			glTexCoord1f((dp[f[i].n2]+1)/2);
			glArrayElement(f[i].v2);
			glTexCoord1f((dp[f[i].n3]+1)/2);
			glArrayElement(f[i].v3);
		}
	}

	glEnd();

	glDisable(GL_POLYGON_OFFSET_FILL);
	glDisable(GL_TEXTURE_1D);
}
*/

-(void)drawEdges
{
	const GLCartoonEdge *e=[edges bytes];

	glBegin(GL_LINES);
	glColor3f(0,0,0);

	int num_edges=[edges count];
	for(int i=0;i<num_edges;i++)
	{
		if(e[i].flags&GLVisibleEdgeFlag)
		{
			glArrayElement(e[i].v1);
			glArrayElement(e[i].v2);
		}
	}

	glEnd();
}



-(void)drawWithCamera:(Vector)camera light:(Vector)light inverseTransform:(Matrix)transform
{
	[self drawWithCamera:TransformVector(transform,camera) light:TransformVectorDirection(transform,light)];
}

-(void)drawWithCamera:(Vector)camera light:(Vector)light
{
	[self calculateVisibilityWithCamera:camera light:light];

	glPushAttrib(GL_CURRENT_BIT|GL_LIGHTING_BIT|GL_ENABLE_BIT|GL_LINE_BIT);
	glShadeModel(GL_FLAT);
	glDisable(GL_LIGHTING);
	glDisable(GL_CULL_FACE);
	//glLineWidth(2);

	[vertexarray lock];

	[self drawWithSubdivision];
	[self drawEdges];

	[vertexarray unlock];

	glPopAttrib();
}

@end



@implementation GLCartoonMaterial

+(NSDictionary *)convertMaterials:(NSDictionary *)materials
{
	NSMutableDictionary *dict=[NSMutableDictionary dictionary];

	NSEnumerator *enumerator=[materials keyEnumerator];
	NSString *name;
	while(name=[enumerator nextObject])
	[dict setObject:[[[GLCartoonMaterial alloc] initWithMaterial:[materials objectForKey:name]] autorelease] forKey:name];

	return dict;
}

+(GLCartoonMaterial *)defaultMaterial
{
	static GLCartoonMaterial *def=nil;
	if(!def) def=[self new];
	return def;
}

-(id)init
{
	if(self=[super init])
	{
		diffuse[0]=diffuse[1]=diffuse[2]=1;
	}
	return self;
}

-(id)initWithMaterial:(GLMaterial *)material
{
	if(self=[super init])
	{
		diffuse[0]=[material diffuseRed];
		diffuse[1]=[material diffuseGreen];
		diffuse[2]=[material diffuseBlue];

		if(material==[GLMaterial defaultMaterial])
		{
			[self release];
			return [[GLCartoonMaterial defaultMaterial] retain];
		}
	}
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

@end




/*

void cartoon_res::draw_alt(vector camera,vector light)
{
	calc_visibility(camera,light);

	glShadeModel(GL_FLAT);
	glDisable(GL_LIGHTING);
	glDisable(GL_CULL_FACE);

	glVertexPointer(3,GL_FLOAT,sizeof(vector),vertices->v);
	glEnableClientState(GL_VERTEX_ARRAY);

//	if(glLockArraysEXT_ptr) glLockArraysEXT_ptr(0,vertices->n);
	glLockArraysEXT(0,vertices->n);

	draw_texture();

	draw_edges();

//	if(glUnlockArraysEXT_ptr) glUnlockArraysEXT_ptr();
	glUnlockArraysEXT();
	glDisableClientState(GL_VERTEX_ARRAY);

	glShadeModel(GL_SMOOTH);
	glEnable(GL_LIGHTING);
	glEnable(GL_CULL_FACE);
}





void cmaterial::build(material *m)
{
	// should have the possibility of loading an alternate texture!

	int d_r=int(255*m->d[0]);
	int d_g=int(255*m->d[1]);
	int d_b=int(255*m->d[2]);

	int h_r=int(255*(m->d[0]+m->s[0]));
	int h_g=int(255*(m->d[1]+m->s[1]));
	int h_b=int(255*(m->d[2]+m->s[2]));

	if(h_r>255) h_r=255;
	if(h_g>255) h_g=255;
	if(h_b>255) h_b=255;

	float a=(m->d[0]+m->d[1]+m->d[2])/3;
	float b=(m->d[0]+m->d[1]+m->d[2]+m->s[0]+m->s[1]+m->s[2])/3;

	float thr;

	// not quite accurate - doesn't take individual channel clipping into account
	if(b>1) thr=(1-a)/(b-a)/2;
	else thr=0.5;

	double cos_a=pow(thr,1/m->phong);

	int threshold=int((cos_a+1)/2*CARTOON_TEX_SIZE);

	for(int i=0;i<CARTOON_TEX_SIZE;i++)
	{
		int r,g,b;

		if(i<CARTOON_TEX_SIZE/2) { r=d_r/2; g=d_g/2; b=d_b/2; }
		else if(i<threshold){ r=d_r; g=d_g; b=d_b; }
		else { r=h_r; g=h_g; b=h_b; }

		rgb[3*i+0]=r;
		rgb[3*i+1]=g;
		rgb[3*i+2]=b;
	}

	glBindTexture(GL_TEXTURE_1D,tex);
	glTexImage1D(GL_TEXTURE_1D,0,GL_RGB,CARTOON_TEX_SIZE,0,GL_RGB,GL_UNSIGNED_BYTE,rgb);
	glTexParameteri(GL_TEXTURE_1D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
	glTexParameteri(GL_TEXTURE_1D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
	glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
}
*/

