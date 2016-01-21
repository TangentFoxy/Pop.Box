# Skins

Skins are simply tables containing information on how to draw elements that have
been assigned them. Skins are loaded from Pop's `skins` directory when you
require it.

- `background` - A [Drawable][1] drawn before the `foreground`, or if a table,
  assumed to be a [color][2] and that color is used (if `false`, is ignored).
- `foreground` - A [Drawable][1] drawn after the `background`, or if a table,
  assumed to be a [color][2] and that color is used (if `false`, is ignored).
- `draw(element)` - If defined, will be used to render an element instead of the
  standard drawing method.

**Note**: Supported Drawables: Canvas, Image, Video

TODO various text style infos!

[1]: https://love2d.org/wiki/Drawable
[2]: https://love2d.org/wiki/love.graphics.setColor
