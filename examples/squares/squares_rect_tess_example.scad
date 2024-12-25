use <../../tess.scad>

side = 10;      // Side length of each square
spacing = 0;    // Spacing between squares
n = 9;          // Number of squares along the x-axis
m = 6;          // Number of squares along the y-axis
extHeight = 10; // Extrusion height for squares
filter = true;  // Enable or disable filtering

// Generate unfiltered center points
unfiltered_centers = squares_centers_rect(side, n, m);
echo("Unfiltered Centers Grid:", unfiltered_centers);

// Define filter points for the rectangular grid
filter_points = [
    [ 10, 10 ], [ 10, 20 ], [ 10, 30 ], [ 10, 40 ], [ 10, 50 ], [ 30, 10 ], [ 30, 20 ],
    [ 30, 30 ], [ 30, 40 ], [ 30, 50 ], [ 50, 10 ], [ 50, 20 ], [ 50, 30 ], [ 50, 40 ],
    [ 50, 50 ], [ 70, 10 ], [ 70, 20 ], [ 70, 30 ], [ 70, 40 ], [ 70, 50 ],
];

// Filter the center points if filtering is enabled
filtered_centers = filter_center_points(unfiltered_centers, filter_points);
echo("Filtered Centers Grid:", filtered_centers);

// Use filtered or unfiltered center points
centers = filter ? filtered_centers : unfiltered_centers;

// Generate vertices for the squares
vertices = squares_vertices(side = side - spacing, centers = centers);

// Render the squares
generic_poly(vertices = vertices, paths = [[ 0, 1, 2, 3, 0 ]], centers = centers, color_scheme = "scheme1", alpha = 1,
             extrude = 5);
// Note:
// - The 'centers' parameter is used only for calculating the color scheme.
//   If no color scheme is needed, this parameter can be omitted.
// - The 'vertices' parameter is mandatory for defining the geometry of the tessellation.
// - The 'paths' parameter defines the connectivity of vertices to form each shape.
//   For example, [[0, 1, 2, 3, 0]] represents a square connecting vertices in order.
// - If only a flat visualization of the tessellation is required, the 'extrude' parameter can be omitted.
//   For example:
//   generic_poly(vertices = vertices, paths = [[0, 1, 2, 3, 0]]);

// Render points for debugging
translate([ 0, 0, extHeight ])
    print_points(centers, text_size = 1, color = "Black", pointD = 0.5, point_color = "Red", fn = 12);