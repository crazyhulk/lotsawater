#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLTexture : NSObject

@property (nonatomic, readonly) id<MTLTexture> texture;
@property (nonatomic, readonly) MTLTextureDescriptor *descriptor;

- (instancetype)initWithDevice:(id<MTLDevice>)device
                    descriptor:(MTLTextureDescriptor *)descriptor;

- (instancetype)initWithDevice:(id<MTLDevice>)device
                        width:(NSUInteger)width
                       height:(NSUInteger)height
                    pixelFormat:(MTLPixelFormat)pixelFormat;

// 更新纹理数据
- (void)replaceRegion:(MTLRegion)region
           mipmapLevel:(NSUInteger)level
             withBytes:(const void *)pixelBytes
           bytesPerRow:(NSUInteger)bytesPerRow;

// 从图片创建纹理
- (instancetype)initWithDevice:(id<MTLDevice>)device
                        image:(NSImage *)image
                   pixelFormat:(MTLPixelFormat)pixelFormat;

// 获取纹理信息
- (NSUInteger)width;
- (NSUInteger)height;
- (MTLPixelFormat)pixelFormat;

@end

NS_ASSUME_NONNULL_END 