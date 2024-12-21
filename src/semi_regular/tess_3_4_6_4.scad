/*
    Tessella: Semi-Regular Tessellation - 3.4.6.4
    =============================================
    This module implements the tessellation of a plane using a semi-regular tiling
    pattern defined by the vertex configuration 3.4.6.4, where one triangle, one
    hexagon, and two squares meet at each vertex.
    
    Tiling properties:
    - Polygons used: triangles (3 sides), squares (4 sides), hexagons (6 sides)
    - Vertex Configuration: 3.4.6.4
    - Angle Sum at Vertex: 360° (valid for Euclidean tiling).
    
    Reference: Euclidean tessellation theory for semi-regular tilings.
*/


include <../tessUtils.scad>;