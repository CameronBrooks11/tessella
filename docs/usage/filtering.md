---
title: Removing Tiles
parent: Usage
nav_order: 2
---

# Removing tiles

`filter_center_points(centers, filter_list)` returns `centers` without the points that appear in `filter_list`.
Because every later step works from the list of centres, removing a centre removes the tile.

```scad
use <tessella/tess.scad>

side = 10;

all_centers = squares_centers_rect(side, 5, 5);
centers = filter_center_points(all_centers, [[20, 20], [10, 20], [30, 20], [20, 10], [20, 30]]);

generic_poly(vertices = squares_vertices(side - 1, centers), paths = [[0, 1, 2, 3, 0]]);
```

This cuts a plus-shaped hole in a 5 × 5 grid.

## Finding the coordinates

The workflow the examples use:

1. Generate the centres and `echo()` them.
2. Preview with `print_points()` to see which coordinate belongs to which tile.
3. Copy the coordinates of the tiles to remove into a filter list.

```scad
use <tessella/tess.scad>

centers = hexagons_centers_radial(radius = 10, levels = 2);
echo(centers);

generic_poly(vertices = hexagons_vertices(9, centers), paths = [[0, 1, 2, 3, 4, 5, 0]]);
print_points(centers, text_size = 1.5, pointD = 0.5, point_color = "Red");
```

The console shows:

```text
ECHO: [[-17.3205, 0], [0, 0], [17.3205, 0], [-8.66025, 15], [8.66025, 15], [-8.66025, -15], [8.66025, -15]]
```

## Tolerance

OpenSCAD prints numbers to six significant figures, so `17.3205` in the console is really `17.3205080…`. A filter
point copied from the console is therefore slightly off.

`filter_center_points()` allows for this. Two points match when every coordinate differs by less than `tolerance`,
which defaults to `EPSILON`, 0.001. A coordinate below 1000 is printed with at least three decimal places, so the
rounding error stays under that.

Past 1000 the console shows fewer decimals and a copied point can miss. Pass a larger tolerance:

```scad
use <tessella/tess.scad>

all_centers = hexagons_centers_rect(radius = 500, n = 40, m = 40);
echo(all_centers[1560]); // prints [33775, 0]; the value is 33774.99…

missed = filter_center_points(all_centers, [[33775, 0]]);
centers = filter_center_points(all_centers, [[33775, 0]], tolerance = 0.5);
echo(len(all_centers), len(missed), len(centers)); // 1600, 1600, 1599
```

## Filtering by rule

A filter list is only one way to choose tiles. The centres are a list, so a list comprehension works too, and does
not need coordinates copied from the console:

```scad
use <tessella/tess.scad>

radius = 10;

// keep only the hexagons within 45 units of the point [95, 80]
centers = [for (c = hexagons_centers_rect(radius, 12, 12)) if (norm(c - [95, 80]) < 45) c];

generic_poly(vertices = hexagons_vertices(radius - 1, centers), paths = [[0, 1, 2, 3, 4, 5, 0]]);
```

## Filter before the vertices

`generic_poly()` pairs `vertices[i]` with `centers[i]` when it colours the tiles. Filter the centres first and
compute the vertices from the filtered list, so the two stay the same length and in the same order.

For 4.8.8, filter the octagon centres and the square centres separately; they are separate lists.
