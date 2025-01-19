# Hexagons Docs

This explains how the hexagons tesselation is generated.

## Hexagons Geometry

![Hexagon Diagram](assets/hexagon_diag1.png)

In the diagram, \( `w` \) is the width of the hexagon, and \( `s` \) is the side length.

### Side Length `s`

In a regular hexagon, each side forms part of equilateral triangles, like triangle \( `ABC` \). The measure of angle \( `DBC` \) is 60 degrees, and the tangent of this angle is given by:

![Equation tan(60°) = |CD| / |DB|](<https://latex.codecogs.com/svg.image?\inline&space;\LARGE&space;\bg{white}{\text{tan}(60^\circ)&space;=&space;\frac{|CD|}{|DB|}}>)

Since \( \text{tan}(60^\circ) = \sqrt{3} \), we can write:

![Equation tan(60°) = √3 = (w / 2) / (s / 2) = w / s](<https://latex.codecogs.com/svg.image?\inline&space;\LARGE&space;\bg{white}{\text{tan}(60^\circ)&space;=&space;\sqrt{3}&space;=&space;\frac{w/2}{s/2}&space;=&space;\frac{w}{s}}>)

Thus, the relationship between the width \( `w` \) and the side length \( `s` \) is:

![Equation w = s√3](https://latex.codecogs.com/svg.image?\inline&space;\LARGE&space;\bg{white}{w&space;=&space;s\sqrt{3}})

### Solving for Side Length `s`

The side length \( `s` \) can be derived from the width \( `w` \) as:

![Equation s = w / √3](https://latex.codecogs.com/svg.image?\inline&space;\LARGE&space;\bg{white}{s&space;=&space;\frac{w}{\sqrt{3}}})

### Example Calculation

If the width \( `w` \) is given, you can calculate the side length using the above formula. For instance, if \( `w = 8` \) feet, then:

![Equation s = 8 / √3 ≈ 4.6 feet](https://latex.codecogs.com/svg.image?\inline&space;\LARGE&space;\bg{white}{s&space;=&space;\frac{8}{\sqrt{3}}&space;\approx&space;4.6\text{&space;feet}})

This general relationship allows you to determine the side length of any regular hexagon based on its width.

### References

[1] [mathcentral.uregina.ca 'Hexagon Tangent Problem'](https://mathcentral.uregina.ca/QQ/database/QQ.09.19/h/rob1.html)

## Tesselation of Regular Hexagons

With the above in mind we can figure out how to create a valid tesselation.

### Centers Calculation

- At the heart of the tesselation script is the calculation for the centers of the hexagons which make up the tesselation pattern. It supports generating hexagons using two different approaches:
  - rectilinear grid
  - "levels" based approach where hexagons are added in concentric levels around a central hexagon.
    The result is a list of 3D points where each datum represents the center point of a single hexagon: [[x0,y0,z0],[x1,y1,z1]...[xk-1,yk-1,zk-1]]. The value of `n` is the number of points in the list, for the rectilinear case this is straight forward as it is simply the value of `n * m` of the input grid. The concentric case is given by `H(L) = 3L^2 - 3L + 1`, the derivation for which is given in [Growth Rate of Hexagonal Pattern](#growth-rate) section below.
- The key parameters for hexagon center calculation include the `radius` of the hexagon, `levels` for concentric hexagon generation, and optional `spacing` and grid dimensions `(n, m)` for rectangular arrangements.

1. **Mathematical Relations**:

   - **Offset Calculation**:

     - The offsets for x and y coordinates (`offset_x` and `offset_y`) are calculated using trigonometric functions based on the hexagon's radius.
       ![Equation offset_x = radius \cdot cos(30^\circ)](<https://latex.codecogs.com/svg.image?\inline&space;\LARGE&space;\bg{white}{\color{White}offset_x&space;=&space;radius&space;\cdot&space;cos(30^\circ)}>)
       ![Equation offset_y = radius + radius \cdot sin(30^\circ)](<https://latex.codecogs.com/svg.image?\inline&space;\LARGE&space;\bg{white}{\color{White}offset_y&space;=&space;radius&space;+&space;radius&space;\cdot&space;sin(30^\circ)}>)
     - These offsets are used to position the hexagons correctly in a grid, ensuring that each hexagon is placed with edges touching but not overlapping.

   - **Center Shift for Levels**:
     - For generating hexagons in levels around a central point, the script calculates a shift in the x-axis (`dx`) to center the hexagons. This shift is based on the number of levels and the x-offset.
       ![Equation dx = -(levels - 1) \cdot offset_x \cdot 2](<https://latex.codecogs.com/svg.image?\inline&space;\LARGE&space;\bg{white}{\color{White}dx&space;=&space;-(levels&space;-&space;1)&space;\cdot&space;offset_x&space;\cdot&space;2}>)

2. **Color Gradient**:
   - Optionally, a color gradient can be applied to the hexagons based on their normalized position within the pattern. This involves calculating the minimum and maximum x and y coordinates of the centers to normalize each center's position.
   - The normalized positions are then used to determine the color of each hexagon if a color scheme is provided, allowing for a gradient effect across the pattern.

### Growth Rate of Hexagonal Pattern {#growth-rate}

The growth rate of the hexagonal pattern in the concentric case is defined by the number of hexagons added at each new level. Let \( L \) be the level number, with \( L = 1 \) representing the central hexagon. Let \( H(L) \) be the total number of hexagons at level \( L \).

For the first level:

![Equation H(1) = 1](<https://latex.codecogs.com/svg.image?\inline&space;\LARGE&space;\bg{white}{\color{White}H(1)&space;=&space;1}>)

For each subsequent level, 6 more hexagons are added for each side of the hexagon formed in the previous level:

![Equation H_{added}(L) = 6(L - 1)](<https://latex.codecogs.com/svg.image?\inline&space;\LARGE&space;\bg{white}{\color{White}H_{\text{added}}(L)&space;=&space;6(L&space;-&space;1)}>)

The total number of hexagons at any level \( L \) is the sum of hexagons up to that level:

![Equation H(L) = 1 + \sum_{i=2}^{L} 6(i - 1)](<https://latex.codecogs.com/svg.image?\inline&space;\LARGE&space;\bg{white}{\color{White}H(L)&space;=&space;1&space;+&space;\sum_{i=2}^{L}&space;6(i&space;-&space;1)}>)

Simplifying the sum using the formula for the sum of the first \( n \) natural numbers:

![Equation \sum_{i=1}^{n} i = n(n + 1) / 2](<https://latex.codecogs.com/svg.image?\inline&space;\LARGE&space;\bg{white}{\color{White}\sum_{i=1}^{n}&space;i&space;=&space;\frac{n(n&space;+&space;1)}{2}}>)

We apply this to our sum:

![Equation H(L) = 1 + 6 \left( \frac{(L-1)L}{2} \right)](<https://latex.codecogs.com/svg.image?\inline&space;\LARGE&space;\bg{white}{\color{White}H(L)&space;=&space;1&space;+&space;6&space;\left(&space;\frac{(L-1)L}{2}&space;\right)}>)

Expanding the equation:

![Equation H(L) = 1 + 3L(L - 1)](<https://latex.codecogs.com/svg.image?\inline&space;\LARGE&space;\bg{white}{\color{White}H(L)&space;=&space;1&space;+&space;3L(L&space;-&space;1)}>)

Finally, we get the quadratic formula representing the total number of hexagons at level \( L \):

![Equation H(L) = 3L^2 - 3L + 1](<https://latex.codecogs.com/svg.image?\inline&space;\LARGE&space;\bg{white}{\color{White}H(L)&space;=&space;3L^2&space;-&space;3L&space;+&space;1}>)

This formula indicates a quadratic growth rate with respect to the number of levels.
