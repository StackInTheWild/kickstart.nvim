-- Debugging with nvim-dap. Configured for .NET (netcoredbg) via easy-dotnet.
-- Keymaps follow Visual Studio: F5 continue, F9 breakpoint, F10 step over, F11 step into, F12 step out.

-- Build the project before launching, so the debugger always runs fresh code.
local function rebuild_project(co, path)
  local spinner = require('easy-dotnet.ui-modules.spinner').new()
  spinner:start_spinner 'Building'
  vim.fn.jobstart(string.format('dotnet build %s', path), {
    on_exit = function(_, return_code)
      if return_code == 0 then
        spinner:stop_spinner 'Built successfully'
      else
        spinner:stop_spinner('Build failed with exit code ' .. return_code, vim.log.levels.ERROR)
      end
      coroutine.resume(co, return_code == 0)
    end,
  })
  if not coroutine.yield() then
    error 'Build failed'
  end
end

local function setup_dotnet(dap)
  local dotnet = require 'easy-dotnet'
  local debug_dll = nil

  -- Ask easy-dotnet which project to debug (once per session)
  local function ensure_dll()
    debug_dll = debug_dll or dotnet.get_debug_dll()
    return debug_dll
  end

  dap.adapters.coreclr = {
    type = 'executable',
    command = 'netcoredbg',
    args = { '--interpreter=vscode' },
  }

  local configuration = {
    type = 'coreclr',
    name = 'Program',
    request = 'launch',
    env = function()
      local dll = ensure_dll()
      return dotnet.get_environment_variables(dll.project_name, dll.absolute_project_path) or nil
    end,
    program = function()
      local dll = ensure_dll()
      rebuild_project(coroutine.running(), dll.project_path)
      local stat = vim.uv.fs_stat(dll.target_path)
      if not stat or stat.type ~= 'file' then
        error('Project has not been built, path: ' .. dll.target_path)
      end
      return dll.target_path
    end,
    cwd = function()
      return ensure_dll().absolute_project_path
    end,
  }
  dap.configurations.cs = { configuration }
  dap.configurations.fsharp = { configuration }

  -- Forget the selected project when the session ends
  dap.listeners.before.event_terminated['easy-dotnet'] = function()
    debug_dll = nil
  end

  require('easy-dotnet.netcoredbg').register_dap_variables_viewer()
end

local function dap_call(fn, ...)
  local args = { ... }
  return function()
    require('dap')[fn](unpack(args))
  end
end

return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'mason-org/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'GustavEikaas/easy-dotnet.nvim',
    },
    keys = {
      { '<F5>', dap_call 'continue', desc = 'Debug: Start/Continue' },
      { '<F9>', dap_call 'toggle_breakpoint', desc = 'Debug: Toggle Breakpoint' },
      { '<F10>', dap_call 'step_over', desc = 'Debug: Step Over' },
      { '<F11>', dap_call 'step_into', desc = 'Debug: Step Into' },
      { '<F12>', dap_call 'step_out', desc = 'Debug: Step Out' },
      { '<S-F11>', dap_call 'step_out', desc = 'Debug: Step Out' },
      {
        '<F2>',
        function()
          require('dap.ui.widgets').hover()
        end,
        desc = 'Debug: Hover variable',
      },
      {
        '<F7>',
        function()
          require('dapui').toggle()
        end,
        desc = 'Debug: Toggle UI (see last session result)',
      },
      { '<leader>db', dap_call 'toggle_breakpoint', desc = '[D]ebug: toggle [B]reakpoint' },
      {
        '<leader>dB',
        function()
          require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = '[D]ebug: conditional [B]reakpoint',
      },
      { '<leader>dO', dap_call 'step_over', desc = '[D]ebug: step [O]ver' },
      { '<leader>dC', dap_call 'run_to_cursor', desc = '[D]ebug: run to [C]ursor' },
      { '<leader>dj', dap_call 'down', desc = '[D]ebug: stack down' },
      { '<leader>dk', dap_call 'up', desc = '[D]ebug: stack up' },
      { '<leader>dt', dap_call 'terminate', desc = '[D]ebug: [T]erminate' },
      {
        '<leader>dr',
        function()
          require('dap').repl.toggle()
        end,
        desc = '[D]ebug: toggle [R]EPL',
      },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('mason-nvim-dap').setup {
        automatic_installation = true,
        ensure_installed = { 'coreclr' }, -- installs netcoredbg
        -- coreclr is configured by hand below; skip mason-nvim-dap's default setup for it
        handlers = {
          coreclr = function() end,
        },
      }

      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      -- Breakpoint icons
      vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
      local breakpoint_icons = vim.g.have_nerd_font
          and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
        or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
      for type, icon in pairs(breakpoint_icons) do
        local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
        vim.fn.sign_define('Dap' .. type, { text = icon, texthl = hl, numhl = hl })
      end

      -- Open/close the UI automatically
      dap.listeners.before.attach.dapui_config = dapui.open
      dap.listeners.before.launch.dapui_config = dapui.open
      dap.listeners.before.event_terminated.dapui_config = dapui.close
      dap.listeners.before.event_exited.dapui_config = dapui.close

      setup_dotnet(dap)
    end,
  },
}
