---
title: Examples
nav_order: 5
---

# Examples

The repository has seven examples under
[`examples/`](https://github.com/CameronBrooks11/tessella/tree/main/examples), one for each tiling and layout. Open
a file in OpenSCAD and preview it with F5.

Every example follows the same outline:

1. Generate the centres and `echo()` them.
2. Remove some with `filter_center_points()`.
3. Compute the vertices and draw them with `generic_poly()`, extruded and coloured.
4. Label the centres with `print_points()`.

The images below look straight down on each example. They were produced with:

```sh
openscad examples/hexagons/hexagons_radial_tess_example.scad -o hexagons_radial.png \
  --imgsize=800,600 --camera=0,0,0,0,0,0,0 --projection=o --viewall --autocenter
```

## Hexagons

### Radial

[`examples/hexagons/hexagons_radial_tess_example.scad`](https://github.com/CameronBrooks11/tessella/blob/main/examples/hexagons/hexagons_radial_tess_example.scad)

<img src="../assets/examples/hexagons_radial.png" alt="Five levels of hexagons with a wedge removed, labelled with their coordinates" height="340">

Five levels of hexagons of radius 10, drawn at radius 9 to leave a gap. Eleven centres are filtered out to cut a
wedge from the middle to the top edge. It shows:

- copying coordinates from the `echo()` output into a filter list
- `color_scheme = "scheme1"` with `alpha = 0.5`
- `print_points()` raised to the top of the extrusion with `translate()`

### Rectangular

[`examples/hexagons/hexagons_rect_tess_example.scad`](https://github.com/CameronBrooks11/tessella/blob/main/examples/hexagons/hexagons_rect_tess_example.scad)

<img src="../assets/examples/hexagons_rect.png" alt="A rectangular hexagon layout with tiles removed from two corners" height="340">

Five rows of six hexagons, with tiles removed from the left and right edges to change the outline.

## Squares

### Radial

[`examples/squares/squares_radial_tess_example.scad`](https://github.com/CameronBrooks11/tessella/blob/main/examples/squares/squares_radial_tess_example.scad)

<img src="../assets/examples/squares_radial.png" alt="Five levels of squares in staggered rows, with tiles removed near the top" height="340">

Five levels of squares of side 10 with no gap. The rows are staggered; see
[Layouts](../usage/layouts.md#radial).

### Rectangular

[`examples/squares/squares_rect_tess_example.scad`](https://github.com/CameronBrooks11/tessella/blob/main/examples/squares/squares_rect_tess_example.scad)

<img src="../assets/examples/squares_rect.png" alt="A 9 by 6 grid of squares with alternate columns partly removed" height="340">

A 9 × 6 grid with every other column removed above the bottom row, leaving a comb.

## Triangles

Both triangle examples generate enough tiles that the point labels are switched off. Set `print_pts = true` to see
them.

### Radial

[`examples/triangles/triangles_radial_tess_example.scad`](https://github.com/CameronBrooks11/tessella/blob/main/examples/triangles/triangles_radial_tess_example.scad)

<img src="../assets/examples/triangles_radial.png" alt="Sixteen levels of triangles with the four central triangles removed" height="340">

Sixteen levels, 361 triangles, with the four at the centre removed. It passes `angular_offset = 30, rect = false` to
`triangle_vertices()`, which radial centres need.

### Rectangular

[`examples/triangles/triangles_rect_tess_example.scad`](https://github.com/CameronBrooks11/tessella/blob/main/examples/triangles/triangles_rect_tess_example.scad)

<img src="../assets/examples/triangles_rect.png" alt="A rectangular triangle layout with a zigzag band removed" height="340">

Fifteen rows of nine triangles with a zigzag band removed from the left edge to the middle.

## 4.8.8

[`examples/tess_4_8_8/tess_4_8_8_tess_example.scad`](https://github.com/CameronBrooks11/tessella/blob/main/examples/tess_4_8_8/tess_4_8_8_tess_example.scad)

<img src="../assets/examples/tess_4_8_8.png" alt="A 7 by 7 grid of octagons with squares in the gaps, and a hole in the middle" height="340">

A 7 × 7 grid of octagons and the 6 × 6 squares between them. It shows:

- two lists of centres, filtered separately: the four corner octagons and the central one, and the four squares
  around the centre
- the squares drawn with `angular_offset = 0`
- a different colour scheme and opacity for each kind of tile

## Known issues

- In the two hexagon examples, setting `filter = false` does not show the unfiltered pattern. The line
  `centers = filter ? filtered_centers : centers;` refers to itself, so `centers` is undefined and OpenSCAD warns
  `Ignoring unknown variable "centers"`. The other examples use `unfiltered_centers` there and work either way.
