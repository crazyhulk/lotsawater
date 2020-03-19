#ifndef __WATER_H__
#define __WATER_H__

#include "GLObject/Vector/Vector.h"

typedef struct WaterState WaterState;
typedef struct Water Water;

struct WaterState
{
	int max_p,max_q;
	float *apq,*bpq;
};

void InitWaterState(WaterState *self,int max_p,int max_q);
void InitRandomWaterState(WaterState *self,Water *water);
void InitDripWaterState(WaterState *self,Water *water,float x0,float y0,float d,float ampl);
void CleanupWaterState(WaterState *self);

struct Water
{
	int w,h,max_p,max_q;

	float v,b,lx,ly;

	float t0;
	WaterState state;

	float *wpq;
	float *ampl;
	float *sin_px,*sin_qy;
	float *cos_px,*cos_qy;
	float *z;
	vec3_t *n;
};

void InitSimpleWater(Water *self,int w,int h,float v,float b,float lx,float ly);
void InitWater(Water *self,int w,int h,int max_p,int max_q,float v,float b,float lx,float ly);
void CleanupWater(Water *self);

void CalculateWaterSurfaceAtTime(Water *self,float t);
void AddWaterStateAtTime(Water *self,WaterState *other,float t);

#endif
