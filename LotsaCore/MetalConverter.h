#import <Cocoa/Cocoa.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

#import "NameMangler.h"
#define MetalConverter MangleClassName(MetalConverter)

@interface MetalConverter : NSObject

+ (id<MTLTexture>)texture2DFromRep:(NSBitmapImageRep *)bm device:(id<MTLDevice>)device;
+ (id<MTLTexture>)textureFromRep:(NSBitmapImageRep *)bm device:(id<MTLDevice>)device;
+ (id<MTLTexture>)uncopiedTextureFromRep:(NSBitmapImageRep *)bm device:(id<MTLDevice>)device;

+ (MTLTextureDescriptor *)descriptorForBitmapImageRep:(NSBitmapImageRep *)bm;
+ (void)uploadRep:(NSBitmapImageRep *)bm toTexture:(id<MTLTexture>)texture;

+ (NSBitmapFormat)bitmapFormatFor:(NSBitmapImageRep *)bm;

@end