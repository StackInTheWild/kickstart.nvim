local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

return {
  s(
    'sthost',
    fmt(
      [[
:host {{
  display: {};
  {}
}}

:host([hidden]) {{
  display: none !important;
}}
]],
      {
        i(1, 'block'),
        i(2, ''),
      }
    )
  ),

  s(
    'sthostattr',
    fmt(
      [[
:host([{}]) {{
  {}
}}
]],
      {
        i(1, 'attribute'),
        i(2, ''),
      }
    )
  ),

  s(
    'sthostclass',
    fmt(
      [[
:host(.{}) {{
  {}
}}
]],
      {
        i(1, 'class-name'),
        i(2, ''),
      }
    )
  ),

  s(
    'stslotted',
    fmt(
      [[
::slotted({}) {{
  {}
}}
]],
      {
        i(1, '*'),
        i(2, ''),
      }
    )
  ),

  s(
    'stvar',
    fmt('--gen-{}: var(--gen-{});', {
      i(1, 'component-property'),
      i(2, 'token'),
    })
  ),
}
