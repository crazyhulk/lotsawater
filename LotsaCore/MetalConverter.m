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
        // Convert 32-bit data to RGBA format to ensure consistent channel ordering
        [self convertRGBA32ToRGBA32:pixels 
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
    
    MTLRegion region = MTLRegionMake2D(0, 0, width, height);
    [texture replaceRegion:region
               mipmapLevel:0
                 withBytes:rgbaPixels
               bytesPerRow:bytesPerRow];
    
    free(rgbaPixels);
}

@end