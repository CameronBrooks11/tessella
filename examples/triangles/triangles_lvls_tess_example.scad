use <../../tess.scad>

// Choose a mode: 
// mode = 1 => "levels" arrangement
// mode = 2 => demonstration of filtering
mode = 1;

// Parameters
side    = 10; 
spacing = 0;
lvls    = 5;

if (mode == 1) {
    centers = triangles_centers_lvls(side, lvls);
    echo("Unfiltered Centers:", centers);
    
    triangles(side = side, spacing = spacing, centers = centers, color_scheme = "scheme1");
    print_points(centers, text_size = 1, color = "Purple", pointD = 1, point_color = "Orange", fn = 12);

} else if (mode == 2) {
    centers = triangles_centers_lvls(side, lvls);
    // Implement filtering if needed
    filtered = centers; // Stub
    echo("Unfiltered Centers:", centers);
    echo("Filtered Centers:", filtered);

    triangles(side = side, spacing = spacing, centers = filtered, color_scheme = "scheme2");
    print_points(filtered, text_size = 1, color = "Purple", pointD = 1, point_color = "Orange", fn = 12);
}
