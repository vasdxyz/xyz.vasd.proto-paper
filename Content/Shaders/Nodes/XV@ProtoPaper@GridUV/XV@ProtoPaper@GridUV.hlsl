#include "../../Includes/ProtoPaper/Grid.hlsl"

void _XV_ProtoPaper_UV_float
(
    bool IN_Variables,

    out float2 OUT_UV
)
{
    OUT_UV = _XV_ProtoPaper_GetCellUV
    (
        _XV_ProtoPaper_GetGridSize(),
        _XV_ProtoPaper_GetGridBorder()
    );
}