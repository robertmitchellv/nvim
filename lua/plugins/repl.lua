return {
  {
    "milanglacier/yarepl.nvim",
    config = function()
      local yarepl = require("yarepl")

      yarepl.setup({
        buflisted = true,
        scratch = true,
        ft = "REPL",
        metas = {
          python = { cmd = "python", formatter = yarepl.formatter.trim_empty_lines },
          ipython = { cmd = "ipython", formatter = yarepl.formatter.bracketed_pasting },
          radian = { cmd = "radian", formatter = yarepl.formatter.bracketed_pasting },
          julia = { cmd = "julia", formatter = yarepl.formatter.bracketed_pasting },
        },
        close_on_exit = true,
        scroll_to_bottom_after_sending = true,
      })
    end,
  },
}
