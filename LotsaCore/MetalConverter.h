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

// Color channel conversion methods
+ (void)convertRGB24ToRGBA32:(void *)sourcePixels 
                       width:(NSUInteger)width 
                      height:(NSUInteger)height 
                 bytesPerRow:(NSUInteger)sourceBytesPerRow 
                   toTexture:(id<MTLTexture>)texture;

+ (void)convertRGBA32ToRGBA32:(void *)sourcePixels 
                        width:(NSUInteger)width 
                       height:(NSUInteger)height 
                  bytesPerRow:(NSUInteger)bytesPerRow 
                    toTexture:(id<MTLTexture>)texture;

// Debugging methods
+ (BOOL)saveTexture:(id<MTLTexture>)texture toJPEGFile:(NSString *)filePath;
+ (NSBitmapImageRep *)bitmapFromTexture:(id<MTLTexture>)texture;

@end