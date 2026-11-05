return {
  { -- Git signs in the gutter + hunk actions
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buf = bufnr, desc = desc })
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, 'Jump to next git [c]hange')
        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, 'Jump to previous git [c]hange')

        -- Actions (stage_hunk toggles: run it again on a staged hunk to unstage it)
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'git [s]tage hunk')
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'git [r]eset hunk')
        map('n', '<leader>hs', gitsigns.stage_hunk, 'git [s]tage/unstage hunk')
        map('n', '<leader>hr', gitsigns.reset_hunk, 'git [r]eset hunk')
        map('n', '<leader>hS', gitsigns.stage_buffer, 'git [S]tage buffer')
        map('n', '<leader>hR', gitsigns.reset_buffer, 'git [R]eset buffer')
        map('n', '<leader>hp', gitsigns.preview_hunk, 'git [p]review hunk')
        map('n', '<leader>hi', gitsigns.preview_hunk_inline, 'git preview hunk [i]nline')
        map('n', '<leader>hb', gitsigns.blame_line, 'git [b]lame line')
        map('n', '<leader>hd', gitsigns.diffthis, 'git [d]iff against index')
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, 'git [D]iff against last commit')

        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, '[T]oggle git [b]lame line')
      end,
    },
  },

  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'G' },
    keys = {
      { '<leader>gs', '<cmd>Git status<CR>', desc = '[G]it [S]tatus' },
      { '<leader>gp', '<cmd>Git pull<CR>', desc = '[G]it [P]ull' },
      { '<leader>gfa', '<cmd>Git fetch --all<CR>', desc = '[G]it [F]etch [A]ll' },
      { '<leader>gff', ':Git fetch origin ', desc = '[G]it [F]etch branch' },
      { '<leader>gmo', ':Git merge origin/', desc = '[G]it [M]erge origin/…' },
      { '<leader>gc', ':Git checkout ', desc = '[G]it [C]heckout' },
      {
        '<leader>gnb',
        function()
          local name = vim.fn.input 'Branch name: story-'
          if name == '' then
            return
          end
          vim.cmd('Git checkout -b story-' .. name:gsub('%s', '-'))
        end,
        desc = '[G]it [N]ew [B]ranch (story-)',
      },
    },
  },

  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
    keys = {
      { '<leader>do', '<cmd>DiffviewOpen<CR>', desc = '[D]iffview [O]pen' },
      { '<leader>dc', '<cmd>DiffviewClose<CR>', desc = '[D]iffview [C]lose' },
    },
  },

  { -- Syntax-aware diffs with difftastic
    'ahkohd/difft.nvim',
    event = 'VeryLazy',
    opts = {},
  },

  {
    'FabijanZulj/blame.nvim',
    cmd = 'BlameToggle',
    keys = { { '<leader>gb', '<cmd>BlameToggle<CR>', desc = '[G]it [B]lame' } },
    opts = {},
  },

  {
    'kdheepak/lazygit.nvim',
    cmd = { 'LazyGit', 'LazyGitConfig', 'LazyGitCurrentFile', 'LazyGitFilter', 'LazyGitFilterCurrentFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = { { '<leader>lg', '<cmd>LazyGit<CR>', desc = '[L]azy[G]it' } },
  },

  { -- Merge-conflict navigation. Local plugin: only loaded when the checkout exists.
    dir = '~/Repositories/GitHub/headhunter.nvim',
    name = 'headhunter.nvim',
    cond = function()
      return vim.uv.fs_stat(vim.fn.expand '~/Repositories/GitHub/headhunter.nvim') ~= nil
    end,
    opts = { next_conflict = ']g' },
  },
}
