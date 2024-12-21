/*
    Tessella: Semi-Regular Tessellation - 3.3.4.3.4
    ===============================================
    This module implements the tessellation of a plane using a semi-regular tiling
    pattern defined by the vertex configuration 3.3.4.3.4, where two triangles and
    two squares alternate around each vertex.
    
    Tiling properties:
    - Polygons used: triangles (3 sides), squares (4 sides)
    - Vertex Configuration: 3.3.4.3.4
    - Angle Sum at Vertex: 360° (valid for Euclidean tiling).
    
    Reference: Euclidean tessellation theory for semi-regular tilings.
*/


include <../tessUtils.scad>;