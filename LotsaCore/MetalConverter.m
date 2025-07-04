#import "MetalConverter.h"

@implementation MetalConverter

+ (id<MTLTexture>)texture2DFromRep:(NSBitmapImageRep *)bm device:(id<MTLDevice>)device
{
    return [self textureFromRep:bm device:device];
}

+ (id<MTLTexture>)textureFromRep:(NSBitmapImageRep *)bm device:(id<MTLDevice>)device
{
    if ([bm isPlanar]) return nil;
    
    // Debug: Dump input bitmap
    NSString *inputFilename = [NSString stringWithFormat:@"debug_02_input_bitmap_%ldx%ld_%ldBPP.jpg", 
                              [bm pixelsWide], [bm pixelsHigh], [bm bitsPerPixel]];
    [self dumpBitmapToFile:bm filename:inputFilename];
    
    // CRITICAL: Force color space conversion to NSDeviceRGBColorSpace
    // This ensures proper color representation before Metal processing
    NSBitmapImageRep *convertedBitmap = bm;
    NSString *currentColorSpace = [bm colorSpaceName];
    NSLog(@"🎨 Original bitmap color space: %@", currentColorSpace);
    
    if (![currentColorSpace isEqualToString:NSDeviceRGBColorSpace]) {
        NSLog(@"🔧 Converting bitmap from %@ to NSDeviceRGBColorSpace", currentColorSpace);
        NSColorSpace *deviceRGBColorSpace = [NSColorSpace deviceRGBColorSpace];
        convertedBitmap = [bm bitmapImageRepByConvertingToColorSpace:deviceRGBColorSpace
                                                       renderingIntent:NSColorRenderingIntentDefault];
        if (convertedBitmap) {
            NSLog(@"✅ Successfully converted to NSDeviceRGBColorSpace");
            // Debug: Dump converted bitmap
            NSString *convertedFilename = [NSString stringWithFormat:@"debug_02b_converted_colorspace_%ldx%ld_%ldBPP.jpg", 
                                          [convertedBitmap pixelsWide], [convertedBitmap pixelsHigh], [convertedBitmap bitsPerPixel]];
            [self dumpBitmapToFile:convertedBitmap filename:convertedFilename];
        } else {
            NSLog(@"⚠️ Failed to convert color space, using original bitmap");
            convertedBitmap = bm;
        }
    } else {
        NSLog(@"✅ Bitmap already in NSDeviceRGBColorSpace");
    }
    
    MTLTextureDescriptor *descriptor = [self descriptorForBitmapImageRep:convertedBitmap];
    if (!descriptor) return nil;
    
    id<MTLTexture> texture = [device newTextureWithDescriptor:descriptor];
    if (!texture) return nil;
    
    [self uploadRep:convertedBitmap toTexture:texture];
    
    // Debug: Dump output texture
    NSString *outputFilename = [NSString stringWithFormat:@"debug_03_output_texture_%ldx%ld.jpg", 
                               texture.width, texture.height];
    [self dumpTextureToFile:texture filename:outputFilename];
    
    return texture;
}

+ (id<MTLTexture>)uncopiedTextureFromRep:(NSBitmapImageRep *)bm device:(id<MTLDevice>)device
{
    return [self textureFromRep:bm device:device];
}

+ (MTLTextureDescriptor *)descriptorForBitmapImageRep:(NSBitmapImageRep *)bm
{
    MTLPixelFormat pixelFormat;
    
    NSBitmapFormat format = [self bitmapFormatFor:bm];
    NSLog(@"🔍 Bitmap format analysis: bitsPerPixel=%ld, hasAlpha=%d, format=0x%lx, bytesPerRow=%ld, pixelsWide=%ld, pixelsHigh=%ld", 
          [bm bitsPerPixel], [bm hasAlpha], format, [bm bytesPerRow], [bm pixelsWide], [bm pixelsHigh]);
    
    switch ([bm bitsPerPixel]) {
        case 8:
            pixelFormat = MTLPixelFormatR8Unorm;
            NSLog(@"🎨 Using R8Unorm for 8-bit");
            break;
        case 24:
            // 24-bit RGB needs conversion to 32-bit RGBA - test RGBA format
            pixelFormat = MTLPixelFormatRGBA8Unorm;
            NSLog(@"🔧 24-bit RGB will be converted to RGBA8Unorm (linear)");
            break;
        case 32:
            // Use RGBA format to test if channel order is the issue
            pixelFormat = MTLPixelFormatRGBA8Unorm;
            NSLog(@"🔧 32-bit data using RGBA8Unorm (linear) (was: %s)", 
                  (format & NSAlphaFirstBitmapFormat) ? "alpha-first" : "alpha-last");
            break;
        default:
            NSLog(@"❌ Unsupported bitsPerPixel: %ld", [bm bitsPerPixel]);
            return nil;
    }
    
    MTLTextureDescriptor *descriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:pixelFormat
                                                                                          width:[bm pixelsWide]
                                                                                         height:[bm pixelsHigh]
                                                                                      mipmapped:NO];
    descriptor.usage = MTLTextureUsageShaderRead;
    descriptor.storageMode = MTLStorageModeShared;
    
    return descriptor;
}

