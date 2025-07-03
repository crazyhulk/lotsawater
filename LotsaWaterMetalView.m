#import "LotsaWaterMetalView.h"
#import "LotsaCore/MetalConverter.h"
#import "LotsaCore/Random.h"

@implementation LotsaWaterMetalView

- (id)init
{
    NSLog(@"🎯 LotsaWaterMetalView init called");
    return [self initWithFrame:NSMakeRect(0, 0, 800, 600) isPreview:NO];
}

- (id)initWithFrame:(NSRect)frame
{
    NSLog(@"🎯 LotsaWaterMetalView initWithFrame(NSRect) called: frame=%.0fx%.0f", 
          frame.size.width, frame.size.height);
    return [self initWithFrame:frame isPreview:NO];
}

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)preview
{
    NSLog(@"🎯 LotsaWaterMetalView initWithFrame called: frame=%.0fx%.0f, preview=%d", 
          frame.size.width, frame.size.height, preview);
    
    if ((self = [super initWithFrame:frame isPreview:preview useGL:NO])) {
        NSLog(@"✅ LotsaWaterMetalView super initWithFrame succeeded");
        screenshot = nil;
        
        device = MTLCreateSystemDefaultDevice();
        if (!device) {
            NSLog(@"Metal is not supported on this device");
            return nil;
        }
        
        NSLog(@"🔥 LotsaWater Metal Version Initialized - Device: %@", device.name);
        
        metalView = [[MTKView alloc] initWithFrame:frame device:device];
        metalView.delegate = self;
        metalView.colorPixelFormat = MTLPixelFormatBGRA8Unorm;
        metalView.clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0);
        metalView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        
        // CRITICAL: Enable display and set frame rate
        metalView.paused = NO;
        metalView.enableSetNeedsDisplay = NO;
        metalView.preferredFramesPerSecond = 60;
        
        [self addSubview:metalView];
        
        NSLog(@"🖥️ MTKView configured: frame=%@, device=%@", 
              NSStringFromRect(frame), device.name);
        
        // Store screen dimensions for Metal rendering
        screen_w = (int)frame.size.width;
        screen_h = (int)frame.size.height;
        
        renderer = [[MetalRenderer alloc] initWithDevice:device];
        if (!renderer) {
            NSLog(@"Failed to create Metal renderer");
            return nil;
        }
        
        [self setAnimationTimeInterval:1/60.0];
        [self setConfigName:@"ConfigSheet"];
        [self setSaverName:@"LotsaWater" andDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
            @"2", @"detail",
            @"1", @"accuracy",
            @"0", @"slowMotion",
            @"0.5", @"rainFall",
            @"0.5", @"depth",
            @"0", @"imageSource",
            @"", @"imageFileName",
            @"1", @"imageFade",
            @"0", @"clockSize",
            nil]];
        
        screenshot = nil;
        
        // Initialize water system directly here instead of waiting for startAnimation
        NSLog(@"🏗️ Direct initialization in initWithFrame");
        [self directInitializeWaterSystem];
    }
    
    return self;
}

- (void)dealloc
{
    if (vertices) {
        free(vertices);
    }
    CleanupWater(&wet);
}

- (void)drawRect:(NSRect)rect
{
    // Metal view handles all rendering - no need to draw here
    // Just ensure screenshot is captured for texture usage
    if (!screenshot) {
        if ([self isPreview] || [[self defaults] integerForKey:@"imageSource"] == 0) {
            screenshot = [self grabScreenShot];
        }
    }
}

- (void)startAnimation
{
    NSLog(@"🚀 startAnimation called - delegating to startAnimationWithDefaults");
    [self startAnimationWithDefaults:[self defaults]];
    
    // Force animation to start
    NSLog(@"🚀 Forcing animation to start - setting interval and starting timer");
    [self setAnimationTimeInterval:1.0/60.0];
    [super startAnimation];
}

