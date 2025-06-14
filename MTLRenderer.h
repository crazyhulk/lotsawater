#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLRenderer : NSObject

@property (nonatomic, readonly) id<MTLDevice> device;
@property (nonatomic, readonly) id<MTLCommandQueue> commandQueue;
@property (nonatomic, readonly) id<MTLLibrary> defaultLibrary;

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

@end

NS_ASSUME_NONNULL_END 