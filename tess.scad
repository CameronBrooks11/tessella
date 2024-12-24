/**
 * @file tess.scad
 * @brief Functions and modules for generating tessellation patterns and rendering shapes.
 * @author Cameron K. Brooks
 * @copyright 2024
 *
 */

 // Import utility modules
 use <src/tessUtils.scad>

// Import regular tessellation modules

include <src/regular/hexagons.scad>;
include <src/regular/triangles.scad>;
include <src/regular/squares.scad>;

// Import semi-regular (Archimedean) tessellation modules
include <src/semi_regular/tess_4_8_8.scad>;