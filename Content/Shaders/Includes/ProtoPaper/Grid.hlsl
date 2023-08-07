#ifndef __XV_PROTOPAPER_GRID_DEFINED
#define __XV_PROTOPAPER_GRID_DEFINED

#include "../Common/Transforms.hlsl"
#include "../Common/Colors.hlsl"
#include "./Variables.hlsl"

// =======================================================
// VARIABLE HELPERS | GRID
// =======================================================
// is grid enabled
bool _XV_ProtoPaper_IsGridEnabled() 
{
    return _XV_ProtoPaper_Grid.x > 0;
}

// is grid text enabled
bool _XV_ProtoPaper_IsGridTextEnabled() 
{
    return _XV_ProtoPaper_Grid.y > 0;
}

// grid size
float _XV_ProtoPaper_GetGridSize() 
{
    return _XV_ProtoPaper_GridData.x;
}

// grid border
float _XV_ProtoPaper_GetGridBorder() 
{
    return _XV_ProtoPaper_GridData.y;
}

// grid distance fade
float _XV_ProtoPaper_GetGridDistanceFade()
{
    return _XV_ProtoPaper_GridData.w;
}

// =======================================================
// VARIABLE HELPERS | SUBGRID
// =======================================================
// subgrid enabled
bool _XV_ProtoPaper_IsSubgridEnabled() 
{
    return _XV_ProtoPaper_Subgrid.x > 0;
}

// subgrid text enabled
bool _XV_ProtoPaper_IsSubgridTextEnabled() 
{
    return _XV_ProtoPaper_Subgrid.y > 0;
}

// subgrid size
float _XV_ProtoPaper_GetSubgridSize() 
{
    return _XV_ProtoPaper_GetGridSize() / floor(_XV_ProtoPaper_SubgridData.x);
}

// subgrid border
float _XV_ProtoPaper_GetSubgridBorder() 
{
    return _XV_ProtoPaper_GetGridBorder();
}

// subgrid distance fade
float _XV_ProtoPaper_GetSubgridDistanceFade()
{
    return _XV_ProtoPaper_SubgridData.w;
}

// =======================================================
// COMMON
// =======================================================
float3 _XV_ProtoPaper_GetCellUV_3D
(
    float IN_CellSize,
    float IN_EdgeSize
)
{
    // =====================================================
    // Prepare sizes
    // =====================================================
    float cellSize = IN_CellSize;
    float edgeSize = IN_CellSize * IN_EdgeSize;
    float halfEdgeSize = edgeSize * 0.5;

    // =====================================================
    // Prepare position
    // =====================================================
    float3 position = _XV_ProtoPaper_PositionRotated;
    // add half of edge offset to position
    // position += float3(
    //     halfEdgeSize * (position.x > 0 ? 1 : -1), 
    //     halfEdgeSize * (position.y > 0 ? 1 : -1), 
    //     halfEdgeSize * (position.z > 0 ? 1 : -1)
    // );

    // =====================================================
    // Get position modulo by cell size
    // =====================================================
    float3 mod = abs(position % cellSize);

    float3 uvi = mod / cellSize;

    #if defined(_XV_PROTOPAPER_ORIENTATION_LOCAL)
    if (position.x > 0) uvi.x = 1 - uvi.x;
    // else uvi.x -= halfEdgeSize;
    if (position.y > 0) 
    {
        uvi.y = 1 - uvi.y;
    }
    else
    {
        // uvi.y -= edgeSize;
    }
    if (position.z > 0) uvi.z = 1 - uvi.z;
    #else
    if (position.x < 0) uvi.x = 1 - uvi.x;
    if (position.y < 0) uvi.y = 1 - uvi.y;
    if (position.z < 0) uvi.z = 1 - uvi.z;
    #endif

    return uvi;
}

float2 _XV_ProtoPaper_GetCellUV
(
    float IN_CellSize,
    float IN_EdgeSize
)
{
    float3 uv_3d = _XV_ProtoPaper_GetCellUV_3D(IN_CellSize, IN_EdgeSize);

    float3 normal = abs(_XV_ProtoPaper_Normal);
    float2 uv = float2(0, 0);

    uv = lerp(uv, uv_3d.xz, normal.y);
    uv = lerp(uv, uv_3d.zy, normal.x);
    uv = lerp(uv, uv_3d.xy, normal.z);

    if (normal.y > normal.x && normal.y > normal.z)
    {
        uv = uv_3d.xz;
    }
    else if (normal.x > normal.z && normal.x > normal.y)
    {
        uv = uv_3d.zy;
    }
    else
    {
        uv = uv_3d.xy;
    }

    float thres = 0.000004;
    if (_XV_ProtoPaper_Normal.x < -thres) uv.x = 1 - uv.x;
    if (_XV_ProtoPaper_Normal.z > thres) uv.x = 1 - uv.x;

    // uv = (uv, uv_3d.xy, normal.z);
    // uv = (uv, uv_3d.zy, normal.x);

    // uv = uv_3d.xz;
    // uv = normal.y;

    // return uv_3d.xz;
    return uv;
}

