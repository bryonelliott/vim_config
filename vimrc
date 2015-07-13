" Bryon's VIMRC.  Based on Bram Moolenaar's example VIMRC file and
" his mswin.vim file.

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Pathogen: Poor man's package manager. Easy manipulation of 'runtimepath' et al 
" http://www.vim.org/scripts/script.php?script_id=2332
" http://github.com/tpope/vim-pathogen
call pathogen#infect()
set sessionoptions-=options

syntax enable
filetype plugin on
set number

" The default temp directory on Windows just doesn't work.  Try this:
if has("win32") || has("win16")
    set directory=.,$TEMP
endif

" I just have no use for the backup files.
set nobackup

" Keep 50 lines of command line history
set history=50

" Look and feel.
set ruler
set showcmd
set showmode
if &t_Co > 2 || has("gui_running")
        syntax on
        syntax sync fromstart
endif
if has("gui_running")
        set columns=110
        set lines=70
        aunmenu ToolBar.Print
        if has("gui_gtk")
                set guifont=FreeMono\ 11
        endif
        if has("gui_win32")
                set guifont=Courier_New:h8:cANSI
        endif
endif

" Searching.
set incsearch
set ignorecase
set hlsearch
if &t_Co > 2 || has("gui_running")
        set hlsearch
endif

" Tabs.
set tabstop=4
set softtabstop=4
set shiftwidth=4
"set noexpandtab
set expandtab

" Because hyphenated words are real words, too!
set iskeyword+=-,_

" Make multiple buffers a bit easier to use.
set hidden

" Don't use Ex mode, use Q for formatting
map Q gq

" Recognize all types of line endings.
set fileformats=unix,mac,dos

" Extend matching functionality.  http://www.vim.org/scripts/script.php?script_id=39
"source $VIMRUNTIME/macros/matchit.vim
runtime macros/matchit.vim

" Let folding be based on the current syntax.
set foldmethod=syntax

" Since I have a windoze background, I'm used to these.
        " Set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
        behave mswin
        " BUT!  Leave select mode off since I prefer visual mode.
        set selectmode=

        " backspace and cursor keys wrap to previous/next line
        set backspace=indent,eol,start whichwrap+=<,>,[,]

        " backspace in Visual mode deletes selection
        vnoremap <BS> d

        " Cut-n-Paste
        vnoremap <C-X> "+x
        vnoremap <C-C> "+y
        map <C-V>               "+gP
        cmap <C-V>              <C-R>+

        " Pasting blockwise and linewise selections is not possible in Insert and
        " Visual mode without the +virtualedit feature.  They are pasted as if they
        " were characterwise instead.
        " Uses the paste.vim autoload script.
        exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
        exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']
        " Use CTRL-Q to do what CTRL-V used to do
        noremap <C-Q>           <C-V>

        " For CTRL-V to work autoselect must be off.
        " On Unix we have two selections, autoselect can be used.
        if !has("unix")
          set guioptions-=a
        endif

        " CTRL-A is Select all
        noremap <C-A> gggH<C-O>G
        inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
        cnoremap <C-A> <C-C>gggH<C-O>G
        onoremap <C-A> <C-C>gggH<C-O>G
        snoremap <C-A> <C-C>gggH<C-O>G
        xnoremap <C-A> <C-C>ggVG

        " CTRL-Tab is Next window
        noremap <C-Tab> <C-W>w
        inoremap <C-Tab> <C-O><C-W>w
        cnoremap <C-Tab> <C-C><C-W>w
        onoremap <C-Tab> <C-C><C-W>w

        " CTRL-F4 is Close window
        noremap <C-F4> <C-W>c
        inoremap <C-F4> <C-O><C-W>c
        cnoremap <C-F4> <C-C><C-W>c
        onoremap <C-F4> <C-C><C-W>c

" Only do this part when compiled with support for autocommands.
if has("autocmd")
        " Enable file type detection.
        " Also load indent files, to automatically do language-dependent indenting.
        filetype plugin indent on

        " Put these in an autocmd group, so that we can delete them easily.
        augroup vimrcEx
        au!

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal g`\"" |
                \ endif

        augroup END

        " From a tip on vim.org.  Allows Ctrl-N completion to work w/ XML.
        autocmd FileType {html,xml,xslt,htmldjango}
                \  setlocal iskeyword=@,-,\:,48-57,_,128-167,224-235

        " Markup files need to be wider.
        autocmd FileType {html,xml,xslt,htmldjango}
                \  setlocal columns=130

        "" Python files should use spaces for indentation.
        "autocmd FileType python
        "       \  setlocal expandtab softtabstop=4

        " Don't wrap log files.
        autocmd BufNew,BufRead *.log
                \  setlocal nowrap go+=b

        "" Recognize SCONS files as Python.
        "autocmd BufNew,BufRead SConstruct*,SConscript*
        "       \  setf python
        "autocmd BufNew,BufRead SConstruct*,SConscript*
        "       \  setlocal syntax=python

        " Current directory should always be the directory of the file we're editing.
        autocmd BufEnter * silent! lcd %:p:h

        " Unfold the folds!
        autocmd FileType {go,c} normal zR
else
        " No autocommand support, so just turn on autointenting.
        set autoindent
endif " has("autocmd")

" Set the extra cursor keys to work one visual line at a time.
noremap  <buffer> <silent> <A-Up>   gk
noremap  <buffer> <silent> <A-Down> gj
noremap  <buffer> <silent> <Home> g<Home>
noremap  <buffer> <silent> <End>  g<End>
vnoremap <buffer> <silent> <A-Up>   gk
vnoremap <buffer> <silent> <A-Down> gj
vnoremap <buffer> <silent> <Home> g<Home>
vnoremap <buffer> <silent> <End>  g<End>
inoremap <buffer> <silent> <A-Up>   <C-o>gk
inoremap <buffer> <silent> <A-Down> <C-o>gj
inoremap <buffer> <silent> <Home> <C-o>g<Home>
inoremap <buffer> <silent> <End>  <C-o>g<End>

" Allow modelines.
set modeline
set modelines=5

