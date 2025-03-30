return {
	"mechatroner/rainbow_csv",
	init = function()
		vim.g.disable_rainbow_hover = 1
		vim.g.rcsv_max_columns = 50
		vim.g.rbql_with_headers = 1
		vim.g.rbql_backend_language = "js"
	end,
}
