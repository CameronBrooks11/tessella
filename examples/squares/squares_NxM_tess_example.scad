use <../../tess.scad>

// Choose a mode: 
// mode = 1 => straightforward NxM
// mode = 2 => filtered NxM
mode = 1;

// Parameters
side    = 10;
spacing = 1;
n = 8;
m = 6;

if (mode == 1) {
    centers_grid = squares_centers_NxM(side, n, m);
    echo("Unfiltered Centers Grid:", centers_grid);

    squares(side = side, spacing = spacing, centers = centers_grid, color_scheme = "scheme3");
    print_points(centers_grid, text_size = 1, color = "Green", pointD = 1, point_color = "Red", fn = 12);

} else if (mode == 2) {
    centers_grid = squares_centers_NxM(side, n, m);
    // Some filtering if desired
    filtered_grid = centers_grid; // Stub for demonstration
    echo("Unfiltered Centers Grid:", centers_grid);
    echo("Filtered Centers Grid:", filtered_grid);

    squares(side = side, spacing = spacing, centers = filtered_grid, color_scheme = "scheme4");
    print_points(filtered_grid, text_size = 1, color = "Green", pointD = 1, point_color = "Red", fn = 12);
}
