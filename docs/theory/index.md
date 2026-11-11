---
title: Theory
nav_order: 6
has_children: true
---

# Theory

## Tilings by regular polygons

A tessellation, or tiling, covers the plane with tiles that leave no gaps and do not overlap. Tessella deals with
edge-to-edge tilings by regular polygons in which every vertex looks the same.

Such a tiling is named by its **vertex configuration**: the number of sides of each polygon around a vertex, in
order. In 4.8.8 every vertex is surrounded by a square and two octagons.

The polygons around a vertex must add up to a full turn. A regular polygon with $n$ sides has an interior angle of

$$
\frac{(n - 2) \cdot 180^\circ}{n}
$$

so a tiling with a single kind of tile needs that angle to divide 360°. Only three polygons qualify, and they give
the three **regular** tilings:

| Polygon  | Interior angle | Tiles at a vertex | Vertex configuration |
| -------- | -------------- | ----------------- | -------------------- |
| Triangle | 60°            | 6                 | 3.3.3.3.3.3          |
| Square   | 90°            | 4                 | 4.4.4.4              |
| Hexagon  | 120°           | 3                 | 6.6.6                |

Allowing more than one kind of polygon, while still requiring every vertex to be the same, gives eight more: the
**semi-regular**, or Archimedean, tilings.

## Status

| Vertex configuration | Polygons                         | Status                                           |
| -------------------- | -------------------------------- | ------------------------------------------------ |
| 3.3.3.3.3.3          | triangles                        | [Implemented](../reference/triangles.md)         |
| 4.4.4.4              | squares                          | [Implemented](../reference/squares.md)           |
| 6.6.6                | hexagons                         | [Implemented](../reference/hexagons.md)          |
| 4.8.8                | squares, octagons                | [Implemented](../reference/tess-4-8-8.md), rectangular layout only |
| 3.12.12              | triangles, dodecagons            | Planned                                          |
| 4.6.12               | squares, hexagons, dodecagons    | Planned                                          |
| 3.6.3.6              | triangles, hexagons              | Planned                                          |
| 3.4.6.4              | triangles, squares, hexagons     | Planned                                          |
| 3.3.3.3.6            | triangles, hexagons              | Planned                                          |
| 3.3.3.4.4            | triangles, squares               | Planned                                          |
| 3.3.4.3.4            | triangles, squares               | Planned                                          |

Each planned tiling has a placeholder file under
[`src/semi_regular/TODO/`](https://github.com/CameronBrooks11/tessella/tree/main/src/semi_regular/TODO). They hold a
header comment and no code, and `tess.scad` does not import them.

## Derivations

- [Hexagons](hexagons.md): the spacing of the hexagon layouts and the tile count of the radial one.
- [Octagons](octagons.md): the octagon dimensions behind the 4.8.8 spacing.

## References

- <https://jwilson.coe.uga.edu/EMT668/EMAT6680.2001/Hembree/tessellations/hingedtessellations.html>
- <https://e.math.cornell.edu/people/belk/projects/LaraMerling.pdf>
- <https://en.wikipedia.org/wiki/Euclidean_tilings_by_convex_regular_polygons#Archimedean,_uniform_or_semiregular_tilings>
