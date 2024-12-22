/*
    Tessella: Regular Tessellation - Squares
    ========================================
    This module implements the tessellation of a plane using regular squares,
    where each tile is congruent, and all vertex angles around a point sum to 360°.

    Polygon properties:
    - Sides: 4
    - Interior Angle: 90°
    - Vertex Configuration: 4.4.4.4

    Mathematically valid because the interior angle divides 360° exactly.
    Reference: Euclidean tessellation theory for regular polygons.
*/

include <../tessUtils.scad>;

//////////////////////////////////////////////////////
// 1) FUNCTION TO GENERATE "LEVELS" (DIAMOND-LIKE) //
//////////////////////////////////////////////////////

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
function squares_centers_lvls(side, levels) = let(
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

//////////////////////////////////////////////////////
// 2) FUNCTION TO GENERATE NxM SQUARE GRID POINTS   //
//////////////////////////////////////////////////////

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
function squares_centers_NxM(side, n, m) =
    let(offset_x = side, offset_y = side)[for (ix = [0:n - 1], iy = [0:m - 1])[ix * offset_x, iy *offset_y]];

//////////////////////////////////////////////////////
// 3) 2D MODULE: RENDER SQUARES AT GIVEN CENTERS    //
//////////////////////////////////////////////////////

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
module squares(side, spacing = 0, centers = [], levels = undef, n = undef, m = undef, color_scheme = undef,
               alpha = undef)
{
    // Determine center points if not provided
    if (len(centers) == 0 && !is_undef(levels))
    {
        centers = squares_centers_lvls(side, levels);
    }
    else if (len(centers) == 0 && !is_undef(n) && !is_undef(m))
    {
        centers = squares_centers_NxM(side, n, m);
    }
    else if (len(centers) == 0)
    {
        echo("No centers provided and 'levels' / (n,m) are undefined for squares.");
    }

    // Bounding box for normalization (used for color gradient)
    min_x = min([for (c = centers) c[0]]);
    max_x = max([for (c = centers) c[0]]);
    min_y = min([for (c = centers) c[1]]);
    max_y = max([for (c = centers) c[1]]);

    // Draw each square
    for (c = centers)
    {
        normalized_x = (c[0] - min_x) / (max_x - min_x + 1e-9);
        normalized_y = (c[1] - min_y) / (max_y - min_y + 1e-9);
        color_val = get_gradient_color(normalized_x, normalized_y, color_scheme);

        if (is_undef(color_scheme))
        {
            color_val = [ 0.9, 0.9, 0.9 ]; // Default grey
        }

        color(color_val, alpha = alpha) translate([ c[0], c[1], 0 ]) square(side - spacing, center = true);
    }
}

//////////////////////////////////////////////////////
// 4) 3D MODULE: EXTRUDED SQUARES (PRISMS)          //
//////////////////////////////////////////////////////

/**
 * @brief Renders extruded (3D) squares (square prisms) at specified centers, with optional color gradient.
 *
 * @param side          The side length of each square.
 * @param height        The extrusion height.
 * @param spacing       (Optional) Spacing between squares, default is 0.
 * @param centers       (Optional) Array of center points. If empty, `levels` or (n,m) must be provided.
 * @param levels        (Optional) Number of levels for diamond-like pattern generation.
 * @param n, m          (Optional) Grid dimensions if using NxM generation.
 * @param color_scheme  (Optional) Name of the color scheme for gradient.
 * @param alpha         (Optional) Alpha transparency value.
 */
module squaresSolid(side, height, spacing = 0, centers = [], levels = undef, n = undef, m = undef, color_scheme = undef,
                    alpha = undef)
{
    // Determine center points if not provided
    if (len(centers) == 0 && !is_undef(levels))
    {
        centers = squares_centers_lvls(side, levels);
    }
    else if (len(centers) == 0 && !is_undef(n) && !is_undef(m))
    {
        centers = squares_centers_NxM(side, n, m);
    }
    else if (len(centers) == 0)
    {
        echo("No centers provided and 'levels' / (n,m) are undefined for squares.");
    }

    // Bounding box for normalization
    min_x = min([for (c = centers) c[0]]);
    max_x = max([for (c = centers) c[0]]);
    min_y = min([for (c = centers) c[1]]);
    max_y = max([for (c = centers) c[1]]);

    // Draw each extruded square
    for (c = centers)
    {
        normalized_x = (c[0] - min_x) / (max_x - min_x + 1e-9);
        normalized_y = (c[1] - min_y) / (max_y - min_y + 1e-9);
        color_val = get_gradient_color(normalized_x, normalized_y, color_scheme);

        if (is_undef(color_scheme))
        {
            color_val = [ 0.9, 0.9, 0.9 ]; // Default grey
        }

        color(color_val, alpha = alpha) translate([ c[0], c[1], 0 ]) linear_extrude(height = height)
            square(side - spacing, center = true);
    }
}