#ifndef WaterTypes_h
#define WaterTypes_h

#include <simd/simd.h>

// Metal着色器常量结构体
typedef struct {
    simd_float4x4 modelViewProjectionMatrix;
    simd_float4x4 normalMatrix;
    float time;
    float waterDepth;
    simd_float2 waterSize;
    simd_float2 textureSize;
    float imageFade;
} MetalConstants;

// 水波纹计算参数
typedef struct {
    uint32_t width;
    uint32_t height;
    uint32_t max_p;
    uint32_t max_q;
    float time;
    float depth;
    float damping;
    float speed;
    float v; // 波速
    float b; // 阻尼
    float lx; // x方向长度
    float ly; // y方向长度
    float t0; // 起始时间
} WaterComputeParams;

// 水波纹状态结构体
typedef struct {
    int max_p;
    int max_q;
    float *apq;
    float *bpq;
} MetalWaterState;

// 水波纹参数结构体
typedef struct {
    int w;
    int h;
    int max_p;
    int max_q;
    float v;
    float b;
    float lx;
    float ly;
    float t0;
    float *wpq;
    float *ampl;
    float *sin_px;
    float *sin_qy;
    float *cos_px;
    float *cos_qy;
    float *z;
    vector_float3 *n;
} MetalWaterParams;

#endif /* WaterTypes_h */ 