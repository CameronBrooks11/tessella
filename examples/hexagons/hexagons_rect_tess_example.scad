use <../../tess.scad>;

rad = 10;       // Hexagon radius
space = 1;      // Spacing between hexagons
n = 6;          // Number of hexagons along x-axis
m = 5;          // Number of hexagons along y-axis
extHeight = 10; // Extrusion height for 3D hexagons
filter = true;  // Toggle for filtering points

// Generate centers for rectangular hexagonal tessellation
centers_grid = hexagon_centers_rect(radius = rad, n = n, m = m);
echo("Unfiltered Centers Grid:", centers_grid);

// Define filter points for the filtered example
filter_points_levels = [
    [ 0, 0 ], [ 17.3205, 0 ], [ 8.66025, 15 ], [ 17.3205, 30 ], [ 0, 30 ], [ 8.66025, 45 ], [ 0, 60 ], [ 95.2628, 15 ],
    [ 86.6025, 30 ], [ 95.2628, 45 ], [ 86.6025, 60 ]
];

// Filter the centers if `filter` is enabled
filtered_centers = filter ? filter_center_points(centers_grid, filter_points_levels) : centers_grid;
echo("Filtered Centers Grid:", filtered_centers);

// Generate vertices for hexagons
vertices = hexagon_vertices(radius = rad - space, centers = filtered_centers, angular_offset = 30);

// Render hexagons as polygons
hexagon_poly(vertices = vertices, centers = filtered_centers, color_scheme = "scheme3", alpha = 0.5,
             extrude = extHeight);

// Visualize points for debugging
translate([ 0, 0, extHeight ])
    print_points(filtered_centers, text_size = 1.5, color = "Black", pointD = 0.5, point_color = "Red", fn = 12);