- (void)directInitializeWaterSystem
{
    NSLog(@"🌊 Direct water system initialization starting...");
    
    ScreenSaverDefaults *defaults = [self defaults];
    
    if (!screenshot) {
        if ([self isPreview] || [defaults integerForKey:@"imageSource"] == 0) {
            NSLog(@"📸 Attempting to grab screenshot...");
            screenshot = [self grabScreenShot];
            if (screenshot) {
                NSLog(@"✅ Screenshot captured: %ldx%ld", [screenshot pixelsWide], [screenshot pixelsHigh]);
            } else {
                NSLog(@"❌ Failed to capture screenshot");
            }
        }
    } else {
        NSLog(@"✅ Screenshot already exists: %ldx%ld", [screenshot pixelsWide], [screenshot pixelsHigh]);
    }
    
    SeedRandom(time(0));
    
    int gridsize, max_p;
    
    switch ([defaults integerForKey:@"detail"]) {
        default: gridsize = 24; break;
        case 1: gridsize = 32; break;
        case 2: gridsize = 48; break;
        case 3: gridsize = 64; break;
        case 4: gridsize = 96; break;
        case 5: gridsize = 128; break;
    }
    
    switch ([defaults integerForKey:@"accuracy"]) {
        default: max_p = 12; break;
        case 1: max_p = 16; break;
        case 2: max_p = 24; break;
        case 3: max_p = 32; break;
        case 4: max_p = 64; break;
    }
    
    double slow = [defaults floatForKey:@"slowMotion"];
    double rain = [defaults floatForKey:@"rainFall"];
    double d = [defaults floatForKey:@"depth"];
    
    t = 0;
    t_next = 1;
    t_div = (slow + 1) * (slow + 1);
    
    raintime = 4 * 0.9 * (rain - 1) * (rain - 1) + 0.1;
    waterdepth = 0.2 + d * d * 4 * 1.8;
    
    int srcid = [defaults integerForKey:@"imageSource"];
    NSString *imagename = [defaults stringForKey:@"imageFileName"];
    
    switch (srcid) {
        case 0:
            NSLog(@"📷 Using screenshot as background texture");
            if (screenshot) {
                NSLog(@"📷 Screenshot exists: %ldx%ld pixels, %ld BPP", 
                      [screenshot pixelsWide], [screenshot pixelsHigh], [screenshot bitsPerPixel]);
                backgroundTexture = [MetalConverter textureFromRep:screenshot device:device];
                tex_w = [screenshot pixelsWide];
                tex_h = [screenshot pixelsHigh];
                if (backgroundTexture) {
                    NSLog(@"✅ Background texture created successfully: %ldx%ld", 
                          backgroundTexture.width, backgroundTexture.height);
                } else {
                    NSLog(@"❌ Failed to create background texture from screenshot");
                }
            } else {
                NSLog(@"❌ Screenshot is nil!");
            }
            break;
        case 1: {
            NSLog(@"🖼️ Using image file as background texture: %@", imagename);
            NSBitmapImageRep *rep = [NSImageRep imageRepWithContentsOfFile:imagename];
            if (rep) {
                backgroundTexture = [MetalConverter textureFromRep:rep device:device];
                tex_w = [rep pixelsWide];
                tex_h = [rep pixelsHigh];
                NSLog(@"✅ Background texture created from file");
            } else {
                NSLog(@"❌ Failed to load image file: %@", imagename);
            }
        }
        break;
    }
    
    float screen_scale = 1.3 / sqrtf((float)(screen_w * screen_w + screen_h * screen_h));
    float screen_fw = (float)screen_w * screen_scale;
    float screen_fh = (float)screen_h * screen_scale;
    
    if (screen_fw / screen_fh < (float)tex_w / (float)tex_h) {
        water_w = screen_fw;
        water_h = screen_fw * (float)tex_h / (float)tex_w;
    } else {
        water_w = screen_fh * (float)tex_w / (float)tex_h;
        water_h = screen_fh;
    }
    
    reflectionTexture = [MetalConverter textureFromRep:[self imageRepFromBundle:@"reflections.png"] device:device];
    
    NSLog(@"🌊 Initializing water with: gridsize=%d, max_p=%d, water_w=%.2f, water_h=%.2f", 
          gridsize, max_p, water_w, water_h);
    
    InitWater(&wet, gridsize, gridsize, max_p, max_p, 1, 1, 2 * water_w, 2 * water_h);
    
    NSLog(@"💧 Water initialized: wet.w=%d, wet.h=%d, wet.lx=%.2f, wet.ly=%.2f", 
          wet.w, wet.h, wet.lx, wet.ly);
          
    // Verify water initialization
    if (wet.w <= 1 || wet.h <= 1 || !wet.z || !wet.n) {
        NSLog(@"❌ Water initialization FAILED: invalid dimensions or null pointers");
        NSLog(@"   wet.w=%d, wet.h=%d, wet.z=%p, wet.n=%p", wet.w, wet.h, wet.z, wet.n);
        return;
    } else {
        NSLog(@"✅ Water initialization successful: %dx%d grid with valid data arrays", wet.w, wet.h);
    }
    
    // Add some initial ripples to make the water surface visible from start
    WaterState initialDrip1, initialDrip2, initialDrip3;
    InitDripWaterState(&initialDrip1, &wet, wet.lx * 0.3f, wet.ly * 0.3f, 0.14f, -0.02f);
    InitDripWaterState(&initialDrip2, &wet, wet.lx * 0.7f, wet.ly * 0.6f, 0.10f, 0.015f);
    InitDripWaterState(&initialDrip3, &wet, wet.lx * 0.5f, wet.ly * 0.8f, 0.12f, -0.018f);
    AddWaterStateAtTime(&wet, &initialDrip1, 0);
    AddWaterStateAtTime(&wet, &initialDrip2, 0);
    AddWaterStateAtTime(&wet, &initialDrip3, 0);
    NSLog(@"💧 Added initial water ripples for startup visibility");
    
    // Clean up temporary drip states
    CleanupWaterState(&initialDrip1);
    CleanupWaterState(&initialDrip2);
    CleanupWaterState(&initialDrip3);
    
    vertices = malloc(wet.w * wet.h * sizeof(WaterVertex));
    if (!vertices) {
        NSLog(@"❌ Failed to allocate vertices array!");
        return;
    }
    
    [renderer setupBuffersWithWaterWidth:wet.w height:wet.h];
    [renderer setBackgroundTexture:backgroundTexture];
    [renderer setReflectionTexture:reflectionTexture];
    
    NSLog(@"🔧 Metal setup complete - forcing initial frame generation");
    
    // Force initial frame generation
    [self animateOneFrame];
    
    NSLog(@"✅ Initial frame generated - water system ready");
}

