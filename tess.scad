/**
 * @file tess.scad
 * @brief Functions and modules for generating tessellation patterns and rendering shapes.
 * @author Cameron K. Brooks
 * @copyright 2024
 *
 */

// Import utility modules
include <src/tessUtils.scad>

// Import regular tessellation modules

include <src/regular/hexagons.scad>;  // Contains hexagon tessellation functions & assets
include <src/regular/squares.scad>;   // Contains square tessellation functions & assets
include <src/regular/triangles.scad>; // Contains triangle tessellation functions & assets

// Import semi-regular (Archimedean) tessellation modules
include <src/semi_regular/tess_4_8_8.scad>; // Contains 4.8.8 tessellation functions & octagon assets