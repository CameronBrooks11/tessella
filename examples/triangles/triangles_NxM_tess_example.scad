use <../../tess.scad>

// Choose a mode:
// mode = 1 => NxM
// mode = 2 => filtered NxM
mode = 1;

// Parameters
side = 20;
spacing = 1;
n = 9;
m = 15;

filter_points = [
    [ 0, 0 ],
    [ 5.7735, 10 ],
    [ 17.3205, 0 ],
    [ 23.094, 10 ],
    [ 17.3205, 20 ],
    [ 34.641, 20 ],
    [ 40.4145, 30 ],
    [ 23.094, 30 ],
    [ 34.641, 40 ],
    [ 40.4145, 50 ],
    [ 51.9615, 40 ],
    [ 57.735, 50 ],
    [ 51.9615, 60 ],
];

if (mode == 1)
{
    centers_grid = triangles_centers_rect(side, n, m);
    echo("Unfiltered Centers Grid:", centers_grid);

    triangles(side = side, spacing = spacing, centers = centers_grid, color_scheme = "scheme3");
    print_points(centers_grid, text_size = 1, color = "DarkGrey", pointD = 0.5, point_color = "Orange", fn = 12);
}
else if (mode == 2)
{
    centers_grid = triangles_centers_rect(side, n, m);
    echo("Unfiltered Centers Grid:", centers_grid);
    filtered_grid = filter_center_points(centers_grid, filter_points);
    echo("Filtered Centers Grid:", filtered_grid);

    triangles(side = side, spacing = spacing, centers = filtered_grid, color_scheme = "scheme4");
    print_points(filtered_grid, text_size = 1, color = "DarkGrey", pointD = 0.5, point_color = "Orange", fn = 12);
}