- (void)startAnimationWithDefaults:(ScreenSaverDefaults *)defaults
{
    NSLog(@"🚀 startAnimationWithDefaults called - system should already be initialized");
    // Water system is already initialized in directInitializeWaterSystem
    // This method is called by the base class but our system is already ready
    [super startAnimationWithDefaults:defaults];
}

- (void)stopAnimation
{
    CleanupWater(&wet);
    
    if (vertices) {
        free(vertices);
        vertices = NULL;
    }
    
    [super stopAnimation];
}

- (void)animateOneFrame
{
    static int animationFrameCount = 0;
    animationFrameCount++;
    
    if (animationFrameCount % 60 == 0) {
        NSLog(@"🔄 animateOneFrame called #%d - dt calculation", animationFrameCount);
    }
    
    double dt = [self deltaTime];
    t += dt / t_div;
    
    while (t > t_next) {
        float x0 = RandomFloat() * wet.lx;
        float y0 = RandomFloat() * wet.ly;
        
        WaterState drip1, drip2;
        InitDripWaterState(&drip1, &wet, x0, y0, 0.14, -0.01);
        InitDripWaterState(&drip2, &wet, x0, y0, 0.07, 0.01);
        AddWaterStateAtTime(&wet, &drip1, t_next);
        AddWaterStateAtTime(&wet, &drip2, t_next);
        
        t_next += (5 - raintime) * exp(-t_next / 10) + raintime;
    }
    
    CalculateWaterSurfaceAtTime(&wet, t);
    
    // Debug water surface calculation
    if (wet.z && wet.n) {
        NSLog(@"🌊 Water surface: z[0]=%.4f, n[0]=(%.3f,%.3f,%.3f)", 
              wet.z[0], wet.n[0].x, wet.n[0].y, wet.n[0].z);
    } else {
        NSLog(@"❌ Water surface arrays are NULL! z=%p, n=%p", wet.z, wet.n);
    }
    
    float fade = [[self defaults] floatForKey:@"imageFade"];
    if (![self isPreview] && t < 1) {
        fade = 1 - (1 - fade) * (t * t * (3 - 2 * t));
    }
    
    int i = 0;
    NSLog(@"🎯 Generating vertices for %dx%d grid", wet.w, wet.h);
    
    if (wet.w <= 1 || wet.h <= 1) {
        NSLog(@"❌ Invalid water grid size: %dx%d - forcing minimum 24x24", wet.w, wet.h);
        // This shouldn't happen, but if it does, we can't render properly
        return;
    }
    
    for (int y = 0; y < wet.h; y++) {
        for (int x = 0; x < wet.w; x++) {
            // Generate proper grid coordinates (0 to 1) - matches OpenGL version
            float u0 = (float)x / (float)(wet.w - 1);
            float v0 = (float)y / (float)(wet.h - 1);
            
            // Debug first few and last few vertices
            if (i < 3 || i >= (wet.w * wet.h - 3)) {
                NSLog(@"🔍 Vertex[%d]: x=%d, y=%d, u0=%.4f, v0=%.4f (wet.w=%d, wet.h=%d)", 
                      i, x, y, u0, v0, wet.w, wet.h);
            }
            
            float n = 1.333f;
            
            float d = wet.z[i] + waterdepth;
            float n_abs2 = vec3sq(wet.n[i]);
            float cos_a = wet.n[i].z / sqrtf(n_abs2);
            float sin_a = sqrtf(1.0f - cos_a * cos_a);
            float sin_b = sin_a / n;
            float cos_b = sqrtf(1.0f - sin_b * sin_b);
            float sin_ab = sin_a * cos_b - cos_a * sin_b;
            float dx = wet.n[i].x;
            float dy = wet.n[i].y;
            float r = sqrtf(dx * dx + dy * dy);
            
            float u, v;
            if (r > 0.000001f) {
                u = u0 - dx / r * sin_ab * d / water_w;
                v = v0 - dy / r * sin_ab * d / water_h;
            } else {
                u = u0;
                v = v0;
            }
            
            // Debug: log detailed calculations for first vertex
            if (i == 0) {
                NSLog(@"🔬 Vertex[0] calc: wet.z=%.4f, waterdepth=%.4f, d=%.4f", wet.z[i], waterdepth, d);
                NSLog(@"🔬 normal=(%.4f,%.4f,%.4f), u0=%.4f, v0=%.4f, u=%.4f, v=%.4f, fade=%.4f", 
                      wet.n[i].x, wet.n[i].y, wet.n[i].z, u0, v0, u, v, fade);
                NSLog(@"🖼️ tex_w=%d, tex_h=%d, water_w=%.2f, water_h=%.2f", tex_w, tex_h, water_w, water_h);
            }
            
            // Convert from normalized coordinates [0,1] to NDC [-1,1]
            // Match OpenGL transform: glTranslatef(-water_w,water_h,-5); glScalef(2*water_w,-2*water_h,10);
            float ndc_x = (u0 * 2.0f - 1.0f);
            float ndc_y = (v0 * 2.0f - 1.0f);  // Keep normal orientation for macOS desktop
            
            vertices[i].position = simd_make_float2(ndc_x, ndc_y);
            vertices[i].texCoord = simd_make_float2(u, v);
            
            // Use pure white color to preserve original wallpaper colors
            vertices[i].color = simd_make_float4(1.0f, 1.0f, 1.0f, 1.0f);
            vertices[i].normal = simd_make_float3(wet.n[i].x, wet.n[i].y, wet.n[i].z);
            
            // Debug: Log first vertex data every frame
            if (i == 0) {
                NSLog(@"🔍 Generated vertex[0]: pos(%.3f,%.3f) tex(%.3f,%.3f) color(%.3f,%.3f,%.3f,%.3f)", 
                      vertices[i].position.x, vertices[i].position.y,
                      vertices[i].texCoord.x, vertices[i].texCoord.y,
                      vertices[i].color.x, vertices[i].color.y, vertices[i].color.z, vertices[i].color.w);
            }
            
            i++;
        }
    }
    
    [renderer updateVertexData:vertices count:wet.w * wet.h];
    
    WaterUniforms uniforms;
    // Identity matrices since vertex positions are already in NDC
    uniforms.projectionMatrix = simd_matrix(
        simd_make_float4(1.0f, 0, 0, 0),
        simd_make_float4(0, 1.0f, 0, 0),
        simd_make_float4(0, 0, 1.0f, 0),
        simd_make_float4(0, 0, 0, 1)
    );
    
    uniforms.modelViewMatrix = simd_matrix(
        simd_make_float4(1.0f, 0, 0, 0),
        simd_make_float4(0, 1.0f, 0, 0),
        simd_make_float4(0, 0, 1.0f, 0),
        simd_make_float4(0, 0, 0, 1)
    );
    
    uniforms.waterSize = simd_make_float2(water_w, water_h);
    uniforms.fade = fade;
    
    [renderer updateUniforms:uniforms];
    
    metalView.needsDisplay = YES;
}

