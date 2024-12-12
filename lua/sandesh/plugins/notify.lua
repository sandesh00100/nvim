return {
		"rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000"
    },
		-- Optional; default configuration will be used if setup isn't called.
    config = function ()
      vim.notify = require("notify")
      vim.keymap.set("n", "<leader>nl", "<cmd>:Telescope notify<CR>")
    end
}
