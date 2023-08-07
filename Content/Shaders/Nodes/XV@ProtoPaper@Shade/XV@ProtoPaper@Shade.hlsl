#include "../../Includes/Common/Colors.hlsl"
#include "../../Includes/ProtoPaper/Variables.hlsl"

void _XV_ProtoPaper_Shade_float
(
    float4 IN_Color,
    out float4 OUT_Color
)
{
    // OUT_Color = IN_Color;
    // return;

    // ======================================================================
    // 1) Absolute normal (we don't need negative values)
    // ======================================================================
    float3 normal = abs(_XV_ProtoPaper_Normal);

    // ======================================================================
    // 2) Calculate shade by normals
    // ======================================================================
    float shade = 0;
    shade = lerp(shade, 1, normal.y);
    shade = lerp(shade, 0.8, normal.x);
    shade = lerp(shade, 0.6, normal.z);

    // ======================================================================
    // 3) Brightening color if it's too dark
    // ======================================================================
    float3 color = IN_Color.xyz;
    if (length(IN_Color.xyz) < 0.1)
    {
        color += float3(1, 1, 1) * 0.1;
        shade = 1 - shade;
    }
    
    // ======================================================================
    // 4) Lerpt to normals a bit
    // ======================================================================
    float len = length(IN_Color.xyz);
    color = lerp(color, normal, clamp(len * 0.05, 0.005, 1));

    // ======================================================================
    // 5) Apply shade
    // ======================================================================
    OUT_Color = _XV_ToRGBA(color * shade, IN_Color.a);
}