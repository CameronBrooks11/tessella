use <../../tess.scad>

// Define the mode:
// 1 for N x M,
// 2 for filtered N x M
mode = 1; // Change this number to switch between different NxM examples

rad = 10;
space = 1;
n = 6;
m = 5;

filter_points_levels = [
    [ 0, 0 ], [ 17.3205, 0 ], [ 8.66025, 15 ], [ 17.3205, 30 ], [ 0, 30 ], [ 8.66025, 45 ], [ 0, 60 ], [ 95.2628, 15 ],
    [ 86.6025, 30 ], [ 95.2628, 45 ], [ 86.6025, 60 ]
];
// ECHO: "Unfiltered Centers Grid:", [[0, 0], [8.66025, 15], [0, 30], [8.66025, 45], [0, 60], [17.3205, 0], [25.9808,
// 15], [17.3205, 30], [25.9808, 45], [17.3205, 60], [34.641, 0], [43.3013, 15], [34.641, 30], [43.3013, 45], [34.641,
// 60], [51.9615, 0], [60.6218, 15], [51.9615, 30], [60.6218, 45], [51.9615, 60], [69.282, 0], [77.9423, 15], [69.282,
// 30], [77.9423, 45], [69.282, 60], [86.6025, 0], [95.2628, 15], [86.6025, 30], [95.2628, 45], [86.6025, 60]]

// NxM Examples
if (mode == 1)
{
    centers_grid = hexagon_centers_NxM(radius = rad, n = n, m = m);
    echo("Unfiltered Centers Grid:", centers_grid);
    hexagons(radius = rad, spacing = space, hexagon_centers = centers_grid, color_scheme = "scheme3");
    print_points(centers_grid, text_size = 1, color = "Black", pointD = 0.5, point_color = "Red", fn = 12);
}
else if (mode == 2)
{
    centers_grid = hexagon_centers_NxM(radius = rad, n = n, m = m);
    echo("Unfiltered Centers Grid:", centers_grid);
    filtered_centers = filter_center_points(centers_grid, filter_points_levels);
    echo("Filtered Centers Grid:", filtered_centers); // Add back filtering logic here
    hexagons(radius = rad, spacing = space, hexagon_centers = filtered_centers, color_scheme = "scheme4");
    print_points(filtered_centers, text_size = 1, color = "Black", pointD = 0.5, point_color = "Red", fn = 12);
}