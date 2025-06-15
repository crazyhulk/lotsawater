#import "LotsaWaterView.h"
#import "LotsaCore/GLConverter.h"
#import "LotsaCore/Random.h"

@implementation LotsaWaterView

-(id)initWithFrame:(NSRect)frame isPreview:(BOOL)preview
{
	if((self=[super initWithFrame:frame isPreview:preview useGL:YES]))
	{
		screenshot=nil;

//        NSLog(@"==============frame:%f", frame.size.width);
//        NSScreen *screen = [NSScreen mainScreen];
//        NSDictionary *description = [screen deviceDescription];
//        NSSize displayPixelSize = [[description objectForKey:NSDeviceSize] sizeValue];
//        NSLog(@"==============frame1111:%f", displayPixelSize.width);
//        NSLog(@"==============retina:%f", [[NSScreen mainScreen] backingScaleFactor]);
    
		[self setAnimationTimeInterval:1/60.0];
		[self setConfigName:@"ConfigSheet"];
		[self setSaverName:@"LotsaWater" andDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
			@"2",@"detail",
			@"1",@"accuracy",
			@"0",@"slowMotion",
			@"0.5",@"rainFall",
			@"0.5",@"depth",
			@"0",@"imageSource",
			@"",@"imageFileName",
			@"1",@"imageFade",
			@"0",@"clockSize",
		nil]];

		screenshot=nil;
    }

    // 创建 Metal 视图
    _metalView = [[MTLView alloc] initWithFrame:self.bounds];
    [self addSubview:_metalView];
    
    // 初始化 OpenGL 相关资源
    [self setupOpenGL];
    
    // 初始化 Metal 相关资源
    [self setupMetal];

    return self;
}

-(void)dealloc
{
//	[screenshot release];
//	[super dealloc];

    // 清理 Metal 资源
    _metalView = nil;
    _metalRenderer = nil;
    _vertexBuffer = nil;
    _indexBuffer = nil;
    _reflectionTexture = nil;
    _backgroundTexture = nil;
    _renderPipeline = nil;
    _waterComputePipeline = nil;
    _dropComputePipeline = nil;
    _waterParamsBuffer = nil;
    _waterStateBuffer = nil;
    _heightBuffer = nil;
    _normalBuffer = nil;
    _currentCommandBuffer = nil;
    _currentDrawable = nil;
}

-(void)drawRect:(NSRect)rect
{
	if(!screenshot)
	if(ispreview||[[self defaults] integerForKey:@"imageSource"]==0)
	{
		screenshot=[self grabScreenShot];
	}
	[screenshot drawAtPoint:NSMakePoint(0,0)];
}

