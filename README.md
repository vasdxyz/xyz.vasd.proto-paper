# Xyz.Vasd.ProtoShaders
Contains shaders for prototype grid and ruler.
It's based on `Shader Graph` with few custom `.hlsl` functions and includes.

There are two shaders:

`Xyz.Vasd/ProtoPaper/ProtoPaper-Lit` for lite version

and 

`Xyz.Vasd/ProtoPaper/ProtoPaper-Unlit` for unlit version.

# Demo Scenes
```
Note, you can install only your currently using Render Pipeline subfolder.
```
## HDRP
`Packages/xyz.vasd.proto-paper/Content/Demo/HDRP/XV@ProtoPaper@Demo-HDRP.unity`

## URP
`Packages/xyz.vasd.proto-paper/Content/Demo/URP/XV@ProtoPaper@Demo-URP.unity`

## Built-In
`Packages/xyz.vasd.proto-paper/Content/Demo/BuiltIn/XV@ProtoPaper@Demo-BuiltIn.unity`

# Shader properties
Below are listed all properties to set in material.

##
### Orientaion
`Local` means grid zero point is determined by mesh zero point (pivot).

`Global` means grid zero point is world coordinates zero (0, 0, 0).

## Text Scale
`0 - 1`

Scale of printed text (Grid Size and Grid Position).

## Grid
Settings for main grid.

### Grid
Boolean.

Enable/Disable grid cells rendering.

### Grid Text
Boolean.

Enable/Disable grid text (cell size and position) rendering.

### Grid Size
Slider: `0 - 999`

Determines main grid cell size in units.
Note, it's floored in the shader, so it's like an interger. 
For example, `10.5` will be `10`.

### Grid Border
Slider: `0 - 1`

Size of grid border in percent of cell size cell size.

### Grid Fade Distance
Float.

Determines the distance on which grid will be totaly faded out.

`0` means fading is disabled.

Note, it's scaled according to cell and border size.

### Grid Color
Color.

Grid borders and text color.

## Subgrid
Properties for subgrid.

### Subgrid
Boolean.

Enable/Disable subgrid cells rendering.

### Subgrid Text
Boolean.

Enable/Disable subgrid text (cell size and position) rendering.

### Subgrid Cells
Number of cells per each main grid cell.

### Subgrid Fade Distance
Float.

Determines the distance on which subgrid will be totaly faded out.

`0` means fading is disabled.

Note, it's scaled according to cell and border size.

### Subgrid Color
Color.

Subgrid borders and text color.

## Background
Basic background color and texture.

### Background Tint.
Color.

Background tint.

### Background Texture.
Texture.

Background texture for cells.
Each cell has uv from 0,0 to 1,1, so it will be tiled according to main grid cell size.
