- `addChild()` Adds children to `@window` instead of itself. This may cause
  issues with expectation vs result. A user expects when using `addChild()` that
  an element will be a direct child of `window`, not that it will end up in a
  sub-element.
