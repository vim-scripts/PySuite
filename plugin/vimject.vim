" Vimject - project plugin for vim, written in Python
"

if exists("b:vimject_loaded")
    finish
endif

let b:vimject_loaded = 1

" Maps
" :au BufNewFile,BufRead,BufEnter *.todo map <space> :call Done()<CR>
:au BufNewFile,BufRead,BufEnter *.proj nnoremap <buffer> <cr> :call Open()<CR>
:au BufNewFile,BufRead,BufEnter *.proj nnoremap <buffer> <Leader>l :call OpenAll()<CR>
:au BufNewFile,BufRead,BufEnter *.proj nnoremap <buffer> U :call UnloadAll()<CR>
:au BufNewFile,BufRead,BufEnter *.proj nnoremap <buffer> <Leader>d :call Getcwd()<CR>
:au BufNewFile,BufRead,BufEnter *.proj nnoremap <buffer> <Leader>L :call AddAll()<CR>
:au BufNewFile,BufRead,BufEnter *.proj nnoremap <buffer> <Leader>g :call GrepAll()<CR>
:au BufNewFile,BufRead,BufEnter *.proj nnoremap <buffer> <Leader>p :call Genpydoc()<CR>
:au BufNewFile,BufRead,BufEnter *.proj nnoremap <buffer> <Leader>x :call Open("run")<CR>
:au BufNewFile,BufRead,BufEnter *.proj nnoremap <buffer> <Leader>y :call Genpydoc("html")<CR>
:au BufNewFile,BufRead,BufEnter *.proj nnoremap <buffer> <Leader>o :call Genpydoc("potl")<CR>
:au BufNewFile,BufRead,BufEnter *.proj nnoremap <buffer> ? :call ProjHelp()<CR>

:au BufNewFile,BufRead *.proj setlocal nowrap

:au BufNewFile,BufRead *.proj :setlocal ai
" nnoremap <Leader>P :vsplit .proj<left><left><left><left><left>
nnoremap <Leader>P :call OpenProj()<CR>


function! OpenProj()     " Open or create project
    let n = input("Project name: ")
    if n != ''
        exe "vsplit ".n.".proj"
        exe "normal 30\<c-w>|"
    endif
endfu


function! GrepAll()     " Grep all files in dir or project
    try
        :pyfile ~/.vim/python/proj_grepall.py
    catch /.*/
        echo "Not found:\n" v:exception
    endtry
endfu

function! UnloadAll()   " Unload (i.e. :bdelete) all files in dir or project
    try
        :pyfile ~/.vim/python/proj_unloadall.py
    endtry
endfu

function! OpenAll()     " Open all files in dir or project
    :pyfile ~/.vim/python/proj_openall.py
endfu

function! Open(...)     " Open or run a file
    :pyfile ~/.vim/python/proj_open.py
endfu

function! Genpydoc(...)     " Generate docs file for all python files in project or dir
    :pyfile ~/.vim/python/proj_genpydoc.py
endfu


function! ProjHelp()
    " Help listing
    echo " Vimject commands:\n\n"


    echo " Open or start a project                              ".g:mapleader."P\n"
    echo " Open file or dir                                      Enter\n"
    echo " Open all files in dir or project                     ".g:mapleader."l\n"
    echo " Add all files in dir to listing                      ".g:mapleader."L\n"
    echo " Add current directory name                           ".g:mapleader."d\n"
    echo " Grep all files in dir or project                     ".g:mapleader."g\n"
    echo " Unload a file or all files in dir or project          U\n"
    echo " Run a .py, .sh or .html file                         ".g:mapleader."x\n\n"

    echo " potl outline for .py files in dir or project         ".g:mapleader."o\n"
    echo "      - same but txt format                           ".g:mapleader."p\n"
    echo "      - same but html format                          ".g:mapleader."y\n\n"

    echo " (For open all, grep all and unload all commands, cursor must be on a dir or project)\n"
    echo " This help message                                     ?\n"
endfu


function! AddAll()
" Add all files to current dir
python <<
from vim import *
import os
from os.path import expanduser
def addall():
    l = current.line
    if l and l[0] in "~/":
        lst = ["  " + fn for fn in os.listdir(expanduser(l))]
        lst.sort()
        b = current.buffer
        lnum = current.window.cursor[0]
        b[lnum:lnum] = lst
        current.window.cursor = (lnum+1, 0)
addall()
.
endfu

function! Getcwd()
" Add current directory path
python <<
from vim import *
b = current.buffer
lnum = current.window.cursor[0] - 1
b[lnum:lnum] = [eval("getcwd()")]
current.window.cursor = (lnum+1, 0)
.
endfu

