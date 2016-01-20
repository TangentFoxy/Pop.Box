# Elements

All elements have the following standard methods:

- `move(x, y)` - Moves from current position by `x`/`y`.
- `setPosition(x, y)` - Sets the `x`/`y` position based on current alignment.
- `getPosition()` - Returns `x` and `y` position based on current alignment.
- `setSize(x, y)` - Sets the witdh/height of the element. Will stretch based on
  alignment.
- `getSize()` - Returns width and height of the element.
- `align(alignment)` - Sets alignment based on the parent's position and size.
  `alignment` is a string specifying how to align: `top-left`, `top-center`,
  `top-right`, `left-center`, `center`, `right-center`, `bottom-left`,
  `bottom-center`, `bottom-right`
- `alignTo(element, alignment)` - Sets alignment based on an element's position
  and size. Same `alignment`'s as `align()`.
- `setAlignment(alignment)` - Sets alignment *value* to this, but does not move
  the element.
- `setSkin(skin)` - Sets the skin (see [Skins.md][1]) used for this element.

**Note**! Calls to `align()`, `alignTo()`, and `setAlignment()` change what
positions will be returned, and how positioning and resizing will work.

## Box Element

Box is the simplest element, a rectangular area that can be styled or used for
alignment.

`pop.box(parent, skin)`
If `parent` not specified, uses `pop.window` (the top level element).
If `skin` is not specified, uses `pop.currentSkin` (see [Skins.md][1]).

TODO Make it possible to just specify skin?

## Text Element

Text is used to draw text. Its styling is based on its skin, see [Skins.md][1]
for information on how to set that up.

`pop.text(parent, text, skin)`
If `parent` not specified, uses `pop.window` (the top level element).
If `skin` is not specified, uses `pop.currentSkin` (see [Skins.md][1]).

TODO Make it possible to just specify text, or just text and skin?

# Excluding Movement/Rendering

If you set `excludeMovement` to `true` on any element, it and its children will
not be moved unless its own movement methods are used.

If you set `excludeRendering` to `true` on any element, it and its children will
not be rendered.

[1]: ./Skins.md
