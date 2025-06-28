#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLBufferManager : NSObject

@property (nonatomic, readonly) id<MTLDevice> device;

- (instancetype)initWithDevice:(id<MTLDevice>)device;

// 创建缓冲区
- (id<MTLBuffer>)createBufferWithLength:(NSUInteger)length options:(MTLResourceOptions)options;
- (id<MTLBuffer>)createBufferWithBytes:(const void *)bytes length:(NSUInteger)length options:(MTLResourceOptions)options;

// 创建顶点缓冲区
- (id<MTLBuffer>)createVertexBufferWithVertices:(const void *)vertices 
                                         count:(NSUInteger)count 
                                        stride:(NSUInteger)stride;

// 创建索引缓冲区
- (id<MTLBuffer>)createIndexBufferWithIndices:(const void *)indices 
                                       count:(NSUInteger)count 
                                      format:(MTLIndexType)format;

// 创建统一缓冲区
- (id<MTLBuffer>)createUniformBufferWithBytes:(const void *)bytes 
                                      length:(NSUInteger)length;

// 更新缓冲区内容
- (void)updateBuffer:(id<MTLBuffer>)buffer 
            withBytes:(const void *)bytes 
              offset:(NSUInteger)offset 
              length:(NSUInteger)length;

// 创建水波纹相关的缓冲区
- (id<MTLBuffer>)createHeightBufferWithWidth:(uint32_t)width height:(uint32_t)height;
- (id<MTLBuffer>)createNormalBufferWithWidth:(uint32_t)width height:(uint32_t)height;
- (id<MTLBuffer>)createWaterStateBufferWithWidth:(uint32_t)width height:(uint32_t)height;
- (id<MTLBuffer>)createTexCoordBufferWithWidth:(NSUInteger)width height:(NSUInteger)height;
- (id<MTLBuffer>)createConstantsBufferWithSize:(NSUInteger)size;

// 网格生成工具方法
- (void)generateGridVerticesForBuffer:(id<MTLBuffer>)vertexBuffer 
                         normalBuffer:(id<MTLBuffer>)normalBuffer
                        texCoordBuffer:(id<MTLBuffer>)texCoordBuffer
                                width:(NSUInteger)width 
                               height:(NSUInteger)height 
                           waterWidth:(float)waterWidth 
                          waterHeight:(float)waterHeight;

- (void)generateGridIndicesForBuffer:(id<MTLBuffer>)indexBuffer 
                               width:(NSUInteger)width 
                              height:(NSUInteger)height;

@end

NS_ASSUME_NONNULL_END 