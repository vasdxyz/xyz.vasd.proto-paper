#ifndef __XV_PROTOPAPER_TEXT_DEFINED
#define __XV_PROTOPAPER_TEXT_DEFINED

#include "../Common/Transforms.hlsl"
#include "./Variables.hlsl"

float4 _XV_ProtoPaper_SplitNumber(float number)
{
    float num = floor(abs(number));
    float4 digits = float4(0, 0, 0, 0);

    digits.x = floor(num / 1000.0f); // Get the thousands digit
    num -= digits.x * 1000.0f;

    digits.y = floor(num / 100.0f); // Get the hundreds digit
    num -= digits.y * 100.0f;

    digits.z = floor(num / 10.0f);  // Get the tens digit
    num -= digits.z * 10.0f;

    digits.w = num; // Get the ones digit

    return digits;
}


float4 _XV_ProtoPaper_GetTextAtlasRect
(
    // 0-9 = numbers 
    // 10 = minus sign
    // 11 = "U" symbol
    float IN_Value 
) 
{
    float2 position = float2(0, 0);

    if (IN_Value == 0) position = float2(0,0);
    else if (IN_Value == 1) position = float2(0,3);
    else if (IN_Value == 2) position = float2(1,3);
    else if (IN_Value == 3) position = float2(2,3);
    else if (IN_Value == 4) position = float2(0,2);
    else if (IN_Value == 5) position = float2(1,2);
    else if (IN_Value == 6) position = float2(2,2);
    else if (IN_Value == 7) position = float2(0,1);
    else if (IN_Value == 8) position = float2(1,1);
    else if (IN_Value == 9) position = float2(2,1);
    // minus sign
    else if (IN_Value == 10) position = float2(1,0);
    // "U" symbol
    else if (IN_Value == 11) position = float2(2,0);
    // x
    else if (IN_Value == 12) position = float2(3,3);
    // y
    else if (IN_Value == 13) position = float2(3,2);
    // z
    else if (IN_Value == 14) position = float2(3,1);

    float2 offset = float2(0.25,0.25) * position;
    float2 size = offset + float2(0.25,0.25);

    float correction = -0.002;
    return float4(offset.x + correction, offset.y + correction, size.x - correction, size.y - correction);
}

float4 _XV_ProtoPaper_SampleTextAtlas
(
    float4 IN_AtlasRect,
    float4 IN_TargetRect,
    float2 IN_UV
) 
{
    if (!_XV_IsInsideRect(IN_UV, IN_TargetRect))
    {
        return float4(0, 0, 0, 0);
    }

    float2 uv;

    uv = _XV_GetUVInsideRect(IN_UV, IN_TargetRect);
    float2 size = IN_AtlasRect.zw - IN_AtlasRect.xy;
    uv = IN_AtlasRect.xy + size * uv;

    return _XV_ProtoPaper_SymbolsTexture.Sample(_XV_ProtoPaper_SymbolsSampler, uv);
}

float4 _XV_ProtoPaper_GetCharRect
(
    float4 IN_Rect,
    float IN_CharWidth,
    float IN_Position
)
{
    float4 rect = IN_Rect;
    rect.x += IN_CharWidth * IN_Position;
    rect.z = rect.x + IN_CharWidth;

    return rect;
}

float4 _XV_ProtoPaper_SampleText
(
    float IN_Prefix,
    float4 IN_Digits,
    float IN_Postfix,

    float2 IN_UV,
    float4 IN_TextRect
)
{
    if (!_XV_IsInsideRect(IN_UV, IN_TextRect)) return float4(0, 0, 0, 0);

    float textWidth = IN_TextRect.z - IN_TextRect.x;
    float charWidth = textWidth / 6; // -1234u

    float2 uv = _XV_GetUVInsideRect(IN_UV, IN_TextRect);
    float position = floor((IN_UV.x - IN_TextRect.x) / charWidth);

    float4 charRect;
    float4 atlasRect;

    charRect = _XV_ProtoPaper_GetCharRect(IN_TextRect, charWidth, position);
    if (position == 0)
    {
        if (IN_Prefix == -1 || IN_Digits.x == 0) return float4(0, 0, 0, 0);
        atlasRect = _XV_ProtoPaper_GetTextAtlasRect(IN_Prefix); // prefix symbol
    }
    else if (position == 1)
    {
        if (IN_Digits.x == 0) 
        {
            if (IN_Digits.y != 0 && IN_Prefix > -1)
            {
                atlasRect = _XV_ProtoPaper_GetTextAtlasRect(IN_Prefix);
            }
            else return float4(0, 0, 0, 0);
        }
        else atlasRect = _XV_ProtoPaper_GetTextAtlasRect(IN_Digits.x);
    }
    else if (position == 2)
    {
        if (IN_Digits.x == 0 && IN_Digits.y == 0) 
        {
            if (IN_Digits.z != 0 && IN_Prefix > -1)
            {
                atlasRect = _XV_ProtoPaper_GetTextAtlasRect(IN_Prefix);
            }
            else return float4(0, 0, 0, 0);
        }        
        else atlasRect = _XV_ProtoPaper_GetTextAtlasRect(IN_Digits.y);
    }
    else if (position == 3)
    {
        if (IN_Digits.x == 0 && IN_Digits.y == 0 && IN_Digits.z == 0) 
        {
            if (IN_Digits.w != 0 && IN_Prefix > -1)
            {
                atlasRect = _XV_ProtoPaper_GetTextAtlasRect(IN_Prefix);
            }
            else return float4(0, 0, 0, 0);
        }
        else atlasRect = _XV_ProtoPaper_GetTextAtlasRect(IN_Digits.z);
    }
    else if (position == 4)
    {
        atlasRect = _XV_ProtoPaper_GetTextAtlasRect(IN_Digits.w);
    }
    else
    {
        if (IN_Postfix == -1) return float4(0, 0, 0, 0);
        atlasRect = _XV_ProtoPaper_GetTextAtlasRect(IN_Postfix);
    }

    float4 color = _XV_ProtoPaper_SampleTextAtlas(atlasRect, charRect, IN_UV);
    return color;
}

#endif