float3 _XV_ProtoPaper_GetCellEdges
(
    float IN_CellSize, 
    float IN_EdgeSize
) 
{
    // =====================================================
    // Prepare sizes
    // =====================================================
    float cellSize = IN_CellSize;
    float edgeSize = IN_CellSize * IN_EdgeSize;
    float halfEdgeSize = edgeSize * 0.5; 

    // =====================================================
    // Prepare position
    // =====================================================
    float3 position = _XV_ProtoPaper_PositionRotated;
    // add half of edge offset to position
    position += float3(
        halfEdgeSize * (position.x > 0 ? 1 : -1), 
        halfEdgeSize * (position.y > 0 ? 1 : -1), 
        halfEdgeSize * (position.z > 0 ? 1 : -1)
    );

    // =====================================================
    // Get position modulo by cell size
    // =====================================================
    float3 mod = abs(position % cellSize);

    return float3
    (
        mod.x < edgeSize,
        mod.y < edgeSize,
        mod.z < edgeSize
    );
}

float _XV_ProtoPaper_GetCellFadeValue
(
    float IN_CellSize,
    float IN_DistanceFade
)
{
    if (IN_DistanceFade == 0) return 1;

    float dist = distance(_XV_ProtoPaper_CameraPosition, _XV_ProtoPaper_PositionAWS);
    float fade = IN_DistanceFade * IN_CellSize / (1 - _XV_ProtoPaper_GetGridBorder());
    return 1 - saturate(dist / fade);
}

float4 _XV_ProtoPaper_FadeCell
(
    float4 IN_Color,
    float IN_CellSize,
    float IN_DistanceFade
)
{
    float fade = _XV_ProtoPaper_GetCellFadeValue(IN_CellSize, IN_DistanceFade);
    float4 color = IN_Color;
    color.a *= fade;

    return color;
}

float4 _XV_ProtoPaper_GetCellColor
(
    bool IN_Enabled,
    float IN_CellSize,
    float IN_EdgeSize,
    float IN_DistanceFade,
    float4 IN_Color
)
{
    float4 color = float4(0, 0, 0, 0);
    if (IN_Enabled)
    {
        float2 uv = _XV_ProtoPaper_GetCellUV(
            IN_CellSize,
            IN_EdgeSize
        );

        if 
        (
            uv.x < IN_EdgeSize ||
            uv.x > 1 - IN_EdgeSize ||
            uv.y < IN_EdgeSize ||
            uv.y > 1 - IN_EdgeSize
        )
        {
            color = IN_Color;
        }
    }

    return color;
}

float4 _XV_ProtoPaper_GetCellColor
(
    bool IN_DrawGrid,
    bool IN_DrawSubgrid
)
{
    float4 color = float4(0, 0, 0, 0);
    float4 cellColor;

    // ========================================================
    // SUBGRID
    // ========================================================
    if (IN_DrawSubgrid)
    {
        cellColor = _XV_ProtoPaper_GetCellColor
        (
            _XV_ProtoPaper_IsSubgridEnabled(),
            _XV_ProtoPaper_GetSubgridSize(),
            _XV_ProtoPaper_GetSubgridBorder(),
            _XV_ProtoPaper_GetSubgridDistanceFade(),
            _XV_ProtoPaper_SubgridColor
        );
        cellColor = _XV_ProtoPaper_FadeCell(cellColor, _XV_ProtoPaper_GetSubgridSize(), _XV_ProtoPaper_GetSubgridDistanceFade());
        color = lerp(color, cellColor, cellColor.a);
    }

    // ========================================================
    // GRID
    // ========================================================
    if (IN_DrawGrid)
    {
        cellColor = _XV_ProtoPaper_GetCellColor
        (
            _XV_ProtoPaper_IsGridEnabled(),
            _XV_ProtoPaper_GetGridSize(),
            _XV_ProtoPaper_GetGridBorder(),
            _XV_ProtoPaper_GetGridDistanceFade(),
            _XV_ProtoPaper_GridColor
        );
        cellColor = _XV_ProtoPaper_FadeCell(cellColor, _XV_ProtoPaper_GetGridSize(), _XV_ProtoPaper_GetGridDistanceFade());
        color = lerp(color, cellColor, cellColor.a);
    }

    return color;
}

float4 _XV_ProtoPaper_GetCellColor
(
    bool IN_DrawGrid,
    bool IN_DrawSubgrid,
    float4 IN_Color
) 
{
    float4 color = _XV_ProtoPaper_GetCellColor(IN_DrawGrid, IN_DrawSubgrid);
    return lerp(IN_Color, color, color.a);
}

#endif