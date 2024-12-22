use <../../tess.scad>

// Choose a mode:
// mode = 1 => straightforward NxM
// mode = 2 => filtered NxM
mode = 1;

// Parameters
side = 10;
spacing = 1;
n = 9;
m = 6;

filter_grid_points = [
    [ 10, 10 ], [ 10, 20 ], [ 10, 30 ], [ 10, 40 ], [ 10, 50 ], [ 30, 10 ], [ 30, 20 ],
    [ 30, 30 ], [ 30, 40 ], [ 30, 50 ], [ 50, 10 ], [ 50, 20 ], [ 50, 30 ], [ 50, 40 ],
    [ 50, 50 ], [ 70, 10 ], [ 70, 20 ], [ 70, 30 ], [ 70, 40 ], [ 70, 50 ]
];
// ECHO: "Unfiltered Centers Grid:", [[0, 0], [0, 10], [0, 20], [0, 30], [0, 40], [0, 50], [10, 0], [10, 10], [10, 20],
// [10, 30], [10, 40], [10, 50], [20, 0], [20, 10], [20, 20], [20, 30], [20, 40], [20, 50], [30, 0], [30, 10], [30, 20],
// [30, 30], [30, 40], [30, 50], [40, 0], [40, 10], [40, 20], [40, 30], [40, 40], [40, 50], [50, 0], [50, 10], [50, 20],
// [50, 30], [50, 40], [50, 50], [60, 0], [60, 10], [60, 20], [60, 30], [60, 40], [60, 50], [70, 0], [70, 10], [70, 20],
// [70, 30], [70, 40], [70, 50], [80, 0], [80, 10], [80, 20], [80, 30], [80, 40], [80, 50]]

if (mode == 1)
{
    centers_grid = squares_centers_NxM(side, n, m);
    echo("Unfiltered Centers Grid:", centers_grid);

    squares(side = side, spacing = spacing, centers = centers_grid, color_scheme = "scheme3");
    print_points(centers_grid, text_size = 1, color = "Black", pointD = 0.5, point_color = "Red", fn = 12);
}
else if (mode == 2)
{
    centers_grid = squares_centers_NxM(side, n, m);
    // Some filtering if desired
    echo("Unfiltered Centers Grid:", centers_grid);
    filtered_grid = filter_center_points(centers_grid, filter_grid_points);
    echo("Filtered Centers Grid:", filtered_grid);
    squares(side = side, spacing = spacing, centers = filtered_grid, color_scheme = "scheme4");
    print_points(filtered_grid, text_size = 1, color = "Black", pointD = 0.5, point_color = "Red", fn = 12);
}