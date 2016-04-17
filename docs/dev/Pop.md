# Pop Module (dev)

(This document focuses on the structure and code of Pop.Box, not how to use it.
 See the [regular documentation][1] for that.)

TODO: Write me.

## Notes

- `pop.mousereleased()` Handling a click maybe should *not* check bounds.
  Handling a mouse release should maybe *not* check for `excludeDraw`. If an
  element was already selected and then went invisible, I'm probably breaking
  things worse by doing this. This has been changed.

[1]: ../Pop.md
