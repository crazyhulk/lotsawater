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
- (instancetype)initWithDevice:(id<MTLDevice>)device library:(id<MTLLibrary>)library;
- (BOOL)setupMetal;
- (BOOL)setupPipeline;
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
                        drawable:(id<CAMetalDrawable>)drawable
                   vertexBuffer:(id<MTLBuffer>)vertexBuffer
                  normalBuffer:(id<MTLBuffer>)normalBuffer
              texCoordBuffer:(id<MTLBuffer>)texCoordBuffer
                   indexBuffer:(id<MTLBuffer>)indexBuffer
              backgroundTexture:(id<MTLTexture>)backgroundTexture
              reflectionTexture:(id<MTLTexture>)reflectionTexture
                     constants:(id<MTLBuffer>)constantsBuffer;

// 已弃用的渲染方法
- (void)renderWithCommandBuffer:(id<MTLCommandBuffer>)commandBuffer
                   vertexBuffer:(id<MTLBuffer>)vertexBuffer
                  normalBuffer:(id<MTLBuffer>)normalBuffer
                   indexBuffer:(id<MTLBuffer>)indexBuffer
              backgroundTexture:(id<MTLTexture>)backgroundTexture
              reflectionTexture:(id<MTLTexture>)reflectionTexture DEPRECATED_MSG_ATTRIBUTE("Use the new method with drawable and constants");

@end

NS_ASSUME_NONNULL_END 