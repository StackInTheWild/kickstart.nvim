-- `:checkhealth config` — verifies Neovim version and external tools this config uses.

local function check_version()
  local verstr = tostring(vim.version())
  if vim.version.ge(vim.version(), '0.12') then
    vim.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    vim.health.error(string.format("Neovim out of date: '%s'. This config requires 0.12+", verstr))
  end
end

local function check_executables(title, exes, report)
  vim.health.start(title)
  for _, exe in ipairs(exes) do
    if vim.fn.executable(exe) == 1 then
      vim.health.ok(string.format("Found executable: '%s'", exe))
    else
      report(string.format("Could not find executable: '%s'", exe))
    end
  end
end

return {
  check = function()
    vim.health.start 'config'
    vim.health.info('System Information: ' .. vim.inspect(vim.uv.os_uname()))
    check_version()

    check_executables('Required tools', { 'git', 'make', 'unzip', 'rg', 'node', 'npm' }, vim.health.error)
    check_executables('Optional tools', { 'fd', 'dotnet', 'lazygit', 'tmux', 'difft' }, vim.health.warn)
  end,
}
