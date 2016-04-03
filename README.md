# Pop.Box

*Do not mix with [Cola][1].*

Pop.Box is a GUI library for use in the [LÖVE][2] engine, designed to be easy to
use and require as little code as possible to set up. It is primarily designed
to make it easy to experiment with GUIs during development.

## Features

- Quickly set up and align GUI elements.
- Fully customizable alignment / styling.
- Moving/resizing elements takes alignment into account.
- Extensible: Make your own elements, skins, extensions, and everything is
  automatically loaded.

## Usage

The basics:

```lua
local pop = require "pop"
-- define LÖVE callbacks here (update, draw, textinput, mouse/key events)
local window = pop.window():align("center"):setTitle("Welcome!")
window:addChild(pop.text("Welcome to Pop.Box()!"))
```

For more examples, see the code in `demo`. For documentation, see `docs`.

# Documentation

**Note**: Docs not written just yet. Will be soon.

- [Pop Module][3] (The main module/interface.)
- [Elements][4] (Basic features of elements/types of elements.)
- [Skins][5] (A basic system for quickly applying settings to many elements.)
- [Extensions][7] (A way to load custom code in.)
- [Drawables][6] (Reference for what can be used as a background/color.)

[1]: https://en.wikipedia.org/wiki/Cola_(programming_language)
[2]: https://love2d.org/
[3]: ./docs/Pop.md
[4]: ./docs/Elements.md
[5]: ./docs/Skins.md
[6]: ./docs/Drawables.md
[7]: ./docs/Extensions.md
