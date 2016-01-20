# Pop.Box

*Do not mix with [Cola][1].*

Pop.Box attempts to make a GUI system for use in the [LÖVE][2] engine that is
easy to use, requiring as little code as possible to get working, but also
extensible, allowing for complex interfaces to be built in it.

I've never written a GUI library before..so we'll see how that goes.

```lua
local pop = require "pop"
-- define love callbacks here (update, draw, textinput, mouse/key events)
local box = pop.box()
```

## Using

Elements store position, size, and child elements. When moved, an element's
children also move. Elements have simple methods for adjusting their position
and size.

`pop.window` - An element representing the game window. It will not auto-resize.

Any element (and its children) with `excludeMovement == true` will not be moved
except when its `move()` or `setPosition()` are called.

Children render on top of their parents. (Rendering starts at `pop.window` and
loops down.) Any element (and its children) with `excludeRendering == true` will
not be rendered.

See [Elements.md][3] for the standard methods each element has, and what
elements are available.

[1]: https://en.wikipedia.org/wiki/Cola_(programming_language)
[2]: https://love2d.org/
[3]: ./Elements.md
