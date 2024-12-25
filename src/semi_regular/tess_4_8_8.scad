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
 * @brief Generates center points for a 4.8.8 tessellation.
 *
 * Creates a grid of center points for a 4.8.8 tessellation, suitable for tiling an area.
 *
 * @param radius The radius of the octagons.
 * @param n The number of octagons along the x-axis.
 * @param m The number of octagons along the y-axis.
 * @param rotate (Optional) Boolean to apply rotation to the grid, default is true.
 * @return An array of center points for octagons.
 */

// function squares_tess_4_8_8_centers(radius, n, m, rotate = true) =

/**
 * @brief Generates center points for an octagonal grid.
 *
 * Creates a grid of octagon center points, optionally rotated, suitable for tiling an area.
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
    side_length = (radius * 2) / (sqrt(4 + 2 * sqrt(2))),  // Side length of the octagon
    total_width = side_length * (1 + sqrt(2)),             // Total width including spacing
    shift_x = total_width / 2,                             // Horizontal shift for squares
    shift_y = total_width / 2                              // Vertical shift for squares
) [for (c = squares_centers_rect(total_width, n - 1, m - 1)) [c[0] + shift_x, c[1] + shift_y]];


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

/**
 * @brief Renders octagons based on vertices and center points.
 *
 * Renders octagons based on the provided vertices and center points, with optional color and extrusion.
 *
 * @param radius The radius of each octagon.
 * @param vertices Array of vertices for octagons.
 * @param rotate (Optional) Boolean to apply rotation to the grid, default is true.
 * @param color_scheme (Optional) Color scheme for octagons, default is undefined.
 * @param alpha (Optional) Transparency value for octagons, default is undefined.
 */
module octagons_poly(radius, vertices, rotate = true, color_scheme = undef, alpha = undef)
{
    if (!is_undef(color_scheme) && !is_undef(centers))
    {
        min_x = min([for (center = centers) center[0]]);
        max_x = max([for (center = centers) center[0]]);
        min_y = min([for (center = centers) center[1]]);
        max_y = max([for (center = centers) center[1]]);
        for (i = [0:len(vertices) - 1])
        {
            normalized_x = (centers[i][0] - min_x) / (max_x - min_x);
            normalized_y = (centers[i][1] - min_y) / (max_y - min_y);
            color_val = get_gradient_color(normalized_x, normalized_y, color_scheme);

            color(color_val, alpha = alpha) if (!is_undef(extrude)) linear_extrude(height = extrude)
                polygon(points = vertices[i], paths = [[ 0, 1, 2, 3, 4, 5, 6, 7, 0 ]]);
            else polygon(points = vertices[i], paths = [[ 0, 1, 2, 3, 4, 5, 6, 7, 0 ]]);
        }
    }
    else
    {
        for (i = [0:len(vertices) - 1])
        {
            if (!is_undef(extrude))
                linear_extrude(height = extrude) polygon(points = vertices[i], paths = [[ 0, 1, 2, 3, 4, 5, 6, 7, 0 ]]);
            else
                polygon(points = vertices[i], paths = [[ 0, 1, 2, 3, 4, 5, 6, 7, 0 ]]);
        }
    }
}