#ifndef __XV_TRANSFORMS_DEFINED
#define __XV_TRANSFORMS_DEFINED

// Function to calculate the normal matrix (inverse transpose) of a 4x4 matrix
float3x3 _XV_NormalizeMatrix(float4x4 in_matrix)
{
    float3x3 normalMatrix;
    normalMatrix[0] = normalize(in_matrix[0].xyz);
    normalMatrix[1] = normalize(in_matrix[1].xyz);
    normalMatrix[2] = normalize(in_matrix[2].xyz);
    return normalMatrix;
}

// Function to rotate a position using the inverse transpose of the model matrix (UNITY_MATRIX_I_M)
float3 _XV_MultipleByMatrix(float3 in_position, float4x4 in_matrix)
{
    // Calculate the normal matrix (inverse transpose) of the model matrix (UNITY_MATRIX_I_M)
    float3x3 normalMatrix = _XV_NormalizeMatrix(in_matrix);

    // Rotate the position using the normal matrix
    float3 rotatedPosition = mul(normalMatrix, in_position);

    // Return the rotated position
    return rotatedPosition;
}

// Function to rotate a position using the inverse transpose of the model matrix (UNITY_MATRIX_I_M)
float3 _XV_MultipleByInverseModelMatrix(float3 in_position)
{
    return _XV_MultipleByMatrix(in_position, UNITY_MATRIX_I_M);
}

bool _XV_IsInsideRect
(
    float2 IN_Position, 
    float4 IN_Rect
)
{
    return (
        IN_Position.x >= IN_Rect.x && 
        IN_Position.x <= IN_Rect.z && 
        IN_Position.y >= IN_Rect.y && 
        IN_Position.y <= IN_Rect.w
    );
}

float2 _XV_GetUVInsideRect
(
    float2 IN_Position,
    float4 IN_Rect
)
{
    float2 rectSize = IN_Rect.zw - IN_Rect.xy;
    float2 offset = IN_Position - IN_Rect.xy;

    if (rectSize.x == 0 && rectSize.y == 0){
        return float2(0, 0);
    }

    return offset / rectSize;
}

#endif