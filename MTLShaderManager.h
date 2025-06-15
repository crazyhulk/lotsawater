#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLShaderManager : NSObject

@property (nonatomic, readonly) id<MTLDevice> device;
@property (nonatomic, readonly) id<MTLLibrary> defaultLibrary;

- (instancetype)initWithDevice:(id<MTLDevice>)device;

// 从默认库加载函数
- (nullable id<MTLFunction>)functionWithName:(NSString *)functionName;

// 从文件加载库
- (nullable id<MTLLibrary>)libraryWithFile:(NSString *)filePath error:(NSError **)error;

// 从字符串加载库
- (nullable id<MTLLibrary>)libraryWithSource:(NSString *)source error:(NSError **)error;

// 从库中加载函数
- (nullable id<MTLFunction>)functionWithName:(NSString *)functionName fromLibrary:(id<MTLLibrary>)library;

@end

NS_ASSUME_NONNULL_END 