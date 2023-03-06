local util = require "util"

-- vim.lsp.set_log_level "trace"
-- vim.cmd.edit(vim.lsp.get_log_path())

local ensure_installed = {
  bashls = {},
  cmake = {},
  cssls = {},
  html = {},
}

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "b0o/schemastore.nvim",
      "folke/neodev.nvim",
      {
        "folke/neoconf.nvim",
        cmd = { "Neoconf" },
        opts = { local_settings = ".nvim.json", global_settings = "nvim.json" },
        config = true,
      },
      "jose-elias-alvarez/null-ls.nvim",
      "jose-elias-alvarez/typescript.nvim",
      "simrat39/rust-tools.nvim",
      { "mickael-menu/zk-nvim", dependencies = { "nvim-telescope/telescope.nvim" } },
    },
    config = function()
      local handlers = require "remote.lsp.handlers"
      local on_attach_nvim = handlers.on_attach
      local client_capabilities = handlers.get_client_capabilities()
      local configurations = vim.api.nvim_get_runtime_file("lua/remote/lsp/servers/*.lua", true)
      for _, file in ipairs(configurations) do
        repeat
          local mod = util.get_module_name(file)
          local srv = (mod):match "[^%.]*$"
          local config = require(mod).config or {}
          if srv == "ls_emmet" then
            local configs = require "lspconfig.configs"
            if not configs.ls_emmet then configs.ls_emmet = { default_config = config } end
          elseif srv == "null-ls" then
            require(mod).setup(on_attach_nvim)
            do
              break
            end
          elseif srv == "powershell_es" and not has "win32" then
            do
              break
            end
          elseif srv == "rust_analyzer" then
            do
              break
            end
          elseif srv == "rust_tools" then
            require(mod).setup(vim.tbl_deep_extend("force", {
              capabilities = client_capabilities,
              flags = { debounce_text_changes = 150 },
              on_attach = on_attach_nvim,
            }, config))
            do
              break
            end
          elseif srv == "lua_ls" then
            require(mod).setup()
          elseif srv == "tsserver" then
            require(mod).setup(vim.tbl_deep_extend("force", {
              capabilities = client_capabilities,
              flags = { debounce_text_changes = 150 },
              on_attach = on_attach_nvim,
            }, config))
            do
              break
            end
          elseif srv == "zk" then
            require(mod).setup(vim.tbl_deep_extend("force", {
              capabilities = client_capabilities,
              flags = { debounce_text_changes = 150 },
              on_attach = on_attach_nvim,
            }, config))
            do
              break
            end
          end
          ensure_installed = vim.tbl_deep_extend("force", ensure_installed, { [srv] = config })
        until true
      end
      for server, config in pairs(ensure_installed) do
        require("lspconfig")[server].setup(vim.tbl_deep_extend("force", {
          capabilities = client_capabilities,
          flags = { debounce_text_changes = 150 },
          on_attach = on_attach_nvim,
        }, config))
      end
      handlers.setup()
    end,
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    config = function()
      local hints = require "lsp-inlayhints"
      vim.api.nvim_create_augroup("lsp_type_hints", {})
      vim.api.nvim_create_autocmd("LspAttach", {
        group = "lsp_type_hints",
        callback = function(args)
          if not (args.data and args.data.client_id) then return end

          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          hints.on_attach(client, bufnr)
        end,
      })

      hints.setup {
        inlay_hints = {
          parameter_hints = {
            show = false,
            prefix = "",
            separator = ", ",
            remove_colon_start = false,
            remove_colon_end = true,
          },
          type_hints = {
            show = true,
            prefix = "",
            separator = ", ",
            remove_colon_start = false,
            remove_colon_end = false,
          },
          only_current_line = false,
          labels_separator = "  ",
          max_len_align = false,
          max_len_align_padding = 1,
          highlight = "Comment",
        },
        enabled_at_startup = true,
        debug_mode = false,
      }
    end,
  },
}
