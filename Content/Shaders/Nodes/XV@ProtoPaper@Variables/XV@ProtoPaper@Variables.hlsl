#include "../../Includes/Common/Transforms.hlsl"
#include "../../Includes/ProtoPaper/Variables.hlsl"

void _XV_ProtoPaper_Variables_float
(
    float3 IN_Position,
    float3 IN_PositionAWS,
    float3 IN_Normal,
    float3 IN_Tangent,
    float3 IN_Bitangent,
    float3 IN_CameraPosition,

    // Cell
    float IN_TextScale,

    // Grid
    float4 IN_Grid,
    float4 IN_GridData,
    float4 IN_GridColor,

    // Subgrid
    float4 IN_Subgrid,
    float4 IN_SubgridData,
    float4 IN_SubgridColor,

    // Background
    float4 IN_BackgroundColor,
    float4 IN_BackgroundTint,

    Texture2D IN_SymbolsTexture,
    SamplerState IN_SymbolsSampler,

    out bool OUT_Variables
)
{
    IN_GridData.x = floor(IN_GridData.x);
    IN_SubgridData.x = floor(IN_SubgridData.x);

    // ===========================================================
    // GEOMETRY
    // ===========================================================
    _XV_ProtoPaper_Position = IN_Position;
    _XV_ProtoPaper_PositionAWS = IN_PositionAWS;
    _XV_ProtoPaper_PositionRotated = _XV_MultipleByInverseModelMatrix(IN_Position);

    // Normal
    #if defined(_XV_PROTOPAPER_ORIENTATION_LOCAL)
    _XV_ProtoPaper_Normal = IN_Normal;
    #else
    _XV_ProtoPaper_Normal = _XV_MultipleByInverseModelMatrix(IN_Normal);
    #endif

    _XV_ProtoPaper_Tangent = IN_Tangent;
    _XV_ProtoPaper_Bitangent = IN_Bitangent;
    _XV_ProtoPaper_CameraPosition = IN_CameraPosition;

    // ===========================================================
    // CELL
    // ===========================================================
    _XV_ProtoPaper_CellTextScale = IN_TextScale;
    _XV_ProtoPaper_CellTextScale.y = _XV_ProtoPaper_CellTextScale.x / 4;

    // ===========================================================
    // GRID
    // ===========================================================
    _XV_ProtoPaper_Grid = IN_Grid;
    _XV_ProtoPaper_GridData = IN_GridData;
    _XV_ProtoPaper_GridColor = IN_GridColor;

    // ===========================================================
    // SUBGRID
    // ===========================================================
    _XV_ProtoPaper_Subgrid = IN_Subgrid;
    _XV_ProtoPaper_SubgridData = IN_SubgridData;
    _XV_ProtoPaper_SubgridColor = IN_SubgridColor;

    // ===========================================================
    // BACKGROUND
    // ===========================================================
    _XV_ProtoPaper_BackgroundColor = IN_BackgroundColor;
    _XV_ProtoPaper_BackgroundTint = IN_BackgroundTint;
    _XV_ProtoPaper_BackgroundTintedColor = _XV_ProtoPaper_BackgroundColor * _XV_ProtoPaper_BackgroundTint;

    // ===========================================================
    // TEXT
    // ===========================================================
    _XV_ProtoPaper_SymbolsTexture = IN_SymbolsTexture;
    _XV_ProtoPaper_SymbolsSampler = IN_SymbolsSampler;

    OUT_Variables = true;
}

void _XV_ProtoPaper_Variables_float
(
    float4 IN_BackgroundColor,
    out bool OUT_Variables
)
{
    _XV_ProtoPaper_BackgroundColor = IN_BackgroundColor;
    _XV_ProtoPaper_BackgroundTintedColor = _XV_ProtoPaper_BackgroundColor * _XV_ProtoPaper_BackgroundTint;
    OUT_Variables = true;
}
