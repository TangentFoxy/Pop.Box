# Elements

Elements are the core of Pop.Box.

- Elements are arranged hierarchically.
- When an element is moved, its child elements move with it.
- When an element is resized, it resizes in a way that makes sense based on its
  set alignment.
- Elements are drawn from the top down (meaning child elements will always draw
  on top of their parents).

The alignment stuff is much easier explained by experimenting or running the
demo, please check it out!

All elements have the following standard methods:

- `move(x, y)` - Moves the element by `x`/`y`.
- `setPosition(x, y)` - Sets the `x`/`y` position based on current alignment.
- `getPosition()` - Returns `x` and `y` position based on current alignment.
- `setSize(x, y)` - Sets the witdh/height of the element. Will stretch based on
  alignment (run the demo to see an example).
- `getSize()` - Returns width and height of the element.
- `adjustSize(x, y)` - Adjusts element size by `x`/`y`.
- `align(horizontal, vertical)` - Sets alignment based on the parent's position
  and size. Valid `horizontal` strings: `left`, `center`, `right`. Valid
  `vertical` strings: `top`, `center`, `bottom`.
- `alignTo(element, horizontal, vertical)` - Sets alignment based on an
  element's position and size. Same `horizontal`/`vertical` strings as `align()`
- `setAlignment(horizontal, vertical)` - Sets alignment *values* to this, but
  does not move the element. Same `horizontal`/`vertical` strings as `align()`

**Note**! Calls to `align()`, `alignTo()`, and `setAlignment()` change what
positions will be returned, and how positioning and resizing will work. Run the
demo to see how these affect things.

(Elements are loaded from the `elements` directory, so place any custom ones in
there.)

## Box Element

Box is the simplest element, a rectangular area.

`pop.box(parent, background)`
If `parent` not specified, uses `pop.window` (the top level element).
If `background` is not specified, doesn't draw anything.

Additional methods:

- `setBackground()` - Sets background, you can use any [supported Drawable][3].
- `getBackground()` - Returns current background, which may be any
  [supported Drawable][3].
- `setColor(r, g, b, a)` - Sets background based on colors (`a` is alpha, and
  optional).
- `getColor()` - Returns background color, or errors if the background is not a
  color.

TODO Make it possible to just specify background?

## Text Element

Text is used to draw text.

`pop.text(parent, text, color)`
If `parent` not specified, uses `pop.window` (the top level element).
If `color` is not specified, uses white.

Overwritten methods:

- `setSize()` - Does not allow you to set the size, instead, it fixes the size
  if it is incorrect (mostly for internal use).

Additional methods:

- `setText(text)` - Sets text and modifies size to fit.
- `getText()` - Returns text.
- `setFont()` - Sets [Font][2] and modifies size to fit. Note: Empty text will
  have the height of the font (and presumably, a 0 width, size is based on
  [Font][2] objects).
- `getFont()` - Returns the [Font][2] in use.
- `setColor(r, g, b, a)` - Sets text color (`a` is alpha, and optional).
- `getColor()` - Returns text color.

TODO Make it possible to just specify text, or just text and color?
TODO Make it possible to use setting size on text to actually calculate what
     font size will make that work?

# Excluding Movement/Rendering

If you set `excludeMovement` to `true` on any element, it and its children will
not be moved unless its own movement methods are used.

If you set `excludeRendering` to `true` on any element, it and its children will
not be rendered.

If you set `excludeUpdating` to `true` on any element, it and its children will
not be rendered.

[1]: ./Skins.md
[2]: https://love2d.org/wiki/Font
[3]: ./Drawables.md
