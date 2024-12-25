use <../../tess.scad>;

side = 20;      // Side length of each triangle
spacing = 0;    // Spacing between triangles
n = 9;          // Number of triangles along the x-axis
m = 15;         // Number of triangles along the y-axis
extHeight = 10; // Extrusion height for triangles

filter = true; // Enable or disable filtering

// WARNING: Printing the center points can be very slow for large grids as they are text-annotated
print_pts = false; // Enable or disable printing of center points

// Generate unfiltered center points
unfiltered_centers = triangles_centers_rect(side, n, m);
echo("Unfiltered Centers Grid:", unfiltered_centers);

// Define filter points for the rectangular tessellation
filter_points_rect = [
    [ 0, 0 ],
    [ 5.7735, 10 ],
    [ 17.3205, 0 ],
    [ 23.094, 10 ],
    [ 17.3205, 20 ],
    [ 34.641, 20 ],
    [ 40.4145, 30 ],
    [ 23.094, 30 ],
    [ 34.641, 40 ],
    [ 40.4145, 50 ],
    [ 51.9615, 40 ],
    [ 57.735, 50 ],
    [ 51.9615, 60 ],
];

// Filter the center points if filtering is enabled
filtered_centers = filter_center_points(unfiltered_centers, filter_points_rect);
echo("Filtered Centers Grid:", filtered_centers);

// Use filtered or unfiltered center points
centers = filter ? filtered_centers : unfiltered_centers;

// Generate vertices for the triangles
vertices = triangle_vertices(side = side - spacing, centers = centers, angular_offset = 0, rect = true);

// Render the triangles
triangle_poly(vertices = vertices, centers = centers, color_scheme = "scheme1", alpha = 0.5, extrude = extHeight);

// Render points for debugging
if (print_pts)
{
    translate([ 0, 0, extHeight ])
        print_points(centers, text_size = 1, color = "DarkGrey", pointD = 0.5, point_color = "Orange", fn = 12);
}