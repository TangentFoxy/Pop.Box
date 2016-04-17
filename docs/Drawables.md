# Supported Drawables

Pop.Box supports three [Drawables][1]: Canvas, Image, and Video.

**Note**: Video and Canvas support are untested.

Additionally, in the place of a Drawable, you can use `false` to not render
anything, or a table of color values. The color values should be in the format
LÖVE uses (`{red, green, blue, alpha}`, see [love.graphics.setColor][2]).

(The alpha value is optional, but not using an alpha is likely to mess up your
 rendering if an alpha is used *anywhere else*.)

[1]: https://love2d.org/wiki/Drawable
[2]: https://love2d.org/wiki/love.graphics.setColor