+ (void)uploadRep:(NSBitmapImageRep *)bm toTexture:(id<MTLTexture>)texture
{
    NSUInteger bitsPerPixel = [bm bitsPerPixel];
    NSUInteger bytesPerRow = [bm bytesPerRow];
    void *pixels = [bm bitmapData];
    
    MTLRegion region = MTLRegionMake2D(0, 0, [bm pixelsWide], [bm pixelsHigh]);
    
    if (bitsPerPixel == 24) {
        // Convert 24-bit RGB to 32-bit RGBA
        NSLog(@"🔧 Converting 24-bit RGB to 32-bit RGBA");
        [self convertRGB24ToRGBA32:pixels 
                             width:[bm pixelsWide] 
                            height:[bm pixelsHigh] 
                       bytesPerRow:bytesPerRow 
                         toTexture:texture];
    } else if (bitsPerPixel == 32) {
        // Convert 32-bit data to RGBA format to ensure consistent channel ordering
        NSBitmapFormat format = [self bitmapFormatFor:bm];
        NSLog(@"🔧 Converting 32-bit data to RGBA (format: %s)", 
              (format & NSAlphaFirstBitmapFormat) ? "alpha-first" : "alpha-last");
        [self convertRGBA32ToRGBA32:pixels 
                              width:[bm pixelsWide] 
                             height:[bm pixelsHigh] 
                        bytesPerRow:bytesPerRow 
                          toTexture:texture];
    } else {
        // 8-bit or other formats - upload directly
        NSLog(@"🔧 Uploading %ld-bit data directly", bitsPerPixel);
        [texture replaceRegion:region
                   mipmapLevel:0
                     withBytes:pixels
                   bytesPerRow:bytesPerRow];
    }
}

+ (NSBitmapFormat)bitmapFormatFor:(NSBitmapImageRep *)bm
{
    if ([bm respondsToSelector:@selector(bitmapFormat)]) {
        return [bm bitmapFormat];
    }
    return 0;
}

+ (void)convertRGB24ToBGRA32:(void *)sourcePixels 
                       width:(NSUInteger)width 
                      height:(NSUInteger)height 
                 bytesPerRow:(NSUInteger)sourceBytesPerRow 
                   toTexture:(id<MTLTexture>)texture
{
    // Allocate buffer for BGRA32 data
    NSUInteger targetBytesPerRow = width * 4;
    NSUInteger totalBytes = targetBytesPerRow * height;
    uint8_t *bgraPixels = malloc(totalBytes);
    
    uint8_t *src = (uint8_t *)sourcePixels;
    uint8_t *dst = bgraPixels;
    
    NSLog(@"🔧 Converting RGB24 to BGRA32: %ldx%ld", width, height);
    
    for (NSUInteger y = 0; y < height; y++) {
        uint8_t *srcRow = src + (y * sourceBytesPerRow);
        uint8_t *dstRow = dst + (y * targetBytesPerRow);
        
        for (NSUInteger x = 0; x < width; x++) {
            uint8_t r = srcRow[x * 3 + 0];
            uint8_t g = srcRow[x * 3 + 1];
            uint8_t b = srcRow[x * 3 + 2];
            
            // Convert RGB to BGRA
            dstRow[x * 4 + 0] = b;  // Blue
            dstRow[x * 4 + 1] = g;  // Green
            dstRow[x * 4 + 2] = r;  // Red
            dstRow[x * 4 + 3] = 255; // Alpha
        }
    }
    
    // Create a debug bitmap to see the converted data
    NSBitmapImageRep *debugBitmap = [[NSBitmapImageRep alloc] 
                                    initWithBitmapDataPlanes:&bgraPixels
                                                  pixelsWide:width
                                                  pixelsHigh:height
                                               bitsPerSample:8
                                             samplesPerPixel:4
                                                    hasAlpha:YES
                                                    isPlanar:NO
                                              colorSpaceName:NSDeviceRGBColorSpace
                                                bitmapFormat:NSBitmapFormatAlphaFirst
                                                 bytesPerRow:targetBytesPerRow
                                                bitsPerPixel:32];
    
    if (debugBitmap) {
        NSString *filename = [NSString stringWithFormat:@"debug_04_converted_RGB24_to_BGRA32_%ldx%ld.jpg", width, height];
        [self dumpBitmapToFile:debugBitmap filename:filename];
    }
    
    MTLRegion region = MTLRegionMake2D(0, 0, width, height);
    [texture replaceRegion:region
               mipmapLevel:0
                 withBytes:bgraPixels
               bytesPerRow:targetBytesPerRow];
    
    free(bgraPixels);
    NSLog(@"✅ Converted %ldx%ld RGB24 to BGRA32", width, height);
}

