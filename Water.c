#include "Water.h"
#include "LotsaCore/Random.h"

#include <stdlib.h>
#include <math.h>

//const complex cerf(const complex &z);

void InitWaterState(WaterState *self,int max_p,int max_q)
{
	self->max_p=max_p;
	self->max_q=max_q;

	self->apq=malloc(max_p*max_q*sizeof(float));
	self->bpq=malloc(max_p*max_q*sizeof(float));

	int i=0;
	for(int q=0;q<max_q;q++)
	for(int p=0;p<max_p;p++)
	{
		self->apq[i]=self->bpq[i]=0;
		i++;
	}
}

void InitRandomWaterState(WaterState *self,Water *water)
{
	InitWaterState(self,water->max_p,water->max_q);

	int i=0;
	for(int q=0;q<water->max_q;q++)
	for(int p=0;p<water->max_p;p++)
	{
		if(water->wpq[i]>0)
		{
			self->apq[i]=0.03*(2*RandomFloat()-1)*expf(-0.01*water->wpq[i]*water->wpq[i]); // boltzmann distribution
			self->bpq[i]=0.03*(2*RandomFloat()-1)*expf(-0.01*water->wpq[i]*water->wpq[i]); // should fix the energy
		}
		else self->apq[i]=self->bpq[i]=0;

		i++;
	}
}

void InitDripWaterState(WaterState *self,Water *water,float x0,float y0,float d,float ampl)
{
	InitWaterState(self,water->max_p,water->max_q);

	int i=0;
	for(int q=0;q<water->max_q;q++)
	for(int p=0;p<water->max_p;p++)
	{
		self->apq[i]=0;

		self->bpq[i]=
		ampl*4.0f/(water->wpq[i]*water->lx*water->ly)*
		cosf(p*M_PI*x0/water->lx)*cosf(q*M_PI*y0/water->ly)*
		expf(-M_PI*M_PI*d*d*(p*p/(water->lx*water->lx)+q*q/(water->ly*water->ly))/4.0f)
/*		*0.5*(
			cerf(complex((water.lx-x0)/d,float(p)*M_PI*d/(2*water.lx))).re
			-cerf(complex(-x0/d,float(p)*M_PI*d/(2*water.lx))).re
		)
		*0.5*(
			cerf(complex((water.ly-y0)/d,float(q)*M_PI*d/(2*water.ly))).re
			-cerf(complex(-y0/d,float(q)*M_PI*d/(2*water.ly))).re
		)*/;

		if(p==0) self->bpq[i]/=2;
		if(q==0) self->bpq[i]/=2;

		i++;
	}
}

/*drip_state::drip_state(float x0,float y0,water &water):water_state(water.max_p,water.max_q)
{
	int i=0;
	for(int q=0;q<max_q;q++)
	for(int p=0;p<max_p;p++)
	{
		apq[i]=0;
		bpq[i]=0.003*4/(water.wpq[i]*water.lx*water.ly)*
		(cos(float(p)*M_PI*x0/water.lx)*cos(float(q)*M_PI*y0/water.ly));

		if(p==0) bpq[i]/=2;
		if(q==0) bpq[i]/=2;

		i++;
	}
}*/

void CleanupWaterState(WaterState *self)
{
	free(self->apq);
	free(self->bpq);
}






void InitSimpleWater(Water *self,int w,int h,float v,float b,float lx,float ly)
{
	InitWater(self,w,h,w,h,v,b,lx,ly);
}

void InitWater(Water *self,int w,int h,int max_p,int max_q,float v,float b,float lx,float ly)
{
	self->w=w;
	self->h=h;
	self->max_p=max_p;
	self->max_q=max_q;

	self->t0=0;
	InitWaterState(&self->state,max_p,max_q);

	self->wpq=malloc(max_p*max_q*sizeof(float));
	self->ampl=malloc(max_p*max_q*sizeof(float));
	self->sin_px=malloc(w*max_p*sizeof(float));
	self->cos_px=malloc(w*max_p*sizeof(float));
	self->sin_qy=malloc(h*max_q*sizeof(float));
	self->cos_qy=malloc(h*max_q*sizeof(float));
	self->z=malloc(w*h*sizeof(float));
	self->n=malloc(w*h*sizeof(vec3_t));

	self->v=v;
	self->b=b;
	self->lx=lx;
	self->ly=ly;

	int i;

	i=0;
	for(int q=0;q<max_q;q++)
	for(int p=0;p<max_p;p++)
	{
		float discr=p*p/(lx*lx)+q*q/(ly*ly)-b*b*v*v/(4*M_PI*M_PI); //-b*b*v*v/(2*M_PI*M_PI)

		if(discr>0) self->wpq[i]=v*M_PI*sqrtf(discr);
		else self->wpq[i]=-v*M_PI*sqrtf(-discr);
		i++;
	}

	i=0;
	for(int x=0;x<w;x++)
	for(int p=0;p<max_p;p++)
	{
		self->sin_px[i]=p*M_PI/lx*sinf(p*M_PI*x/(float)(w-1));
		self->cos_px[i]=cosf(p*M_PI*x/(float)(w-1));
		i++;
	}

	i=0;
	for(int y=0;y<h;y++)
	for(int q=0;q<max_q;q++)
	{
		self->sin_qy[i]=q*M_PI/ly*sinf(q*M_PI*y/(float)(h-1));
		self->cos_qy[i]=cosf(q*M_PI*y/(float)(h-1));
		i++;
	}

	i=0;
	for(int y=0;y<h;y++)
	for(int x=0;x<w;x++)
	{
		self->n[i].z=1;
		i++;
	}
}

