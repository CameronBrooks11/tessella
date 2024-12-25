/*
    Tessella: Semi-Regular Tessellation - 4.8.8
    ===========================================
    This module implements the tessellation of a plane using a semi-regular tiling
    pattern defined by the vertex configuration 4.8.8, where one square and two
    octagons meet at each vertex.

    Tiling properties:
    - Polygons used: squares (4 sides), octagons (8 sides)
    - Vertex Configuration: 4.8.8
    - Angle Sum at Vertex: 360° (valid for Euclidean tiling).

    Reference: Euclidean tessellation theory for semi-regular tilings.
*/

include <../tessUtils.scad>;

/**
 * @brief Generates center points for an octagonal grid.
 *
 * Creates a 2D grid of center points for octagons spaced by the octagon's side length.
 *
 * @param radius The radius of each octagon.
 * @param n The number of octagons along the x-axis.
 * @param m The number of octagons along the y-axis.
 * @param rotate (Optional) Boolean to apply rotation to the grid, default is true.
 * @return An array of center points for octagons.
 */
function octagons_centers_rect(radius, n,
                               m) = let(side_length = (radius * 2) /
                                                      (sqrt(4 + 2 * sqrt(2))),    // Side length of the octagon
                                        total_width = side_length * (1 + sqrt(2)) // Total width including spacing
                                        ) squares_centers_rect(total_width, n, m);

/**
 * @brief Generates center points for the squares in a 4.8.8 tiling grid.
 *
 * Aligns the square centers with the octagonal centers by using a shifted grid,
 * creating the required semi-regular tiling pattern.
 *
 * @param radius The radius of the octagons.
 * @param n The number of octagons along the x-axis.
 * @param m The number of octagons along the y-axis.
 * @return An array of center points for squares.
 */
function squares_8_8_centers_rect(radius, n, m) = let(
    side_length = (radius * 2) / (sqrt(4 + 2 * sqrt(2))), // Side length of the octagon
    total_width = side_length * (1 + sqrt(2)),            // Total width including spacing
    shift_x = total_width / 2,                            // Horizontal shift for squares
    shift_y = total_width / 2                             // Vertical shift for squares
    )[for (c = squares_centers_rect(total_width, n - 1, m - 1))[c[0] + shift_x, c[1] + shift_y]];

/**
 * @brief Generates vertices for octagons based on radius and center points.
 *
 * Generates the vertices for octagons based on the provided center points and radius.
 *
 * @param radius The radius of each octagon.
 * @param centers Array of center points.
 * @param angular_offset (Optional) Rotation angle for vertices, default is 22.5°.
 * @return Array of vertices for each octagon.
 */
function octagons_vertices(radius, centers, angular_offset = 22.5) = [for (center = centers)[for (i = [0:7]) let(
    angle = i * 45 + angular_offset)[center[0] + radius * cos(angle), center[1] + radius *sin(angle)]]];