-(void)startAnimationWithDefaults:(ScreenSaverDefaults *)defaults
{
	if(!screenshot)
	if(ispreview||[[self defaults] integerForKey:@"imageSource"]==0)
	{
		screenshot=[self grabScreenShot];
	}

	SeedRandom(time(0));

	int gridsize,max_p;

	switch([defaults integerForKey:@"detail"])
	{
		default: gridsize=24; break;
		case 1: gridsize=32; break;
		case 2: gridsize=48; break;
		case 3: gridsize=64; break;
		case 4: gridsize=96; break;
		case 5: gridsize=128; break;
	}

	switch([defaults integerForKey:@"accuracy"])
	{
		default: max_p=12; break;
		case 1: max_p=16; break;
		case 2: max_p=24; break;
		case 3: max_p=32; break;
		case 4: max_p=64; break;
	}

	double slow=[defaults floatForKey:@"slowMotion"];
	double rain=[defaults floatForKey:@"rainFall"];
	double d=[defaults floatForKey:@"depth"];

	t=0;
	t_next=1;
	t_div=(slow+1)*(slow+1);

	raintime=4*0.9*(rain-1)*(rain-1)+0.1;
	waterdepth=0.2+d*d*4*1.8;

	int srcid=[defaults integerForKey:@"imageSource"];
	NSString *imagename=[defaults stringForKey:@"imageFileName"];

	[[self openGLContext] makeCurrentContext];

	switch(srcid)
	{
		case 0:
			backtex=[GLConverter uncopiedTextureRectangleFromRep:screenshot];
			tex_w=[screenshot pixelsWide];
			tex_h=[screenshot pixelsHigh];
		break;
		case 1:
		{
			NSBitmapImageRep *rep=[NSImageRep imageRepWithContentsOfFile:imagename];
			backtex=[GLConverter textureRectangleFromRep:rep];
			tex_w=[rep pixelsWide];
			tex_h=[rep pixelsHigh];
		}
		break;
	}

	float screen_scale=1.3/sqrtf((float)(screen_w*screen_w+screen_h*screen_h));
	float screen_fw=(float)screen_w*screen_scale;
	float screen_fh=(float)screen_h*screen_scale;

	if(screen_fw/screen_fh<(float)tex_w/(float)tex_h)
	{
		water_w=screen_fw;
		water_h=screen_fw*(float)tex_h/(float)tex_w;
	}
	else
	{
		water_w=screen_fh*(float)tex_w/(float)tex_h;
		water_h=screen_fh;
	}

	refltex=[GLConverter texture2DFromRep:[self imageRepFromBundle:@"reflections.png"]];

	InitWater(&wet,gridsize,gridsize,max_p,max_p,1,1,2*water_w,2*water_h);

/*	WaterState rnd;
	InitRandomWaterState(&rnd,&wet);
	AddWaterStateAtTime(&wet,&rnd,0);
	CleanupWaterState(&rnd);*/

	tex=malloc(wet.w*wet.h*sizeof(struct texcoord));
	col=malloc(wet.w*wet.h*sizeof(struct color));
	vert=malloc(wet.w*wet.h*sizeof(struct vertexcoord));

	int i=0;
	for(int y=0;y<wet.h;y++)
	for(int x=0;x<wet.w;x++)
	{
		float fx=(float)x/(float)(wet.w-1);
		float fy=(float)y/(float)(wet.h-1);

		vert[i].x=fx;
		vert[i].y=fy;
		col[i].a=255;

		i++;
	}

	glClearColor(0,0,0,0);
	glViewport(0,0,screen_w,screen_h);

	glActiveTextureARB(GL_TEXTURE0_ARB);
	glEnable(GL_TEXTURE_RECTANGLE_EXT);
	glBindTexture(GL_TEXTURE_RECTANGLE_EXT,backtex);
	glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
	glMatrixMode(GL_TEXTURE);
	glLoadIdentity();
	glScalef((float)tex_w,(float)tex_h,1);

	glActiveTextureARB(GL_TEXTURE1_ARB);
	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D,refltex);
	glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_ADD);
	glEnable(GL_TEXTURE_GEN_S);
	glEnable(GL_TEXTURE_GEN_T);
	glTexGeni(GL_S,GL_TEXTURE_GEN_MODE,GL_SPHERE_MAP);
	glTexGeni(GL_T,GL_TEXTURE_GEN_MODE,GL_SPHERE_MAP);
	glEnable(GL_NORMALIZE);

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glScalef(1/screen_fw,1/screen_fh,-0.001);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
//	glTranslatef(0,0,-5);
	glTranslatef(-water_w,water_h,-5);
	glScalef(2*water_w,-2*water_h,10);

//	[self animateOneFrame];

	[NSOpenGLContext clearCurrentContext];
}

-(void)stopAnimation
{
	[[self openGLContext] makeCurrentContext];

	CleanupWater(&wet);

	glDeleteTextures(1,&backtex);
	glDeleteTextures(1,&refltex);

	free(tex);
	free(col);
	free(vert);

	[NSOpenGLContext clearCurrentContext];

	[super stopAnimation];
}

