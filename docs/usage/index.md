---
title: Usage
nav_order: 3
has_children: true
---

# Usage

Every tessellation in the library is built the same way: centres, then vertices, then geometry.

| Step     | What you call                                                | What you get                                   |
| -------- | ------------------------------------------------------------ | ---------------------------------------------- |
| Centres  | `<shape>_centers_rect()` or `<shape>_centers_radial()`       | A list of `[x, y]` points, one per tile        |
| Filter   | `filter_center_points()`, optional                           | The same list with some points removed         |
| Vertices | `<shape>_vertices()`                                         | A list of polygons, each a list of `[x, y]`    |
| Geometry | `generic_poly()`                                             | 2D polygons, or solids if `extrude` is set     |

The first three steps are functions and return data. Only `generic_poly()` creates geometry. Nothing stops you from
using the points for something else: placing your own module at each centre, for instance.

```scad
use <tessella/tess.scad>

for (c = squares_centers_rect(side = 12, n = 4, m = 3))
    translate([c[0], c[1], 0]) cylinder(h = 5, d = 8);
```

## Pages

- [Layouts](layouts.md): the rectangular and radial layouts, how many tiles each produces and where they sit.
- [Removing tiles](filtering.md): cutting holes and shaping the outline of a pattern.
- [Rendering](rendering.md): `generic_poly()`, gaps between tiles, colour schemes and point labels.

## Conventions

- All points are 2D, `[x, y]`. The pattern lies on the XY plane.
- Lengths are in the units of your model. The library has no unit of its own.
- Angles are in degrees.
- Hexagons and octagons are sized by `radius`, the distance from the centre to a corner. Squares and triangles are
  sized by `side`.
- Rectangular layouts put their first tile's centre at the origin and grow along +X and +Y. Radial layouts are
  centred on the origin.
