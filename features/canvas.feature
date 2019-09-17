Feature: Canvas

@focus
Scenario: Creating a canvas
  Given c ← Canvas[10, 20]
  Then c.width = 10
    And c.height = 20
    And every pixel of c is Color[0, 0, 0]

@focus
Scenario: Writing pixels to a canvas
  Given c ← Canvas[10, 20]
    And red ← Color[1, 0, 0]
  When c[2, 3] = red
  Then c[2, 3] is red

@focus
Scenario: Constructing the PPM header
  Given c ← Canvas[5, 3]
  When ppm ← canvas_to_ppm(c)
  Then lines 1-3 of ppm are
    """
    P3
    5 3
    255
    """

Scenario: Constructing the PPM pixel data
  Given c ← Canvas[5, 3]
    And c1 ← Color[1.5, 0, 0]
    And c2 ← Color[0, 0.5, 0]
    And c3 ← Color[-0.5, 0, 1]
  When write_pixel(c, 0, 0, c1)
    And write_pixel(c, 2, 1, c2)
    And write_pixel(c, 4, 2, c3)
    And ppm ← canvas_to_ppm(c)
  Then lines 4-6 of ppm are
    """
    255 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 128 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 255
    """

Scenario: Splitting long lines in PPM files
  Given c ← Canvas[10, 2]
  When every pixel of c is set to Color[1, 0.8, 0.6]
    And ppm ← canvas_to_ppm(c)
  Then lines 4-7 of ppm are
    """
    255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
    153 255 204 153 255 204 153 255 204 153 255 204 153
    255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
    153 255 204 153 255 204 153 255 204 153 255 204 153
    """

Scenario: PPM files are terminated by a newline character
  Given c ← Canvas[5, 3]
  When ppm ← canvas_to_ppm(c)
  Then ppm ends with a newline character
