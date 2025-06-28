#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Testing Metal support...");
        
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        if (!device) {
            NSLog(@"ERROR: Metal is not supported on this device");
            return 1;
        }
        
        NSLog(@"Metal device: %@", device.name);
        
        // 尝试加载默认库
        id<MTLLibrary> library = [device newDefaultLibrary];
        if (!library) {
            NSLog(@"newDefaultLibrary failed, trying bundle approach");
            
            // 尝试从屏保bundle加载
            NSString *saverPath = [@"~/Library/Screen Savers/LotsaWater.saver" stringByExpandingTildeInPath];
            NSBundle *bundle = [NSBundle bundleWithPath:saverPath];
            if (bundle) {
                NSLog(@"Found saver bundle: %@", bundle.bundlePath);
                NSError *error = nil;
                library = [device newDefaultLibraryWithBundle:bundle error:&error];
                if (!library) {
                    NSLog(@"Bundle library failed: %@", error.localizedDescription);
                    
                    // 尝试手动加载metallib文件
                    NSString *metalLibPath = [bundle pathForResource:@"default" ofType:@"metallib"];
                    if (metalLibPath) {
                        NSLog(@"Found metallib at: %@", metalLibPath);
                        NSURL *libraryURL = [NSURL fileURLWithPath:metalLibPath];
                        library = [device newLibraryWithURL:libraryURL error:&error];
                        if (!library) {
                            NSLog(@"Failed to load from URL: %@", error.localizedDescription);
                            return 1;
                        } else {
                            NSLog(@"Successfully loaded library from URL");
                        }
                    } else {
                        NSLog(@"No metallib file found in bundle");
                        return 1;
                    }
                } else {
                    NSLog(@"Successfully loaded library from bundle");
                }
            } else {
                NSLog(@"Could not load saver bundle");
                return 1;
            }
        } else {
            NSLog(@"Successfully loaded default library");
        }
        
        // 尝试加载着色器函数
        id<MTLFunction> vertexFunction = [library newFunctionWithName:@"waterVertexShader"];
        id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"waterFragmentShader"];
        
        if (!vertexFunction) {
            NSLog(@"ERROR: Could not load vertex shader 'waterVertexShader'");
            return 1;
        }
        if (!fragmentFunction) {
            NSLog(@"ERROR: Could not load fragment shader 'waterFragmentShader'");
            return 1;
        }
        
        NSLog(@"SUCCESS: All Metal resources loaded successfully!");
        NSLog(@"Vertex shader: %@", vertexFunction);
        NSLog(@"Fragment shader: %@", fragmentFunction);
        
        return 0;
    }
}