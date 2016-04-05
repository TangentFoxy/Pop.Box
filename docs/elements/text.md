# text

The text element is plain text in one color. Nothing special.

(**Note**: Other, more advanced text elements are planned, with support for
 things like line-wrapping and custom coloring and formatting of text.)

## Methods

- `setSize()` Unlike other elements, a size cannot be set. If this is called, it
  will fix the size of the text if it somehow was modified incorrectly.
- `setWidth()` Width cannot be set. If called, will fix the size of the text.
- `setHeight()` Height cannot be set. If called, will fix the size of the text.
- `setText(text)` Sets the text of the element. Will resize element to fit text.
  Newlines are supported. Defaults to an empty string.
- `getText()` Returns the text of the element.
- `setFont()` Sets the font to be used on this element. Will resize to fit the
  text and font.
- `setColor(red, green, blue, alpha)` Sets color of text. `alpha` is optional
  and defaults to `255`. Alternately, pass a table of color values (ex: `{red,
  green, blue, alpha}`).
- `getColor()` Returns red, green, blue, and alpha values of color.
