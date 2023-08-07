#include "../../Includes/Common/Colors.hlsl"
#include "../../Includes/ProtoPaper/Variables.hlsl"
#include "../../Includes/ProtoPaper/Grid.hlsl"

void _XV_ProtoPaper_Ruler_float
(
    out float4 OUT_Color
)
{
    float4 color = _XV_ProtoPaper_GetCellColor(true, true, float4(0, 0, 0, 0));

    OUT_Color = color;
}