// Each layout must tile: neighbouring centres sit one pitch apart, no two
// centres are closer, and neighbouring tiles share an edge (two corners).
// `just test` fails on the ERROR a failed assert prints.

use <../tess.scad>

tol = 1e-6;

function dist(a, b) = norm([a[0] - b[0], a[1] - b[1]]);

function shared(p, q) = len([for (a = p, b = q) if (dist(a, b) < tol) 1]);

function pairs(n) = [for (i = [0:n - 2], j = [i + 1:n - 1]) [i, j]];

// Returns the number of neighbouring pairs, after checking the layout tiles.
function tiles(name, centers, polys, pitch) =
    let (
        ps = pairs(len(centers)),
        d_min = min([for (p = ps) dist(centers[p[0]], centers[p[1]])]),
        near = [for (p = ps) if (abs(dist(centers[p[0]], centers[p[1]]) - pitch) < tol) p],
        bad = [for (p = near) if (shared(polys[p[0]], polys[p[1]]) != 2) p]
    )
    assert(abs(d_min - pitch) < tol, str(name, ": closest centres ", d_min, " apart, expected ", pitch))
    assert(len(bad) == 0, str(name, ": neighbours without a shared edge ", bad))
    len(near);

// Every corner of every tile is `r` from its centre.
function on_radius(name, centers, polys, r) =
    let (bad = [for (i = [0:len(centers) - 1], v = polys[i]) if (abs(dist(v, centers[i]) - r) > tol) i])
    assert(len(bad) == 0, str(name, ": corners off the circumradius in tiles ", bad))
    true;

r = 10;
s = 10;

// Hexagons: 3L(L - 1) + 1 tiles in L levels, r * sqrt(3) apart.
for (L = [1:5])
    assert(len(hexagons_centers_radial(r, L)) == 3 * L * (L - 1) + 1, str("hexagons radial, ", L, " levels"));
hex_radial = hexagons_centers_radial(r, 3);
hex_rect = hexagons_centers_rect(r, 4, 3);
echo(
    hexagons_radial=tiles("hexagons radial", hex_radial, hexagons_vertices(r, hex_radial), r * sqrt(3)),
    hexagons_rect=tiles("hexagons rect", hex_rect, hexagons_vertices(r, hex_rect), r * sqrt(3)),
    hexagons_radius=on_radius("hexagons", hex_radial, hexagons_vertices(r, hex_radial), r)
);

// Squares: 3L(L - 1) + 1 tiles in L levels, rows offset by half a side
// (#12), n * m in a grid, one side apart.
for (L = [1:5])
    assert(len(squares_centers_radial(s, L)) == 3 * L * (L - 1) + 1, str("squares radial, ", L, " levels"));
assert(len(squares_centers_rect(s, 4, 3)) == 12, "squares rect, 4 x 3");
sq_radial = squares_centers_radial(s, 3);
sq_rect = squares_centers_rect(s, 4, 3);
echo(
    squares_radial=tiles("squares radial", sq_radial, squares_vertices(s, sq_radial), s),
    squares_rect=tiles("squares rect", sq_rect, squares_vertices(s, sq_rect), s),
    squares_radius=on_radius("squares", sq_rect, squares_vertices(s, sq_rect), s / sqrt(2))
);

// Triangles: neighbours are twice the inradius, s / sqrt(3), apart.
tri_radial = triangles_centers_radial(s, 4);
tri_rect = triangles_centers_rect(s, 4, 3);
echo(
    triangles_radial=tiles("triangles radial", tri_radial, triangle_vertices(s, tri_radial, angular_offset=30, rect=false), s / sqrt(3)),
    triangles_rect=tiles("triangles rect", tri_rect, triangle_vertices(s, tri_rect), s / sqrt(3)),
    triangles_radius=on_radius("triangles", tri_rect, triangle_vertices(s, tri_rect), s / sqrt(3))
);

// 4.8.8: octagons one pitch apart share an edge, and each square shares an
// edge with the four octagons around it.
oct_side = 2 * r / sqrt(4 + 2 * sqrt(2));
pitch = oct_side * (1 + sqrt(2));
oct = octagons_centers_rect(r, 4, 3);
sq = squares_8_8_centers_rect(r, 4, 3);
oct_polys = octagons_vertices(r, oct);
sq_polys = squares_vertices(oct_side, sq, angular_offset=0);
assert(len(oct) == 12 && len(sq) == 6, "4.8.8, 4 x 3 octagons and the 3 x 2 squares between them");
sq_oct_edges = len([for (q = sq_polys, o = oct_polys) if (shared(q, o) == 2) 1]);
assert(sq_oct_edges == 4 * len(sq), str("4.8.8: ", sq_oct_edges, " square-octagon edges, expected ", 4 * len(sq)));
echo(octagons=tiles("4.8.8 octagons", oct, oct_polys, pitch), octagon_square_edges=sq_oct_edges);

// filter_center_points removes exactly the listed centres, within tolerance.
kept = filter_center_points(hex_radial, [[0, 0], [r * sqrt(3) + 1e-4, 0], [100, 100]]);
assert(len(kept) == len(hex_radial) - 2, "filter_center_points removes the two listed centres present");
assert(len([for (c = kept) if (norm(c) < tol) 1]) == 0, "filter_center_points keeps a removed centre");
