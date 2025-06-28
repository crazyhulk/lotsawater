#import "MTLView.h"

@implementation MTLView

+ (Class)layerClass {
    return [CAMetalLayer class];
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        self.wantsLayer = YES;
        self.layer = [CAMetalLayer layer];
        
        // 配置 Metal 层
        _metalLayer = (CAMetalLayer *)self.layer;
        // 不在这里设置device，稍后由父视图设置
        _metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
        _metalLayer.framebufferOnly = YES;
        // contentsScale 稍后设置，因为这时window可能还没有
    }
    return self;
}

// 添加设置设备的方法
- (void)setDevice:(id<MTLDevice>)device {
    _metalLayer.device = device;
    
    // 设置正确的scale
    NSScreen *screen = self.window.screen ?: [NSScreen mainScreen];
    _metalLayer.contentsScale = screen.backingScaleFactor;
    
    // 设置drawable size - 但限制最大尺寸以避免内存问题
    NSSize frameSize = self.frame.size;
    CGFloat scale = _metalLayer.contentsScale;
    
    // 限制drawable size以避免内存分配失败
    CGFloat maxSize = 2048; // 限制最大尺寸
    CGFloat drawableWidth = MIN(frameSize.width * scale, maxSize);
    CGFloat drawableHeight = MIN(frameSize.height * scale, maxSize);
    
    _metalLayer.drawableSize = CGSizeMake(drawableWidth, drawableHeight);
    
    NSLog(@"MTLView: Set device %@ with scale %f, drawable size: %fx%f", 
          device.name, _metalLayer.contentsScale,
          _metalLayer.drawableSize.width, _metalLayer.drawableSize.height);
}

- (void)setFrameSize:(NSSize)newSize {
    [super setFrameSize:newSize];
    
    // 更新 Metal 层的绘制大小
    _metalLayer.drawableSize = CGSizeMake(newSize.width * _metalLayer.contentsScale,
                                        newSize.height * _metalLayer.contentsScale);
}

- (id<CAMetalDrawable>)currentDrawable {
    id<CAMetalDrawable> drawable = [_metalLayer nextDrawable];
    if (!drawable) {
        NSLog(@"WARNING: nextDrawable returned nil. Layer device: %@, size: %fx%f", 
              _metalLayer.device ? _metalLayer.device.name : @"nil",
              _metalLayer.drawableSize.width, _metalLayer.drawableSize.height);
    }
    return drawable;
}

@end 