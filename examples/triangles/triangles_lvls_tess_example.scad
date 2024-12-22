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
// ECHO: "Unfiltered Centers:", [[-20, -34.641], [0, -34.641], [20, -34.641], [-30, -17.3205], [-10, -17.3205], [10,
// -17.3205], [30, -17.3205], [-40, 0], [-20, 0], [0, 0], [20, 0], [40, 0], [-30, 17.3205], [-10, 17.3205],
// [10, 17.3205], [30, 17.3205], [-20, 34.641], [0, 34.641], [20, 34.641], [-10, -28.8675], [10, -28.8675], [-20,
// -11.547], [0, -11.547], [20, -11.547], [-30, 5.7735], [-10, 5.7735], [10, 5.7735], [30, 5.7735], [-20, 23.094],
// [0, 23.094], [20, 23.094]]

if (mode == 1)
{
    centers = triangles_centers_lvls(side, lvls);
    echo("Unfiltered Centers:", centers);
    triangles(side = side, spacing = spacing, centers = centers, centers_type = "levels", color_scheme = "scheme1");
    print_points(centers, text_size = 1, color = "Purple", pointD = 1, point_color = "Orange", fn = 12);
}
else if (mode == 2)
{
    centers = triangles_centers_lvls(side, lvls);
    echo("Unfiltered Centers:", centers);
    filtered_centers = filter_center_points(centers, filter_points);
    echo("Filtered Centers:", filtered_centers);

    triangles(side = side, spacing = spacing, centers = filtered_centers, centers_type = "levels",
              color_scheme = "scheme2");
    print_points(filtered_centers, text_size = 1, color = "Purple", pointD = 0.5, point_color = "Orange", fn = 12);
}