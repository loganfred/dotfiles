return {
	"rhysd/vim-grammarous",
	config = function()
		local utils = require("config.utils")
		vim.cmd([[ let g:grammarous#jar_url = 'https://www.languagetool.org/download/LanguageTool-5.9.zip' ]])
		if utils.is_windows() then
			vim.cmd(
				-- https://github.com/rhysd/vim-grammarous/issues/110
				[[let g:grammarous#languagetool_cmd='java -jar "C:\Users\logan.frederick\AppData\Local\nvim-data\lazy\vim-grammarous\misc\LanguageTool-5.9\languagetool-commandline.jar"' ]]
			)
		end
		vim.cmd([[
            let g:grammarous#hooks = {}
            function! g:grammarous#hooks.on_check(errs) abort
                nmap <buffer><C-n> <Plug>(grammarous-move-to-next-error)<Plug>(grammarous-move-to-info-window)
                nmap <buffer><C-p> <Plug>(grammarous-move-to-previous-error)
            endfunction

            function! g:grammarous#hooks.on_reset(errs) abort
                nunmap <buffer><C-n>
                nunmap <buffer><C-p>
            endfunction
        ]])
		vim.cmd([[let g:grammarous#languagetool_lang = 'en-US' ]])
	end,
}
