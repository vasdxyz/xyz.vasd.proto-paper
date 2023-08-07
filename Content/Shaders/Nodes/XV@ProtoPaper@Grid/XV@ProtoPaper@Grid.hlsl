#include "../../Includes/Common/Colors.hlsl"
#include "../../Includes/ProtoPaper/Variables.hlsl"
#include "../../Includes/ProtoPaper/Grid.hlsl"
#include "../../Includes/ProtoPaper/Text.hlsl"

float4 _XV_ProtoPaper_GetCellPositionText
(
    float IN_Num,
    float IN_GridBorder,
    float IN_Offset,
    float IN_Postfix,    
    float2 IN_UV,
    float4 IN_Color,
    float4 IN_TextColor
)
{
    // if (abs(IN_Num) < 1) return IN_Color;
    float4 digits = _XV_ProtoPaper_SplitNumber(IN_Num);

    float width = _XV_ProtoPaper_CellTextScale.x * (1 - (IN_GridBorder * 2));
    float height = _XV_ProtoPaper_CellTextScale.y * (1 - (IN_GridBorder * 2));
 
    float x = 1 - IN_GridBorder - width;
    float x2 = x + width;
    float y = 1 - IN_GridBorder - height;
    float y2 = y + height;

    width = _XV_ProtoPaper_CellTextScale.x * 0.5 * (1 - (IN_GridBorder * 2));
    height = _XV_ProtoPaper_CellTextScale.y * 0.5 * (1 - (IN_GridBorder * 2));
    x = 1 - IN_GridBorder - width;
    x2 = x + width;
    y = y - height;
    y2 = y + height;

    y -= height * IN_Offset;
    y2 -= height * IN_Offset;

    float4 textColor = _XV_ProtoPaper_SampleText
    (
        IN_Num < 0 ? 10 : -1, // 10 = minus sign
        digits,
        IN_Postfix, // postfix
        IN_UV,
        float4(x, y, x2, y2)
    );
    return lerp(IN_Color, IN_TextColor * textColor.a, textColor.a);
}

float4 _XV_ProtoPaper_GetCellText
(
    bool IN_Enabled,
    bool IN_Ruler,
    float IN_GridSize,
    float IN_GridBorder,
    float IN_DistanceFade,
    float4 IN_Color
)
{
    if (!IN_Enabled) return float4(0, 0, 0, 0);
    if (IN_GridSize < 1) return float4(0, 0, 0, 0);

    float threshold = 0.5;
    float3 normal = abs(_XV_ProtoPaper_Normal);
    if (normal.x < threshold && normal.y < threshold && normal.z < threshold) return float4(0, 0, 0, 0);

    float2 uv = _XV_ProtoPaper_GetCellUV(
        IN_GridSize,
        IN_GridBorder
    );

    // ====================================================================
    // CELL SIZE
    // ====================================================================
    float4 digits = _XV_ProtoPaper_SplitNumber(IN_GridSize);

    float width = _XV_ProtoPaper_CellTextScale.x * (1 - (IN_GridBorder * 2));
    float height = _XV_ProtoPaper_CellTextScale.y * (1 - (IN_GridBorder * 2));

    float x = 1 - IN_GridBorder - width;
    float x2 = x + width;
    float y = 1 - IN_GridBorder - height;
    float y2 = y + height;

    float4 textColor = _XV_ProtoPaper_SampleText
    (
        -1, // prefix
        digits,
        11, // postfix, 11 = "U" symbol
        uv,
        float4(x, y, x2, y2)
    );
    float4 color = IN_Color * textColor.a;

    // ====================================================================
    // CELL POSITION
    // ====================================================================
    if (IN_GridSize >= 1)
    {
        float3 position = _XV_ProtoPaper_PositionRotated;
        if (abs(position.y) < 0.001) position.y = 0; 
        position = floor(position / floor(IN_GridSize)) * floor(IN_GridSize);
        float colorize = 0.3;

        #if defined(_XV_PROTOPAPER_ORIENTATION_LOCAL)
        position *= -1;
        #endif

        // ====================================================================
        // CELL POSITION: X
        // ====================================================================
        color = _XV_ProtoPaper_GetCellPositionText
        (
            position.x,
            IN_GridBorder,
            0,
            12,
            uv,
            color,
            lerp(IN_Color, float4(1, 0, 0, 1), colorize)
        );
        // color = lerp(color, IN_Color * textColor.a, textColor.a);

        // ====================================================================
        // CELL POSITION: Y
        // ====================================================================
        color = _XV_ProtoPaper_GetCellPositionText
        (
            position.y,
            IN_GridBorder,
            1,
            13,
            uv,
            color,
            lerp(IN_Color, float4(0, 1, 0, 1), colorize)
        );
        // if (position.y < 0) color = float4(0, 1, 0, 1);

        // ====================================================================
        // CELL POSITION: Z
        // ====================================================================
        color = _XV_ProtoPaper_GetCellPositionText
        (
            position.z,
            IN_GridBorder,
            2,
            14,
            uv,
            color,
            lerp(IN_Color, float4(0, 0, 1, 1), colorize)
        );
    }
 
    return _XV_ProtoPaper_FadeCell(color, IN_GridSize, IN_DistanceFade);
}

void _XV_ProtoPaper_Grid_float
(
    out float4 OUT_Color
)
{
    // =================================================
    // CELL
    // =================================================
    // just background
    float4 color = _XV_ProtoPaper_BackgroundTintedColor;
    
    // =================================================
    // TEXT
    // =================================================
    color = _XV_ProtoPaper_GetCellColor(false, true, color);
    float4 textColor = _XV_ProtoPaper_GetCellText
    (
        _XV_ProtoPaper_IsSubgridTextEnabled(),
        false, // not ruler
        _XV_ProtoPaper_GetSubgridSize(),
        _XV_ProtoPaper_GetSubgridBorder(),
        _XV_ProtoPaper_GetSubgridDistanceFade(),
        _XV_ProtoPaper_SubgridColor * float4(1, 1, 1, 0.8)
    );
    color = lerp(color, textColor, textColor.a);

    color = _XV_ProtoPaper_GetCellColor(true, false, color);
    textColor = _XV_ProtoPaper_GetCellText
    (
        _XV_ProtoPaper_IsGridTextEnabled(),
        false, // not ruler
        _XV_ProtoPaper_GetGridSize(),
        _XV_ProtoPaper_GetGridBorder(),
        _XV_ProtoPaper_GetGridDistanceFade(),
        _XV_ProtoPaper_GridColor
    );
    color = lerp(color, textColor, textColor.a);

    // =================================================
    // RESULT
    // =================================================
    OUT_Color = color;
}