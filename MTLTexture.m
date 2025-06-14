#import "MTLTexture.h"

@interface MTLTexture()
@property (nonatomic, strong) id<MTLTexture> texture;
@property (nonatomic, strong) MTLTextureDescriptor *descriptor;
@end

@implementation MTLTexture

- (instancetype)initWithDevice:(id<MTLDevice>)device
                    descriptor:(MTLTextureDescriptor *)descriptor {
    self = [super init];
    if (self) {
        _descriptor = descriptor;
        _texture = [device newTextureWithDescriptor:descriptor];
        if (!_texture) {
            return nil;
        }
    }
    return self;
}

- (instancetype)initWithDevice:(id<MTLDevice>)device
                        width:(NSUInteger)width
                       height:(NSUInteger)height
                    pixelFormat:(MTLPixelFormat)pixelFormat {
    MTLTextureDescriptor *descriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:pixelFormat
                                                                                         width:width
                                                                                        height:height
                                                                                     mipmapped:NO];
    descriptor.usage = MTLTextureUsageShaderRead | MTLTextureUsageShaderWrite;
    return [self initWithDevice:device descriptor:descriptor];
}

- (void)replaceRegion:(MTLRegion)region
           mipmapLevel:(NSUInteger)level
             withBytes:(const void *)pixelBytes
           bytesPerRow:(NSUInteger)bytesPerRow {
    [_texture replaceRegion:region mipmapLevel:level withBytes:pixelBytes bytesPerRow:bytesPerRow];
}

- (instancetype)initWithDevice:(id<MTLDevice>)device
                        image:(NSImage *)image
                   pixelFormat:(MTLPixelFormat)pixelFormat {
    if (!image) {
        return nil;
    }
    
    CGImageRef cgImage = [image CGImageForProposedRect:NULL context:nil hints:nil];
    if (!cgImage) {
        return nil;
    }
    
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    
    self = [self initWithDevice:device width:width height:height pixelFormat:pixelFormat];
    if (!self) {
        return nil;
    }
    
    // 创建位图上下文
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    size_t bytesPerRow = width * 4;
    void *imageData = malloc(bytesPerRow * height);
    
    CGContextRef context = CGBitmapContextCreate(imageData,
                                               width,
                                               height,
                                               8,
                                               bytesPerRow,
                                               colorSpace,
                                               kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    if (!context) {
        free(imageData);
        CGColorSpaceRelease(colorSpace);
        return nil;
    }
    
    // 绘制图片到位图上下文
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    
    // 更新纹理
    MTLRegion region = MTLRegionMake2D(0, 0, width, height);
    [self replaceRegion:region mipmapLevel:0 withBytes:imageData bytesPerRow:bytesPerRow];
    
    // 清理
    CGContextRelease(context);
    free(imageData);
    CGColorSpaceRelease(colorSpace);
    
    return self;
}

- (NSUInteger)width {
    return _texture.width;
}

- (NSUInteger)height {
    return _texture.height;
}

- (MTLPixelFormat)pixelFormat {
    return _texture.pixelFormat;
}

@end 