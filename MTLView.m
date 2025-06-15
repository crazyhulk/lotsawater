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
        _metalLayer.device = MTLCreateSystemDefaultDevice();
        _metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
        _metalLayer.framebufferOnly = YES;
        _metalLayer.contentsScale = self.window.screen.backingScaleFactor;
    }
    return self;
}

- (void)setFrameSize:(NSSize)newSize {
    [super setFrameSize:newSize];
    
    // 更新 Metal 层的绘制大小
    _metalLayer.drawableSize = CGSizeMake(newSize.width * _metalLayer.contentsScale,
                                        newSize.height * _metalLayer.contentsScale);
}

- (id<CAMetalDrawable>)currentDrawable {
    return [_metalLayer nextDrawable];
}

@end 