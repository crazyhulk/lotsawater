#import "LotsaWaterView.h"
#import "LotsaCore/Random.h"
#import "WaterTypes.h"
#import <simd/simd.h>
#import <os/log.h>

@implementation LotsaWaterView

+ (void)initialize {
    if (self == [LotsaWaterView class]) {
        // 类初始化时的日志
        NSLog(@"=== LotsaWaterView +initialize called ===");
        os_log(OS_LOG_DEFAULT, "LotsaWaterView class initialized");
        
        // 写入文件日志
        NSString *logPath = @"/tmp/lotsawater_init.log";
        NSString *logMessage = [NSString stringWithFormat:@"%@ - LotsaWaterView class initialized\n", [NSDate date]];
        [logMessage writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

+ (void)load {
    // 类加载时的日志
    NSLog(@"=== LotsaWaterView +load called ===");
    os_log(OS_LOG_DEFAULT, "LotsaWaterView class loaded");
}

+ (void)debugLog:(NSString *)message {
    // 同时尝试多种方法来确保我们能看到调试信息
    // 1. 尝试写入到用户桌面上的调试文件（更容易找到）
    NSString *desktopPath = [@"/tmp/lotsawater_debug.log" stringByExpandingTildeInPath];
    NSString *timestampedMessage = [NSString stringWithFormat:@"%@ - %@\n", [NSDate date], message];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:desktopPath]) {
        [@"LotsaWater Debug Log\n" writeToFile:desktopPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:desktopPath];
    if (fileHandle) {
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[timestampedMessage dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
    
    // 2. 同时写入到临时目录
    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"lotsawater_debug.log"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
        [@"LotsaWater Debug Log\n" writeToFile:tempPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSFileHandle *tempFileHandle = [NSFileHandle fileHandleForWritingAtPath:tempPath];
    if (tempFileHandle) {
        [tempFileHandle seekToEndOfFile];
        [tempFileHandle writeData:[timestampedMessage dataUsingEncoding:NSUTF8StringEncoding]];
        [tempFileHandle closeFile];
    }
    
    // 3. 保留NSLog作为备用
    NSLog(@"LotsaWater: %@", message);
}

-(id)initWithFrame:(NSRect)frame isPreview:(BOOL)preview
{
    os_log(OS_LOG_DEFAULT, "Hello %{public}@", @"屏保"); // ✅ 正确方式

    os_log_t logger = os_log_create("in.xizi.lotsawater", "screensaver");
    os_log_error(logger, "========= 屏保启动成功！value={public}");
	// 立即在Console中显示，最可靠的方法
	NSLog(@"=== LotsaWater initWithFrame called ===");
	[LotsaWaterView debugLog:@"initWithFrame called"];
	
	if((self=[super initWithFrame:frame isPreview:preview useGL:YES]))
	{
		NSLog(@"=== LotsaWater initWithFrame success, frame: %@ ===", NSStringFromRect(frame));
		[LotsaWaterView debugLog:[NSString stringWithFormat:@"initWithFrame success, frame: %@", NSStringFromRect(frame)]];
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
    [LotsaWaterView debugLog:@"Creating MTLView"];
    _metalView = [[MTLView alloc] initWithFrame:self.bounds];
    if (!_metalView) {
        [LotsaWaterView debugLog:@"ERROR: Failed to create MTLView"];
        return self;
    }
    
    [LotsaWaterView debugLog:[NSString stringWithFormat:@"Created MTLView with frame: %@", NSStringFromRect(self.bounds)]];
    [self addSubview:_metalView];
    [LotsaWaterView debugLog:@"Added MTLView as subview"];
    
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
    _normalBuffer = nil;
    _texCoordBuffer = nil;
    _indexBuffer = nil;
    _heightBuffer = nil;
    _constantsBuffer = nil;
    _reflectionTexture = nil;
    _backgroundTexture = nil;
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
	[LotsaWaterView debugLog:@"=== startAnimationWithDefaults called ==="];
	[LotsaWaterView debugLog:[NSString stringWithFormat:@"Current _device: %@", _device]];
	[LotsaWaterView debugLog:[NSString stringWithFormat:@"Current _bufferManager: %@", _bufferManager]];
	
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

	// 时间参数由新的Metal系统管理，这里保留raintime计算

	raintime=4*0.9*(rain-1)*(rain-1)+0.1;
	waterdepth=0.2+d*d*4*1.8;

	int srcid=[defaults integerForKey:@"imageSource"];
	NSString *imagename=[defaults stringForKey:@"imageFileName"];

	// 处理纹理资源
	switch(srcid)
	{
		case 0:
			tex_w=[screenshot pixelsWide];
			tex_h=[screenshot pixelsHigh];
		break;
		case 1:
		{
			NSBitmapImageRep *rep=[NSImageRep imageRepWithContentsOfFile:imagename];
			tex_w=[rep pixelsWide];
			tex_h=[rep pixelsHigh];
			screenshot = rep; // 暂时使用这个图像
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

	// 初始化水波纹数据结构
	InitWater(&wet,gridsize,gridsize,max_p,max_p,1,1,2*water_w,2*water_h);

	// 确保Metal已经初始化，如果没有则重新初始化
	if (!_device || !_bufferManager) {
		NSLog(@"Metal not initialized in startAnimationWithDefaults, calling setupMetal...");
		[self setupMetal];
	}
	
	// 创建Metal缓冲区
	if (_device && _bufferManager) {
		[self createMetalBuffers];
		
		// 更新纹理
		[self updateBackgroundTexture];
		[self updateReflectionTexture];
	} else {
		NSLog(@"ERROR: Failed to initialize Metal for water animation");
	}

	// 初始化时间参数
	_time = 0.0;
	_nextTime = 0.0;
	_timeStep = 1.0 / 60.0;
	_waterDepth = waterdepth;
	_damping = 0.98;
	_waveSpeed = 1.0;
}

-(void)stopAnimation
{
	// 清理水波纹数据
	CleanupWater(&wet);

	// 清理Metal资源
	_vertexBuffer = nil;
	_normalBuffer = nil;
	_texCoordBuffer = nil;
	_heightBuffer = nil;
	_indexBuffer = nil;
	_constantsBuffer = nil;
	_backgroundTexture = nil;
	_reflectionTexture = nil;
	_metalRenderer = nil;
	_bufferManager = nil;
	_computeManager = nil;
	_commandQueue = nil;
	_device = nil;

	[super stopAnimation];
}

-(void)animateOneFrame
{
    if (!_device || !_metalView) {
        NSLog(@"animateOneFrame: Missing device (%@) or metalView (%@)", _device, _metalView);
        return;
    }
    
    // 更新水波纹状态
    [self updateWaterSurface];
    
    // 获取当前可绘制对象
    id<CAMetalDrawable> drawable = [_metalView currentDrawable];
    if (!drawable) {
        NSLog(@"animateOneFrame: No drawable available");
        return;
    }
    
    NSLog(@"animateOneFrame: Rendering frame with drawable: %@", drawable);
    
    // 创建命令缓冲区
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"Water Animation Frame";
    
    // 更新常量缓冲区
    [self updateConstants];
    
    // 渲染水波纹
    [_metalRenderer renderWithCommandBuffer:commandBuffer
                                    drawable:drawable
                               vertexBuffer:_vertexBuffer
                              normalBuffer:_normalBuffer
                            texCoordBuffer:_texCoordBuffer
                               indexBuffer:_indexBuffer
                        backgroundTexture:_backgroundTexture
                        reflectionTexture:_reflectionTexture
                               constants:_constantsBuffer];
    
    // 显示drawable
    [commandBuffer presentDrawable:drawable];
    
    // 提交命令
    [commandBuffer commit];
    
    // 更新时间
    _time += _timeStep;
    if (_time >= _nextTime) {
        [self addRandomWaterDrop];
        _nextTime += (5 - raintime) * exp(-_time / 10) + raintime;
    }
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

- (void)createMetalBuffers {
    if (!_device || !_bufferManager) {
        NSLog(@"Metal device or buffer manager not initialized");
        return;
    }
    
    NSLog(@"Creating Metal buffers for water grid %dx%d", wet.w, wet.h);
    
    // 创建顶点缓冲区
    NSUInteger vertexCount = wet.w * wet.h;
    _vertexBuffer = [_bufferManager createVertexBufferWithVertices:NULL 
                                                           count:vertexCount 
                                                          stride:sizeof(simd_float3)];
    if (!_vertexBuffer) {
        NSLog(@"Failed to create vertex buffer");
        return;
    }
    
    // 创建法线缓冲区
    _normalBuffer = [_bufferManager createNormalBufferWithWidth:wet.w height:wet.h];
    if (!_normalBuffer) {
        NSLog(@"Failed to create normal buffer");
        return;
    }
    
    // 创建纹理坐标缓冲区
    _texCoordBuffer = [_bufferManager createTexCoordBufferWithWidth:wet.w height:wet.h];
    if (!_texCoordBuffer) {
        NSLog(@"Failed to create texcoord buffer");
        return;
    }
    
    // 创建高度缓冲区
    _heightBuffer = [_bufferManager createHeightBufferWithWidth:wet.w height:wet.h];
    if (!_heightBuffer) {
        NSLog(@"Failed to create height buffer");
        return;
    }
    
    // 创建索引缓冲区
    NSUInteger indexCount = (wet.w - 1) * (wet.h - 1) * 6;
    _indexBuffer = [_bufferManager createBufferWithLength:indexCount * sizeof(uint32_t) 
                                                  options:MTLResourceStorageModeShared];
    if (!_indexBuffer) {
        NSLog(@"Failed to create index buffer");
        return;
    }
    
    [_bufferManager generateGridIndicesForBuffer:_indexBuffer width:wet.w height:wet.h];
    
    // 创建常量缓冲区
    _constantsBuffer = [_bufferManager createConstantsBufferWithSize:sizeof(MetalConstants)];
    if (!_constantsBuffer) {
        NSLog(@"Failed to create constants buffer");
        return;
    }
    
    // 创建背景纹理
    MTLTextureDescriptor *backgroundDesc = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatBGRA8Unorm
                                                                                              width:tex_w
                                                                                             height:tex_h
                                                                                          mipmapped:NO];
    backgroundDesc.usage = MTLTextureUsageShaderRead | MTLTextureUsageShaderWrite;
    _backgroundTexture = [_device newTextureWithDescriptor:backgroundDesc];
    
    // 创建反射纹理
    MTLTextureDescriptor *reflectionDesc = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatBGRA8Unorm
                                                                                               width:256
                                                                                              height:256
                                                                                           mipmapped:NO];
    reflectionDesc.usage = MTLTextureUsageShaderRead | MTLTextureUsageShaderWrite;
    _reflectionTexture = [_device newTextureWithDescriptor:reflectionDesc];
    
    // 生成网格顶点
    [_bufferManager generateGridVerticesForBuffer:_vertexBuffer 
                                     normalBuffer:_normalBuffer 
                                    texCoordBuffer:_texCoordBuffer 
                                            width:wet.w 
                                           height:wet.h 
                                       waterWidth:water_w 
                                      waterHeight:water_h];
    
    NSLog(@"Metal buffers created successfully");
}

- (void)setupMetal {
    [LotsaWaterView debugLog:@"Setting up Metal..."];
    
    // 获取默认的 Metal 设备
    _device = MTLCreateSystemDefaultDevice();
    if (!_device) {
        [LotsaWaterView debugLog:@"ERROR: Metal is not supported on this device"];
        return;
    }
    [LotsaWaterView debugLog:[NSString stringWithFormat:@"Metal device: %@", _device.name]];
    
    // 设置MTLView的设备
    [LotsaWaterView debugLog:@"Setting MTLView device"];
    [_metalView setDevice:_device];
    
    // 创建命令队列
    [LotsaWaterView debugLog:@"Creating command queue"];
    _commandQueue = [_device newCommandQueue];
    if (!_commandQueue) {
        [LotsaWaterView debugLog:@"ERROR: Failed to create command queue"];
        return;
    }
    [LotsaWaterView debugLog:@"Command queue created successfully"];
    
    // 直接在这里加载Metal库，不依赖MTLRenderer的init
    [LotsaWaterView debugLog:@"Loading Metal library directly"];
    
    // 根据测试程序的结果，直接尝试bundle方式（因为newDefaultLibrary会失败）
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    [LotsaWaterView debugLog:[NSString stringWithFormat:@"Using bundle: %@", bundle.bundlePath]];
    
    NSError *error = nil;
    id<MTLLibrary> metalLibrary = [_device newDefaultLibraryWithBundle:bundle error:&error];
    if (!metalLibrary) {
        [LotsaWaterView debugLog:[NSString stringWithFormat:@"Bundle library failed: %@", error.localizedDescription]];
        
        // 尝试手动加载metallib文件
        NSString *metalLibPath = [bundle pathForResource:@"default" ofType:@"metallib"];
        if (metalLibPath) {
            [LotsaWaterView debugLog:[NSString stringWithFormat:@"Found metallib at: %@", metalLibPath]];
            NSURL *libraryURL = [NSURL fileURLWithPath:metalLibPath];
            metalLibrary = [_device newLibraryWithURL:libraryURL error:&error];
            if (!metalLibrary) {
                [LotsaWaterView debugLog:[NSString stringWithFormat:@"Failed to load from URL: %@", error.localizedDescription]];
                return;
            } else {
                [LotsaWaterView debugLog:@"Successfully loaded library from URL"];
            }
        } else {
            [LotsaWaterView debugLog:@"No metallib file found in bundle"];
            return;
        }
    } else {
        [LotsaWaterView debugLog:@"Successfully loaded library from bundle"];
    }
    
    // 初始化 Metal 渲染器，传入已成功加载的设备和库
    [LotsaWaterView debugLog:@"Creating Metal renderer with device and library"];
    _metalRenderer = [[MTLRenderer alloc] initWithDevice:_device library:metalLibrary];
    if (!_metalRenderer) {
        [LotsaWaterView debugLog:@"ERROR: Failed to create Metal renderer with device and library"];
        return;
    }
    [LotsaWaterView debugLog:@"Metal renderer created successfully"];
    
    // 初始化缓冲区管理器
    [LotsaWaterView debugLog:@"Creating buffer manager"];
    _bufferManager = [[MTLBufferManager alloc] initWithDevice:_device];
    if (!_bufferManager) {
        [LotsaWaterView debugLog:@"Failed to create buffer manager"];
        return;
    }
    [LotsaWaterView debugLog:@"Buffer manager created successfully"];
    
    // 初始化计算管线管理器
    [LotsaWaterView debugLog:@"Creating compute pipeline manager"];
    _computeManager = [[MTLComputePipelineManager alloc] initWithDevice:_device];
    if (!_computeManager) {
        [LotsaWaterView debugLog:@"Failed to create compute pipeline manager"];
        return;
    }
    [LotsaWaterView debugLog:@"Compute pipeline manager created successfully"];
    
    [LotsaWaterView debugLog:@"Metal setup completed successfully"];
}

- (void)updateWaterSurface {
    // 计算当前时间的水波纹表面
    CalculateWaterSurfaceAtTime(&wet, _time);
    
    // 更新顶点缓冲区的高度数据
    if (_vertexBuffer) {
        simd_float3 *vertices = (simd_float3 *)[_vertexBuffer contents];
        for (int y = 0; y < wet.h; y++) {
            for (int x = 0; x < wet.w; x++) {
                int index = y * wet.w + x;
                vertices[index].z = wet.z[index] * _waterDepth;
            }
        }
    }
    
    // 更新法线缓冲区
    if (_normalBuffer) {
        simd_float3 *normals = (simd_float3 *)[_normalBuffer contents];
        for (int y = 0; y < wet.h; y++) {
            for (int x = 0; x < wet.w; x++) {
                int index = y * wet.w + x;
                normals[index] = simd_make_float3(wet.n[index].x, wet.n[index].y, wet.n[index].z);
            }
        }
    }
}

- (void)updateConstants {
    if (!_constantsBuffer) {
        return;
    }
    
    MetalConstants *constants = (MetalConstants *)[_constantsBuffer contents];
    
    // 设置投影和模型视图矩阵
    simd_float4x4 projection = matrix_orthographic_projection(-water_w, water_w, -water_h, water_h, -10.0f, 10.0f);
    simd_float4x4 modelView = matrix_identity_float4x4;
    modelView.columns[3].z = -5.0f; // 向后移动5个单位
    
    constants->modelViewProjectionMatrix = simd_mul(projection, modelView);
    constants->normalMatrix = matrix_upper_left_3x3(modelView);
    constants->time = _time;
    constants->waterDepth = _waterDepth;
    constants->waterSize = simd_make_float2(water_w, water_h);
    constants->textureSize = simd_make_float2(tex_w, tex_h);
    constants->imageFade = [[self defaults] floatForKey:@"imageFade"];
}

- (void)addRandomWaterDrop {
    // 添加随机水滴
    float x0 = RandomFloat() * wet.lx;
    float y0 = RandomFloat() * wet.ly;
    
    WaterState drip1, drip2;
    InitDripWaterState(&drip1, &wet, x0, y0, 0.14, -0.01);
    InitDripWaterState(&drip2, &wet, x0, y0, 0.07, 0.01);
    
    AddWaterStateAtTime(&wet, &drip1, _time);
    AddWaterStateAtTime(&wet, &drip2, _time);
    
    CleanupWaterState(&drip1);
    CleanupWaterState(&drip2);
}

// 辅助函数：创建正交投影矩阵
static simd_float4x4 matrix_orthographic_projection(float left, float right, float bottom, float top, float near, float far) {
    simd_float4x4 m = matrix_identity_float4x4;
    m.columns[0].x = 2.0f / (right - left);
    m.columns[1].y = 2.0f / (top - bottom);
    m.columns[2].z = -2.0f / (far - near);
    m.columns[3].x = -(right + left) / (right - left);
    m.columns[3].y = -(top + bottom) / (top - bottom);
    m.columns[3].z = -(far + near) / (far - near);
    return m;
}

// 辅助函数：提取3x3矩阵
static simd_float4x4 matrix_upper_left_3x3(simd_float4x4 m) {
    simd_float4x4 result = matrix_identity_float4x4;
    result.columns[0] = simd_make_float4(m.columns[0].x, m.columns[0].y, m.columns[0].z, 0.0f);
    result.columns[1] = simd_make_float4(m.columns[1].x, m.columns[1].y, m.columns[1].z, 0.0f);
    result.columns[2] = simd_make_float4(m.columns[2].x, m.columns[2].y, m.columns[2].z, 0.0f);
    return result;
}

- (void)updateMetalBuffers {
    if (!_heightBuffer || !_normalBuffer || !_vertexBuffer) {
        return;
    }
    
    // 更新高度缓冲区
    float *heights = (float *)[_heightBuffer contents];
    for (int y = 0; y < wet.h; y++) {
        for (int x = 0; x < wet.w; x++) {
            heights[y * wet.w + x] = wet.z[y * wet.w + x];
        }
    }
    
    // 更新法线缓冲区
    float *normals = (float *)[_normalBuffer contents];
    for (int y = 0; y < wet.h; y++) {
        for (int x = 0; x < wet.w; x++) {
            int idx = (y * wet.w + x) * 3;
            normals[idx] = wet.n[y * wet.w + x].x;
            normals[idx + 1] = wet.n[y * wet.w + x].y;
            normals[idx + 2] = wet.n[y * wet.w + x].z;
        }
    }
    
    // 更新顶点缓冲区
    float *vertices = (float *)[_vertexBuffer contents];
    for (int y = 0; y < wet.h; y++) {
        for (int x = 0; x < wet.w; x++) {
            int idx = (y * wet.w + x) * 3;
            vertices[idx] = x * wet.lx / (wet.w - 1);
            vertices[idx + 1] = y * wet.ly / (wet.h - 1);
            vertices[idx + 2] = wet.z[y * wet.w + x];
        }
    }
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

- (void)updateBackgroundTexture {
    if (!_backgroundTexture || !screenshot) {
        return;
    }
    
    // 获取图像数据
    NSBitmapImageRep *imageRep = screenshot;
    NSInteger width = [imageRep pixelsWide];
    NSInteger height = [imageRep pixelsHigh];
    NSInteger bytesPerRow = [imageRep bytesPerRow];
    NSInteger bitsPerPixel = [imageRep bitsPerPixel];
    
    // 创建纹理描述符
    MTLTextureDescriptor *textureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatBGRA8Unorm
                                                                                                width:width
                                                                                               height:height
                                                                                            mipmapped:NO];
    textureDescriptor.usage = MTLTextureUsageShaderRead | MTLTextureUsageShaderWrite;
    
    // 创建新纹理
    id<MTLTexture> newTexture = [_device newTextureWithDescriptor:textureDescriptor];
    
    // 复制图像数据到纹理
    [newTexture replaceRegion:MTLRegionMake2D(0, 0, width, height)
                 mipmapLevel:0
                   withBytes:[imageRep bitmapData]
                 bytesPerRow:bytesPerRow];
    
    // 更新背景纹理
    _backgroundTexture = newTexture;
}

- (void)updateReflectionTexture {
    if (!_reflectionTexture) {
        return;
    }
    
    // 加载反射图像
    NSImage *reflectionImage = [NSImage imageNamed:@"reflections"];
    if (!reflectionImage) {
        NSLog(@"Failed to load reflection image");
        return;
    }
    
    // 获取图像数据
    NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithData:[reflectionImage TIFFRepresentation]];
    NSInteger width = [imageRep pixelsWide];
    NSInteger height = [imageRep pixelsHigh];
    NSInteger bytesPerRow = [imageRep bytesPerRow];
    NSInteger bitsPerPixel = [imageRep bitsPerPixel];
    
    // 创建纹理描述符
    MTLTextureDescriptor *textureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatBGRA8Unorm
                                                                                                width:width
                                                                                               height:height
                                                                                            mipmapped:NO];
    textureDescriptor.usage = MTLTextureUsageShaderRead | MTLTextureUsageShaderWrite;
    
    // 创建新纹理
    id<MTLTexture> newTexture = [_device newTextureWithDescriptor:textureDescriptor];
    
    // 复制图像数据到纹理
    [newTexture replaceRegion:MTLRegionMake2D(0, 0, width, height)
                 mipmapLevel:0
                   withBytes:[imageRep bitmapData]
                 bytesPerRow:bytesPerRow];
    
    // 更新反射纹理
    _reflectionTexture = newTexture;
}

- (void)calculateWaterSurface {
    // 计算水波纹表面
    double dt = [self deltaTime];
    _time += dt / _timeStep;
    
    while (_time > _nextTime) {
        // 添加随机水滴
        float x0 = RandomFloat() * wet.lx;
        float y0 = RandomFloat() * wet.ly;
        
        WaterState drip1, drip2;
        InitDripWaterState(&drip1, &wet, x0, y0, 0.14, -0.01);
        InitDripWaterState(&drip2, &wet, x0, y0, 0.07, 0.01);
        
        AddWaterStateAtTime(&wet, &drip1, _nextTime);
        AddWaterStateAtTime(&wet, &drip2, _nextTime);
        
        _nextTime += (5 - raintime) * exp(-_nextTime / 10) + raintime;
    }
    
    // 计算当前时间的水波纹表面
    CalculateWaterSurfaceAtTime(&wet, _time);
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
