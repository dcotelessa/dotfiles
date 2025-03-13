require('dapui').setup()
require('dap-go').setup()
require('nvim-dap-virtual-text').setup()
vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })

local dap = require 'dap'
  -- Add TypeScript/JavaScript debugging
  dap.adapters.node2 = {
    type = 'executable',
    command = 'node',
    args = { vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js' },
  }

  dap.configurations.typescript = {
    {
      name = 'Launch (Node)',
      type = 'node2',
      request = 'launch',
      program = '${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      console = 'integratedTerminal',
    },
    {
      -- For this to work you need to make sure the node process is started with the `--inspect` flag.
      name = 'Attach to process (Node)',
      type = 'node2',
      request = 'attach',
      processId = require('dap.utils').pick_process,
    },
  }

dap.configurations.typescript = {
  -- Keep your existing node configurations
  {
    name = 'Launch Node (Script)',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    name = 'Attach to Node Process (Script)',
    type = 'node2',
    request = 'attach',
    processId = require('dap.utils').pick_process,
  },
  -- Add these Chrome configurations
  {
    name = 'Debug with Chrome Port 3000 (Script)',
    type = 'chrome',
    request = 'launch',
    url = 'http://localhost:3000', -- This is for Create React App, adjust if needed
    webRoot = '${workspaceFolder}',
    sourceMapPathOverrides = {
      -- Add sourcemap overrides as needed
      ['webpack:///./~/*'] = '${workspaceFolder}/node_modules/*',
      ['webpack:///./*'] = '${workspaceFolder}/*',
      ['webpack:///*'] = '*',
    },
  },
  {
    name = 'Attach to Chrome (Script)',
    type = 'chrome',
    request = 'attach',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    port = 9222,
    webRoot = '${workspaceFolder}',
  },
}

-- Make sure JavaScript has the same configurations
dap.configurations.javascript = dap.configurations.typescript

-- Debugger
vim.api.nvim_set_keymap('n', '<leader>dt', ':DapUiToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>db', ':DapToggleBreakpoint<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dc', ':DapContinue<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dr', ":lua require('dapui').open({reset = true})<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>ht', ":lua require('harpoon.ui').toggle_quick_menu()<CR>", { noremap = true })
