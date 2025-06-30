#import "MetalConverter.h"

@implementation MetalConverter

+ (id<MTLTexture>)texture2DFromRep:(NSBitmapImageRep *)bm device:(id<MTLDevice>)device
{
    return [self textureFromRep:bm device:device];
}

+ (id<MTLTexture>)textureFromRep:(NSBitmapImageRep *)bm device:(id<MTLDevice>)device
{
    if ([bm isPlanar]) return nil;
    
    MTLTextureDescriptor *descriptor = [self descriptorForBitmapImageRep:bm];
    if (!descriptor) return nil;
    
    id<MTLTexture> texture = [device newTextureWithDescriptor:descriptor];
    if (!texture) return nil;
    
    [self uploadRep:bm toTexture:texture];
    
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
            pixelFormat = MTLPixelFormatRGBA8Unorm_sRGB;
            break;
        case 32:
            if ([self bitmapFormatFor:bm] & NSAlphaFirstBitmapFormat) {
                pixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
            } else {
                pixelFormat = MTLPixelFormatRGBA8Unorm_sRGB;
            }
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
    NSUInteger bytesPerPixel = [bm bitsPerPixel] / 8;
    NSUInteger bytesPerRow = [bm bytesPerRow];
    void *pixels = [bm bitmapData];
    
    MTLRegion region = MTLRegionMake2D(0, 0, [bm pixelsWide], [bm pixelsHigh]);
    
    [texture replaceRegion:region
               mipmapLevel:0
                 withBytes:pixels
               bytesPerRow:bytesPerRow];
}

+ (NSBitmapFormat)bitmapFormatFor:(NSBitmapImageRep *)bm
{
    if ([bm respondsToSelector:@selector(bitmapFormat)]) {
        return [bm bitmapFormat];
    }
    return 0;
}

@end