/*
    Tessella: Semi-Regular Tessellation - 6.6.12
    ============================================
    This module implements the tessellation of a plane using a semi-regular tiling
    pattern defined by the vertex configuration 6.6.12, where two hexagons and one
    dodecagon meet at each vertex.
    
    Tiling properties:
    - Polygons used: hexagons (6 sides), dodecagons (12 sides)
    - Vertex Configuration: 6.6.12
    - Angle Sum at Vertex: 360° (valid for Euclidean tiling).
    
    Reference: Euclidean tessellation theory for semi-regular tilings.
*/


include <../tessUtils.scad>;