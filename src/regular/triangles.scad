/*
    Tessella: Regular Tessellation - Triangles
    ==========================================
    This module implements the tessellation of a plane using regular triangles,
    where each tile is congruent, and all vertex angles around a point sum to 360°.

    Polygon properties:
    - Sides: 3
    - Interior Angle: 60°
    - Vertex Configuration: 3.3.3.3.3.3

    Mathematically valid because the interior angle divides 360° exactly.
    Reference: Euclidean tessellation theory for regular polygons.
*/

include <../tessUtils.scad>;

/**
 * @brief Generates center points for a "levels-based" triangle arrangement.
 *
 * Creates a roughly radial or diamond-like pattern of triangle centers. The center row
 * has (2*levels - 1) triangles, each additional row above/below decreases by 1 triangle.
 *
 * @param side   The side length of each equilateral triangle.
 * @param levels Number of levels away from the center row.
 * @return       An array of center points for triangles.
 */
function triangles_centers_radial(side, levels) = let(
    // Vertical height of each triangle
    vheight = side * sqrt(3) / 2,
    // Generate rows symmetrically around the center
    rows0 = [for (i = [-ceil(levels / 2 - 1):ceil(levels / 2 - 1)])
            let(rowCount = (levels - ((levels + 1) % 2)) - abs(i), // Number of triangles in the row
                yOff = i * vheight,                                // Vertical offset for the row
                xStart = -(rowCount - 1) * side / 2                // Horizontal start to center the row
                ) [[xStart, yOff], rowCount]

],
    rows1 = (levels == 1) ? []
                          : [for (i = [-(floor(levels / 2)):(floor(levels / 2 - 1))])
                                    let(rowCount = (levels - ((levels) % 2)) - abs(i), // Number of triangles in the row
                                        yOff = i * vheight + vheight / 2 -
                                               (vheight - sqrt(3) / 3 * side) / 2, // Vertical offset for the row
                                        xStart = -(rowCount - 1) * side / 2        // Horizontal start to center the row
                                        ) [[xStart, yOff], rowCount]

],
    rows = concat(rows0, rows1))
    // Generate center points for all rows
    [for (row = rows) for (j = [0:row[1] - 1])[row[0][0] + j * side, row[0][1]]];

/**
 * @brief Generates center points for a rectangular grid of equilateral triangles (n x m).
 *
 * Alternating rows are horizontally offset by half a side for a typical triangular tiling pattern.
 *
 * @param side The side length of each triangle.
 * @param n    Number of triangles along x-axis.
 * @param m    Number of rows (y-axis).
 * @return     An array of center points for triangles.
 */
function triangles_centers_rect(side, n, m) = let(
    vheight = side * sqrt(3) / 2, // Vertical height of each triangle
    col_shift = side / 2,         // Horizontal shift for each column
    row_shift = vheight,          // Horizontal shift for alternating rows
    offset_shift = row_shift -
                   (vheight - sqrt(3) / 3 * side) *
                       2)[for (j = [0:m - 1], i = [0:n - 1])[(i)*row_shift + (offset_shift * (j % 2)), j *col_shift]];

/**
 * @brief Generates vertices for equilateral triangles at specified centers.
 *
 * Rotates every other row by 180° and applies an additional angular offset for customization.
 *
 * @param side           The side length of each triangle.
 * @param centers        The array of center points for the triangles.
 * @param angular_offset An additional angular offset to apply to all triangles.
 * @param is_radial      If true, calculates the row index based on radial arrangement.
 * @return               A nested array of vertices for all triangles.
 */
function triangle_vertices(side, centers, angular_offset = 0, rect = true) = let(
    EPSILON = 1e-9,               // Small value for floating-point comparison
    vheight = side * sqrt(3) / 2, // Vertical height of each triangle
    // This messy line pretty much determines if a row is odd or even based on the vertical position, it needs to check
    // using the reverse calculation of rows1 / offset shift, looking at that now it should probably be refactored.
    // Overall, this works and gets the geometrical idea across, but it's not the most readable (literally horrendous).
    row_parity = [for (c = centers)(
        (((((rect ? c[0] : c[1]) + EPSILON - vheight / 2 + (vheight - sqrt(3) / 3 * side) / 2) / vheight) % 1) <=
         EPSILON) &&
                (((((rect ? c[0] : c[1]) - EPSILON - vheight / 2 + (vheight - sqrt(3) / 3 * side) / 2) / vheight) %
                  1) >= -EPSILON)
            ? 0
            : 1)], // Calculate row parity
    rotation_adjustment = [for (i = [0:len(centers) - 1])(row_parity[i] ? (rect ? 0 : 180)
                                                                        : (rect ? 180 : 0))] // Flip every other row
    )[for (i = [0:len(centers) - 1])[for (j = [0:2]) let(
    angle = j * 120 + angular_offset + rotation_adjustment[i])[centers[i][0] + side / sqrt(3) * cos(angle),
                                                               centers[i][1] + side / sqrt(3) * sin(angle)]]];

module triangle_poly(vertices, centers = undef, color_scheme = undef, alpha = 1, extrude = undef)
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
                polygon(points = vertices[i], paths = [[ 0, 1, 2, 0 ]]);
            else polygon(points = vertices[i], paths = [[ 0, 1, 2, 0 ]]);
        }
    }
    else
    {
        for (i = [0:len(vertices) - 1])
        {
            if (!is_undef(extrude))
                linear_extrude(height = extrude) polygon(points = vertices[i], paths = [[ 0, 1, 2, 0 ]]);
            else
                polygon(points = vertices[i], paths = [[ 0, 1, 2, 0 ]]);
        }
    }
}