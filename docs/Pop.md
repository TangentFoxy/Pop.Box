# Pop Module

This is the main module that allows you to access everything else in Pop.Box.
Simply require it (`local pop = require "pop"`) and define LÖVE callbacks for:

- `pop.update(dt)`
- `pop.draw()`
- `pop.mousemoved(x, y, dx, dy)` (when using LÖVE 0.10.0 or later)
- `pop.mousepressed(x, y, button)`
- `pop.mousereleased(x, y, button)`
- `pop.keypressed(key)`
- `pop.keyreleased(key)`
- `pop.textinput(text)`

Every callback returns `true`/`false` for whether or not the event was handled.
For example, using the `mousepressed` event handler:

```lua
function love.mousepressed(x, y, button)
    local handled = pop.mousepressed(x, y, button)
    if not handled then
        -- do something useful
    end
end
```

## Creating Elements

Once `pop` has been required, you can create [Elements][1] and interact with
them. Most elements can be created like this: `local box = pop.box(...)`

For more information, see the [Elements documentation][1].

## Skinning Elements

See the [Skins][2] documentation.

## Custom Elements/Skins/Extensions

Any `.lua` file placed in the `elements`, `skins`, and `extensions` directories
within the module will be loaded and available as appropriate. See the
documentation on each for how to make them:

- [Elements][1]
- [Skins][2]
- [Extensions][3]

Also of use, there is a separate set of docs about how Pop.Box works under the
surface: [Pop Module (dev)][4]

[1]: ./Elements.md
[2]: ./Skins.md
[3]: ./Extensions.md
[4]: ./dev/Pop.md
