#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLRenderer : NSObject

@property (nonatomic, readonly) id<MTLDevice> device;
@property (nonatomic, readonly) id<MTLCommandQueue> commandQueue;
@property (nonatomic, readonly) id<MTLLibrary> defaultLibrary;
@property (nonatomic, readonly) id<MTLCommandBuffer> currentCommandBuffer;

- (instancetype)init;
- (BOOL)setupMetal;
- (void)cleanup;

// 基础渲染方法
- (void)beginFrame;
- (void)endFrame;
- (void)presentDrawable:(id<CAMetalDrawable>)drawable;

// 资源管理
- (id<MTLBuffer>)createBufferWithBytes:(const void *)bytes 
                               length:(NSUInteger)length 
                              options:(MTLResourceOptions)options;
- (id<MTLTexture>)createTextureWithDescriptor:(MTLTextureDescriptor *)descriptor;

// 水波纹渲染方法
- (void)renderWithCommandBuffer:(id<MTLCommandBuffer>)commandBuffer
                   vertexBuffer:(id<MTLBuffer>)vertexBuffer
                  normalBuffer:(id<MTLBuffer>)normalBuffer
                   indexBuffer:(id<MTLBuffer>)indexBuffer
              backgroundTexture:(id<MTLTexture>)backgroundTexture
              reflectionTexture:(id<MTLTexture>)reflectionTexture;

@end

NS_ASSUME_NONNULL_END 