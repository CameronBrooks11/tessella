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
                       2)[for (j = [0:m - 1], i = [0:n - 1])[i * row_shift + (offset_shift * (j % 2)), j *col_shift]];

function triangle_vertices(side, centers, angular_offset = 0) = [for (center = centers)[for (i = [0:2]) let(
    angle = i * 120 + angular_offset)[center[0] + side * cos(angle), center[1] + side *sin(angle)]]];

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

/**
 * @brief Renders 2D equilateral triangles at specified centers, with optional color gradient.
 *
 * @param side          The side length of each triangle.
 * @param spacing       (Optional) Spacing between triangles, default is 0.
 * @param centers       (Optional) Array of center points. If empty, `levels` or (n,m) must be provided.
 * @param levels        (Optional) Number of levels for radial-like pattern.
 * @param n, m          (Optional) Grid dimensions if using NxM generation.
 * @param color_scheme  (Optional) Name of the color scheme for gradient.
 * @param alpha         (Optional) Alpha transparency value.
 */
module triangles(side, spacing = 0, centers = [], centers_type = undef, levels = undef, n = undef, m = undef,
                 color_scheme = undef, alpha = undef)
{
    // Determine center points
    if (len(centers) == 0 && !is_undef(levels))
    {
        centers = triangles_centers_radial(side, levels);
    }
    else if (len(centers) == 0 && !is_undef(n) && !is_undef(m))
    {
        centers = triangles_centers_rect(side, n, m);
    }
    else if (len(centers) == 0)
    {
        echo("No centers provided and 'levels' / (n,m) undefined for triangles.");
    }

    is_lvls = centers_type == "levels" || levels != undef;

    // Bounding box for normalization
    min_x = min([for (c = centers) c[0]]);
    max_x = max([for (c = centers) c[0]]);
    min_y = min([for (c = centers) c[1]]);
    max_y = max([for (c = centers) c[1]]);

    // Draw each triangle
    for (c = centers)
    {
        normalized_x = (c[0] - min_x) / (max_x - min_x + 1e-9);
        normalized_y = (c[1] - min_y) / (max_y - min_y + 1e-9);

        // Derive the row index using the calculated vheight
        vheight = side * sqrt(3) / 4;                                               // Vertical height of the triangle
        row_index = is_lvls ? floor(c[1] / vheight * 2) : floor(c[1] / (side / 2)); // Correct row approximation
        rot = row_index % 2 == 0 ? 0 : 60; // Set rotation: 0 for even rows, 180 for odd rows
        rot_lvls = is_lvls ? 30 : 0;

        color_val =
            !is_undef(color_scheme) ? get_gradient_color(normalized_x, normalized_y, color_scheme) : [ 0.9, 0.9, 0.9 ];

        color(color_val, alpha = alpha) translate([ c[0], c[1], 0 ]) rotate(rot - rot_lvls)
            circle($fn = 3, r = (side - spacing) / sqrt(3));
    }
}