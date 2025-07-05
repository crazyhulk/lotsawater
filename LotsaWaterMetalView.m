#import "LotsaWaterMetalView.h"
#import "LotsaCore/MetalConverter.h"
#import "LotsaCore/Random.h"

@implementation LotsaWaterMetalView

- (id)init
{
    return [self initWithFrame:NSMakeRect(0, 0, 800, 600) isPreview:NO];
}

- (id)initWithFrame:(NSRect)frame
{
    return [self initWithFrame:frame isPreview:NO];
}

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)preview
{
    if ((self = [super initWithFrame:frame isPreview:preview useGL:NO])) {
        screenshot = nil;
        
        device = MTLCreateSystemDefaultDevice();
        if (!device) {
            NSLog(@"Metal is not supported on this device");
            return nil;
        }
        
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
        backgroundTexture = nil;  // Clear cached texture too
        
        // Initialize water system directly here instead of waiting for startAnimation
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
}

- (void)startAnimation
{
    [self startAnimationWithDefaults:[self defaults]];
    [self setAnimationTimeInterval:1.0/60.0];
    [super startAnimation];
}

- (void)directInitializeWaterSystem
{
    ScreenSaverDefaults *defaults = [self defaults];
    
    if (!screenshot) {
        if ([self isPreview] || [defaults integerForKey:@"imageSource"] == 0) {
            screenshot = [self grabScreenShot];
        }
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
            screenshot = nil;
            screenshot = [self grabScreenShot];
            if (screenshot) {
                // Save original screenshot before Metal conversion for debugging comparison
                NSString *projectDir = @"/Users/xizi/Documents/workspace/macOS/lotsawater";
                NSString *originalPath = [projectDir stringByAppendingPathComponent:@"screen/metal_original_screenshot.jpg"];
                NSData *jpegData = [screenshot representationUsingType:NSBitmapImageFileTypeJPEG properties:@{
                    NSImageCompressionFactor: @0.8
                }];
                [jpegData writeToFile:originalPath atomically:YES];
                NSLog(@"🔍 Original screenshot saved: %@", originalPath);
                
                backgroundTexture = [MetalConverter textureFromRep:screenshot device:device];
                tex_w = [screenshot pixelsWide];
                tex_h = [screenshot pixelsHigh];
                
                // Save Metal background texture for debugging comparison
                NSString *debugPath = [projectDir stringByAppendingPathComponent:@"screen/metal_background.jpg"];
                [MetalConverter saveTexture:backgroundTexture toJPEGFile:debugPath];
                NSLog(@"🔍 Metal background texture saved for debugging: %@", debugPath);
            }
            break;
        case 1: {
            NSBitmapImageRep *rep = [NSImageRep imageRepWithContentsOfFile:imagename];
            if (rep) {
                backgroundTexture = [MetalConverter textureFromRep:rep device:device];
                tex_w = [rep pixelsWide];
                tex_h = [rep pixelsHigh];
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
    
    InitWater(&wet, gridsize, gridsize, max_p, max_p, 1, 1, 2 * water_w, 2 * water_h);
          
    // Verify water initialization
    if (wet.w <= 1 || wet.h <= 1 || !wet.z || !wet.n) {
        NSLog(@"❌ Water initialization FAILED: invalid dimensions or null pointers");
        return;
    }
    
    // Add some initial ripples to make the water surface visible from start
    WaterState initialDrip1, initialDrip2, initialDrip3;
    InitDripWaterState(&initialDrip1, &wet, wet.lx * 0.3f, wet.ly * 0.3f, 0.14f, -0.02f);
    InitDripWaterState(&initialDrip2, &wet, wet.lx * 0.7f, wet.ly * 0.6f, 0.10f, 0.015f);
    InitDripWaterState(&initialDrip3, &wet, wet.lx * 0.5f, wet.ly * 0.8f, 0.12f, -0.018f);
    AddWaterStateAtTime(&wet, &initialDrip1, 0);
    AddWaterStateAtTime(&wet, &initialDrip2, 0);
    AddWaterStateAtTime(&wet, &initialDrip3, 0);
    
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
    
    // Force initial frame generation
    [self animateOneFrame];
}

- (void)startAnimationWithDefaults:(ScreenSaverDefaults *)defaults
{
    // Water system is already initialized in directInitializeWaterSystem
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
    
    float fade = [[self defaults] floatForKey:@"imageFade"];
    if (![self isPreview] && t < 1) {
        fade = 1 - (1 - fade) * (t * t * (3 - 2 * t));
    }
    
    int i = 0;
    
    if (wet.w <= 1 || wet.h <= 1) {
        // This shouldn't happen, but if it does, we can't render properly
        return;
    }
    
    for (int y = 0; y < wet.h; y++) {
        for (int x = 0; x < wet.w; x++) {
            // Generate proper grid coordinates (0 to 1) - matches OpenGL version
            float u0 = (float)x / (float)(wet.w - 1);
            float v0 = (float)y / (float)(wet.h - 1);
            
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
            
            // Convert from normalized coordinates [0,1] to NDC [-1,1]
            // Match OpenGL transform: glTranslatef(-water_w,water_h,-5); glScalef(2*water_w,-2*water_h,10);
            float ndc_x = (u0 * 2.0f - 1.0f);
            float ndc_y = (v0 * 2.0f - 1.0f);  // Keep normal orientation for macOS desktop
            
            vertices[i].position = simd_make_float2(ndc_x, ndc_y);
            vertices[i].texCoord = simd_make_float2(u, v);
            
            // Match OpenGL vertex color calculation exactly for proper ripple visibility
            float col_intensity = 3.0f;  // Must match OpenGL col_intensity for identical ripple patterns
            float c = -(wet.n[i].x + wet.n[i].y) * col_intensity + 1.0f;
            if (c < 0.0f) c = 0.0f;
            if (c > 1.0f) c = 1.0f;
            float final_color = c * fade;
            vertices[i].color = simd_make_float4(final_color, final_color, final_color, 1.0f);
            vertices[i].normal = simd_make_float3(wet.n[i].x, wet.n[i].y, wet.n[i].z);
            
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
    static BOOL hasInitialized = NO;
    
    // Lazy initialization check - if constructor wasn't called properly
    if (!hasInitialized && !device) {
        // Initialize Metal device
        device = MTLCreateSystemDefaultDevice();
        if (!device) {
            return;
        }
        
        // Set up screen dimensions from the view
        screen_w = (int)view.drawableSize.width;
        screen_h = (int)view.drawableSize.height;
        
        // Create Metal renderer
        renderer = [[MetalRenderer alloc] initWithDevice:device];
        if (!renderer) {
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
    }
    
    // Check if we have valid data to render
    if (!vertices || !renderer.vertexBuffer) {
        // Clear to black if no data ready
        id<MTLCommandBuffer> commandBuffer = [renderer.commandQueue commandBuffer];
        MTLRenderPassDescriptor *renderPassDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
        renderPassDescriptor.colorAttachments[0].texture = view.currentDrawable.texture;
        renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0);
        renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
        
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        [renderEncoder endEncoding];
        
        [commandBuffer presentDrawable:view.currentDrawable];
        [commandBuffer commit];
        return;
    }
    
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

