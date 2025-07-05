#import "MetalConverter.h"

@implementation MetalConverter

+ (id<MTLTexture>)texture2DFromRep:(NSBitmapImageRep *)bm device:(id<MTLDevice>)device
{
    return [self textureFromRep:bm device:device];
}

+ (id<MTLTexture>)textureFromRep:(NSBitmapImageRep *)bm device:(id<MTLDevice>)device
{
    if ([bm isPlanar]) return nil;
    
    // CRITICAL: Force color space conversion to NSDeviceRGBColorSpace
    // This ensures proper color representation before Metal processing
    NSBitmapImageRep *convertedBitmap = bm;
    NSString *currentColorSpace = [bm colorSpaceName];
    
    if (![currentColorSpace isEqualToString:NSDeviceRGBColorSpace]) {
        NSColorSpace *deviceRGBColorSpace = [NSColorSpace deviceRGBColorSpace];
        convertedBitmap = [bm bitmapImageRepByConvertingToColorSpace:deviceRGBColorSpace
                                                       renderingIntent:NSColorRenderingIntentDefault];
        if (!convertedBitmap) {
            convertedBitmap = bm;
        }
    }
    
    MTLTextureDescriptor *descriptor = [self descriptorForBitmapImageRep:convertedBitmap];
    if (!descriptor) return nil;
    
    id<MTLTexture> texture = [device newTextureWithDescriptor:descriptor];
    if (!texture) return nil;
    
    [self uploadRep:convertedBitmap toTexture:texture];
    
    return texture;
}

+ (id<MTLTexture>)uncopiedTextureFromRep:(NSBitmapImageRep *)bm device:(id<MTLDevice>)device
{
    return [self textureFromRep:bm device:device];
}

