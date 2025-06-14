#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLBuffer : NSObject

@property (nonatomic, readonly) id<MTLBuffer> buffer;
@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) MTLResourceOptions options;

- (instancetype)initWithDevice:(id<MTLDevice>)device
                        bytes:(const void *)bytes
                       length:(NSUInteger)length
                      options:(MTLResourceOptions)options;

- (instancetype)initWithDevice:(id<MTLDevice>)device
                       length:(NSUInteger)length
                      options:(MTLResourceOptions)options;

// 更新缓冲区数据
- (void)updateBytes:(const void *)bytes length:(NSUInteger)length;
- (void)updateBytes:(const void *)bytes offset:(NSUInteger)offset length:(NSUInteger)length;

// 获取缓冲区内容
- (void *)contents;
- (void)didModifyRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END 