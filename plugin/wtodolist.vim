" WTodo - todo plugin for vim written in Python
"

" Maps
"

if exists("b:wtodo_loaded")
    finish
endif

let b:wtodo_loaded = 1

nnoremap _T :call OpenTodo()<CR>

:au BufNewFile,BufRead,BufEnter *.todo nnoremap <buffer> N :call NewTodo()<CR>0 R
:au BufNewFile,BufRead,BufEnter *.todo nnoremap <buffer> <Tab> :call NewTodo()<CR>0 R
:au BufNewFile,BufRead,BufEnter *.todo nnoremap <buffer> <space> :call WtodoDone()<CR>
:au BufNewFile,BufRead,BufEnter *.todo nnoremap <buffer> H :call ToggleOnHold()<CR>
:au BufNewFile,BufRead,BufEnter *.todo nnoremap <buffer> <cr> :call WtodoSort()<CR>
:au BufNewFile,BufRead,BufEnter *.todo nnoremap <buffer> ? :call TodoHelp()<CR>
:au BufNewFile,BufRead,BufEnter *.todo nnoremap <buffer> C :call ChangeName()<CR>0 R
:au BufNewFile,BufRead,BufEnter *.todo nnoremap <buffer> A :call ShowActive()<CR>
:au BufNewFile,BufRead,BufEnter *.todo nnoremap <buffer> <M-j> :m+<CR>
:au BufNewFile,BufRead,BufEnter *.todo nnoremap <buffer> <M-k> :m-2<CR>
:au BufRead *.todo :call WtodoSort()


let s:headers='Name Project Priority Diff Done OnHold Started'


function! NewTodo()
    :pyfile ~/.vim/python/todo_new.py
    :call ChangeName()
endfu


function! WtodoDone()    " Mark task as done, i.e. set 'Complete' to 100
    normal $F 4BR100
    normal 0
endfu


function! WtodoSort()
    :pyfile ~/.vim/python/todo_sort.py
endfu


function! OpenTodo()    " Try to open & resize todo win if it's in buffer list
    :pyfile ~/.vim/python/todo_open.py
endfu



function! ChangeName()
" Change task name
python <<
from vim import *
i = current.line.index("  ")
current.line = ' '*i + current.line[i:]
.
endfu


function! ToggleOnHold()
" Toggle task on / off hold
python <<
from vim import *
command("normal $F 3B")
val = eval("expand('<cword>')").lower()
if val == "no": command("normal RYes")
elif val == "yes": command("normal RNo ")
command("normal 0")
.
endfu

function! ShowActive()
" Resize window to show all active tasks only
python <<
from vim import *
for n, l in enumerate(current.buffer):
    if not l.strip():
        n += 2
        if n < 6: n = 6
        command('exe "normal %d\\<c-w>_"' % n)
        command("normal gg")
        break
.
endfu

function! TodoHelp()
    " Help listing
    echo " WTodo commands:      \n\n"
    echo " New                  Tab or N\n"
    echo " Done                 Space\n"
    echo " Toggle OnHold        H\n"
    echo " Sort                 Enter\n"
    echo " Change name          C\n"
    echo " Show active tasks    A\n"
    echo " Move tasks           Alt-j/k\n\n"

    echo " Help                 ?\n\n"
    echo "When todo win is hidden, use '_T' to open and resize it to show active tasks"
endfu
