/*
    Tessella: Semi-Regular Tessellation - 3.6.3.6
    =============================================
    This module implements the tessellation of a plane using a semi-regular tiling
    pattern defined by the vertex configuration 3.6.3.6, where alternating triangles
    and hexagons meet at each vertex.
    
    Tiling properties:
    - Polygons used: triangles (3 sides), hexagons (6 sides)
    - Vertex Configuration: 3.6.3.6
    - Angle Sum at Vertex: 360° (valid for Euclidean tiling).
    
    Reference: Euclidean tessellation theory for semi-regular tilings.
*/


include <../tessUtils.scad>;