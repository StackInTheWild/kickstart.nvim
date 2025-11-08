local ls = require 'luasnip'
local s = ls.snippet
local f = ls.function_node
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

-- Helper: turn filename into PascalCase component name
local function filename_component()
  local name = vim.fn.expand '%:t:r' -- e.g. "my-button.stories"
  name = name:gsub('%.stories$', '') -- strip ".stories"
  name = name:gsub('[-_](%w)', function(c) -- kebab/snake to camel
    return c:upper()
  end)
  return name:sub(1, 1):upper() .. name:sub(2) -- capitalize first
end

return {
  s(
    'story',
    fmt(
      [[
    import React from 'react';
    import {{ Meta, StoryObj }} from '@storybook/react';
    import {{ {} }} from './{}';

    const meta: Meta<typeof {}> = {{
      title: '{}',
      component: {},
      tags: ['autodocs'],
    }};
    export default meta;

    type Story = StoryObj<typeof {}>;

    export const {}: Story = {{
      args: {{
        {}
      }},
    }};
  ]],
      {
        f(filename_component), -- component import
        f(filename_component), -- import path
        f(filename_component), -- typeof
        f(function() -- Storybook title
          return 'components/' .. filename_component()
        end),
        f(filename_component), -- component
        f(filename_component), -- Story type
        i(1, 'Default'), -- story name
        i(2, '// props here'), -- args
      }
    )
  ),
}
