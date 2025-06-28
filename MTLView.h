#import <Cocoa/Cocoa.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLView : NSView

@property (nonatomic, readonly) CAMetalLayer *metalLayer;
@property (nonatomic, readonly) id<CAMetalDrawable> currentDrawable;

- (instancetype)initWithFrame:(NSRect)frameRect;
- (void)setFrameSize:(NSSize)newSize;
- (void)setDevice:(id<MTLDevice>)device;

@end

NS_ASSUME_NONNULL_END 