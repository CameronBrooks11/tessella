use <../../tess.scad>

lvls = 5;       // Number of 'levels' in the radial tessellation
rad = 10;       // Radius of hexagons
space = 1;      // Spacing between hexagons
extHeight = 10; // Extrusion height for hexagons
filter = true;  // Enable or disable filtering

unfiltered_centers = hexagons_centers_radial(radius = rad, levels = lvls);
echo("Unfiltered Centers:", unfiltered_centers);

// Use the echo output to define the desired filter points
filter_points = [
    [ 0, 0 ], [ -17.3205, 0 ], [ 17.3205, 0 ], [ -8.66025, 15 ], [ 8.66025, 15 ], [ -17.3205, 30 ], [ 17.3205, 30 ],
    [ 0, 30 ], [ -8.66025, 45 ], [ 8.66025, 45 ], [ 0, 60 ]
];

filtered_centers = filter_center_points(unfiltered_centers, filter_points);
echo("Filtered Centers:", filtered_centers);

// Use the filtered centers if filtering is enabled
centers = filter ? filtered_centers : centers;

// Generate vertices for the hexagons
vertices = filter ? hexagons_vertices(radius = rad - space, centers = filtered_centers, angular_offset = 30)
                  : hexagons_vertices(radius = rad - space, centers = centers, angular_offset = 30);

// Render the hexagons
generic_poly(
    vertices = vertices,
    paths = [[0, 1, 2, 3, 4, 5, 0]], // Hexagon paths
    centers = centers,
    color_scheme = "scheme1",
    alpha = 0.5,
    extrude = 10
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
    print_points(centers, text_size = 3 / 2, color = "Black", pointD = 0.5, point_color = "Red", fn = 12);