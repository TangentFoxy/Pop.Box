-- Note that the "default" name is a bit of a misnomer, as this does not
-- specify the defaults used in Pop.Box elements (they define their own)

--TODO make this actually specify defaults and be used (along with redoing the
--      skinning system entirely)

import graphics from love

return {
    background: {0, 0, 0, 220}
    color: {255, 255, 255, 250}
    font: graphics.newFont 14
}
