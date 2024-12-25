use <../../tess.scad>

side = 10;      // Side length of each square
spacing = 0;    // Spacing between squares
lvls = 5;       // Number of levels
extHeight = 10; // Extrusion height for squares
filter = true;  // Enable or disable filtering

// Generate unfiltered center points
unfiltered_centers = squares_centers_radial(side, lvls);
echo("Unfiltered Centers:", unfiltered_centers);

// Use the echo output to define the desired filter points
filter_points_radial = [
    [ -20, 40 ], [ -10, 40 ], [ 0, 40 ], [ 10, 40 ], [ 20, 40 ], [ 0, 20 ], [ -10, 20 ], [ 10, 20 ], [ 25, 30 ],
    [ 15, 30 ], [ 5, 30 ], [ -5, 30 ], [ -15, 30 ], [ -25, 30 ]
];

// Filter the center points if filtering is enabled
filtered_centers = filter_center_points(unfiltered_centers, filter_points_radial);
echo("Filtered Centers:", filtered_centers);

// Use filtered or unfiltered center points
centers = filter ? filtered_centers : unfiltered_centers;

// Generate vertices for the squares
vertices = squares_vertices(side = side - spacing, centers = centers);

// Render the squares
squares_poly(vertices = vertices, centers = centers, color_scheme = "scheme1", alpha = 0.5, extrude = extHeight);
// Note that we are passing 'centers' to the module, but it only used for color_scheme calculations.
// In terms of the final render, it is not necessary to pass 'vertices' and 'extrude' to the module
// to get the identical mesh:
// squares_poly(vertices = vertices, extrude = extHeight);
// Really if just wanted to visualize the tesselation we could just use 'vertices' like this:
// squares_poly(vertices = vertices);
// If we just wanted to render the squares without any color scheme or extrusion.

// Render points for debugging
translate([ 0, 0, extHeight ])
    print_points(centers, text_size = 1, color = "Blue", pointD = 0.5, point_color = "Red", fn = 12);