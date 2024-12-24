EPSILON = 1e-3; ///< Tolerance value used for floating-point comparisons.

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
        translate([ point[0], point[1] + pointD * 2, pointD * 2 ]) color(color)
            text(str("[", point[0], ", ", point[1], "]"), size = text_size, valign = "center", halign = "center");
        if (pointD != undef)
        {
            // Place a sphere at the point if pointD is specified
            color(point_color) translate([ point[0], point[1], 0 ]) sphere(pointD, $fn = fn);
        }
    }
}

/**
 * @brief Checks if two points are equal within a specified tolerance.
 *
 * @param p1 First point as [x, y].
 * @param p2 Second point as [x, y].
 * @param tolerance (Optional) Tolerance value for comparison; default is EPSILON.
 * @return True if points are equal within tolerance, false otherwise.
 */
function points_equal(p1, p2, tolerance = EPSILON) = let(comparisons = [for (i = [0:len(p1) - 1]) abs(p1[i] - p2[i]) <
                                                             tolerance])
                                                     // Check if all comparisons are true
                                                     len([for (comp = comparisons) if (comp) true]) == len(comparisons);

/**
 * @brief Checks if a point exists within a list of points, within a specified tolerance.
 *
 * @param point The point to check, as [x, y].
 * @param list The list of points to search within.
 * @param tolerance (Optional) Tolerance value for comparison; default is EPSILON.
 * @return True if the point exists in the list within tolerance, false otherwise.
 */
function is_point_in_list(point, list,
                          tolerance = EPSILON) = let(equal_points = [for (p = list) points_equal(p, point, tolerance)])
                                                     len([for (eq = equal_points) if (eq) true]) > 0;

/**
 * @brief Filters out centers that are present in a filter list.
 *
 * Removes centers from the provided list that match any in the filter_list, within a specified tolerance.
 *
 * @param centers An array of centers to be filtered.
 * @param filter_list An array of centers to filter out.
 * @param tolerance (Optional) Tolerance value for comparison; default is EPSILON.
 * @return A filtered array of centers.
 */
function filter_center_points(centers, filter_list, tolerance = EPSILON) =
    [for (center = centers) if (!is_point_in_list(center, filter_list, tolerance)) center];

/**
 * @brief Filters out points from centers that are within a radius of points in the filter list.
 *
 * Useful for removing points that are too close to certain areas or features.
 *
 * @param r The radius within which to filter out points.
 * @param centers An array of centers to be filtered.
 * @param filter_list An array of points to filter against.
 * @param tolerance (Optional) Tolerance value for comparison; default is EPSILON.
 * @return A filtered array of centers.
 */
function filter_triangulated_center_points(r, centers, filter_list, tolerance = EPSILON) = let(
    n = len(centers))[for (i = [0:n - 1]) if (!is_within_radius(centers[i], r + tolerance, filter_list)) centers[i]];