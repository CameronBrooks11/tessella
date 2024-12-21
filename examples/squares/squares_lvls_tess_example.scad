use <../../tess.scad>     

// Choose a mode: 
// mode = 1 => "levels" arrangement
// mode = 2 => possibly some filtering demonstration
mode = 1;

// Parameters
side    = 10;    // Side length of each square
spacing = 1;
lvls    = 6;     // Number of 'levels'

if (mode == 1) {
    centers = squares_centers_lvls(side, lvls);
    echo("Unfiltered Centers:", centers);
    
    squares(side = side, spacing = spacing, centers = centers, color_scheme = "scheme1");
    print_points(centers, text_size = 1, color = "Blue", pointD = 1, point_color = "Red", fn = 12);
    
} else if (mode == 2) {
    // If you want to demonstrate some filtering logic:
    centers = squares_centers_lvls(side, lvls);
    filtered = centers; // Replace with your filtering function
    echo("Unfiltered Centers:", centers);
    echo("Filtered Centers:", filtered);
    
    squares(side = side, spacing = spacing, centers = filtered, color_scheme = "scheme2");
    print_points(filtered, text_size = 1, color = "Blue", pointD = 1, point_color = "Red", fn = 12);
}
