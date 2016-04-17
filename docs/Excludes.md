# Excludes

Any element can have a few boolean values set to exclude it from normal
operations for movement, rendering, and updating. Simply set the appropriate
value to a true value.

Note that any element using one of these excludes its children as well.

- `excludeMovement` Excludes movement caused by a parent being moved.
- `excludeUpdate` Excludes an element from being updated (by `pop.update()`).
- `excludeDraw` Excludes being rendered (by `pop.draw()`).

**Note**: `excludeDraw` also excludes an element from accepting the following
events:

- `mousepressed`
- `clicked`
- `keypressed`
- `textinput`

The reason for this is that it wouldn't make sense for an invisible element to
be capturing input. However, some events are passed through in case an element
becomes invisible while processing input.
