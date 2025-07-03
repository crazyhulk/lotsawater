# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a macOS screen saver that simulates water ripple effects on the desktop wallpaper. The project has been migrated from OpenGL to Metal API for modern macOS compatibility.

**Key Features:**
- Real-time water physics simulation with ripple effects
- Desktop screenshot capture as background texture
- Configurable rain intensity, water depth, and visual effects
- Dual rendering implementations: Legacy OpenGL and modern Metal

## Build Commands

```bash
# Build the screen saver
xcodebuild

# Build quietly (suppress warnings)
xcodebuild -quiet

# Clean build
xcodebuild clean

# Install screen saver (copies to ~/Library/Screen Savers/)
# This happens automatically after successful build via Run Script
```

**Important:** The project uses a custom Run Script that automatically installs the built screen saver to `~/Library/Screen Savers/LotsaWater.saver`. Always check this script before testing.

## Testing

```bash
# Open System Preferences to test screen saver
open "/System/Library/PreferencePanes/DesktopScreenEffectsPref.prefPane"

# View logs during runtime (use full path to avoid command conflicts)
/usr/bin/log stream --predicate 'subsystem == "com.apple.screensaver"'
```

## Architecture Overview

### Dual Implementation Strategy
The project maintains two parallel implementations:

1. **Legacy OpenGL** (`LotsaWaterView.m`) - Original implementation using deprecated OpenGL
2. **Modern Metal** (`LotsaWaterMetalView.m`) - New implementation using Metal API

The active implementation is controlled by `Info.plist` → `NSPrincipalClass`:
- `LWLotsaWaterView` for OpenGL
- `LWLotsaWaterMetalView` for Metal (current)

### Core Components

**Water Physics Engine** (`Water.c/.h`)
- Real-time wave equation solver using finite differences
- Manages water surface height (`z`) and normals (`n`) arrays
- Supports multiple simultaneous ripple effects
- Time-based animation with configurable parameters

**Rendering Pipeline**
- **OpenGL Path**: Uses dual texture units with `GL_MODULATE` + `GL_ADD` blending
- **Metal Path**: Implements equivalent dual-texture rendering with custom shaders

**Base Framework** (`LotsaCore/LotsaView`)
- Abstract screen saver base class with common functionality
- Handles screen capture, configuration management, and timing
- Provides OpenGL context management (for legacy path)

### Metal Implementation Details

**Key Files:**
- `LotsaWaterMetalView.m` - Main Metal view controller
- `LotsaCore/MetalRenderer.m` - Metal rendering engine
- `LotsaCore/MetalConverter.m` - Texture conversion utilities
- `WaterShaders.metal` - Metal vertex/fragment shaders

**Metal Pipeline:**
1. Capture desktop screenshot as background texture
2. Generate vertex grid with refraction calculations
3. Apply water physics to modify texture coordinates
4. Render with dual textures: background (modulated) + reflection (additive)

**Critical Shader Details:**
The Metal fragment shader must replicate OpenGL's dual-texture behavior:
- Background texture: `GL_MODULATE` → `backgroundColor * vertexColor`
- Reflection texture: `GL_ADD` with sphere mapping → `modulatedColor + reflectionColor`

### Configuration System

User settings are managed through macOS screen saver preferences:
- `detail` (0-5): Water grid resolution (24×24 to 128×128)
- `accuracy` (0-4): Physics simulation precision (12-64 max particles)
- `slowMotion`, `rainFall`, `depth`: Animation parameters
- `imageSource`: 0=screenshot, 1=custom image file
- `imageFade`: Background opacity control

### Texture Management

**Background Sources:**
- Screenshot capture via `grabScreenShot` (desktop wallpaper)
- Custom image files (PNG/JPEG support)
- Automatic scaling to maintain aspect ratio

**Reflection Texture:**
- Static `reflections.png` asset provides water surface highlights
- Applied using sphere mapping from surface normals

## Common Development Patterns

**Water Physics Integration:**
```c
// Initialize water system
InitWater(&wet, gridsize, gridsize, max_p, max_p, 1, 1, 2*water_w, 2*water_h);

// Add ripple effects
InitDripWaterState(&drip, &wet, x, y, radius, amplitude);
AddWaterStateAtTime(&wet, &drip, time);

// Calculate surface per frame
CalculateWaterSurfaceAtTime(&wet, current_time);
```

**Metal Rendering Flow:**
```objc
// Update vertex data with physics results
[renderer updateVertexData:vertices count:vertex_count];

// Set textures and uniforms
[renderer setBackgroundTexture:backgroundTexture];
[renderer updateUniforms:uniforms];

// Render to drawable
[renderer renderToTexture:view.currentDrawable.texture withCommandBuffer:commandBuffer];
```

**Error Handling Patterns:**
- Metal device creation failures fall back gracefully
- Texture loading errors use fallback textures or colors
- Water physics initialization validates grid dimensions and memory allocation

## Project History

Originally created by Dag Ågren, this screen saver was updated for modern macOS compatibility due to:
1. Screen resolution changes in newer macOS versions
2. OpenGL deprecation warnings starting in macOS 10.14
3. Need for Metal API migration for future compatibility

The Metal migration preserves identical visual effects while using modern graphics APIs.

## how to test.

1. 使用 log show 查看日志的时候注意要用全路径 /usr/bin/log，因为可能有命令冲突
2. xcode 添加了 run script 如下:
```
# Type a script or drag a script file from your workspace to insert its path.

#!/bin/bash

  

**echo** "🔄 ==========Building LotsaWater screensaver..."

  

**echo** "🔄 Killing screensaver processes..."

killall "System Preferences" 2>/dev/null || true

#killall "System Settings" 2>/dev/null || true

killall legacyScreenSaver 2>/dev/null || true

PRODUCT="${BUILT_PRODUCTS_DIR}/${FULL_PRODUCT_NAME}"

rm -rf ~/Library/Screen\ Savers/LotsaWater.saver && cp -R ${PRODUCT} ~/Library/Screen\ Savers/

open -a ScreenSaverEngine

**echo** ${PRODUCT}

# 截图

screencapture -T 3 ${PROJECT_DIR}/screen/screen.jpg

sleep 1

  

# 停止屏保

osascript -e 'tell application "System Events" to tell screen saver preferences to stop'

#exit(0)
```
所以只要编译运行就能拿到截图和日志。
