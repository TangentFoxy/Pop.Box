# Supported Drawables

Pop.Box supports three [Drawables][1]: Canvas, Image, Video

Additionally, you can use in the place of any Drawable `false` to stop rendering
of whatever is using a Drawable, or a table of color values.

Color values are in the form `{r, g, b, a}` where `r` is 0 to 255 red, `g` is
the same range for green, `b` is the same range for blue, and `a` is the same
range for alpha. `a` is optional, but in the event that any element uses
transparency, could screw up your rendering.

[1]: https://love2d.org/wiki/Drawable
