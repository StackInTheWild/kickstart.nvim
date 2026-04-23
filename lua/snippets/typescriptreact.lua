local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node
local i = ls.insert_node
local c = ls.choice_node
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

-- Helper: get kebab-case tag from filename (e.g. "gen-stack")
local function filename_tag()
  local name = vim.fn.expand '%:t:r'
  name = name:gsub('%.spec$', '')
  name = name:gsub('%.e2e$', '')
  name = name:gsub('%.stories$', '')
  return name
end

-- Helper: kebab-case to PascalCase class name
local function filename_class()
  local name = filename_tag()
  name = name:gsub('[-_](%w)', function(c)
    return c:upper()
  end)
  return name:sub(1, 1):upper() .. name:sub(2)
end

return {
  -- ═══════════════════════════════════════════
  -- Storybook
  -- ═══════════════════════════════════════════
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

  -- ═══════════════════════════════════════════
  -- StencilJS Component (full boilerplate)
  -- ═══════════════════════════════════════════
  s(
    'stcomp',
    fmt(
      [[
import {{ Component, Host, h }} from '@stencil/core';

/**
 * {}
 * @name {}
 * @category {}
 * @route {}
 * @keywords {}
 */
@Component({{
  tag: '{}',
  styleUrl: '{}.scss',
  shadow: true,
}})
export class {} {{
  render() {{
    return (
      <Host>
        <slot></slot>
      </Host>
    );
  }}
}}
]],
      {
        i(1, 'Component description.'),
        i(2, 'ComponentName'),
        i(3, 'General'),
        f(filename_tag),
        i(4, 'keyword1, keyword2'),
        f(filename_tag),
        f(filename_tag),
        f(filename_class),
      }
    )
  ),

  -- ═══════════════════════════════════════════
  -- StencilJS Component (full with imports)
  -- ═══════════════════════════════════════════
  s(
    'stcompfull',
    fmt(
      [[
import {{ Component, Element, Event, EventEmitter, Host, Prop, State, Watch, h }} from '@stencil/core';

/**
 * {}
 * @name {}
 * @category {}
 * @route {}
 * @keywords {}
 */
@Component({{
  tag: '{}',
  styleUrl: '{}.scss',
  shadow: true,
}})
export class {} {{
  @Element() element: {};

  @Prop() readonly {}: {} = {};

  @State() {}: {} = {};

  @Event() {}: EventEmitter<{}>;

  componentWillLoad() {{
    {}
  }}

  render() {{
    return (
      <Host>
        <slot></slot>
      </Host>
    );
  }}
}}
]],
      {
        i(1, 'Component description.'),
        i(2, 'ComponentName'),
        i(3, 'General'),
        f(filename_tag),
        i(4, 'keyword1, keyword2'),
        f(filename_tag),
        f(filename_tag),
        f(filename_class),
        f(function()
          return 'HTML' .. filename_class() .. 'Element'
        end),
        i(5, 'propName'),
        i(6, 'string'),
        i(7, "''"),
        i(8, '_stateName'),
        i(9, 'boolean'),
        i(10, 'false'),
        i(11, 'eventName'),
        i(12, 'void'),
        i(13, ''),
      }
    )
  ),

  -- ═══════════════════════════════════════════
  -- @Prop() variants
  -- ═══════════════════════════════════════════
  s(
    'stprop',
    fmt('@Prop() readonly {}: {} = {};', {
      i(1, 'propName'),
      i(2, 'string'),
      i(3, "''"),
    })
  ),

  s(
    'stpropreflect',
    fmt('@Prop({{ reflect: true }}) readonly {}: {} = {};', {
      i(1, 'propName'),
      i(2, 'string'),
      i(3, "''"),
    })
  ),

  s(
    'stpropmutable',
    fmt("@Prop({{ attribute: '{}', mutable: true, reflect: true }}) {}: {} = {};", {
      i(1, 'attr'),
      i(2, 'propName'),
      i(3, 'boolean'),
      i(4, 'false'),
    })
  ),

  s(
    'stpropbool',
    fmt('@Prop() readonly {}: boolean = false;', {
      i(1, 'disabled'),
    })
  ),

  -- ═══════════════════════════════════════════
  -- @State()
  -- ═══════════════════════════════════════════
  s(
    'ststate',
    fmt('@State() {}: {} = {};', {
      i(1, '_stateName'),
      i(2, 'boolean'),
      i(3, 'false'),
    })
  ),

  -- ═══════════════════════════════════════════
  -- @Event() / EventEmitter
  -- ═══════════════════════════════════════════
  s(
    'stevent',
    fmt('@Event() {}: EventEmitter<{}>;', {
      i(1, 'eventName'),
      i(2, 'void'),
    })
  ),

  s(
    'steventhandler',
    fmt(
      [[
@Event() {}: EventEmitter<{}>;

private {} = ({}) => {{
  this.{}.emit({});
}};]],
      {
        i(1, 'eventName'),
        i(2, 'void'),
        i(3, 'onEvent'),
        i(4, ''),
        ls.dynamic_node(1, function(args)
          return ls.snippet_node(nil, { t(args[1][1]) })
        end, { 1 }),
        i(5, ''),
      }
    )
  ),

  -- ═══════════════════════════════════════════
  -- @Watch()
  -- ═══════════════════════════════════════════
  s(
    'stwatch',
    fmt(
      [[
@Watch('{}')
{}(newValue: {}, oldValue: {}) {{
  {}
}}]],
      {
        i(1, 'propName'),
        i(2, 'propNameWatchHandler'),
        i(3, 'any'),
        i(4, 'any'),
        i(5, ''),
      }
    )
  ),

  -- ═══════════════════════════════════════════
  -- @Method()
  -- ═══════════════════════════════════════════
  s(
    'stmethod',
    fmt(
      [[
@Method()
async {}(): Promise<{}> {{
  {}
}}]],
      {
        i(1, 'methodName'),
        i(2, 'void'),
        i(3, ''),
      }
    )
  ),

  -- ═══════════════════════════════════════════
  -- @Listen()
  -- ═══════════════════════════════════════════
  s(
    'stlisten',
    fmt(
      [[
@Listen('{}')
async {}(event: CustomEvent<{}>) {{
  event.stopPropagation();
  {}
}}]],
      {
        i(1, 'eventName'),
        i(2, 'eventNameHandler'),
        i(3, 'void'),
        i(4, ''),
      }
    )
  ),

  -- ═══════════════════════════════════════════
  -- @Element()
  -- ═══════════════════════════════════════════
  s(
    'stelement',
    fmt('@Element() element: {};', {
      f(function()
        return 'HTML' .. filename_class() .. 'Element'
      end),
    })
  ),

  -- ═══════════════════════════════════════════
  -- render()
  -- ═══════════════════════════════════════════
  s(
    'strender',
    fmt(
      [[
render() {{
  return (
    <Host{}>
      {}
      <slot></slot>
    </Host>
  );
}}]],
      {
        i(1, ''),
        i(2, ''),
      }
    )
  ),

  s(
    'strenderclass',
    fmt(
      [[
render() {{
  return (
    <Host
      class={{{{
        '{}': this.{},
      }}}}
    >
      {}
      <slot></slot>
    </Host>
  );
}}]],
      {
        i(1, 'class-name'),
        i(2, 'condition'),
        i(3, ''),
      }
    )
  ),

  -- ═══════════════════════════════════════════
  -- Lifecycle hooks
  -- ═══════════════════════════════════════════
  s(
    'stwillload',
    fmt(
      [[
componentWillLoad() {{
  {}
}}]],
      { i(1, '') }
    )
  ),

  s(
    'stdidload',
    fmt(
      [[
async componentDidLoad(): Promise<void> {{
  {}
}}]],
      { i(1, '') }
    )
  ),

  s(
    'stconnected',
    fmt(
      [[
connectedCallback() {{
  {}
}}]],
      { i(1, '') }
    )
  ),

  s(
    'stdisconnected',
    fmt(
      [[
disconnectedCallback() {{
  {}
}}]],
      { i(1, '') }
    )
  ),

  s(
    'stwillrender',
    fmt(
      [[
componentWillRender() {{
  {}
}}]],
      { i(1, '') }
    )
  ),

  s(
    'stdidrender',
    fmt(
      [[
async componentDidRender() {{
  {}
}}]],
      { i(1, '') }
    )
  ),

  -- ═══════════════════════════════════════════
  -- Spec test (newSpecPage)
  -- ═══════════════════════════════════════════
  s(
    'stspec',
    fmt(
      [[
import {{ newSpecPage }} from '@stencil/core/testing';
import {{ {} }} from '../{}';

describe('{}', () => {{
  it('{}', async () => {{
    const page = await newSpecPage({{
      components: [{}],
      html: `<{}>{}   </{}>`,
    }});

    expect(page.root{}).{};
  }});
}});
]],
      {
        f(filename_class),
        f(filename_tag),
        f(filename_tag),
        i(1, 'renders'),
        f(filename_class),
        f(filename_tag),
        i(2, ''),
        f(filename_tag),
        i(3, ''),
        i(4, 'toBeTruthy()'),
      }
    )
  ),

  s(
    'stit',
    fmt(
      [[
it('{}', async () => {{
  const page = await newSpecPage({{
    components: [{}],
    html: `<{}>{}</{}>`,
  }});

  {};
}});
]],
      {
        i(1, 'should do something'),
        i(2, 'Component'),
        i(3, 'gen-component'),
        i(4, ''),
        i(5, 'gen-component'),
        i(6, 'expect(page.root).toBeTruthy();'),
      }
    )
  ),

  s(
    'stspecevent',
    fmt(
      [[
it('should emit {} when {}', async () => {{
  const page = await newSpecPage({{
    components: [{}],
    html: `<{}>   </{}>`,
  }});
  const spy = jest.spyOn(page.rootInstance.{}, 'emit');

  {};

  expect(spy).toHaveBeenCalledTimes(1);
}});
]],
      {
        i(1, 'eventName'),
        i(2, 'condition'),
        i(3, 'Component'),
        f(filename_tag),
        f(filename_tag),
        i(4, 'eventName'),
        i(5, '// trigger event'),
      }
    )
  ),

  -- ═══════════════════════════════════════════
  -- SCSS patterns
  -- ═══════════════════════════════════════════

  -- ═══════════════════════════════════════════
  -- Slot with name
  -- ═══════════════════════════════════════════
  s(
    'stslot',
    fmt('<slot name="{}">{}</slot>', {
      i(1, 'slot-name'),
      i(2, ''),
    })
  ),

  -- ═══════════════════════════════════════════
  -- Host with class bindings
  -- ═══════════════════════════════════════════
  s(
    'sthost',
    fmt(
      [[
<Host
  class={{{{
    '{}': this.{},
  }}}}
  {}
>
  {}
</Host>]],
      {
        i(1, 'class-name'),
        i(2, 'condition'),
        i(3, ''),
        i(4, '<slot></slot>'),
      }
    )
  ),

  -- ═══════════════════════════════════════════
  -- Private arrow function handler
  -- ═══════════════════════════════════════════
  s(
    'sthandler',
    fmt(
      [[
private {} = ({}) => {{
  {}
}};]],
      {
        i(1, 'onEvent'),
        i(2, ''),
        i(3, ''),
      }
    )
  ),

  -- ═══════════════════════════════════════════
  -- Ref pattern
  -- ═══════════════════════════════════════════
  s(
    'stref',
    fmt('private {}!: {};', {
      i(1, '_elementRef'),
      i(2, 'HTMLElement'),
    })
  ),
}
