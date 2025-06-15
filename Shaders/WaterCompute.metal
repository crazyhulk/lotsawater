#include <metal_stdlib>
using namespace metal;

// 水波纹参数结构体
struct WaterComputeParams {
    uint width;
    uint height;
    float time;
    float depth;
    float damping;
    float speed;
};

// 水波纹计算着色器
kernel void computeWaterSurface(
    device float* current [[buffer(0)]],
    device float* previous [[buffer(1)]],
    device float* next [[buffer(2)]],
    constant WaterComputeParams& params [[buffer(3)]],
    uint2 position [[thread_position_in_grid]])
{
    // 检查边界
    if (position.x >= params.width || position.y >= params.height) {
        return;
    }
    
    uint index = position.y * params.width + position.x;
    
    // 获取相邻点的高度
    float h_left = (position.x > 0) ? current[index - 1] : current[index];
    float h_right = (position.x < params.width - 1) ? current[index + 1] : current[index];
    float h_top = (position.y > 0) ? current[index - params.width] : current[index];
    float h_bottom = (position.y < params.height - 1) ? current[index + params.width] : current[index];
    
    // 计算拉普拉斯算子
    float laplacian = (h_left + h_right + h_top + h_bottom - 4.0f * current[index]);
    
    // 更新下一个时间步的高度
    next[index] = (2.0f * current[index] - previous[index] + 
                  params.speed * laplacian) * params.damping;
    
    // 添加时间相关的波动
    float time_factor = sin(params.time * 2.0f * M_PI_F * 0.1f) * 0.01f;
    next[index] += time_factor;
    
    // 应用深度因子
    next[index] *= params.depth;
}

// 水滴效果计算着色器
kernel void computeWaterDrop(
    device float* height [[buffer(0)]],
    constant float2& position [[buffer(1)]],
    constant float& amplitude [[buffer(2)]],
    constant float& radius [[buffer(3)]],
    uint2 pos [[thread_position_in_grid]])
{
    // 计算到水滴中心的距离
    float2 center = position;
    float2 current = float2(pos) / float2(radius);
    float dist = distance(center, current);
    
    // 如果在水滴半径内，添加高度
    if (dist < 1.0f) {
        float drop = amplitude * (1.0f - dist * dist);
        height[pos.y * uint(radius) + pos.x] += drop;
    }
} 