#include <metal_stdlib>
using namespace metal;

// 水波纹参数结构体
struct WaterComputeParams {
    uint width;
    uint height;
    uint max_p;
    uint max_q;
    float time;
    float depth;
    float damping;
    float speed;
    float v; // 波速
    float b; // 阻尼
    float lx; // x方向长度
    float ly; // y方向长度
    float t0; // 起始时间
};

// 水波纹状态结构体
struct WaterState {
    device float* apq; // 系数a
    device float* bpq; // 系数b
    device float* wpq; // 频率
    device float* ampl; // 振幅
};

// 三角函数预计算缓冲区
struct TrigBuffers {
    device float* sin_px;
    device float* sin_qy;
    device float* cos_px;
    device float* cos_qy;
};

// 基于原始算法的水波纹计算着色器
kernel void computeWaterSurfaceOriginal(
    constant WaterComputeParams& params [[buffer(0)]],
    constant WaterState& state [[buffer(1)]],
    constant TrigBuffers& trig [[buffer(2)]],
    device float* outputHeight [[buffer(3)]],
    device float3* outputNormal [[buffer(4)]],
    uint2 position [[thread_position_in_grid]])
{
    if (position.x >= params.width || position.y >= params.height) {
        return;
    }
    
    uint x = position.x;
    uint y = position.y;
    uint index = y * params.width + x;
    
    float z = 0.0;
    float3 normal = float3(0.0, 0.0, 1.0);
    float dx_sum = 0.0;
    float dy_sum = 0.0;
    
    // 计算水波纹高度和法线
    for (uint p = 0; p < params.max_p; p++) {
        for (uint q = 0; q < params.max_q; q++) {
            uint pq = p * params.max_q + q;
            
            // 获取预计算的三角函数值
            float sin_px = trig.sin_px[p * params.width + x];
            float sin_qy = trig.sin_qy[q * params.height + y];
            float cos_px = trig.cos_px[p * params.width + x];
            float cos_qy = trig.cos_qy[q * params.height + y];
            
            // 计算时间相关的因子
            float wt = state.wpq[pq] * (params.time - params.t0);
            float time_factor = state.apq[pq] * cos(wt) + state.bpq[pq] * sin(wt);
            
            float amplitude = state.ampl[pq] * time_factor;
            
            // 累加高度
            z += amplitude * sin_px * sin_qy;
            
            // 累加法线的x和y分量
            float kx = M_PI_F * (p + 1) / params.lx;
            float ky = M_PI_F * (q + 1) / params.ly;
            
            dx_sum += amplitude * kx * cos_px * sin_qy;
            dy_sum += amplitude * ky * sin_px * cos_qy;
        }
    }
    
    // 计算最终法线
    normal = normalize(float3(-dx_sum, -dy_sum, 1.0));
    
    // 存储结果
    outputHeight[index] = z;
    outputNormal[index] = normal;
}

// 简化的波动方程水波纹计算着色器
kernel void computeWaterSurfaceWave(
    device float* current [[buffer(0)]],
    device float* previous [[buffer(1)]],
    device float* next [[buffer(2)]],
    constant WaterComputeParams& params [[buffer(3)]],
    uint2 position [[thread_position_in_grid]])
{
    if (position.x >= params.width || position.y >= params.height) {
        return;
    }
    
    uint index = position.y * params.width + position.x;
    
    // 边界处理
    if (position.x == 0 || position.x == params.width - 1 || 
        position.y == 0 || position.y == params.height - 1) {
        next[index] = current[index] * params.damping;
        return;
    }
    
    // 获取相邻点的高度
    float h_center = current[index];
    float h_left = current[index - 1];
    float h_right = current[index + 1];
    float h_top = current[index - params.width];
    float h_bottom = current[index + params.width];
    
    // 计算拉普拉斯算子
    float laplacian = h_left + h_right + h_top + h_bottom - 4.0f * h_center;
    
    // 波动方程: ∂²u/∂t² = c²∇²u - b∂u/∂t
    float dt = 1.0f / 60.0f; // 60fps
    float c_squared = params.speed * params.speed;
    
    // 更新下一个时间步的高度
    next[index] = (2.0f * h_center - previous[index] + 
                  c_squared * dt * dt * laplacian) * params.damping;
    
    // 应用深度因子
    next[index] *= params.depth;
}

// 法线计算着色器
kernel void computeNormals(
    device const float* heights [[buffer(0)]],
    device float3* normals [[buffer(1)]],
    constant WaterComputeParams& params [[buffer(2)]],
    constant float& scale [[buffer(3)]],
    uint2 position [[thread_position_in_grid]])
{
    if (position.x >= params.width || position.y >= params.height) {
        return;
    }
    
    uint index = position.y * params.width + position.x;
    
    // 边界处理
    if (position.x == 0 || position.x == params.width - 1 || 
        position.y == 0 || position.y == params.height - 1) {
        normals[index] = float3(0.0, 0.0, 1.0);
        return;
    }
    
    // 获取相邻点的高度
    float h_left = heights[index - 1];
    float h_right = heights[index + 1];
    float h_top = heights[index - params.width];
    float h_bottom = heights[index + params.width];
    
    // 计算梯度
    float dx = (h_right - h_left) * 0.5f * scale;
    float dy = (h_bottom - h_top) * 0.5f * scale;
    
    // 计算法线
    float3 normal = normalize(float3(-dx, -dy, 1.0));
    normals[index] = normal;
}

// 水滴效果计算着色器
kernel void computeWaterDrop(
    device float* heights [[buffer(0)]],
    constant float2& dropCenter [[buffer(1)]],
    constant float& amplitude [[buffer(2)]],
    constant float& radius [[buffer(3)]],
    constant WaterComputeParams& params [[buffer(4)]],
    uint2 position [[thread_position_in_grid]])
{
    if (position.x >= params.width || position.y >= params.height) {
        return;
    }
    
    uint index = position.y * params.width + position.x;
    
    // 计算当前位置到水滴中心的距离
    float2 currentPos = float2(position) / float2(params.width - 1, params.height - 1);
    float2 center = dropCenter;
    float dist = distance(currentPos, center);
    
    // 如果在水滴半径内，添加高度
    if (dist < radius) {
        float factor = 1.0f - (dist / radius);
        float drop = amplitude * factor * factor; // 平方衰减
        heights[index] += drop;
    }
}

// 预计算三角函数值
kernel void precomputeTrigValues(
    constant WaterComputeParams& params [[buffer(0)]],
    device float* sin_px [[buffer(1)]],
    device float* cos_px [[buffer(2)]],
    device float* sin_qy [[buffer(3)]],
    device float* cos_qy [[buffer(4)]],
    uint2 position [[thread_position_in_grid]])
{
    uint p = position.x;
    uint x = position.y;
    
    if (p >= params.max_p || x >= params.width) {
        return;
    }
    
    uint index = p * params.width + x;
    float kx = M_PI_F * (p + 1) * x / (params.lx * (params.width - 1));
    
    sin_px[index] = sin(kx);
    cos_px[index] = cos(kx);
    
    // 同样处理y方向
    uint q = position.x;
    uint y = position.y;
    
    if (q >= params.max_q || y >= params.height) {
        return;
    }
    
    uint index_y = q * params.height + y;
    float ky = M_PI_F * (q + 1) * y / (params.ly * (params.height - 1));
    
    sin_qy[index_y] = sin(ky);
    cos_qy[index_y] = cos(ky);
} 