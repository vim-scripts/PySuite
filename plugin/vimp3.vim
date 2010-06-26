if exists("g:vimp3_loaded")
    finish
endif
let g:vimp3_loaded = 1

" Important!: change this to location of your music!
let s:root = "/home/ak/music/"
let s:change_score = 10             " How much to add/subtract from scores
let s:follow_current = 1
let s:vol_incr = 5                  " Volume increment

au CursorMoved * exe 'call Vimp3SInfo()'
au CursorHold  *.vimp3 exe 'call Vimp3SInfo()'
au BufNewFile,BufRead *.vimp3  nnoremap <buffer> <CR>      :call Vimp3Player("play_current")<CR>
au BufNewFile,BufRead *.vimp3  nnoremap <buffer> <Leader>l :call Vimp3Player("make_playlist")<CR>
au BufNewFile,BufRead *.vimp3  nnoremap <buffer> <Leader>d :call Vimp3Player("add_dir")<CR>
au BufNewFile,BufRead *.vimp3  nnoremap <buffer> <Leader>D :call Vimp3Player("add_dir_ask")<CR>
au BufNewFile,BufRead *.vimp3  nnoremap <buffer> <Leader>s :call Vimp3Player("seek 10")<CR>
au BufNewFile,BufRead *.vimp3  nnoremap <buffer> <M-right> :call Vimp3Player("seek 10")<CR>
au BufNewFile,BufRead *.vimp3  nnoremap <buffer> <Leader>B :call Vimp3Player("seek -10")<CR>
au BufNewFile,BufRead *.vimp3  nnoremap <buffer> <M-left> :call Vimp3Player("seek -10")<CR>
au BufNewFile,BufRead *.vimp3  nnoremap <buffer> <Leader>h :call Vimp3Help()<CR>
au BufNewFile,BufRead *.vimp3  nnoremap <buffer> <Leader>t :call Vimp3CopyTrack()<CR>
au BufNewFile,BufRead *.vimp3  nnoremap <buffer> - :call Vimp3Player("score decr")<CR>
au BufNewFile,BufRead *.vimp3  nnoremap <buffer> = :call Vimp3Player("score incr")<CR>
au BufNewFile,BufRead *.vimp3  nnoremap <buffer> + :call Vimp3Player("score incr")<CR>

" First echo empty to refresh current indicator
au BufNewFile,BufRead *.vimp3  nnoremap <buffer> <m-c> :call Vimp3Player("jump_current")<CR>
au BufNewFile,BufRead *.vimp3  setlocal nowrap foldmethod=expr foldexpr=Vimp3FoldLevel(v:lnum) formatoptions=crqno

" Change status line to your taste, see :help 'statusline'
set statusline=%<%f\ %h%m%r\ %10(%{getcwd()}%)\ \ \ \ %20.60(%{Vimp3Info()}%)\ \ \ \ %=%-7.(%l,%c%)
set updatetime=500

nnoremap        gs :call Vimp3Player("status")<CR>
nnoremap     <c-q> :call Vimp3Player("next")<CR>
nnoremap     <m-u> :call Vimp3Player("vol +")<CR>
nnoremap     <m-y> :call Vimp3Player("vol -")<CR>
nnoremap <Leader>p :call Vimp3Player("toggle_play")<CR>
nnoremap <Leader>a :call Vimp3Player("pause")<CR>
nnoremap <Leader>n :call Vimp3Player("next")<CR>
nnoremap <Leader>P :call Vimp3Player("prev")<CR>
nnoremap <Leader>r :call Vimp3Player("toggle_repeat")<CR>
nnoremap <Leader>R :call Vimp3Player("toggle_random")<CR>
nnoremap <Leader>b :call Vimp3Player("btpause")<CR>

command! Vimp3QuitServer :call Vimp3Player("quit")


let s:decr_score = []
let s:length = '0:00'
let s:elapsed = "0:00"
let s:last_start = '0'
let s:last_update = '0'
let s:btpause = '0'
let s:cur_lnum = '-1'
let s:current = ''
let s:random = "off"
let s:repeat = "off"
let s:bufname = ''
let s:mode = "stop"



function! Vimp3Player(...)
    :pyfile ~/.vim/python/vimp3_player.py
endfu


function! Vimp3FoldLevel(n)
    let l = getline(a:n)
    if (l == '') | return '=' | endif

    let level = matchend(l, '^[ ]*') / 4

    " Recognize header lines, which start with optional spaces and a '·'
    if (l =~ '.*/$')
        return '>' . (level + 1)
    else
        return '='
    endif
endfunction


function! Vimp3SInfo()
    if s:last_update == 0 || reltime()[0] - s:last_update > 10
        call Vimp3Player("info")
        let s:last_update = reltime()[0]
    endif
endfu


function! Vimp3CopyTrack()
    " Copy single track along with its dir
    normal "tyy
    normal mt
    if search("/$", 'b')
        " copy directory, go to next empty line, add an empty lines
        normal "dyy}
        :s/$/\r/
        :nohl

        " command: k "dp "tp k 0 i<space><space> <esc> J x 't
        " (up, paste dir, paste track, insert 2 spaces at beginning, join line, del space, jump back)
        exe "normal k\"dp\"tpk0i  \<esc>Jx't"
    endif
endfu


function! Vimp3Info()
    " call Vimp3SInfo()
    if s:last_start && s:mode == "play"
        let elapsed = reltime()[0] - s:last_start
        let s:elapsed = ''.elapsed/60.':'.printf("%02d", elapsed%60)
    else
        let s:elapsed = "0:00"
    endif
    if s:mode == "play"
        let ind = "|>"
    elseif s:mode == "pause"
        let ind = "||"
    else
        let ind = "[]"
    endif

    return s:current .' '. ind .' '. s:elapsed . '/' . s:length
endfu


function! Vimp3Help()
    " Help listing
    echo " Vimp3 playlist commands:\n\n"

    echo " Play track under cursor                               Enter\n"
    echo " Load (send) current playlist to server               ".g:mapleader."l\n"
    echo " Add current dir to playlist                          ".g:mapleader."d\n"
    echo " Add path to playlist                                 ".g:mapleader."D\n"
    echo " Seek 10sec ahead                                     ".g:mapleader."s\n"
    echo " Seek 10sec back                                      ".g:mapleader."B\n"
    echo " Copy track w/full path                               ".g:mapleader."t\n"
    echo " Increase/Decrease score                               +/-\n"
    echo " Jump to current track                                 Alt-c\n"
    echo " Show status, options                                  gs   \n\n"

    echo " Vimp3 global commands:\n\n"

    echo " Play/Stop                                            ".g:mapleader."p\n"
    echo " Pause                                                ".g:mapleader."a\n"
    echo " Next                                                  Ctrl-q\n"
    echo " Previous                                             ".g:mapleader."P\n"
    echo " Volume -/+                                            Alt-y/u\n"
    echo " Open/close folded dirs                                zr/zm\n"
    echo " Toggle repeat mode                                   ".g:mapleader."r\n"
    echo " Toggle random mode                                   ".g:mapleader."R\n"
    echo " Set pause between tracks                             ".g:mapleader."b\n\n"
    echo " Help message                                         ".g:mapleader."h\n"
endfu

