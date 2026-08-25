-- return {
--   'gennaro-tedesco/nvim-peekup',
--   config = function( )
--     -- local peekup = require('nvim-peekup.config')
--     -- peekup.geometry['height'] = 0.7
--     -- peekup.geometry['title'] = "Registers"
--   end
--
-- }
return {
	"tversteeg/registers.nvim",
	cmd = "Registers",
	config = true,
	keys = {
		{ "\"",    mode = { "n", "v" } },
		{ "<C-R>", mode = "i" }
	},
	name = "registers",
}
