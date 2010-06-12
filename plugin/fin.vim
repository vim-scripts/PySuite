" Fin - very basic plugin to track finances
"

if exists("b:py_fin_loaded")
    finish
endif

let b:py_fin_loaded = 1


" Maps

:au BufNewFile,BufRead,BufEnter *.fin   nnoremap <buffer> <CR> :call FinNew()<CR>k$R
:au BufNewFile,BufRead,BufEnter *.fin   nnoremap <buffer> <Leader>i :call InitFin()<CR>
:au BufNewFile,BufRead,BufEnter *.fin   nnoremap <buffer> <Leader>h :call FinHelp()<CR>
:au BufNewFile,BufRead,BufEnter *.fin   nnoremap <buffer> U :call FinUpdate()<CR>

:au BufRead *.fin :call FinUpdate()


function! InitFin()
    :pyfile ~/.vim/python/fin_init.py
endfu


function! FinHelp()
    echo " New                   Enter\n"
    echo " Update totals         U\n"
    echo " Initialize new file  ".g:mapleader."i\n"
    echo " Help                 ".g:mapleader."h\n"
endfu


function! FinUpdate()   " Update totals
    :pyfile ~/.vim/python/fin_update.py
endfu


function! FinNew()      " Add new entry
    :pyfile ~/.vim/python/fin_new.py
endfu
