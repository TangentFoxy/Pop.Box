# Skins

**Note**: This system is mostly an after-thought right now, and will probably
be replaced with something else entirely.

Skins are simple tables containing information to style a variety of elements.
Use `pop.skin()` to apply a skin to an element and its children (see
[Pop Module][3] documentation). Skins are loaded from the `skins` directory.

- `color` - A table of RGBA values (see [love.graphics.setColor][2]), used as a
  foreground color (currently for `text` elements only).
- `background` - A [supported Drawable][4], used for backgrounds (currently
  used on `box` elements only).
- `font` - A [Font][5].

[2]: https://love2d.org/wiki/love.graphics.setColor
[3]: ./Pop.md
[4]: ./Drawables.md
[5]: https://love2d.org/wiki/Font
