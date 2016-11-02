# Pop.Box

*Do not mix with [Cola][1].*

[![GitHub release](https://img.shields.io/github/release/Guard13007/Pop.Box.svg?maxAge=86400)](https://github.com/Guard13007/Pop.Box/releases/latest)
[![GitHub downloads](https://img.shields.io/github/downloads/Guard13007/Pop.Box/latest/total.svg?maxAge=86400)](https://github.com/Guard13007/Pop.Box/releases/latest)
[![GitHub issues](https://img.shields.io/github/issues-raw/Guard13007/Pop.Box.svg?maxAge=86400)](https://github.com/Guard13007/Pop.Box/issues)
[![GitHub license](https://img.shields.io/badge/license-MIT%20License-blue.svg?maxAge=86400)](https://github.com/Guard13007/Pop.Box/blob/master/LICENSE.txt)

Pop.Box is a GUI library for use in the [LÖVE][2] engine, designed to be easy to
use and require as little code as possible to set up. It is primarily designed
to make it easy to experiment with GUIs during development.

Supports LÖVE versions 0.9.1 and higher.

## Documentation

Building the documentation relies on a specific version of LDoc. Run
`sudo luarocks install ldoc 1.4.4-1` to install the necessary version.



**Note**: Currently rewriting and redesigning Pop.Box. The following info is out of date until I finish:

## Features

- Quickly set up and align GUI elements.
- Fully customizable alignment / styling.
- Moving/resizing elements takes alignment into account.
- Mouse and key input handling. (**Note**: Work in progress.)
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

**Note**: Due to this being so early in development...the above example doesn't
actually work as expected. `window` is a very new element.

For more examples, see the code in `demo`. For documentation, see `docs` (and
links to documentation below).

# Documentation

**Note**: Docs are a work in progress, sometimes lagging behind the actual code.

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
