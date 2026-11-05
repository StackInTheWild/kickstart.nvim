-- JS/TS tests. (.NET tests run through easy-dotnet, see lua/plugins/dotnet.lua.)
return {
  {
    'mattkubej/jest.nvim',
    main = 'nvim-jest',
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    opts = { jest_cmd = 'npx jest' },
  },
}
