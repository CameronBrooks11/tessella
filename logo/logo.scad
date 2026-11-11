// Tessella logo: a 4.8.8 tessellation with the tiles behind the name removed.
//
// Render from the repository root (preview mode, looking straight down):
//   openscad logo/logo.scad -o docs/assets/logo.png --imgsize=1500,500 \
//     --camera=0,0,0,0,0,0,240 --projection=o --colorscheme=Tomorrow
//
// The name is set in Liberation Sans Bold, which has to be installed.

use <../tess.scad>

radius = 10; // octagon centre-to-corner distance
n = 16;      // octagons along x
m = 7;       // octagons along y
gap = 0.45;  // how much each tile is shrunk
hole = [8, 3]; // octagons removed behind the name, along x and y
seed = 488;  // fixes the colours

side_length = (radius * 2) / sqrt(4 + 2 * sqrt(2));
pitch = side_length * (1 + sqrt(2));

// centre of the pattern, so the hole can be described around it
mid = [(n - 1) * pitch / 2, (m - 1) * pitch / 2];

// true if a centre lies strictly inside the hole
function in_hole(c) =
  abs(c[0] - mid[0]) < hole[0] * pitch / 2 - 0.01 && abs(c[1] - mid[1]) < hole[1] * pitch / 2 - 0.01;

oct_centers = [for (c = octagons_centers_rect(radius, n, m)) if (!in_hole(c)) c];
sq_centers = [for (c = squares_8_8_centers_rect(radius, n, m)) if (!in_hole(c)) c];

oct_vertices = octagons_vertices(radius - gap, oct_centers);
sq_vertices = squares_vertices(side_length - 2 * cos(22.5) * gap, sq_centers, angular_offset = 0);

// One blue-green colour per tile: no red, and green and blue from a seeded draw.
function palette(count, seed, lo, hi) =
  let (g = rands(lo, hi, count, seed), b = rands(lo, hi, count, seed + 1))
  [for (i = [0:count - 1]) [0, g[i], b[i]]];

oct_colors = palette(len(oct_centers), seed, 0.35, 0.95);
sq_colors = palette(len(sq_centers), seed + 2, 0.1, 0.45);

module tiles(vertices, colors, paths) {
  for (i = [0:len(vertices) - 1])
    color(colors[i]) polygon(points = vertices[i], paths = paths);
}

translate([-mid[0], -mid[1], 0]) {
  tiles(oct_vertices, oct_colors, [[0, 1, 2, 3, 4, 5, 6, 7, 0]]);
  tiles(sq_vertices, sq_colors, [[0, 1, 2, 3, 0]]);
}

// backing, seen through the gaps between tiles
color([0.02, 0.08, 0.16]) translate([0, 0, -2])
  difference() {
    square([n * pitch, m * pitch], center = true);
    square([hole[0] * pitch, hole[1] * pitch], center = true);
  }

color([0, 0.3, 0.25])
  text("Tessella", size = 22, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