+ (void)convertRGB24ToRGBA32:(void *)sourcePixels 
                       width:(NSUInteger)width 
                      height:(NSUInteger)height 
                 bytesPerRow:(NSUInteger)sourceBytesPerRow 
                   toTexture:(id<MTLTexture>)texture
{
    // Allocate buffer for RGBA32 data
    NSUInteger targetBytesPerRow = width * 4;
    uint8_t *rgbaPixels = malloc(targetBytesPerRow * height);
    
    uint8_t *src = (uint8_t *)sourcePixels;
    
    NSLog(@"🔧 Converting RGB24 to RGBA32: %ldx%ld", width, height);
    
    for (NSUInteger y = 0; y < height; y++) {
        uint8_t *srcRow = src + (y * sourceBytesPerRow);
        uint8_t *dstRow = rgbaPixels + (y * targetBytesPerRow);
        
        for (NSUInteger x = 0; x < width; x++) {
            // Keep RGB order, just add alpha
            dstRow[x * 4 + 0] = srcRow[x * 3 + 0]; // R
            dstRow[x * 4 + 1] = srcRow[x * 3 + 1]; // G
            dstRow[x * 4 + 2] = srcRow[x * 3 + 2]; // B
            dstRow[x * 4 + 3] = 255; // Alpha
        }
    }
    
    // Create debug bitmap to see the converted data
    NSBitmapImageRep *debugBitmap = [[NSBitmapImageRep alloc] 
                                    initWithBitmapDataPlanes:&rgbaPixels
                                                  pixelsWide:width
                                                  pixelsHigh:height
                                               bitsPerSample:8
                                             samplesPerPixel:4
                                                    hasAlpha:YES
                                                    isPlanar:NO
                                              colorSpaceName:NSDeviceRGBColorSpace
                                                bitmapFormat:0  // Regular RGBA order
                                                 bytesPerRow:targetBytesPerRow
                                                bitsPerPixel:32];
    
    if (debugBitmap) {
        NSString *filename = [NSString stringWithFormat:@"debug_04_converted_RGB24_to_RGBA32_%ldx%ld.jpg", width, height];
        [self dumpBitmapToFile:debugBitmap filename:filename];
    }
    
    MTLRegion region = MTLRegionMake2D(0, 0, width, height);
    [texture replaceRegion:region
               mipmapLevel:0
                 withBytes:rgbaPixels
               bytesPerRow:targetBytesPerRow];
    
    free(rgbaPixels);
    NSLog(@"✅ Converted %ldx%ld RGB24 to RGBA32", width, height);
}

