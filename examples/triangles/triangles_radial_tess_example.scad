use <../../tess.scad>

side = 20;      // Side length of each triangle
spacing = 0;    // Spacing between triangles
lvls = 16;      // Number of levels
extHeight = 10; // Extrusion height for triangles

filter = true; // Enable or disable filtering

// WARNING: Printing the center points can be very slow for large numbers of levels as they are text-annotated
print_pts = false; // Enable or disable printing of center points

// Generate unfiltered center points
unfiltered_centers = triangles_centers_radial(side, lvls);
echo("Unfiltered Centers:", unfiltered_centers);

// Define filter points for the radial tessellation
filter_points_radial = [
    [ 0, 0 ],
    [ 10, 5.7735 ],
    [ -10, 5.7735 ],
    [ 0, -11.547 ],
];

// Filter the center points if filtering is enabled
filtered_centers = filter_center_points(unfiltered_centers, filter_points_radial);
echo("Filtered Centers:", filtered_centers);

// Use filtered or unfiltered center points
centers = filter ? filtered_centers : unfiltered_centers;

// Generate vertices for the triangles
vertices = triangle_vertices(side = side - spacing, centers = centers, angular_offset = 30, rect = false);

// Render the triangles
generic_poly(
    vertices = vertices,
    paths = [[0, 1, 2, 0]], // Triangle paths
    centers = centers,
    color_scheme = "scheme2",
    alpha = 0.7,
    extrude = 3
);

// Render points for debugging
if (print_pts)
{
    translate([ 0, 0, extHeight ])
        print_points(centers, text_size = 1, color = "Purple", pointD = 1, point_color = "Orange", fn = 12);
}