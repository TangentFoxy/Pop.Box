# element

This is the base of all elements, and useful for alignment purposes. It is also
the element type used for `pop.screen` (the top-level element of Pop.Box). All
methods here are available on all other elements (any differences are noted on
their documentation pages).

## Alignment

All elements have a `horizontal` and `vertical` alignment property. These modify
how elements are aligned and how positions are handled. For example, an element
aligned to the top-right will return the position of the top-right corner when
calling `getPosition()`.

- `horizontal` can be `left`, `center`, or `right`. Defaults to `left`.
- `vertical` can be `top`, `center`, or `bottom`. Defaults to `top`.

## Methods

Every method that does not return a value returns the element itself, so that
you can chain method calls (ex: `box:setSize(100, 50):align("right")`).

- `addChild(child)` Adds a child element.
- `removeChild(child)` Removes child element by reference or index. If `child`
  is a number, it will return the child at that index (after removing it).
- `getChildren()` Returns a numerically indexed table of child elements.
- `move(x, y)` Moves the element (and its children) by specified values.
  Parameters optional. (Children can exclude being moved with their parent. See
  [Excludes][1].)
- `setPosition(x, y)` Sets position of the element (and its children) based on
  the alignment of the element. Parameters optional. (Children can exclude being
  moved with their parent. See [Excludes][1].)
- `getPosition()` Returns x/y position of the element based on its alignment.
- `setSize(w, h)` Sets the width/height of the element, element keeps "in-place"
  based on its alignment. (For example, a right-aligned element will grow to the
  left.) Parameters optional.
- `getSize()` Returns the width/height of the element.
- `setWidth(w)` Sets the width of the element. Element stays "in-place" based on
  its alignment.
- `getWidth()` Returns the width of the element.
- `setHeight(h)` Sets the height of the element. Element stays "in-place" based
  on its alignment.
- `getHeight()` Returns the height of the element.
- `adjustSize(w, h)` Grows the element by a relative width/height. Element stays
  "in-place" based on its alignment.
- `align(horizontal, vertical, toPixel)` Aligns the element based on its margin
  and parent. `toPixel` is a boolean for pixel-perfect alignment, defaulting to
  `true`. See above section about alignment for valid values of `horizontal` and
  `vertical`. A parent element is required for this method.
- `alignTo(element, horizontal, vertical, toPixel)` Works just like `align()`,
  except that alignment is based on a specific element instead of the parent.
  Does not require a parent element.
- `setAlignment(horizontal, vertical)` Sets alignment values on the element
  *without* moving the element.
- `getAlignment()` Returns the `horizontal` and `vertical` alignment of the
  element.
- `setMargin(m)` Sets a margin to be used when aligning the element.
- `getMargin()` Returns the current margin value.
- `fill()` Resizes and aligns the element to fill its parent's area, with the
  element's margin taken into account on all sides.

[1]: ../Excludes.md
