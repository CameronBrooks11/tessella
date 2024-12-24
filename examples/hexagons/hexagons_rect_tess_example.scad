use <../../tess.scad>

rad = 10;       // Radius of hexagons
space = 1;      // Spacing between hexagons
n = 6;          // Number of hexagons along x-axis
m = 5;          // Number of hexagons along y-axis
extHeight = 10; // Extrusion height for hexagons
filter = true;  // Enable or disable filtering

// Generate unfiltered center points
unfiltered_centers = hexagon_centers_rect(radius = rad, n = n, m = m);
echo("Unfiltered Centers Grid:", unfiltered_centers);

// Define filter points for the rectangular grid
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
vertices = hexagon_vertices(radius = rad - space, centers = filtered_centers, angular_offset = 30);

// Render the hexagons
hexagon_poly(vertices = vertices, centers = filtered_centers, color_scheme = "scheme3", alpha = 0.5,
             extrude = extHeight);

// Render points for debugging
translate([ 0, 0, extHeight ])
    print_points(filtered_centers, text_size = 1, color = "Black", pointD = 0.5, point_color = "Red", fn = 12);