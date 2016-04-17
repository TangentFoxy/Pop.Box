# Skins

**Note**: This system is mostly an after-thought right now, and will probably
be replaced with something else entirely.

Skins are simple tables containing information to style a variety of elements.
Use `pop.skin()` to apply a skin to an element and its children. Skins are
loaded from the `skins` directory.

**Note**: Skins are only applied on elements as-is. You can't change elements
added in the future by setting a skin, or change a skin to modify elements that
have had it applied. In the future, I might change this. (This skinning system
is basically a placeholder.)

Usage: `pop.skin(element, skin, depth)`

- `element` is the element to start with.
- `skin` is the skin (a table).
- `depth` is how many levels of children of the element should be skinned.
  Defaults to skinning as many levels of children as there are.

Alternately, you can think of depth as a boolean for "don't recurse". By
setting it to `true`, you can stop skinning children. `false` (and default
behavior) will skin all levels of children.

## What's inside a skin

- `color` - A table of RGBA values (see [love.graphics.setColor][2]), used as a
  foreground color (currently for `text` elements only).
- `background` - A [supported Drawable][4], used for backgrounds (currently
  used on `box` elements only).
- `font` - A [Font][5].

[2]: https://love2d.org/wiki/love.graphics.setColor
[3]: ./Pop.md
[4]: ./Drawables.md
[5]: https://love2d.org/wiki/Font
