local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s('story', {
    t { "import React from 'react';", '' },
    t { 'import { ' },
    i(1, 'ComponentName'),
    t { " } from './" },
    i(2, 'ComponentFile'),
    t { "';", '' },
    t { '', 'export default {', "  title: '" },
    i(3, 'Category/ComponentName'),
    t { "',", '  component: ' },
    i(4, 'ComponentName'),
    t { ',', '};', '' },
    t { '', 'const Template = (args) => <' },
    i(5, 'ComponentName'),
    t { ' {...args} />;', '' },
    t { '', 'export const Primary = Template.bind({});', 'Primary.args = {', '  ' },
    i(6, "prop: 'value'"),
    t { '', '};' },
  }),
}
