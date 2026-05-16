-- ys{motion}{char}  → add surround
-- ds{char}          → delete surround
-- cs{old}{new}      → change surround
-- S{char} (visual)  → surround selection
-- Examples:
--   ysiw"   → surround word with "
--   ysiw(   → surround word with ( )
--   yssb    → surround line with ( )
--   dst     → delete surrounding tag
--   cst<p>  → change surrounding tag to <p>
return {
  "kylechui/nvim-surround",
  version = "*",
  event   = "VeryLazy",
  config  = true,
}
