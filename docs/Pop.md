# `pop` Module

`pop` is the name of the Pop.Box module. You are expected to require it and then
define the following callbacks in LÖVE's callbacks: `pop.update(dt)`,
`pop.draw()`, `pop.textinput(text)`, `pop.mousepressed(button, x, y)`,
`pop.mousereleased(button, x, y)`, `pop.keypressed(key)`, `pop.keyreleased(key)`

Once that has been done (or at the very least, `pop` has been required and a
callback is set up for `pop.draw`), you can start creating [Elements][1] and
drawing them.

Also look into [Skins][2], which can make it easy to apply styles to many
elements at once.

## `pop` Values / Methods

- `pop.window` is the top level element. It essentially represents the game
  window.
- `pop.focused` holds a reference to the last clicked on element (that handled
  the click using `element:mousepressed()` (see [Elements.md][1])).
- `pop.create(element, parent, ...)` is how elements are actually created,
  `element` is a string naming the desired element. There are wrappers around
  any element that doesn't conflict with a key in the `pop` module so that you
  can call `pop.element(parent, ...)` instead.
- `pop.load()` loads elements and skins, and sets up `pop.window`. This is used
  internally, and will probably lead to issues if you use it (namely, destroying
  Pop.Box's access to any existing GUI).
- `pop.skin(element, skin, stop)` will apply the specified [skin][2] to the
  specified `element` and its children (unless `stop` is set).

## `pop` Callbacks

- `pop.update(dt)` is used so that any element can have a frame-by-frame update
  attached to it.
- `pop.draw()` is used to draw everything.
- `pop.debugDraw()` can be used to draw everything in existence, to try to help
  figure out exactly what's going on.
- `pop.textinput(text)` is used to grab text input for any focused element that
  can accept it.
- `pop.mousepressed(button, x, y)` is used to detect and handle when an element
  is clicked on. See [Elements.md][1].
- `pop.mousereleased(button, x, y)` is used to detect and handle when a mouse
  button is released over an element. See [Elements.md][1].

- `pop.keypressed(key)` is not used yet, but probably will be used in the
  future.
- `pop.keyreleased(key)` is also not used yet, but probably will be used in the
  future.

[1]: ./Elements.md
[2]: ./Skins.md
