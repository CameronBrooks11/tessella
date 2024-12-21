
/**
 * @brief Generates a gradient color based on normalized coordinates and a color scheme.
 *
 * Selects a color by mapping normalized x and y coordinates to RGB values according to the specified color scheme.
 *
 * @param normalized_x The normalized x-coordinate (0 to 1).
 * @param normalized_y The normalized y-coordinate (0 to 1).
 * @param color_scheme The name of the color scheme to use.
 * @return An RGB color array [r, g, b].
 */
function get_gradient_color(normalized_x, normalized_y, color_scheme) =
    color_scheme == "scheme1" ? [ normalized_x, 1 - normalized_x, normalized_y ] : // Red to Blue
        color_scheme == "scheme2" ? [ 1 - normalized_y, normalized_x, normalized_y ]
                                  : // Green to Magenta
        color_scheme == "scheme3" ? [ normalized_y, 1 - normalized_y, normalized_x ]
                                  : // Blue to Yellow
        color_scheme == "scheme4" ? [ 1 - normalized_x, normalized_x, 1 - normalized_y ]
                                  : // Cyan to Red
        color_scheme == "scheme5" ? [ normalized_x, normalized_x *normalized_y, 1 - normalized_x ]
                                  : // Purple to Green
        color_scheme == "scheme6" ? [ 1 - normalized_x * normalized_y, normalized_y, normalized_x ]
                                  : // Orange to Blue
        [ 0.9, 0.9, 0.9 ];          // Default color (grey) if no valid color scheme is provided


/**
 * @brief Renders points as text labels and optional spheres in the 3D space.
 *
 * Displays each point's coordinates as text at its location and optionally places a sphere at the point.
 *
 * @param points An array of points to display, each as [x, y].
 * @param text_size (Optional) Size of the text labels; default is 1.
 * @param color (Optional) Color of the text labels; default is [0.1, 0.1, 0.1].
 * @param pointD (Optional) Diameter of the sphere to place at each point; if undef, no sphere is placed.
 * @param point_color (Optional) Color of the spheres; default is [0.1, 0.1, 0.1].
 * @param fn (Optional) Number of facets for the spheres; default is 8.
 */
module print_points(points, text_size = 1, color = [ 0.1, 0.1, 0.1 ], pointD = undef, point_color = [ 0.1, 0.1, 0.1 ],
                    fn = 8)
{
    for (point = points)
    {
        // Translate +1 in Z-axis to avoid z-fighting with the surface
        translate([ point[0], point[1], 1 ]) color(color)
            text(str("[", point[0], ", ", point[1], "]"), size = text_size, valign = "center", halign = "center");
        if (pointD != undef)
        {
            // Place a sphere at the point if pointD is specified
            color(point_color) translate([ point[0], point[1], 1 ]) sphere(pointD, $fn = fn);
        }
    }
}