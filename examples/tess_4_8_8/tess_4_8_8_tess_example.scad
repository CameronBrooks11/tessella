use <../../tess.scad>;

radius = 10;    // Radius of each octagon
spacing = 1;    // Spacing between octagons
n = 7;          // Number of octagons along the x-axis
m = 7;          // Number of octagons along the y-axis
extHeight = 10; // Extrusion height for octagons
filter = true;  // Enable or disable filtering

// WARNING: Printing the center points can be very slow for large grids as they are text-annotated
print_pts = false; // Enable or disable printing of center points

// Generate unfiltered center points
unfiltered_oct_centers = octagons_centers_rect(radius, n, m);
echo("Unfiltered Centers Grid Oct:", unfiltered_oct_centers);

unfiltered_square_centers = squares_8_8_centers_rect(radius, n, m);
echo("Unfiltered Centers Grid Sq:", unfiltered_square_centers);

// Define filter points for the rectangular tessellation
filter_points_oct = [
    [ 0, 0 ],
    [ 110.866, 0 ],
    [ 0, 110.866 ],
    [ 110.866, 110.866 ],
    [ 55.4328, 55.4328 ],
];

filter_points_square = [
    [ 46.194, 64.6716 ],
    [ 64.6716, 64.6716 ],
    [ 46.194, 46.194 ],
    [ 64.6716, 46.194 ],
];

// Filter the center points if filtering is enabled
filtered_oct_centers = filter_center_points(unfiltered_oct_centers, filter_points_oct);
echo("Filtered Centers Oct:", filtered_oct_centers);

filtered_square_centers = filter_center_points(unfiltered_square_centers, filter_points_square);
echo("Filtered Centers Sq:", filtered_square_centers);

// Use filtered or unfiltered oct center points
oct_centers = filter ? filtered_oct_centers : unfiltered_oct_centers;

// Use filtered or unfiltered sq center points
sq_centers = filter ? filtered_square_centers : unfiltered_square_centers;

// Generate vertices for the octagons
oct_vertices = octagons_vertices(radius = radius - spacing, centers = oct_centers);

// Calculate the side length of the squares based on the octagon radius
side_length = (radius * 2) / (sqrt(4 + 2 * sqrt(2)));

// Generate vertices for the squares
square_vertices = squares_vertices(side = side_length - spacing, centers = sq_centers, angular_offset = 0);

// Render the squares
generic_poly(vertices = square_vertices, paths = [[ 0, 1, 2, 3, 0 ]], // Square paths
             centers = sq_centers, color_scheme = "scheme1", alpha = 1, extrude = extHeight);

// Render the octagons
generic_poly(vertices = oct_vertices, paths = [[ 0, 1, 2, 3, 4, 5, 6, 7, 0 ]], // Octagon paths
             centers = oct_centers, color_scheme = "scheme2", alpha = 0.5, extrude = extHeight);

// Render points for debugging
if (print_pts)
{
    translate([ 0, 0, extHeight ])
    {
        print_points(oct_centers, text_size = 1, color = "Black", pointD = 0.5, point_color = "Blue", fn = 12);
        print_points(sq_centers, text_size = 1, color = "Black", pointD = 0.5, point_color = "Red", fn = 12);
    }
}