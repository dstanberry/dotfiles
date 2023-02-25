return {
  "numToStr/Comment.nvim",
  opts = function(_, opts)
    local ok, ts_context_commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
    if ok then
      opts.pre_hook = ts_context_commentstring.create_pre_hook()
    end
    opts.padding = true
    opts.padding = true
    opts.sticky = true
    opts.mappings = {
      basic = true,
      extra = true,
    }
    opts.opleader = {
      line = "gc",
      block = "gb",
    }
    opts.toggler = {
      line = "gcc",
      block = "gbc",
    }
  end,
}
