# Elements

Elements are the core of Pop.Box.

Once `pop` has been required, you can create elements and interact with them.
Most elements can be created like this: `local box = pop.box(...)`

However, if an element's name clashes with a function name used in Pop.Box, you
will have to use `pop.create(type, ...)` where `type` is a string naming the
element type. (No standard elements do this.)

When creating an element, the first argument is its parent element. If the first
argument is not an element, it will be treated as the second argument. If it is
`false`, then an element with no parent will be created.

When no parent is specified, an element's parent is `pop.screen`, which is the
top-level element of Pop.Box. (This behavior can be modified by custom elements,
so check their documentation.)

## Available Elements

- [Element][1] (The base of all elements, and useful for alignment.)
- [Box][2] (A box, can be colored, or display a [supported Drawable][3].)
- [Text][4] (Plain text, no special features. Useful for basic labels and such.)
- [Window][5] (A movable window. Has a title and area for other elements.)

[1]: ./elements/element.md
[2]: ./elements/box.md
[3]: ./Drawables.md
[4]: ./elements/text.md
[5]: ./elements/window.md
