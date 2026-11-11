---
title: Reference
nav_order: 4
has_children: true
---

# Reference

Every function and module the library provides, by file.

| Page                          | Provides                                                                                   | Source                             |
| ----------------------------- | ------------------------------------------------------------------------------------------ | ---------------------------------- |
| [Triangles](triangles.md)     | `triangles_centers_rect`, `triangles_centers_radial`, `triangle_vertices`                  | `src/regular/triangles.scad`       |
| [Squares](squares.md)         | `squares_centers_rect`, `squares_centers_radial`, `squares_vertices`                       | `src/regular/squares.scad`         |
| [Hexagons](hexagons.md)       | `hexagons_centers_rect`, `hexagons_centers_radial`, `hexagons_vertices`                    | `src/regular/hexagons.scad`        |
| [4.8.8](tess-4-8-8.md)        | `octagons_centers_rect`, `squares_8_8_centers_rect`, `octagons_vertices`                   | `src/semi_regular/tess_4_8_8.scad` |
| [Utilities](utilities.md)     | `generic_poly`, `print_points`, `filter_center_points`, `is_point_in_list`, `points_equal`, `get_gradient_color`, `EPSILON` | `src/tessUtils.scad` |

`use <tessella/tess.scad>` provides all of them. `include <tessella/tess.scad>` also provides `EPSILON`.

The files under `src/` can be imported one at a time; each regular tiling pulls in the utilities it needs.
`tess_4_8_8.scad` is the exception: it calls `squares_centers_rect()` without importing `squares.scad`, so import it
through `tess.scad`.

Conventions that hold throughout:

- Points are `[x, y]`. A list of centres is a list of points. A list of vertices is a list of polygons, each a list of
  points, in the same order as the centres it was computed from.
- Lengths are in the units of your model. Angles are in degrees.
- Only `generic_poly()` and `print_points()` are modules. Everything else is a function.
- The triangle function is `triangle_vertices`, singular. The others are plural: `squares_vertices`,
  `hexagons_vertices`, `octagons_vertices`.