+ (void)convertRGBA32ToRGBA32:(void *)sourcePixels 
                        width:(NSUInteger)width 
                       height:(NSUInteger)height 
                  bytesPerRow:(NSUInteger)bytesPerRow 
                    toTexture:(id<MTLTexture>)texture
{
    // This function handles conversion from different 32-bit formats to standard RGBA
    NSUInteger totalBytes = bytesPerRow * height;
    uint8_t *rgbaPixels = malloc(totalBytes);
    
    uint8_t *src = (uint8_t *)sourcePixels;
    uint8_t *dst = rgbaPixels;
    
    NSLog(@"🔧 Converting 32-bit data to RGBA32: %ldx%ld", width, height);
    
    for (NSUInteger y = 0; y < height; y++) {
        uint8_t *srcRow = src + (y * bytesPerRow);
        uint8_t *dstRow = dst + (y * bytesPerRow);
        
        for (NSUInteger x = 0; x < width; x++) {
            // Assume source is ARGB (alpha-first) and convert to RGBA
            uint8_t a = srcRow[x * 4 + 0];  // Alpha (first)
            uint8_t r = srcRow[x * 4 + 1];  // Red  
            uint8_t g = srcRow[x * 4 + 2];  // Green
            uint8_t b = srcRow[x * 4 + 3];  // Blue
            
            // Output as RGBA
            dstRow[x * 4 + 0] = r;  // Red
            dstRow[x * 4 + 1] = g;  // Green  
            dstRow[x * 4 + 2] = b;  // Blue
            dstRow[x * 4 + 3] = a;  // Alpha
        }
    }
    
    // Create a debug bitmap to see the converted data
    NSBitmapImageRep *debugBitmap = [[NSBitmapImageRep alloc] 
                                    initWithBitmapDataPlanes:&rgbaPixels
                                                  pixelsWide:width
                                                  pixelsHigh:height
                                               bitsPerSample:8
                                             samplesPerPixel:4
                                                    hasAlpha:YES
                                                    isPlanar:NO
                                              colorSpaceName:NSDeviceRGBColorSpace
                                                bitmapFormat:0  // Standard RGBA
                                                 bytesPerRow:bytesPerRow
                                                bitsPerPixel:32];
    
    if (debugBitmap) {
        NSString *filename = [NSString stringWithFormat:@"debug_05_converted_32bit_to_RGBA32_%ldx%ld.jpg", width, height];
        [self dumpBitmapToFile:debugBitmap filename:filename];
    }
    
    MTLRegion region = MTLRegionMake2D(0, 0, width, height);
    [texture replaceRegion:region
               mipmapLevel:0
                 withBytes:rgbaPixels
               bytesPerRow:bytesPerRow];
    
    free(rgbaPixels);
    NSLog(@"✅ Converted %ldx%ld 32-bit data to RGBA32", width, height);
}

+ (void)convertRGBA32ToBGRA32:(void *)sourcePixels 
                        width:(NSUInteger)width 
                       height:(NSUInteger)height 
                  bytesPerRow:(NSUInteger)bytesPerRow 
                    toTexture:(id<MTLTexture>)texture
{
    // Allocate buffer for BGRA32 data
    NSUInteger totalBytes = bytesPerRow * height;
    uint8_t *bgraPixels = malloc(totalBytes);
    
    uint8_t *src = (uint8_t *)sourcePixels;
    uint8_t *dst = bgraPixels;
    
    NSLog(@"🔧 Converting RGBA32 to BGRA32: %ldx%ld", width, height);
    
    for (NSUInteger y = 0; y < height; y++) {
        uint8_t *srcRow = src + (y * bytesPerRow);
        uint8_t *dstRow = dst + (y * bytesPerRow);
        
        for (NSUInteger x = 0; x < width; x++) {
            uint8_t r = srcRow[x * 4 + 0];
            uint8_t g = srcRow[x * 4 + 1];
            uint8_t b = srcRow[x * 4 + 2];
            uint8_t a = srcRow[x * 4 + 3];
            
            // Convert RGBA to BGRA
            dstRow[x * 4 + 0] = b;  // Blue
            dstRow[x * 4 + 1] = g;  // Green
            dstRow[x * 4 + 2] = r;  // Red
            dstRow[x * 4 + 3] = a;  // Alpha
        }
    }
    
    // Create a debug bitmap to see the converted data
    NSBitmapImageRep *debugBitmap = [[NSBitmapImageRep alloc] 
                                    initWithBitmapDataPlanes:&bgraPixels
                                                  pixelsWide:width
                                                  pixelsHigh:height
                                               bitsPerSample:8
                                             samplesPerPixel:4
                                                    hasAlpha:YES
                                                    isPlanar:NO
                                              colorSpaceName:NSDeviceRGBColorSpace
                                                bitmapFormat:NSBitmapFormatAlphaFirst
                                                 bytesPerRow:bytesPerRow
                                                bitsPerPixel:32];
    
    if (debugBitmap) {
        NSString *filename = [NSString stringWithFormat:@"debug_05_converted_RGBA32_to_BGRA32_%ldx%ld.jpg", width, height];
        [self dumpBitmapToFile:debugBitmap filename:filename];
    }
    
    MTLRegion region = MTLRegionMake2D(0, 0, width, height);
    [texture replaceRegion:region
               mipmapLevel:0
                 withBytes:bgraPixels
               bytesPerRow:bytesPerRow];
    
    free(bgraPixels);
    NSLog(@"✅ Converted %ldx%ld RGBA32 to BGRA32", width, height);
}

