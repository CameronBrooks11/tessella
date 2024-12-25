use <../../tess.scad>

n = 6;          // Number of hexagons along x-axis in the rectangular tessellation
m = 5;          // Number of hexagons along y-axis in the rectangular tessellation
rad = 10;       // Radius of hexagons
space = 1;      // Spacing between hexagons
extHeight = 10; // Extrusion height for hexagons
filter = true;  // Enable or disable filtering

// Generate unfiltered center points
unfiltered_centers = hexagons_centers_rect(radius = rad, n = n, m = m);
echo("Unfiltered Centers Grid:", unfiltered_centers);

// Use the echo output to define the desired filter points
filter_points = [
    [ 0, 0 ], [ 17.3205, 0 ], [ 8.66025, 15 ], [ 17.3205, 30 ], [ 0, 30 ], [ 8.66025, 45 ], [ 0, 60 ], [ 95.2628, 15 ],
    [ 86.6025, 30 ], [ 95.2628, 45 ], [ 86.6025, 60 ]
];

// Filter the center points if filtering is enabled
filtered_centers = filter_center_points(unfiltered_centers, filter_points);
echo("Filtered Centers Grid:", filtered_centers);

// Use the filtered centers if filtering is enabled
centers = filter ? filtered_centers : centers;

// Generate vertices for the hexagons
vertices = hexagons_vertices(radius = rad - space, centers = filtered_centers, angular_offset = 30);

// Render the hexagons using the generic_poly module
generic_poly(vertices = vertices,               // The vertices defining the hexagons
             paths = [[ 0, 1, 2, 3, 4, 5, 0 ]], // Hexagon paths defining the connection order of vertices
             centers = centers,                 // Centers used for optional color scheme calculations
             color_scheme = "scheme3",          // Apply a color gradient based on centers
             alpha = 0.5,                       // Set the transparency level
             extrude = 10                       // Extrusion height for 3D rendering
);
// Note:
// - The 'centers' parameter is used only for calculating the color scheme.
//   If no color scheme is needed, this parameter can be omitted.
// - The 'vertices' parameter is mandatory for defining the geometry of the tessellation.
// - The 'paths' parameter defines the connectivity of vertices to form each shape.
//   For example, [[0, 1, 2, 3, 4, 5, 0]] represents a hexagon connecting vertices in order.
// - If only a flat visualization of the tessellation is required, the 'extrude' parameter can be omitted.
//   For example:
//   generic_poly(vertices = vertices, paths = [[0, 1, 2, 3, 4, 5, 0]]);

// Render points for debugging and visualization of the center points and their filtering
translate([ 0, 0, extHeight ])
    print_points(filtered_centers, text_size = 1, color = "Black", pointD = 0.5, point_color = "Red", fn = 12);