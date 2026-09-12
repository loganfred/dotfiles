function GetOS()
	return vim.loop.os_uname().sysname
end

vim.cmd([[
    " [How to get group name of highlighting under cursor in vim? - Stack
    " Overflow](https://stackoverflow.com/questions/9464844/how-to-get-group-name-of-highlighting-under-cursor-in-vim)
    function! SynGroup()
	let l:s = synID(line('.'), col('.'), 1)
	echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
	call setreg("", synIDattr(l:s, 'name'))
    endfun
    nnoremap gs :call SynGroup()<CR>
]])
