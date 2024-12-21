use <../../tess.scad>

// Choose a mode: 
// mode = 1 => NxM
// mode = 2 => filtered NxM
mode = 1;

// Parameters
side    = 10;
spacing = 0;
n = 5;
m = 4;

if (mode == 1) {
    centers_grid = triangles_centers_NxM(side, n, m);
    echo("Unfiltered Centers Grid:", centers_grid);

    triangles(side = side, spacing = spacing, centers = centers_grid, color_scheme = "scheme3");
    print_points(centers_grid, text_size = 1, color = "Purple", pointD = 1, point_color = "Orange", fn = 12);

} else if (mode == 2) {
    centers_grid = triangles_centers_NxM(side, n, m);
    // Filter if needed
    filtered_grid = centers_grid; // Stub
    echo("Unfiltered Centers Grid:", centers_grid);
    echo("Filtered Centers Grid:", filtered_grid);

    triangles(side = side, spacing = spacing, centers = filtered_grid, color_scheme = "scheme4");
    print_points(filtered_grid, text_size = 1, color = "Purple", pointD = 1, point_color = "Orange", fn = 12);
}