void CleanupWater(Water *self)
{
	CleanupWaterState(&self->state);

	free(self->wpq);
	free(self->ampl);
	free(self->sin_px);
	free(self->cos_px);
	free(self->sin_qy);
	free(self->cos_qy);
	free(self->z);
	free(self->n);
}

void CalculateWaterSurfaceAtTime(Water *self,float t)
{
	int i;

	float decay=expf(-self->v*self->v*self->b*(t-self->t0)/2);

	i=0;
	for(int q=0;q<self->max_q;q++)
	for(int p=0;p<self->max_p;p++)
	{
		if(self->wpq[i]>=0)
		{
			self->ampl[i]=(
				self->state.apq[i]*cosf(self->wpq[i]*(t-self->t0))+
				self->state.bpq[i]*sinf(self->wpq[i]*(t-self->t0))
			)*decay;
		}
		else
		{
			self->ampl[i]=self->state.apq[i]*expf(self->wpq[i]*(t-self->t0));
		}

		i++;
	}

	i=0;
	for(int y=0;y<self->h;y++)
	for(int x=0;x<self->w;x++)
	{
		float z_curr=0;
		float ndzdx=0;
		float ndzdy=0;
		float *sin_px_ptr_start=&self->sin_px[x*self->max_p];
		float *cos_px_ptr_start=&self->cos_px[x*self->max_p];
		float *sin_qy_ptr=&self->sin_qy[y*self->max_q];
		float *cos_qy_ptr=&self->cos_qy[y*self->max_q];
		float *ampl_ptr=&self->ampl[0];

		for(int q=0;q<self->max_q;q++)
		{
			float *sin_px_ptr=sin_px_ptr_start;
			float *cos_px_ptr=cos_px_ptr_start;
			float ampl_cos=0;
			float ampl_sin=0;

			for(int p=0;p<self->max_p;p++)
			{
				float ampl=*ampl_ptr++;
				ampl_sin+=ampl*(*sin_px_ptr++);
				ampl_cos+=ampl*(*cos_px_ptr++);
			}

			ndzdx+=ampl_sin*(*cos_qy_ptr);
			ndzdy+=ampl_cos*(*sin_qy_ptr++);
			z_curr+=ampl_cos*(*cos_qy_ptr++);
		}

		self->z[i]=z_curr;
		self->n[i].x=ndzdx;
		self->n[i].y=ndzdy;

		i++;
	}

/*	i=0;
	for(int y=0;y<self->h;y++)
	for(int x=0;x<self->w;x++)
	{
		if(x==0||x==self->w-1) self->n[i].x=0;
		else self->n[i].x=(self->z[i-1]-self->z[i+1])*(self->w-1);

		if(y==0||y==self->h-1) self->n[i].y=0;
		else n[i].y=(self->z[i-self->w]-self->z[i+self->w])*(self->h-1);

		self->n[i].z=2.0;

		i++;
	}*/
}

void AddWaterStateAtTime(Water *self,WaterState *other,float t)
{
	float decay=expf(-self->v*self->v*self->b*(t-self->t0)/2);

	int i=0;
	for(int q=0;q<self->max_q;q++)
	for(int p=0;p<self->max_p;p++)
	{
		float napq,nbpq;

		if(self->wpq[i]>0)
		{
			napq=
			self->state.apq[i]*cosf(self->wpq[i]*(t-self->t0))+
			self->state.bpq[i]*sinf(self->wpq[i]*(t-self->t0));

			nbpq=
			-self->state.apq[i]*sinf(self->wpq[i]*(t-self->t0))+
			self->state.bpq[i]*cosf(self->wpq[i]*(t-self->t0));
		}
		else
		{
			napq=self->state.apq[i]*expf(self->wpq[i]*(t-self->t0));
			nbpq=0;
		}

		self->state.apq[i]=napq*decay+other->apq[i];
		self->state.bpq[i]=nbpq*decay+other->bpq[i];
		i++;
	}

	self->t0=t;
}