-(void)animateOneFrame
{
	int i;

	[[self openGLContext] makeCurrentContext];

	double dt=[self deltaTime];
	t+=dt/t_div;

	while(t>t_next)
	{
		float x0=RandomFloat()*wet.lx;
		float y0=RandomFloat()*wet.ly;

		WaterState drip1,drip2;
		InitDripWaterState(&drip1,&wet,x0,y0,0.14,-0.01);
		InitDripWaterState(&drip2,&wet,x0,y0,0.07,0.01);
//		softdrip_state drip(0.5*wet->lx,0.5*wet->ly,wet);
		AddWaterStateAtTime(&wet,&drip1,t_next);
		AddWaterStateAtTime(&wet,&drip2,t_next);

//		t_next+=0.3;
		t_next+=(5-raintime)*exp(-t_next/10)+raintime;
	}

	CalculateWaterSurfaceAtTime(&wet,t);

	float fade=[[self defaults] floatForKey:@"imageFade"];
	if(![self isPreview]&&t<1) fade=1-(1-fade)*(t*t*(3-2*t));

	i=0;
	for(int y=0;y<wet.h;y++)
	for(int x=0;x<wet.w;x++)
	{
		float u0=vert[i].x;
		float v0=vert[i].y;

		float n=1.333f;
		float col_intensity=3.0f;

		float d=wet.z[i]+waterdepth;
		float n_abs2=vec3sq(wet.n[i]);
		float cos_a=wet.n[i].z/sqrtf(n_abs2);
		float sin_a=sqrtf(1.0f-cos_a*cos_a);
		float sin_b=sin_a/n;
		float cos_b=sqrtf(1.0f-sin_b*sin_b);
		float sin_ab=sin_a*cos_b-cos_a*sin_b;
		float dx=wet.n[i].x;
		float dy=wet.n[i].y;
		float r=sqrtf(dx*dx+dy*dy);

		if(r>0.000001f)
		{
			tex[i].u=u0-dx/r*sin_ab*d/water_w;
			tex[i].v=v0-dy/r*sin_ab*d/water_h;
		}
		else
		{
			tex[i].u=u0;
			tex[i].v=v0;
		}

		float c=-(wet.n[i].x+wet.n[i].y)*col_intensity+1.0f;
		if(c<0.0f) c=0.0f;
		if(c>1.0f) c=1.0f;

		col[i].r=col[i].g=col[i].b=(int)(c*fade*255.0f);

		i++;
	}

	glClear(GL_COLOR_BUFFER_BIT);

	glShadeModel(GL_SMOOTH);
	glDisable(GL_BLEND);

	glTexCoordPointer(2,GL_FLOAT,sizeof(struct texcoord),tex);
	glColorPointer(4,GL_UNSIGNED_BYTE,4,col);
	glNormalPointer(GL_FLOAT,sizeof(vec3_t),wet.n); 
	glVertexPointer(2,GL_FLOAT,sizeof(struct vertexcoord),vert); 

	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_NORMAL_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);

	glLockArraysEXT(0,wet.w*wet.h);

	i=0;
	for(int y=0;y<wet.h-1;y++)
	{
		glBegin(GL_TRIANGLE_STRIP);
		for(int x=0;x<wet.w;x++)
		{
			glArrayElement(i);
			glArrayElement(i+wet.w);
			i++;
		}
		glEnd();
	}

	glUnlockArraysEXT();

	[[self openGLContext] flushBuffer];

	[NSOpenGLContext clearCurrentContext];

    // 使用 Metal 渲染
    [self updateMetalBuffers];
    [self renderWithMetal];
}

-(void)updateConfigWindow:(NSWindow *)window usingDefaults:(ScreenSaverDefaults *)defaults
{
	[detail setIntValue:[defaults integerForKey:@"detail"]];
	[accuracy setIntValue:[defaults integerForKey:@"accuracy"]];
	[slomo setFloatValue:[defaults floatForKey:@"slowMotion"]];
	[rainfall setFloatValue:[defaults floatForKey:@"rainFall"]];
	[depth setFloatValue:[defaults floatForKey:@"depth"]];
	[imagefade setFloatValue:[defaults floatForKey:@"imageFade"]];
	[imgsrc selectItemAtIndex:[defaults integerForKey:@"imageSource"]];
	[imageview setFileName:[defaults stringForKey:@"imageFileName"]];

	[self pickImageSource:imgsrc];
}

-(void)updateDefaults:(ScreenSaverDefaults *)defaults usingConfigWindow:(NSWindow *)window
{
	[defaults setInteger:[detail intValue] forKey:@"detail"];
	[defaults setInteger:[accuracy intValue] forKey:@"accuracy"];
	[defaults setFloat:[slomo floatValue] forKey:@"slowMotion"];
	[defaults setFloat:[rainfall floatValue] forKey:@"rainFall"];
	[defaults setFloat:[depth floatValue] forKey:@"depth"];
	[defaults setFloat:[imagefade floatValue] forKey:@"imageFade"];
	[defaults setInteger:[imgsrc indexOfSelectedItem] forKey:@"imageSource"];
	[defaults setObject:[imageview fileName] forKey:@"imageFileName"];
}