#pragma mark - Debug Dump Functions

+ (void)dumpBitmapToFile:(NSBitmapImageRep *)bitmap filename:(NSString *)filename
{
    if (!bitmap) {
        NSLog(@"❌ Cannot dump nil bitmap");
        return;
    }
    
    NSString *screenDir = @"/Users/xizi/Documents/workspace/macOS/lotsawater/screen";
    NSString *fullPath = [screenDir stringByAppendingPathComponent:filename];
    
    NSLog(@"🔍 Dumping bitmap: %ldx%ld, %ld BPP, %ld BPR to %@", 
          [bitmap pixelsWide], [bitmap pixelsHigh], [bitmap bitsPerPixel], [bitmap bytesPerRow], fullPath);
    
    NSData *imageData = [bitmap representationUsingType:NSBitmapImageFileTypeJPEG properties:@{NSImageCompressionFactor: @0.9}];
    
    if (imageData) {
        [imageData writeToFile:fullPath atomically:YES];
        NSLog(@"✅ Bitmap dumped to %@", fullPath);
    } else {
        NSLog(@"❌ Failed to create image data for bitmap dump");
    }
}

+ (void)dumpTextureToFile:(id<MTLTexture>)texture filename:(NSString *)filename
{
    if (!texture) {
        NSLog(@"❌ Cannot dump nil texture");
        return;
    }
    
    NSBitmapImageRep *bitmap = [self createBitmapFromTexture:texture];
    if (bitmap) {
        [self dumpBitmapToFile:bitmap filename:filename];
    } else {
        NSLog(@"❌ Failed to create bitmap from texture");
    }
}

+ (NSBitmapImageRep *)createBitmapFromTexture:(id<MTLTexture>)texture
{
    if (!texture) {
        return nil;
    }
    
    NSUInteger width = texture.width;
    NSUInteger height = texture.height;
    NSUInteger bytesPerRow = width * 4; // BGRA
    NSUInteger totalBytes = bytesPerRow * height;
    
    uint8_t *textureData = malloc(totalBytes);
    if (!textureData) {
        NSLog(@"❌ Failed to allocate memory for texture readback");
        return nil;
    }
    
    // Read texture data
    MTLRegion region = MTLRegionMake2D(0, 0, width, height);
    [texture getBytes:textureData 
          bytesPerRow:bytesPerRow 
           fromRegion:region 
          mipmapLevel:0];
    
    NSLog(@"🔍 Read texture data: %ldx%ld, %ld bytes", width, height, totalBytes);
    
    // Create bitmap from texture data
    NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] 
                               initWithBitmapDataPlanes:&textureData
                                             pixelsWide:width
                                             pixelsHigh:height
                                          bitsPerSample:8
                                        samplesPerPixel:4
                                               hasAlpha:YES
                                               isPlanar:NO
                                         colorSpaceName:NSDeviceRGBColorSpace
                                           bitmapFormat:NSBitmapFormatAlphaFirst
                                            bytesPerRow:bytesPerRow
                                           bitsPerPixel:32];
    
    if (!bitmap) {
        NSLog(@"❌ Failed to create NSBitmapImageRep from texture data");
        free(textureData);
        return nil;
    }
    
    NSLog(@"✅ Created bitmap from texture: %ldx%ld", [bitmap pixelsWide], [bitmap pixelsHigh]);
    return bitmap;
}

@end