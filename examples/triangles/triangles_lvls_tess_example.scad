use <../../tess.scad>

// Choose a mode:
// mode = 1 => "levels" arrangement
// mode = 2 => demonstration of filtering
mode = 1;

// Parameters
side = 20;
spacing = 1;
lvls = 6;

filter_points = [ [ 0, 0 ], [10, 5.7735], [-10, 5.7735], [0, -11.547] ];

if (mode == 1)
{
    centers = triangles_centers_radial(side, lvls);
    echo("Unfiltered Centers:", centers);
    triangles(side = side, spacing = spacing, centers = centers, centers_type = "levels", color_scheme = "scheme1");
    print_points(centers, text_size = 1, color = "Purple", pointD = 1, point_color = "Orange", fn = 12);
}
else if (mode == 2)
{
    centers = triangles_centers_radial(side, lvls);
    echo("Unfiltered Centers:", centers);
    filtered_centers = filter_center_points(centers, filter_points);
    echo("Filtered Centers:", filtered_centers);

    triangles(side = side, spacing = spacing, centers = filtered_centers, centers_type = "levels",
              color_scheme = "scheme2");
    print_points(filtered_centers, text_size = 1, color = "Purple", pointD = 0.5, point_color = "Orange", fn = 12);
}