-(IBAction)pickImageSource:(id)sender
{
	switch([imgsrc indexOfSelectedItem])
	{
		case 0:
		{
			NSImage *img=[[NSImage alloc] init];
			[img addRepresentation:screenshot];
			[imageview setImage:img];
		}
		break;
		case 1:
		{
			NSImage *img=[[NSImage alloc] initWithContentsOfFile:[imageview fileName]];
			[imageview setImage:img];
		}
		break;
	}
}

-(IBAction)dropImage:(id)sender
{
	[imgsrc selectItemAtIndex:1];
	[self pickImageSource:imgsrc];
}

+(BOOL)performGammaFade
{
    return NO;
}

- (void)setupOpenGL {
    // 保持原有的 OpenGL 初始化代码
    // ... existing code ...
}

- (void)setupMetal {
    // 获取默认设备
    _device = MTLCreateSystemDefaultDevice();
    if (!_device) {
        NSLog(@"Metal is not supported on this device");
        return;
    }
    
    // 创建命令队列
    _commandQueue = [_device newCommandQueue];
    
    // 初始化管理器
    _shaderManager = [[MTLShaderManager alloc] initWithDevice:_device];
    _bufferManager = [[MTLBufferManager alloc] initWithDevice:_device];
    _computeManager = [[MTLComputePipelineManager alloc] initWithDevice:_device];
    
    // 创建缓冲区
    size_t bufferSize = tex_w * tex_h * sizeof(float);
    _heightBuffer = [_device newBufferWithLength:bufferSize options:MTLResourceStorageModeShared];
    _normalBuffer = [_device newBufferWithLength:bufferSize * sizeof(simd_float3) options:MTLResourceStorageModeShared];
    
    // 创建顶点缓冲区
    size_t vertexCount = tex_w * tex_h;
    size_t vertexBufferSize = vertexCount * sizeof(simd_float4);
    _vertexBuffer = [_device newBufferWithLength:vertexBufferSize options:MTLResourceStorageModeShared];
    
    // 创建索引缓冲区
    size_t indexCount = (tex_w - 1) * (tex_h - 1) * 6;
    size_t indexBufferSize = indexCount * sizeof(uint32_t);
    _indexBuffer = [_device newBufferWithLength:indexBufferSize options:MTLResourceStorageModeShared];
    
    // 初始化索引
    uint32_t *indices = (uint32_t *)_indexBuffer.contents;
    int index = 0;
    for (int y = 0; y < tex_h - 1; y++) {
        for (int x = 0; x < tex_w - 1; x++) {
            uint32_t topLeft = y * tex_w + x;
            uint32_t topRight = topLeft + 1;
            uint32_t bottomLeft = (y + 1) * tex_w + x;
            uint32_t bottomRight = bottomLeft + 1;
            
            indices[index++] = topLeft;
            indices[index++] = bottomLeft;
            indices[index++] = topRight;
            indices[index++] = topRight;
            indices[index++] = bottomLeft;
            indices[index++] = bottomRight;
        }
    }
    
    // 初始化水波纹参数
    _time = 0.0f;
    _nextTime = 0.0f;
    _timeStep = 1.0f / 60.0f;
    _waterDepth = waterdepth;
    _damping = 0.99f;
    _waveSpeed = 0.1f;
}

- (void)updateMetalBuffers {
    // 计算水波纹表面
    [self calculateWaterSurface];
    
    // 更新高度缓冲区
    float *heights = (float *)_heightBuffer.contents;
    for (int y = 0; y < tex_h; y++) {
        for (int x = 0; x < tex_w; x++) {
            heights[y * tex_w + x] = wet.z[y * tex_w + x];
        }
    }
    
    // 计算法线
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    [_computeManager computeNormalsWithHeightBuffer:_heightBuffer
                                     normalBuffer:_normalBuffer
                                           width:tex_w
                                          height:tex_h
                                          scale:1.0f
                                    commandBuffer:commandBuffer];
    [commandBuffer commit];
    
    // 更新顶点缓冲区
    simd_float4 *vertices = (simd_float4 *)_vertexBuffer.contents;
    simd_float3 *normals = (simd_float3 *)_normalBuffer.contents;
    
    for (int y = 0; y < tex_h; y++) {
        for (int x = 0; x < tex_w; x++) {
            int index = y * tex_w + x;
            float nx = (float)x / (tex_w - 1);
            float ny = (float)y / (tex_h - 1);
            
            vertices[index] = simd_make_float4(
                nx * 2.0f - 1.0f,
                ny * 2.0f - 1.0f,
                heights[index],
                1.0f
            );
        }
    }
    
    // 更新背景纹理
    [self updateBackgroundTexture];
    
    // 更新反射纹理
    [self updateReflectionTexture];
}

