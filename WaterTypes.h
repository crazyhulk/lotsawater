#ifndef WaterTypes_h
#define WaterTypes_h

#include <simd/simd.h>

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