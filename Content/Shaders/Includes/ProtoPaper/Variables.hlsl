#ifndef __XV_PROTOPAPER_VARIABLES_DEFINED
#define __XV_PROTOPAPER_VARIABLES_DEFINED

// Geometry
float3 _XV_ProtoPaper_Position;
float3 _XV_ProtoPaper_PositionAWS;
float3 _XV_ProtoPaper_PositionRotated;
float3 _XV_ProtoPaper_Normal;
float3 _XV_ProtoPaper_Tangent;
float3 _XV_ProtoPaper_Bitangent;
float3 _XV_ProtoPaper_CameraPosition;

// Cell
float2 _XV_ProtoPaper_CellTextScale;

// Grid
float4 _XV_ProtoPaper_Grid; // x = grid enabled, y = text enabled
float4 _XV_ProtoPaper_GridData; // x = size, y = border
float4 _XV_ProtoPaper_GridColor; // rgba color of the grid

// Subgrid
float4 _XV_ProtoPaper_Subgrid; // x = subgrid enabled, y = text enabled
float4 _XV_ProtoPaper_SubgridData; // x = cells
float4 _XV_ProtoPaper_SubgridColor; // rgba color of the subgrid

// Background
float4 _XV_ProtoPaper_BackgroundColor;  // background color (from texture)
float4 _XV_ProtoPaper_BackgroundTint;   // background tint
float4 _XV_ProtoPaper_BackgroundTintedColor;       // tinted background color

// Text
Texture2D _XV_ProtoPaper_SymbolsTexture;
SamplerState _XV_ProtoPaper_SymbolsSampler;

#endif