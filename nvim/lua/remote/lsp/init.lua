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
      "jose-elias-alvarez/null-ls.nvim",
      "jose-elias-alvarez/typescript.nvim",
      "williamboman/mason.nvim",
      "simrat39/rust-tools.nvim",
      { "mickael-menu/zk-nvim", dependencies = { "nvim-telescope/telescope.nvim" } },
      {
        "folke/neoconf.nvim",
        cmd = { "Neoconf" },
        opts = { local_settings = ".nvim.json", global_settings = "nvim.json" },
        config = true,
      },
    },
    config = function()
      local handlers = require "remote.lsp.handlers"
      local on_attach_nvim = handlers.on_attach
      local client_capabilities = handlers.get_client_capabilities()
      local configurations = vim.api.nvim_get_runtime_file("lua/remote/lsp/servers/*.lua", true)
      for _, file in ipairs(configurations) do
        local modname = util.get_module_name(file)
        local mod = require(modname)
        local srv = (modname):match "[^%.]*$"
        local config = vim.F.if_nil(mod.config, {})
        local configs = require "lspconfig.configs"
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = client_capabilities,
          flags = { debounce_text_changes = 150 },
          on_attach = on_attach_nvim,
        }, config)
        if mod.register_default_config and not configs[srv] then configs[srv] = { default_config = config } end
        if mod.setup then mod.setup(server_opts) end
        if not mod.defer_setup then
          ensure_installed = vim.tbl_deep_extend("force", ensure_installed, { [srv] = config })
        end
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
    event = "LspAttach",
    commit = "0948ecb196b7b288459fad478480359bbf315bee",
    config = function()
      local hints = require "lsp-inlayhints"
      local lsp_type_hints = vim.api.nvim_create_augroup("lsp_type_hints", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = lsp_type_hints,
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
