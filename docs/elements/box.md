# box

The box element is a rectangle that has a [supported Drawable][1] as its
background.

## Methods

- `setBackground(background)` Using a supported Drawable (see above), set the
  background.
- `getBackground()` Returns the background in use.
- `setColor(red, green, blue, alpha)` Sets the background to the specified
  color. `alpha` is optional and defaults to `255`. Alternately, pass a table of
  color values (ex: `{red, green, blue, alpha}`).
- `getColor()` Returns red, green, blue, and alpha color values of background.
  Errors if the background is not a color.

[1]: ../Drawables.md
