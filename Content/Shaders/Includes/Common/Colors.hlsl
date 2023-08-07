#ifndef __XV_COLORS_DEFINED
#define __XV_COLORS_DEFINED

float4 _XV_ToRGBA(float3 rgb, float a)
{
    return float4(rgb.r, rgb.g, rgb.b, a);
}

#endif