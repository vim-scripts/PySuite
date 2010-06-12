" Cal - a calendar plugin for vim
"

if exists("b:py_cal_loaded")
    finish
endif

let b:py_cal_loaded = 1


" Maps

:au BufNewFile,BufRead,BufEnter *.cal   nnoremap <buffer> <CR> :call CalEntry()<CR>
:au BufNewFile,BufRead,BufEnter *.cal   nnoremap <buffer> <Leader>b :call CalBack()<CR>
:au BufNewFile,BufRead,BufEnter *.cal   nnoremap <buffer> <Leader>n :call CalAddMonth()<CR>
:au BufNewFile,BufRead,BufEnter *.cal   nnoremap <buffer> <Leader>h :call CalHelp()<CR>
:au BufNewFile,BufRead,BufEnter *.cal   nnoremap <buffer> <Leader>t :call CalToday()<CR>
:au BufRead *.cal :call CalToday()
" :au FileType cal   :set nolist

let g:py_cal_width = 98

function! CalAddMonth()
    :pyfile ~/.vim/python/cal_add_month.py
endfu


function! CalBack()         " Jump back to cal view from entries section
    :pyfile ~/.vim/python/cal_back.py
endfu


function! CalToday()
    :pyfile ~/.vim/python/cal_today.py
endfu


function! CalEntry()        " Goto or add new entry
    :pyfile ~/.vim/python/cal_entry.py
endfu


function! CalHelp()
    echo " Add New Month           ".g:mapleader."n\n"
    echo " Add New Entry            Enter (on day in month view)\n"
    echo " Jump Back to month view ".g:mapleader."b\n\n"
    echo " Jump to today           ".g:mapleader."t\n"
    echo " Help                    ".g:mapleader."h\n"
endfu
