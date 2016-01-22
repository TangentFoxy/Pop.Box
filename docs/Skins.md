# Skins

Skins are simple tables containing information to style a variety of elements.
Use `pop.skin()` to apply a skin to an element and its children (see
[`pop` Module][3]). Skins are loaded from the `skins` directory.

- `color` - [Color][2], used on text elements currently.
- `background` - A [supported Drawable][4], used for backgrounds (or `false` or
  a color).
- `font` - For text elements, what [Font][5] to use.

[1]: https://love2d.org/wiki/Drawable
[2]: https://love2d.org/wiki/love.graphics.setColor
[3]: ./Pop.md
[4]: ./Drawables.md
[5]: https://love2d.org/wiki/Font
