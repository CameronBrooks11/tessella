use <../../tess.scad>

lvls = 5;       // Number of 'levels' in the radial tessellation
rad = 10;       // Radius of hexagons
space = 1;      // Spacing between hexagons
extHeight = 10; // Extrusion height for hexagons
filter = true;  // Enable or disable filtering

unfiltered_centers = hexagon_centers_radial(radius = rad, levels = lvls);
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
vertices = filter ? hexagon_vertices(radius = rad - space, centers = filtered_centers, angular_offset = 30)
                  : hexagon_vertices(radius = rad - space, centers = centers, angular_offset = 30);

// Render the hexagons
hexagon_poly(vertices = vertices, centers = centers, color_scheme = "scheme1", alpha = 0.5, extrude = extHeight);

// Render points for debugging and visualization of the center points and their filtering
translate([ 0, 0, extHeight ])
    print_points(centers, text_size = 3 / 2, color = "Black", pointD = 0.5, point_color = "Red", fn = 12);