#pragma mark - MTKViewDelegate

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size
{
    // Size changes are handled by the renderer
}

- (void)drawInMTKView:(MTKView *)view
{
    static int frameCount = 0;
    static BOOL hasInitialized = NO;
    frameCount++;
    
    // Lazy initialization check - if constructor wasn't called properly
    if (!hasInitialized && !device) {
        NSLog(@"🚨 LAZY INITIALIZATION: Constructor not called, initializing in drawInMTKView");
        
        // Initialize Metal device
        device = MTLCreateSystemDefaultDevice();
        if (!device) {
            NSLog(@"❌ Failed to create Metal device in lazy initialization");
            return;
        }
        
        // Set up screen dimensions from the view
        screen_w = (int)view.drawableSize.width;
        screen_h = (int)view.drawableSize.height;
        
        // Create Metal renderer
        renderer = [[MetalRenderer alloc] initWithDevice:device];
        if (!renderer) {
            NSLog(@"❌ Failed to create Metal renderer in lazy initialization");
            return;
        }
        
        // Set up screen saver defaults
        [self setAnimationTimeInterval:1/60.0];
        [self setConfigName:@"ConfigSheet"];
        [self setSaverName:@"LotsaWater" andDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
            @"2", @"detail",
            @"1", @"accuracy",
            @"0", @"slowMotion",
            @"0.5", @"rainFall",
            @"0.5", @"depth",
            @"0", @"imageSource",
            @"", @"imageFileName",
            @"1", @"imageFade",
            @"0", @"clockSize",
            nil]];
        
        // Initialize water system
        [self directInitializeWaterSystem];
        hasInitialized = YES;
        
        NSLog(@"✅ Lazy initialization completed successfully");
    }
    
    if (frameCount % 60 == 0) { // 每秒日志一次 (60fps)
        NSLog(@"⚡ Metal Rendering Frame #%d", frameCount);
        NSLog(@"📊 Debug Status: device=%@, renderer=%@, vertices=%p", 
              device ? @"✓" : @"✗", renderer ? @"✓" : @"✗", vertices);
        NSLog(@"💧 Water Status: wet.w=%d, wet.h=%d, wet.z=%p, wet.n=%p", 
              wet.w, wet.h, wet.z, wet.n);
        NSLog(@"🎯 View drawable size: %.0fx%.0f", view.drawableSize.width, view.drawableSize.height);
        NSLog(@"🖼️ Current drawable: %@", view.currentDrawable);
    }
    
    // Check if we have valid data to render
    if (!vertices || !renderer.vertexBuffer) {
        if (frameCount % 60 == 0) { // Log once per second
            NSLog(@"⚠️ No render data - clearing to magenta for debugging");
            NSLog(@"🔍 vertices=%p, renderer.vertexBuffer=%@", vertices, renderer.vertexBuffer);
        }
        // Clear to magenta to confirm we can at least clear the screen
        id<MTLCommandBuffer> commandBuffer = [renderer.commandQueue commandBuffer];
        MTLRenderPassDescriptor *renderPassDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
        renderPassDescriptor.colorAttachments[0].texture = view.currentDrawable.texture;
        renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 0.0, 1.0, 1.0); // Bright magenta
        renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
        
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        [renderEncoder endEncoding];
        
        [commandBuffer presentDrawable:view.currentDrawable];
        [commandBuffer commit];
        return;
    }
    
    NSLog(@"🎨 Executing full Metal render pipeline");
    id<MTLCommandBuffer> commandBuffer = [renderer.commandQueue commandBuffer];
    
    [renderer renderToTexture:view.currentDrawable.texture withCommandBuffer:commandBuffer];
    
    [commandBuffer presentDrawable:view.currentDrawable];
    [commandBuffer commit];
}

#pragma mark - Configuration

- (void)updateConfigWindow:(NSWindow *)window usingDefaults:(ScreenSaverDefaults *)defaults
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

- (void)updateDefaults:(ScreenSaverDefaults *)defaults usingConfigWindow:(NSWindow *)window
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

- (IBAction)pickImageSource:(id)sender
{
    switch ([imgsrc indexOfSelectedItem]) {
        case 0: {
            NSImage *img = [[NSImage alloc] init];
            [img addRepresentation:screenshot];
            [imageview setImage:img];
        }
        break;
        case 1: {
            NSImage *img = [[NSImage alloc] initWithContentsOfFile:[imageview fileName]];
            [imageview setImage:img];
        }
        break;
    }
}

- (IBAction)dropImage:(id)sender
{
    [imgsrc selectItemAtIndex:1];
    [self pickImageSource:imgsrc];
}

+ (BOOL)performGammaFade
{
    return NO;
}

@end

