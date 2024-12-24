/*
    Tessella: Regular Tessellation - Hexagons
    =========================================
    Tessellates a plane using regular hexagons.
    Properties:
    - Sides: 6
    - Interior Angle: 120°
    - Vertex Configuration: 6.6.6
*/

include <../tessUtils.scad>;

/**
 * Generates center points for a hexagonal tessellation in a radial pattern.
 * @param radius The radius of each hexagon.
 * @param levels Number of radial levels.
 * @return Array of hexagon center points.
 */
function hexagon_centers_radial(radius, levels) = let(
    offset_x = radius * cos(30),
    offset_y = radius + radius * sin(30),
    offset_step = 2 * offset_x,
    dx = -(levels - 1) * offset_x * 2,
    beginning_n = 2 * levels - 1,

    hexagons_pts = function(hex_datum)
        let(tx = hex_datum[0][0] + dx,
            ty = hex_datum[0][1],
            n_pts = hex_datum[1],
            offset_xs = [for (i = [0:n_pts - 1]) i * offset_step])
        [for (x = offset_xs) [x + tx, ty]],

    upper_hex_data = levels > 1 
        ? [for (i = [1:beginning_n - levels]) 
            let(x = offset_x * i, y = offset_y * i, n_upper = beginning_n - i) 
            [[x, y], n_upper]]
        : [],

    lower_hex_data = levels > 1 
        ? [for (hex_datum = upper_hex_data) 
            [[hex_datum[0][0], -hex_datum[0][1]], hex_datum[1]]]
        : [],

    total_hex_data = [[ [0, 0], beginning_n ], each upper_hex_data, each lower_hex_data],

    centers = [for (hex_datum = total_hex_data) hexagons_pts(hex_datum)]
)
concat([for (c = centers) each c]);

/**
 * Generates center points for a rectangular hexagonal grid.
 * @param radius The radius of each hexagon.
 * @param n Number of hexagons along x-axis.
 * @param m Number of hexagons along y-axis.
 * @return Array of hexagon center points.
 */
function hexagon_centers_rect(radius, n, m) =
    let(offset_x = radius * cos(30),
        offset_y = radius + radius * sin(30),
        offset_step = 2 * offset_x)
    [for (i = [0:n - 1], j = [0:m - 1]) 
        [i * offset_step + (j % 2) * (offset_step / 2), j * offset_y]];

/**
 * Generates vertices for hexagons based on radius and center points.
 * @param radius The radius of each hexagon.
 * @param centers Array of center points.
 * @param angular_offset Rotation angle for vertices.
 * @return Array of vertices for each hexagon.
 */
function hexagon_vertices(radius, centers, angular_offset = 30) =
    [for (center = centers)
        [for (i = [0:5]) 
            let(angle = i * 60 + angular_offset) 
            [center[0] + radius * cos(angle), center[1] + radius * sin(angle)]]];
            
/**
 * Renders hexagonal polygons from vertices.
 * @param vertices Array of vertices for each hexagon.
 * @param centers (Optional) Array of hexagon center points.
 * @param color_scheme (Optional) Color scheme for gradient.
 * @param alpha Transparency value (default: 1).
 * @param extrude (Optional) Extrusion height for 3D hexagons.
 */
module hexagon_poly(vertices, centers = undef, color_scheme = undef, alpha = 1, extrude = undef)
{
    if (!is_undef(color_scheme)) {
        for (i = [0:len(vertices) - 1]) {
            min_x = min([for (center = centers) center[0]]);
            max_x = max([for (center = centers) center[0]]);
            min_y = min([for (center = centers) center[1]]);
            max_y = max([for (center = centers) center[1]]);

            normalized_x = (centers[i][0] - min_x) / (max_x - min_x);
            normalized_y = (centers[i][1] - min_y) / (max_y - min_y);
            color_val = get_gradient_color(normalized_x, normalized_y, color_scheme);

            color(color_val, alpha = alpha)
                if (!is_undef(extrude))
                    linear_extrude(height = extrude) 
                        polygon(points = vertices[i], paths = [[0, 1, 2, 3, 4, 5, 0]]);
                else 
                    polygon(points = vertices[i], paths = [[0, 1, 2, 3, 4, 5, 0]]);
        }
    } else {
        for (i = [0:len(vertices) - 1]) {
            if (!is_undef(extrude))
                linear_extrude(height = extrude) 
                    polygon(points = vertices[i], paths = [[0, 1, 2, 3, 4, 5, 0]]);
            else 
                polygon(points = vertices[i], paths = [[0, 1, 2, 3, 4, 5, 0]]);
        }
    }
}
