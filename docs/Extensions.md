# Extensions

Extensions are simply a way for custom code to be run after loading elements and
skins. Simply place a `.lua` file in the `extensions` directory, and it will be
required.

## Standard Extensions

There is only one standard extension, which modifies element classes to add a
more convenient getter/setter method to most get/set methods. For example,
instead of `element:getSize()`, just call `element:size()`. Instead of
`element:setSize(w, h)`, call `element:size(w, h)`.

This is mostly for a demo of what can be possible, but also might be useful.
