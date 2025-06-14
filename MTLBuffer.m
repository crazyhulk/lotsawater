#import "MTLBuffer.h"

@interface MTLBuffer()
@property (nonatomic, strong) id<MTLBuffer> buffer;
@property (nonatomic, assign) NSUInteger length;
@property (nonatomic, assign) MTLResourceOptions options;
@end

@implementation MTLBuffer

- (instancetype)initWithDevice:(id<MTLDevice>)device
                        bytes:(const void *)bytes
                       length:(NSUInteger)length
                      options:(MTLResourceOptions)options {
    self = [super init];
    if (self) {
        _length = length;
        _options = options;
        _buffer = [device newBufferWithBytes:bytes length:length options:options];
        if (!_buffer) {
            return nil;
        }
    }
    return self;
}

- (instancetype)initWithDevice:(id<MTLDevice>)device
                       length:(NSUInteger)length
                      options:(MTLResourceOptions)options {
    return [self initWithDevice:device bytes:NULL length:length options:options];
}

- (void)updateBytes:(const void *)bytes length:(NSUInteger)length {
    [self updateBytes:bytes offset:0 length:length];
}

- (void)updateBytes:(const void *)bytes offset:(NSUInteger)offset length:(NSUInteger)length {
    if (offset + length > _length) {
        NSLog(@"Buffer update out of bounds");
        return;
    }
    
    void *bufferContents = [self contents];
    if (bufferContents) {
        memcpy(bufferContents + offset, bytes, length);
        [self didModifyRange:NSMakeRange(offset, length)];
    }
}

- (void *)contents {
    if (_options & MTLResourceStorageModeShared) {
        return _buffer.contents;
    }
    return NULL;
}

- (void)didModifyRange:(NSRange)range {
    if (_options & MTLResourceStorageModeShared) {
        [_buffer didModifyRange:range];
    }
}

@end 