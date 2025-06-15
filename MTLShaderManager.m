#import "MTLShaderManager.h"

@interface MTLShaderManager()
@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLLibrary> defaultLibrary;
@end

@implementation MTLShaderManager

- (instancetype)initWithDevice:(id<MTLDevice>)device {
    self = [super init];
    if (self) {
        _device = device;
        
        // 加载默认库
        NSError *error = nil;
        _defaultLibrary = [device newDefaultLibrary];
        if (!_defaultLibrary) {
            NSLog(@"Failed to load default library: %@", error);
            return nil;
        }
    }
    return self;
}

- (id<MTLFunction>)functionWithName:(NSString *)functionName {
    return [self.defaultLibrary newFunctionWithName:functionName];
}

- (id<MTLLibrary>)libraryWithFile:(NSString *)filePath error:(NSError **)error {
    return [self.device newLibraryWithFile:filePath error:error];
}

- (id<MTLLibrary>)libraryWithSource:(NSString *)source error:(NSError **)error {
    return [self.device newLibraryWithSource:source options:nil error:error];
}

- (id<MTLFunction>)functionWithName:(NSString *)functionName fromLibrary:(id<MTLLibrary>)library {
    return [library newFunctionWithName:functionName];
}

@end 