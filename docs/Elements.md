# Elements

Elements are the core of Pop.Box.

- Elements are arranged hierarchically.
- When an element is moved, its child elements move with it.
- When an element is resized, it resizes in a way that makes sense based on its
  alignment.
- Elements are drawn from the top down (meaning child elements will always draw
  on top of their parents.)

The alignment stuff is much easier explained by experimenting or running the
demo, please check it out!

All elements have the following standard methods:

- `move(x, y)` - Moves the element by `x`/`y`.
- `setPosition(x, y)` - Sets the `x`/`y` position based on current alignment.
- `getPosition()` - Returns `x` and `y` position based on current alignment.
- `setSize(x, y)` - Sets the witdh/height of the element. Will stretch based on
  alignment (run the demo to see an example).
- `getSize()` - Returns width and height of the element.
- `align(horizontal, vertical)` - Sets alignment based on the parent's position
  and size. Valid `horizontal` strings: `left`, `center`, `right`. Valid
  `vertical` strings: `top`, `center`, `bottom`.
- `alignTo(element, horizontal, vertical)` - Sets alignment based on an
  element's position and size. Same `horizontal`/`vertical` strings as `align()`
- `setAlignment(horizontal, vertical)` - Sets alignment *values* to this, but
  does not move the element. Same `horizontal`/`vertical` strings as `align()`
- `setSkin(skin)` - Sets the skin (see [Skins.md][1]) used for this element.

**Note**! Calls to `align()`, `alignTo()`, and `setAlignment()` change what
positions will be returned, and how positioning and resizing will work. Run the
demo to see how these affect things.

## Box Element

Box is the simplest element, a rectangular area.

`pop.box(parent, skin)`
If `parent` not specified, uses `pop.window` (the top level element).
If `skin` is not specified, uses `pop.currentSkin` (see [Skins.md][1]).

TODO Make it possible to just specify skin?

## Text Element (NOT DEFINED YET!)

Text is used to draw text.

`pop.text(parent, text, skin)`
If `parent` not specified, uses `pop.window` (the top level element).
If `skin` is not specified, uses `pop.currentSkin` (see [Skins.md][1]).

TODO Make it possible to just specify text, or just text and skin?
TODO Make it possible to use setting size on text to actually calculate what
     font size will make that work?

# Excluding Movement/Rendering

If you set `excludeMovement` to `true` on any element, it and its children will
not be moved unless its own movement methods are used.

If you set `excludeRendering` to `true` on any element, it and its children will
not be rendered.

[1]: ./Skins.md
