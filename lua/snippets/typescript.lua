local ls = require 'luasnip'
local s = ls.snippet
local f = ls.function_node
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt

local function filename_tag()
  local name = vim.fn.expand '%:t:r'
  name = name:gsub('%.spec$', '')
  name = name:gsub('%.e2e$', '')
  return name
end

local function filename_class()
  local name = filename_tag()
  name = name:gsub('[-_](%w)', function(c)
    return c:upper()
  end)
  return name:sub(1, 1):upper() .. name:sub(2)
end

return {
  -- ═══════════════════════════════════════════
  -- E2E test (Playwright)
  -- ═══════════════════════════════════════════
  s(
    'ste2e',
    fmt(
      [[
import {{ test, waitForChanges }} from '@stencil/playwright';
import {{ compareScreenshot, loadPage, setPlaywrightContent }} from '../../../test/playwright/playwright-utils';
import {{ toTitle }} from '../../../../test/title';
import {{ Page }} from '@playwright/test';

let page: Page;

test.beforeAll(async ({{ browser }}) => {{
  page = await browser.newPage();
  await loadPage(page);
}});

test.afterAll(async () => {{
  await page.close();
}});

test.afterEach(async () => {{
  await page.mouse.move(0, 0);
}});

test.describe.serial('{}', () => {{
  test(toTitle('{}'), async ({{}}, testInfo) => {{
    await setPlaywrightContent(page, `
      <div style="padding: 120px">
        <{}>{}   </{}>
      </div>
    `);

    await waitForChanges(page);
    await compareScreenshot(page, testInfo);
  }});
}});
]],
      {
        f(filename_tag),
        i(1, 'should render'),
        f(filename_tag),
        i(2, ''),
        f(filename_tag),
      }
    )
  ),

  -- ═══════════════════════════════════════════
  -- E2E test case
  -- ═══════════════════════════════════════════
  s(
    'ste2etest',
    fmt(
      [[
test(toTitle('{}'), async ({{}}, testInfo) => {{
  await setPlaywrightContent(page, `
    <div style="padding: 120px">
      {}
    </div>
  `);

  await waitForChanges(page);
  {}
  await compareScreenshot(page, testInfo);
}});
]],
      {
        i(1, 'should render'),
        i(2, '<gen-component></gen-component>'),
        i(3, ''),
      }
    )
  ),

  -- ═══════════════════════════════════════════
  -- Enum
  -- ═══════════════════════════════════════════
  s(
    'stenum',
    fmt(
      [[
export enum {} {{
  {} = '{}',
  {} = '{}',
}}
]],
      {
        i(1, 'EnumName'),
        i(2, 'Value1'),
        i(3, 'value1'),
        i(4, 'Value2'),
        i(5, 'value2'),
      }
    )
  ),

  -- ═══════════════════════════════════════════
  -- Slot enum
  -- ═══════════════════════════════════════════
  s(
    'stslotenum',
    fmt(
      [[
export enum {}Slot {{
  {} = '{}-{}',
  {} = '{}-{}',
}}
]],
      {
        f(filename_class),
        i(1, 'Header'),
        f(filename_tag),
        i(2, 'header'),
        i(3, 'Body'),
        f(filename_tag),
        i(4, 'body'),
      }
    )
  ),

  -- ═══════════════════════════════════════════
  -- Part enum
  -- ═══════════════════════════════════════════
  s(
    'stpartenum',
    fmt(
      [[
export enum {}Part {{
  /**
   * {}
   */
  {} = '{}',
}}
]],
      {
        f(filename_class),
        i(1, 'Description of the part.'),
        i(2, 'PartName'),
        i(3, 'part-name'),
      }
    )
  ),

  -- ═══════════════════════════════════════════
  -- Enum index barrel export
  -- ═══════════════════════════════════════════
  s(
    'stenumindex',
    fmt("export {{ {} }} from './{}';", {
      i(1, 'EnumName'),
      i(2, 'enum-file'),
    })
  ),
}
