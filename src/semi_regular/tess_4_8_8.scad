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
 * Creates a grid of octagon center points, optionally rotated, suitable for tiling an area.
 *
 * @param radius The radius of each octagon.
 * @param n The number of octagons along the x-axis.
 * @param m The number of octagons along the y-axis.
 * @param rotate (Optional) Boolean to apply rotation to the grid, default is true.
 * @return An array of center points for octagons.
 */
function octagon_centers_grid(radius, n, m, rotate = true) =
    let(side_length = (radius * 2) / (sqrt(4 + 2 * sqrt(2))),                      // Side length of the octagon
        segment_length = side_length / sqrt(2),                                    // Segment length for positioning
        total_width = side_length * (1 + sqrt(2)),                                 // Total width including spacing
        tip = rotate ? segment_length : (side_length / 2) * sqrt(2 - sqrt(2)) * 2, // Adjustment for rotation
        shift = rotate ? total_width : radius * 2,                                 // Shift amount based on rotation
        offset = shift - tip,                                                      // Offset for alignment
        // Function to generate grid points
        generate_grid_points = function(n, m, step)[for (i = [0:n - 1], j = [0:m - 1])[i * step, j *step]])
        generate_grid_points(n, m, total_width);

/**
 * @brief Renders octagons at specified centers with optional color gradient.
 *
 * Draws 2D octagons based on the provided center points, applying spacing and color gradients if specified.
 *
 * @param radius The radius of each octagon.
 * @param spacing (Optional) Spacing between octagons, default is 0.
 * @param octagon_centers (Optional) Array of center points. If not provided, n and m must be specified.
 * @param n (Optional) Number of octagons along x-axis for grid.
 * @param m (Optional) Number of octagons along y-axis for grid.
 * @param rotate (Optional) Boolean to apply rotation to the octagons, default is true.
 * @param order (Optional) Multiplier for the number of facets, default is 1.
 * @param color_scheme (Optional) Name of the color scheme for gradient.
 * @param alpha (Optional) Alpha transparency value.
 */
module octagons(radius, spacing = 0, octagon_centers = [], n = undef, m = undef, rotate = true, order = 1,
                color_scheme = undef, alpha = undef)
{
    if (len(octagon_centers) == 0 && !is_undef(n) && !is_undef(m))
    {
        // Generate octagon centers based on n x m grid
        octagon_centers = octagon_centers_grid(radius, n, m, rotate);
    }
    else if (len(octagon_centers) == 0)
    {
        echo("No octagon centers provided and 'n' or 'm' is undefined.");
    }

    // Determine the range of the center points for normalization
    min_x = min([for (center = octagon_centers) center[0]]);
    max_x = max([for (center = octagon_centers) center[0]]);
    min_y = min([for (center = octagon_centers) center[1]]);
    max_y = max([for (center = octagon_centers) center[1]]);

    for (center = octagon_centers)
    {
        // Normalize coordinates for color gradient
        normalized_x = (center[0] - min_x) / (max_x - min_x);
        normalized_y = (center[1] - min_y) / (max_y - min_y);

        color_val = get_gradient_color(normalized_x, normalized_y, color_scheme);

        // If color_scheme is not specified, use default color
        if (is_undef(color_scheme))
        {
            color_val = [ 0.9, 0.9, 0.9 ]; // Default grey color
        }

        // Draw the octagon at the specified center
        color(color_val, alpha = alpha) translate([ center[0], center[1], 0 ])
            rotate([ 0, 0, rotate ? 22.5 : 0 ])            // Apply rotation if specified
            circle(radius - spacing / 2, $fn = 8 * order); // Octagon shape
    }
}

/**
 * @brief Renders extruded octagons at specified centers with optional color gradient.
 *
 * Draws 3D octagonal prisms based on the provided center points, applying spacing and color gradients if specified.
 *
 * @param radius The radius of each octagon.
 * @param height The extrusion height of the octagons.
 * @param spacing (Optional) Spacing between octagons, default is 0.
 * @param octagon_centers (Optional) Array of center points. If not provided, n and m must be specified.
 * @param n (Optional) Number of octagons along x-axis for grid.
 * @param m (Optional) Number of octagons along y-axis for grid.
 * @param rotate (Optional) Boolean to apply rotation to the octagons, default is true.
 * @param order (Optional) Multiplier for the number of facets, default is 1.
 * @param color_scheme (Optional) Name of the color scheme for gradient.
 * @param alpha (Optional) Alpha transparency value.
 */
module octagonsSolid(radius, height, spacing = 0, octagon_centers = [], n = undef, m = undef, rotate = true, order = 1,
                     color_scheme = undef, alpha = undef)
{
    if (len(octagon_centers) == 0 && !is_undef(n) && !is_undef(m))
    {
        // Generate octagon centers based on n x m grid
        octagon_centers = octagon_centers_grid(radius, n, m, rotate);
    }
    else if (len(octagon_centers) == 0)
    {
        echo("No octagon centers provided and 'n' or 'm' is undefined.");
    }

    // Determine the range of the center points for normalization
    min_x = min([for (center = octagon_centers) center[0]]);
    max_x = max([for (center = octagon_centers) center[0]]);
    min_y = min([for (center = octagon_centers) center[1]]);
    max_y = max([for (center = octagon_centers) center[1]]);

    for (center = octagon_centers)
    {
        // Normalize coordinates for color gradient
        normalized_x = (center[0] - min_x) / (max_x - min_x);
        normalized_y = (center[1] - min_y) / (max_y - min_y);

        color_val = get_gradient_color(normalized_x, normalized_y, color_scheme);

        // If color_scheme is not specified, use default color
        if (is_undef(color_scheme))
        {
            color_val = [ 0.9, 0.9, 0.9 ]; // Default grey color
        }

        // Draw the extruded octagon at the specified center
        color(color_val, alpha = alpha) translate([ center[0], center[1], 0 ])
            rotate([ 0, 0, rotate ? 22.5 : 0 ]) // Apply rotation if specified
            linear_extrude(height = height) circle(radius - spacing / 2, $fn = 8 * order); // Octagon shape
    }
}