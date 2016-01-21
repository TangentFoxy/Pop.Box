# Pop.Box

*Do not mix with [Cola][1].*

Pop.Box attempts to make a GUI system for use in the [LÖVE][2] engine that is
easy to use, requiring as little code as possible to get working, but also
extensible, allowing for complex interfaces to be built in it.

## Features

- Quickly set up and align GUI elements.
- Fully customizable alignment / styling.
- Supports moving/resizing things in ways that take the alignment headache away,
  without trying to do too much and become bloated.
- Supports custom elements/skins, make your own and move them into the
  appropriate directories for them to be automatically loaded.

## Usage

```lua
local pop = require "pop"
-- define LÖVE callbacks here (update, draw, textinput, mouse/key events)
local box = pop.box()
```

Docs: [pop Module][3], [Elements][4], [Skins][5]

[1]: https://en.wikipedia.org/wiki/Cola_(programming_language)
[2]: https://love2d.org/
[3]: ./docs/Pop.md
[4]: ./docs/Elements.md
[5]: ./docs/Skins.md
