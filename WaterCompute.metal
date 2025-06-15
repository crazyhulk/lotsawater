#include <metal_stdlib>
using namespace metal;

// 水波纹状态结构体
struct MetalWaterState {
    int max_p;
    int max_q;
    device float* apq;
    device float* bpq;
};

// 水波纹参数结构体
struct MetalWaterParams {
    int w;
    int h;
    int max_p;
    int max_q;
    float v;
    float b;
    float lx;
    float ly;
    float t0;
    device float* wpq;
    device float* ampl;
    device float* sin_px;
    device float* sin_qy;
    device float* cos_px;
    device float* cos_qy;
    device float* z;
    device float3* n;
};

// 计算水波纹表面的计算着色器
kernel void calculateWaterSurface(device const MetalWaterParams& water [[buffer(0)]],
                                device float* outputZ [[buffer(1)]],
                                device float3* outputN [[buffer(2)]],
                                uint2 position [[thread_position_in_grid]]) {
    // 检查边界
    if (position.x >= water.w || position.y >= water.h) {
        return;
    }
    
    int x = position.x;
    int y = position.y;
    float z = 0.0;
    float3 normal = float3(0.0, 0.0, 1.0);
    
    // 计算水波纹高度
    for (int p = 0; p < water.max_p; p++) {
        for (int q = 0; q < water.max_q; q++) {
            int pq = p * water.max_q + q;
            float wpq = water.wpq[pq];
            float ampl = water.ampl[pq];
            
            // 计算正弦和余弦项
            float sin_px = water.sin_px[p * water.w + x];
            float sin_qy = water.sin_qy[q * water.h + y];
            float cos_px = water.cos_px[p * water.w + x];
            float cos_qy = water.cos_qy[q * water.h + y];
            
            // 计算高度
            z += ampl * sin_px * sin_qy;
            
            // 计算法线
            float dx = p * water.lx * ampl * cos_px * sin_qy;
            float dy = q * water.ly * ampl * sin_px * cos_qy;
            normal += float3(-dx, -dy, 1.0);
        }
    }
    
    // 归一化法线
    normal = normalize(normal);
    
    // 存储结果
    int index = y * water.w + x;
    outputZ[index] = z;
    outputN[index] = normal;
}

// 添加水滴效果的计算着色器
kernel void addWaterDrop(device MetalWaterParams& water [[buffer(0)]],
                        device float* outputZ [[buffer(1)]],
                        constant float4& dropParams [[buffer(2)]], // x0, y0, d, ampl
                        uint2 position [[thread_position_in_grid]]) {
    // 检查边界
    if (position.x >= water.w || position.y >= water.h) {
        return;
    }
    
    int x = position.x;
    int y = position.y;
    float x0 = dropParams.x;
    float y0 = dropParams.y;
    float d = dropParams.z;
    float ampl = dropParams.w;
    
    // 计算到水滴中心的距离
    float dx = (x - x0) * water.lx;
    float dy = (y - y0) * water.ly;
    float dist = sqrt(dx * dx + dy * dy);
    
    // 计算水滴效果
    if (dist < d) {
        float factor = (1.0 - dist / d) * ampl;
        int index = y * water.w + x;
        outputZ[index] += factor;
    }
} 