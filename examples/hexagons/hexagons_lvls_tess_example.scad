use <../../tess.scad>

// Define the mode:
// 1 for levels,
// 2 for filtered levels
mode = 1; // Change this number to switch between different levels examples

rad = 10;
space = 1;
lvls = 5;

filter_points_levels = [
    [ 0, 0 ],
    [ -17.3205, 0 ],
    [ 17.3205, 0 ],
    [ -8.66025, 15 ],
    [ 8.66025, 15 ],
    [ -17.3205, 30 ],
    [ 17.3205, 30 ],
    [ 0, 30 ],
    [ -8.66025, 45 ],
    [ 8.66025, 45 ],
    [ 0, 60 ],
];
// ECHO: "Unfiltered Centers:", [[-69.282, 0], [-51.9615, 0], [-34.641, 0], [-17.3205, 0], [0, 0], [17.3205, 0],
// [34.641, 0], [51.9615, 0], [69.282, 0], [-60.6218, 15], [-43.3013, 15], [-25.9808, 15], [-8.66025, 15], [8.66025,
// 15], [25.9808, 15], [43.3013, 15], [60.6218, 15], [-51.9615, 30], [-34.641, 30], [-17.3205, 30], [0, 30], [17.3205,
// 30], [34.641, 30], [51.9615, 30], [-43.3013, 45], [-25.9808, 45], [-8.66025, 45], [8.66025, 45], [25.9808, 45],
// [43.3013, 45], [-34.641, 60], [-17.3205, 60], [0, 60], [17.3205, 60], [34.641, 60], [-60.6218, -15], [-43.3013, -15],
// [-25.9808, -15], [-8.66025, -15], [8.66025, -15], [25.9808, -15], [43.3013, -15], [60.6218, -15], [-51.9615, -30],
// [-34.641, -30], [-17.3205, -30], [0, -30], [17.3205, -30], [34.641, -30], [51.9615, -30], [-43.3013, -45], [-25.9808,
// -45], [-8.66025, -45], [8.66025, -45], [25.9808, -45], [43.3013, -45], [-34.641, -60], [-17.3205, -60], [0, -60],
// [17.3205, -60], [34.641, -60]]

// Levels Examples
if (mode == 1)
{
    centers = hexagon_centers_lvls(radius = rad, levels = lvls);
    echo("Unfiltered Centers:", centers);
    hexagons(radius = rad, spacing = space, hexagon_centers = centers, color_scheme = "scheme1");
    print_points(centers, text_size = 1, color = "Black", pointD = 0.5, point_color = "Red", fn = 12);
}
else if (mode == 2)
{
    centers = hexagon_centers_lvls(radius = rad, levels = lvls);
    filtered_centers = filter_center_points(centers, filter_points_levels);
    echo("Unfiltered Centers:", centers);
    echo("Filtered Centers:", filtered_centers);
    hexagons(radius = rad, spacing = space, hexagon_centers = filtered_centers, color_scheme = "scheme2");
    print_points(filtered_centers, text_size = 1, color = "Black", pointD = 0.5, point_color = "Red", fn = 12);
}