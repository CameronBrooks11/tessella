---
title: Utilities
parent: Reference
nav_order: 5
---

# Utilities

Defined in `src/tessUtils.scad`. These work with any list of points or polygons, not only the ones the tiling
functions return.

## generic_poly

```scad
generic_poly(vertices, paths, centers = undef, color_scheme = undef, alpha = 1, extrude = undef)
```

Draws one polygon for each entry in `vertices`.

| Parameter      | Meaning                                                                         |
| -------------- | ------------------------------------------------------------------------------- |
| `vertices`     | List of polygons, each a list of `[x, y]` points                                |
| `paths`        | Passed to `polygon()` for every polygon; the order in which to join the points  |
| `centers`      | One centre per polygon, used only to choose its colour                          |
| `color_scheme` | Name of a colour scheme; see [`get_gradient_color`](#get_gradient_color)        |
| `alpha`        | Opacity from 0 to 1, applied only when a colour scheme is in use                |
| `extrude`      | Height to extrude each polygon to; omit for 2D geometry                         |

Colour is applied only when both `centers` and `color_scheme` are given. Each centre is normalised to the bounding
box of `centers`, and the result is passed to `get_gradient_color()`. Polygon `i` takes its colour from
`centers[i]`, so the two lists must correspond.

```scad
use <tessella/tess.scad>

centers = squares_centers_rect(10, 4, 3);

generic_poly(vertices = squares_vertices(9, centers), paths = [[0, 1, 2, 3, 0]], centers = centers,
             color_scheme = "scheme4", alpha = 0.6, extrude = 3);
```

[Rendering](../usage/rendering.md) has more.

## print_points

```scad
print_points(points, text_size = 1, color = [0.1, 0.1, 0.1], pointD = undef, point_color = [0.1, 0.1, 0.1], fn = 8)
```

Labels each point with its coordinates and marks it with a sphere.

| Parameter     | Meaning                                        |
| ------------- | ---------------------------------------------- |
| `points`      | List of `[x, y]` points                        |
| `text_size`   | Size of the label text                         |
| `color`       | Colour of the label                            |
| `pointD`      | Radius of the marker sphere                    |
| `point_color` | Colour of the sphere                           |
| `fn`          | Number of facets of the sphere                 |

The label is centred `2 * pointD` beyond the point in Y and raised `2 * pointD` in Z, so it clears the marker.

```scad
use <tessella/tess.scad>

print_points(hexagons_centers_radial(10, 2), text_size = 1.5, color = "Black", pointD = 0.5, point_color = "Red");
```

### Known issues

- `pointD` defaults to `undef` but is needed to position the label. Without it OpenSCAD reports `undefined operation`
  and `Unable to convert translate(...)` warnings for every point. Always pass it.
- `pointD` is used as the sphere's radius, though its name and source comment say diameter.

## filter_center_points

```scad
filter_center_points(centers, filter_list, tolerance = EPSILON)
```

Returns `centers` without the points that match any point in `filter_list`.

| Parameter     | Meaning                                                |
| ------------- | ------------------------------------------------------ |
| `centers`     | List of points to filter                               |
| `filter_list` | List of points to remove                               |
| `tolerance`   | How far apart two coordinates can be and still match   |

The order of the remaining points is kept. Points in `filter_list` that match nothing are ignored.

```scad
use <tessella/tess.scad>

echo(filter_center_points([[0, 0], [10, 0], [20, 0]], [[10, 0.0002]]));
// ECHO: [[0, 0], [20, 0]]
```

[Removing tiles](../usage/filtering.md) covers the workflow.

## is_point_in_list

```scad
is_point_in_list(point, list, tolerance = EPSILON)
```

Returns `true` if `point` matches any point in `list`.

## points_equal

```scad
points_equal(p1, p2, tolerance = EPSILON)
```

Returns `true` if every coordinate of `p1` is within `tolerance` of the same coordinate of `p2`. The comparison is
per coordinate, not a distance, and uses as many coordinates as `p1` has.

```scad
use <tessella/tess.scad>

echo(points_equal([0, 0], [0, 0.0005]), points_equal([0, 0], [0, 0.002]));
// ECHO: true, false
```

## get_gradient_color

```scad
get_gradient_color(normalized_x, normalized_y, color_scheme)
```

Returns an `[r, g, b]` colour for a position within a pattern.

| Parameter      | Meaning                                  |
| -------------- | ---------------------------------------- |
| `normalized_x` | Position along X, from 0 to 1            |
| `normalized_y` | Position along Y, from 0 to 1            |
| `color_scheme` | `"scheme1"` to `"scheme6"`               |

| `color_scheme` | Red     | Green   | Blue    |
| -------------- | ------- | ------- | ------- |
| `"scheme1"`    | x       | 1 − x   | y       |
| `"scheme2"`    | 1 − y   | x       | y       |
| `"scheme3"`    | y       | 1 − y   | x       |
| `"scheme4"`    | 1 − x   | x       | 1 − y   |
| `"scheme5"`    | x       | x · y   | 1 − x   |
| `"scheme6"`    | 1 − x·y | y       | x       |

Any other value returns light grey, `[0.9, 0.9, 0.9]`.

```scad
use <tessella/tess.scad>

echo(get_gradient_color(0.25, 0.5, "scheme1"));
// ECHO: [0.25, 0.75, 0.5]
```

## EPSILON

```scad
EPSILON = 1e-3;
```

The default tolerance for the point comparisons. It is a top-level variable, so it is visible in your file only with
`include <tessella/tess.scad>`. With `use`, the functions still default to it; to change the tolerance, pass
`tolerance` to the function.