+ (MTLTextureDescriptor *)descriptorForBitmapImageRep:(NSBitmapImageRep *)bm
{
    MTLPixelFormat pixelFormat;
    
    switch ([bm bitsPerPixel]) {
        case 8:
            pixelFormat = MTLPixelFormatR8Unorm;
            break;
        case 24:
            // 24-bit RGB needs conversion to 32-bit RGBA
            pixelFormat = MTLPixelFormatRGBA8Unorm;
            break;
        case 32:
            // Use RGBA format for consistent channel ordering
            pixelFormat = MTLPixelFormatRGBA8Unorm;
            break;
        default:
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
        [self convertRGB24ToRGBA32:pixels 
                             width:[bm pixelsWide] 
                            height:[bm pixelsHigh] 
                       bytesPerRow:bytesPerRow 
                         toTexture:texture];
    } else if (bitsPerPixel == 32) {
        // Debug: Log bitmap properties to understand the format
        NSBitmapFormat format = [self bitmapFormatFor:bm];
        NSLog(@"🔍 Bitmap properties: colorSpace=%@, format=0x%lx, bytesPerRow=%lu, samplesPerPixel=%lu", 
              [bm colorSpaceName], (unsigned long)format, bytesPerRow, [bm samplesPerPixel]);
        
        // Use correct format-aware conversion for different bitmap types
        [self convertRGBA32ToRGBA32:pixels 
                                 bm:bm
                              width:[bm pixelsWide] 
                             height:[bm pixelsHigh] 
                        bytesPerRow:bytesPerRow 
                          toTexture:texture];
    } else {
        // 8-bit or other formats - upload directly
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
    
    MTLRegion region = MTLRegionMake2D(0, 0, width, height);
    [texture replaceRegion:region
               mipmapLevel:0
                 withBytes:rgbaPixels
               bytesPerRow:targetBytesPerRow];
    
    free(rgbaPixels);
}

+ (void)convertRGBA32ToRGBA32:(void *)sourcePixels 
                           bm:(NSBitmapImageRep *)bm
                        width:(NSUInteger)width 
                       height:(NSUInteger)height 
                  bytesPerRow:(NSUInteger)bytesPerRow 
                    toTexture:(id<MTLTexture>)texture
{
    // This function handles conversion from different 32-bit formats to standard RGBA
    // macOS screenshots are typically in BGRA format, not ARGB
    NSUInteger totalBytes = bytesPerRow * height;
    uint8_t *rgbaPixels = malloc(totalBytes);
    
    uint8_t *src = (uint8_t *)sourcePixels;
    uint8_t *dst = rgbaPixels;
    
    // Check bitmap format once before loop
    NSBitmapFormat format = [self bitmapFormatFor:bm];
    BOOL isAlphaFirst = (format & NSAlphaFirstBitmapFormat) != 0;
    
    for (NSUInteger y = 0; y < height; y++) {
        uint8_t *srcRow = src + (y * bytesPerRow);
        uint8_t *dstRow = dst + (y * bytesPerRow);
        
        for (NSUInteger x = 0; x < width; x++) {
            uint8_t r, g, b, a;
            
            if (isAlphaFirst) {
                // ARGB format (Alpha first)
                a = srcRow[x * 4 + 0];  // Alpha
                r = srcRow[x * 4 + 1];  // Red
                g = srcRow[x * 4 + 2];  // Green
                b = srcRow[x * 4 + 3];  // Blue
            } else {
                // RGBA format (standard)
                r = srcRow[x * 4 + 0];  // Red
                g = srcRow[x * 4 + 1];  // Green
                b = srcRow[x * 4 + 2];  // Blue
                a = srcRow[x * 4 + 3];  // Alpha
            }
            
            // Output as RGBA for Metal texture
            dstRow[x * 4 + 0] = r;  // Red
            dstRow[x * 4 + 1] = g;  // Green  
            dstRow[x * 4 + 2] = b;  // Blue
            dstRow[x * 4 + 3] = (a > 0) ? a : 255;  // Preserve alpha but ensure non-zero
        }
    }
    
    MTLRegion region = MTLRegionMake2D(0, 0, width, height);
    [texture replaceRegion:region
               mipmapLevel:0
                 withBytes:rgbaPixels
               bytesPerRow:bytesPerRow];
    
    free(rgbaPixels);
}

#pragma mark - Debugging Methods

+ (BOOL)saveTexture:(id<MTLTexture>)texture toJPEGFile:(NSString *)filePath
{
    if (!texture) {
        NSLog(@"❌ Cannot save texture: texture is nil");
        return NO;
    }
    
    NSBitmapImageRep *bitmap = [self bitmapFromTexture:texture];
    if (!bitmap) {
        NSLog(@"❌ Failed to create bitmap from texture");
        return NO;
    }
    
    // Convert to JPEG data
    NSData *jpegData = [bitmap representationUsingType:NSBitmapImageFileTypeJPEG properties:@{
        NSImageCompressionFactor: @0.8
    }];
    
    if (!jpegData) {
        NSLog(@"❌ Failed to create JPEG data from bitmap");
        return NO;
    }
    
    // Write to file
    BOOL success = [jpegData writeToFile:filePath atomically:YES];
    if (success) {
        NSLog(@"✅ Metal texture saved to: %@", filePath);
        NSLog(@"   Texture size: %lux%lu, format: %lu", texture.width, texture.height, (unsigned long)texture.pixelFormat);
    } else {
        NSLog(@"❌ Failed to write JPEG file to: %@", filePath);
    }
    
    return success;
}

+ (NSBitmapImageRep *)bitmapFromTexture:(id<MTLTexture>)texture
{
    if (!texture) {
        return nil;
    }
    
    NSUInteger width = texture.width;
    NSUInteger height = texture.height;
    NSUInteger bytesPerRow = width * 4; // Assuming RGBA format
    NSUInteger totalBytes = bytesPerRow * height;
    
    // Allocate buffer for texture data
    uint8_t *textureData = malloc(totalBytes);
    if (!textureData) {
        NSLog(@"❌ Failed to allocate memory for texture data");
        return nil;
    }
    
    // Read texture data
    MTLRegion region = MTLRegionMake2D(0, 0, width, height);
    [texture getBytes:textureData
          bytesPerRow:bytesPerRow
           fromRegion:region
          mipmapLevel:0];
    
    // Create bitmap image rep
    NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] 
        initWithBitmapDataPlanes:&textureData
                      pixelsWide:width
                      pixelsHigh:height
                   bitsPerSample:8
                 samplesPerPixel:4
                        hasAlpha:YES
                        isPlanar:NO
                  colorSpaceName:NSDeviceRGBColorSpace
                     bytesPerRow:bytesPerRow
                    bitsPerPixel:32];
    
    if (!bitmap) {
        NSLog(@"❌ Failed to create NSBitmapImageRep from texture data");
        free(textureData);
        return nil;
    }
    
    // Note: Don't free textureData here as NSBitmapImageRep now owns it
    
    return bitmap;
}

@end