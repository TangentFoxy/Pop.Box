# Pop.Box

*Do not mix with [Cola][1].*

Pop.Box attempts to make a GUI system for use in the [LÖVE][2] engine that is
easy to use, requiring as little code as possible to get working, but also
extensible, allowing for complex interfaces to be built in it.

I've never written a GUI library before..so we'll see how that goes.

## Features

```lua
local pop = require "pop"
-- define love callbacks here
local box = pop.box()
```

* `box` is a box for containing things.
* `text` is a class for handling text.
* Nothing else! Is alpha, just started.

[1]: https://en.wikipedia.org/wiki/Cola_(programming_language)
[2]: https://love2d.org/
