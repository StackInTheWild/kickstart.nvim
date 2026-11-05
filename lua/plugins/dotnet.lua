-- C# / .NET: Roslyn LSP, test runner, project commands, user secrets.
-- Debugging is configured in lua/plugins/debug.lua.

local function get_secret_path(secret_guid)
  local home_dir = vim.fn.expand '~'
  if require('easy-dotnet.extensions').isWindows() then
    return home_dir .. '\\AppData\\Roaming\\Microsoft\\UserSecrets\\' .. secret_guid .. '\\secrets.json'
  end
  return home_dir .. '/.microsoft/usersecrets/' .. secret_guid .. '/secrets.json'
end

---@param action "test" | "restore" | "build" | "run" | "watch"
local function terminal(path, action, args)
  args = args or ''
  local commands = {
    run = 'dotnet run --project %s %s',
    test = 'dotnet test %s %s',
    restore = 'dotnet restore %s %s',
    build = 'dotnet build %s %s',
    watch = 'dotnet watch --project %s %s',
  }
  local command = string.format(commands[action], path, args)
  if require('easy-dotnet.extensions').isWindows() then
    command = command .. '\r'
  end
  vim.cmd 'vsplit'
  vim.cmd('term ' .. command)
end

return {
  {
    'GustavEikaas/easy-dotnet.nvim',
    lazy = false, -- starts Roslyn and registers :Dotnet; must be loaded before C# buffers open
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    keys = {
      {
        '<C-p>',
        function()
          require('easy-dotnet').run_project()
        end,
        desc = '.NET: run project',
      },
    },
    config = function()
      local dotnet = require 'easy-dotnet'
      dotnet.setup {
        lsp = {
          enabled = true, -- builtin Roslyn LSP
          roslynator_enabled = true,
          analyzer_assemblies = {},
          config = {},
        },
        debugger = {
          bin_path = 'netcoredbg',
          -- The coreclr adapter/configuration is set up by hand in lua/plugins/debug.lua
          -- (it rebuilds before launching). Don't let easy-dotnet register a second one.
          auto_register_dap = false,
          mappings = {
            open_variable_viewer = { lhs = 'T', desc = 'open variable viewer' },
          },
        },
        ---@type TestRunnerOptions
        test_runner = {
          viewmode = 'float', ---@type "split" | "vsplit" | "float" | "buf"
          enable_buffer_test_execution = true,
          noBuild = true,
          icons = {
            passed = '',
            skipped = '',
            failed = '',
            success = '',
            reload = '',
            test = '',
            sln = '󰘐',
            project = '󰘐',
            dir = '',
            package = '',
          },
          mappings = {
            run_test_from_buffer = { lhs = '<leader>tr', desc = 'run test from buffer' },
            peek_stack_trace_from_buffer = { lhs = '<leader>tp', desc = 'peek stack trace from buffer' },
            filter_failed_tests = { lhs = '<leader>fe', desc = 'filter failed tests' },
            debug_test = { lhs = '<leader>d', desc = 'debug test' },
            go_to_file = { lhs = 'g', desc = 'go to file' },
            run_all = { lhs = '<leader>R', desc = 'run all tests' },
            run = { lhs = '<leader>r', desc = 'run test' },
            peek_stacktrace = { lhs = '<leader>p', desc = 'peek stacktrace of failed test' },
            expand = { lhs = 'o', desc = 'expand' },
            expand_node = { lhs = 'E', desc = 'expand node' },
            expand_all = { lhs = '-', desc = 'expand all' },
            collapse_all = { lhs = 'W', desc = 'collapse all' },
            close = { lhs = 'q', desc = 'close testrunner' },
            refresh_testrunner = { lhs = '<C-r>', desc = 'refresh testrunner' },
          },
          additional_args = {},
        },
        new = {
          project = { prefix = 'sln' }, -- "sln" | "none"
        },
        terminal = terminal,
        secrets = { path = get_secret_path },
        csproj_mappings = true,
        fsproj_mappings = true,
        auto_bootstrap_namespace = {
          type = 'block_scoped', -- "block_scoped" | "file_scoped"
          enabled = true,
          use_clipboard_json = {
            behavior = 'prompt', -- "auto" | "prompt" | "never"
            register = '+',
          },
        },
        server = {
          log_level = nil, ---@type nil | "Off" | "Critical" | "Error" | "Warning" | "Information" | "Verbose" | "All"
        },
        picker = 'telescope',
        background_scanning = true,
        notifications = {
          handler = function(start_event)
            local spinner = require('easy-dotnet.ui-modules.spinner').new()
            spinner:start_spinner(start_event.job.name)
            ---@param finished_event JobEvent
            return function(finished_event)
              spinner:stop_spinner(finished_event.result.msg, finished_event.result.level)
            end
          end,
        },
        diagnostics = {
          default_severity = 'error',
          setqflist = false,
        },
      }

      vim.api.nvim_create_user_command('Secrets', function()
        dotnet.secrets()
      end, { desc = 'Open .NET user secrets' })
    end,
  },
}
