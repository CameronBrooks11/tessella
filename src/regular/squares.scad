/*
    Tessella: Regular Tessellation - Squares
    ========================================
    This module implements the tessellation of a plane using regular squares,
    where each tile is congruent, and all vertex angles around a point sum to 360°.

    Polygon properties:
    - Sides: 4
    - Interior Angle: 90°
    - Vertex Configuration: 4.4.4.4
*/

include <../tessUtils.scad>;

/**
 * @brief Generates center points for a "levels-based" square arrangement.
 *
 * Creates a diamond-like pattern of square centers. The center (middle) row has (2*levels - 1) squares.
 * Each additional row above or below the center has one fewer square, until only 1 square remains at the
 * top and bottom (when levels > 1).
 *
 * @param side   The side length of each square.
 * @param levels Number of levels (rows above the center, plus the center, plus rows below).
 * @return       An array of center points for squares.
 */
function squares_centers_radial(side, levels) = let(
    // Offsets for spacing
    offset_x = side, // Horizontal spacing
    offset_y = side, // Vertical spacing

    // Generate rows from the center outward
    // Row i = -(levels-1) to +(levels-1), where i=0 is the center row.
    rows = [for (i = [-(levels - 1):(levels - 1)])
            let(rowCount = (2 * levels - 1) - abs(i),   // Number of squares in the row
                yOff = i * offset_y,                    // Vertical position of the row
                xStart = -(rowCount - 1) * offset_x / 2 // Horizontal start to center the row
                ) [[xStart, yOff], rowCount]
])
    // For each row definition, generate square center points
    [for (row = rows) for (j = [0:row[1] - 1])[row[0][0] + j * offset_x, row[0][1]]];

/**
 * @brief Generates center points for a rectangular grid of squares (n x m).
 *
 * Produces a 2D grid of center points spaced by side length in both x and y directions.
 *
 * @param side The side length of each square.
 * @param n    The number of squares along the x-axis.
 * @param m    The number of squares along the y-axis.
 * @return     An array of center points for squares.
 */
function squares_centers_rect(side, n, m) =
    let(offset_x = side, offset_y = side)[for (ix = [0:n - 1], iy = [0:m - 1])[ix * offset_x, iy *offset_y]];

/**
 * @brief Renders 2D squares at specified centers, with optional color gradient.
 *
 * @param side          The side length of each square.
 * @param spacing       (Optional) Spacing between squares, default is 0.
 * @param centers       (Optional) Array of center points. If empty, `levels` or (n,m) must be provided.
 * @param levels        (Optional) Number of levels for diamond-like pattern generation.
 * @param n, m          (Optional) Grid dimensions if using NxM generation.
 * @param color_scheme  (Optional) Name of the color scheme for gradient.
 * @param alpha         (Optional) Alpha transparency value.
 */

function squares_vertices(side, centers, angular_offset = 45) = [for (
    center = centers)[for (i = [0:3]) let(angle = i * 90 + angular_offset)[center[0] + side / sqrt(2) * cos(angle),
                                                                           center[1] + side / sqrt(2) * sin(angle)]]];

/**
 * @brief Renders 2D squares at specified centers, with optional color gradient.
 *
 * @param vertices      Array of vertices for each square.
 * @param centers       (Optional) Array of square center points.
 * @param color_scheme  (Optional) Color scheme for gradient.
 * @param alpha         Transparency value (default: 1).
 * @param extrude       (Optional) Extrusion height for 3D squares.
 */
module squares_poly(vertices, centers = undef, color_scheme = undef, alpha = 1, extrude = undef)
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
                polygon(points = vertices[i], paths = [[ 0, 1, 2, 3, 0 ]]);
            else polygon(points = vertices[i], paths = [[ 0, 1, 2, 3, 0 ]]);
        }
    }
    else
    {
        for (i = [0:len(vertices) - 1])
        {
            if (!is_undef(extrude))
                linear_extrude(height = extrude) polygon(points = vertices[i], paths = [[ 0, 1, 2, 3, 0 ]]);
            else
                polygon(points = vertices[i], paths = [[ 0, 1, 2, 3, 0 ]]);
        }
    }
}