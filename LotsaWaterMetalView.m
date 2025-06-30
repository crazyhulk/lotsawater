#import "LotsaWaterMetalView.h"
#import "LotsaCore/MetalConverter.h"
#import "LotsaCore/Random.h"

@implementation LotsaWaterMetalView

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
        [self addSubview:metalView];
        
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
    if (!screenshot) {
        if ([self isPreview] || [[self defaults] integerForKey:@"imageSource"] == 0) {
            screenshot = [self grabScreenShot];
        }
    }
    [screenshot drawAtPoint:NSMakePoint(0, 0)];
}

- (void)startAnimation
{
    [self startAnimationWithDefaults:[self defaults]];
}

- (void)startAnimationWithDefaults:(ScreenSaverDefaults *)defaults
{
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
            backgroundTexture = [MetalConverter textureFromRep:screenshot device:device];
            tex_w = [screenshot pixelsWide];
            tex_h = [screenshot pixelsHigh];
            break;
        case 1: {
            NSBitmapImageRep *rep = [NSImageRep imageRepWithContentsOfFile:imagename];
            backgroundTexture = [MetalConverter textureFromRep:rep device:device];
            tex_w = [rep pixelsWide];
            tex_h = [rep pixelsHigh];
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
    
    vertices = malloc(wet.w * wet.h * sizeof(WaterVertex));
    
    [renderer setupBuffersWithWaterWidth:wet.w height:wet.h];
    [renderer setBackgroundTexture:backgroundTexture];
    [renderer setReflectionTexture:reflectionTexture];
    
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
    for (int y = 0; y < wet.h; y++) {
        for (int x = 0; x < wet.w; x++) {
            float u0 = (float)x / (float)(wet.w - 1);
            float v0 = (float)y / (float)(wet.h - 1);
            
            float n = 1.333f;
            float col_intensity = 3.0f;
            
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
            
            float c = -(wet.n[i].x + wet.n[i].y) * col_intensity + 1.0f;
            if (c < 0.0f) c = 0.0f;
            if (c > 1.0f) c = 1.0f;
            
            vertices[i].position = simd_make_float2(u0, v0);
            vertices[i].texCoord = simd_make_float2(u, v);
            vertices[i].color = simd_make_uchar4(
                (unsigned char)(c * fade * 255.0f),
                (unsigned char)(c * fade * 255.0f),
                (unsigned char)(c * fade * 255.0f),
                255
            );
            vertices[i].normal = simd_make_float3(wet.n[i].x, wet.n[i].y, wet.n[i].z);
            
            i++;
        }
    }
    
    [renderer updateVertexData:vertices count:wet.w * wet.h];
    
    WaterUniforms uniforms;
    uniforms.projectionMatrix = simd_matrix(
        simd_make_float4(1/screen_w, 0, 0, 0),
        simd_make_float4(0, 1/screen_h, 0, 0),
        simd_make_float4(0, 0, -0.001, 0),
        simd_make_float4(0, 0, 0, 1)
    );
    
    uniforms.modelViewMatrix = simd_matrix(
        simd_make_float4(2*water_w, 0, 0, 0),
        simd_make_float4(0, -2*water_h, 0, 0),
        simd_make_float4(0, 0, 10, 0),
        simd_make_float4(-water_w, water_h, -5, 1)
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