- (void)renderWithMetal {
    if (!_device || !_commandQueue) {
        return;
    }
    
    // 创建命令缓冲区
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    
    // 更新水波纹
    [_computeManager computeWaterSurfaceWithCurrentBuffer:_heightBuffer
                                          previousBuffer:_heightBuffer
                                              nextBuffer:_heightBuffer
                                                   width:tex_w
                                                  height:tex_h
                                                   time:_time
                                                  depth:_waterDepth
                                                damping:_damping
                                                  speed:_waveSpeed
                                           commandBuffer:commandBuffer];
    
    // 更新法线
    [_computeManager computeNormalsWithHeightBuffer:_heightBuffer
                                     normalBuffer:_normalBuffer
                                           width:tex_w
                                          height:tex_h
                                          scale:1.0f
                                    commandBuffer:commandBuffer];
    
    // 渲染水波纹
    [_metalRenderer renderWithCommandBuffer:commandBuffer
                              vertexBuffer:_vertexBuffer
                              normalBuffer:_normalBuffer
                              indexBuffer:_indexBuffer
                        backgroundTexture:_backgroundTexture
                        reflectionTexture:_reflectionTexture];
    
    // 提交命令
    [commandBuffer commit];
    
    // 更新时间
    _time = _nextTime;
    _nextTime += _timeStep;
}

- (void)addWaterDropAtX:(float)x y:(float)y depth:(float)depth amplitude:(float)amplitude {
    if (!_device || !_commandQueue) {
        return;
    }
    
    // 创建命令缓冲区
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    
    // 计算水滴位置
    simd_float2 position = simd_make_float2(x * tex_w, y * tex_h);
    float radius = 10.0f; // 水滴半径
    
    // 添加水滴
    [_computeManager computeWaterDropWithHeightBuffer:_heightBuffer
                                          position:position
                                         amplitude:amplitude
                                            radius:radius
                                     commandBuffer:commandBuffer];
    
    // 提交命令
    [commandBuffer commit];
}

@end

@implementation ImagePicker

-(id)initWithCoder:(NSCoder *)coder
{
	if((self=[super initWithCoder:coder]))
	{
		filename=nil;
	}
	return self;
}

-(void)dealloc
{
//	[filename release];
//	[super dealloc];
}

-(void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
	NSPasteboard *pboard=[sender draggingPasteboard];
	NSString *type=[pboard availableTypeFromArray:[NSArray arrayWithObjects:
	NSFilenamesPboardType,NSTIFFPboardType,NSPICTPboardType,nil]];


	if(type==NSFilenamesPboardType)
	{
		[self setFileName:[[pboard propertyListForType:NSFilenamesPboardType] objectAtIndex:0]];
	}
	else
	{
		NSFileManager *fm=[NSFileManager defaultManager];
		NSString *path=[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,NSUserDomainMask,YES) objectAtIndex:0];
		NSString *dir=[path stringByAppendingPathComponent:@"LotsaBlankers"];
		if(![fm fileExistsAtPath:dir]) [fm createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:NULL];

		NSString *ext=type==NSTIFFPboardType?@"tiff":@"pict";
		NSString *imagename=[[dir stringByAppendingPathComponent:@"LotsaWater"] stringByAppendingPathExtension:ext];
		[[pboard dataForType:type] writeToFile:imagename atomically:NO];

		[self setFileName:imagename];
	}

    [super concludeDragOperation:sender];
}

-(void)setFileName:(NSString *)newname
{
//	[filename autorelease];
//	filename=[newname retain];
}

-(NSString *)fileName { return filename; }

@end

/*			NSUserDefaults *desktopdefs=[[NSUserDefaults alloc] init];
			[desktopdefs addSuiteNamed:@"com.apple.desktop"];
			NSString *desktopname=[[[desktopdefs objectForKey:@"Background"] objectForKey:@"default"] objectForKey:@"ImageFilePath"];
			[desktopdefs release];*/
