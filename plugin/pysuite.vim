" PySuite - collection of Vim plugins written in Python
" version: 0.2.3

command! -nargs=? AlignCode call DoAlignCode(<q-args>)
nnoremap <Leader>hg :call HelpGrep()<cr>
nnoremap <Leader>df :call Pdocfold()<cr>
nnoremap <Leader>sd :call PyStripDoc()<cr>
nnoremap \f :call SearchCode()<cr>
nnoremap <Leader>n :call SearchCode(1)<cr>

function! DoAlignCode(...)
    " Align equal signs or comments in code
    :pyfile ~/.vim/python/aligncode.py
endfu


function! HelpGrep()
    " helpgrep given words in any order
    :pyfile ~/.vim/python/helpgrep.py
endfu


function! Pdocfold()
    " fold docstrings and comments
    :pyfile ~/.vim/python/pydocfold.py
endfu


function! PyStripDoc()
    " copy buffer with stripped docstrings and comments
    :pyfile ~/.vim/python/pystripdoc.py
endfu


function! SearchCode(...)
    " Search in code only, skipping strings and python-style comments
    :pyfile /home/ak/.vim/python/searchcode.py
endfu

