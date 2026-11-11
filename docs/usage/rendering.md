---
title: Rendering
parent: Usage
nav_order: 3
---

# Rendering

## generic_poly

`generic_poly()` draws one polygon for each entry in `vertices`.

```scad
use <tessella/tess.scad>

centers = squares_centers_rect(side = 10, n = 4, m = 3);
vertices = squares_vertices(side = 9, centers = centers);

generic_poly(vertices = vertices, paths = [[0, 1, 2, 3, 0]]);
```

With only `vertices` and `paths` the result is flat 2D geometry. Add `extrude` for a solid:

```scad
use <tessella/tess.scad>

centers = squares_centers_rect(side = 10, n = 4, m = 3);
vertices = squares_vertices(side = 9, centers = centers);

generic_poly(vertices = vertices, paths = [[0, 1, 2, 3, 0]], extrude = 5);
```

`paths` is passed straight to OpenSCAD's `polygon()` and is shared by every tile. Use the one for the shape:

| Shape    | `paths`                             |
| -------- | ----------------------------------- |
| Triangle | `[[0, 1, 2, 0]]`                    |
| Square   | `[[0, 1, 2, 3, 0]]`                 |
| Hexagon  | `[[0, 1, 2, 3, 4, 5, 0]]`           |
| Octagon  | `[[0, 1, 2, 3, 4, 5, 6, 7, 0]]`     |

## Gaps between tiles

The layouts place tiles so they touch. To leave a gap, lay out the centres at full size and draw the vertices
smaller:

```scad
use <tessella/tess.scad>

radius = 10;
shrink = 1;

centers = hexagons_centers_rect(radius, 5, 4);
vertices = hexagons_vertices(radius - shrink, centers);

generic_poly(vertices = vertices, paths = [[0, 1, 2, 3, 4, 5, 0]]);
```

The gap that results depends on the shape, because `radius` and `side` relate differently to the distance across a
tile:

| Shape    | Shrink this | Gap between neighbours           |
| -------- | ----------- | -------------------------------- |
| Square   | `side`      | 1 × the shrink                   |
| Triangle | `side`      | 0.577 × the shrink (1/√3)        |
| Hexagon  | `radius`    | 1.732 × the shrink (√3)          |
| Octagon  | `radius`    | 1.848 × the shrink (2 cos 22.5°) |

To make a perforated plate, subtract the extruded tiles from a slab:

```scad
use <tessella/tess.scad>

radius = 6;
centers = hexagons_centers_rect(radius, 8, 6);
vertices = hexagons_vertices(radius - 1, centers);

difference() {
    translate([-10, -10, 0]) cube([100, 65, 3]);
    translate([0, 0, -1]) generic_poly(vertices = vertices, paths = [[0, 1, 2, 3, 4, 5, 0]], extrude = 5);
}
```

## Colour

Pass both `centers` and `color_scheme` and each tile is coloured by where its centre sits in the pattern.

```scad
use <tessella/tess.scad>

centers = hexagons_centers_radial(radius = 10, levels = 4);
vertices = hexagons_vertices(radius = 9, centers = centers);

generic_poly(vertices = vertices, paths = [[0, 1, 2, 3, 4, 5, 0]], centers = centers, color_scheme = "scheme3",
             alpha = 0.8, extrude = 2);
```

The centre's position is normalised to the bounding box of all the centres, giving `x` and `y` between 0 and 1. The
scheme maps those to red, green and blue:

| `color_scheme` | Red     | Green   | Blue    |
| -------------- | ------- | ------- | ------- |
| `"scheme1"`    | x       | 1 − x   | y       |
| `"scheme2"`    | 1 − y   | x       | y       |
| `"scheme3"`    | y       | 1 − y   | x       |
| `"scheme4"`    | 1 − x   | x       | 1 − y   |
| `"scheme5"`    | x       | x · y   | 1 − x   |
| `"scheme6"`    | 1 − x·y | y       | x       |
| anything else  | 0.9     | 0.9     | 0.9     |

Things to know:

- `color_scheme` without `centers` has no effect; the tiles are drawn in the default colour.
- `alpha` is only applied together with a colour scheme.
- `centers` must be the list the vertices were computed from. `generic_poly()` colours tile `i` from `centers[i]`.
- To colour the whole pattern one colour, leave both out and wrap the call in `color()`.

`get_gradient_color(x, y, scheme)` is the function behind the table, and can be called directly.

## Point labels

`print_points()` writes the coordinates of each point next to it and marks it with a sphere. It is meant for working
out which coordinates to put in a filter list.

```scad
use <tessella/tess.scad>

centers = squares_centers_rect(side = 10, n = 3, m = 2);

generic_poly(vertices = squares_vertices(9, centers), paths = [[0, 1, 2, 3, 0]]);
print_points(centers, text_size = 1, color = "Black", pointD = 0.5, point_color = "Red", fn = 12);
```

Always pass `pointD`. It sets the sphere size, and the label position is derived from it; without it OpenSCAD reports
`undefined operation` warnings and the labels are not moved to their points.

Text is slow to draw. The examples that generate hundreds of tiles switch the labels off behind a `print_pts` flag.
