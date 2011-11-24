if v:progname =~? "evim"
	finish
endif

set backspace=indent,eol,start

set history=50
set incsearch
set ignorecase smartcase
set ai
set nobackup
set wildmenu
set title
set sts=4
set ts=4
set sw=4
set nocp
set showcmd
set cino=t0g0:0l1(0
set switchbuf=useopen	" Open errors, grep matches in current buffer
set splitright
set hidden " Hide buffers instead closing them, it's good when you need undo history on closed files
set mouse=a	" Use mouse even in terminals (but you still need gvim)
set completeopt=menu,longest

" Complete options that acts on C-n
set complete-=i	" Don't search in include files, it's too slow
set complete-=u " Also don't search in unloaded files

syntax on
set hlsearch
set wildignore=*.o,*.obj,*.lo*,*.so,*.d " Ignore pattern for menu and completions
set lispwords+=define-record-type,library,syntax-rules,fields,begin
let g:is_mzscheme=1

" Add ifdef HEADER
function! s:insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! Go#endif /* " . gatename . " */"
  normal! kk
endfunction

let c_space_errors = 1

filetype plugin on
filetype plugin indent on
au BufNewFile *.{h,hpp} call <SID>insert_gates()

map <F3> :nohl<CR>
imap <Home> <Esc>^:startinsert<CR>
imap <C-A> <Home>
imap <C-E> <End>
cnoremap <C-A> <Home>
cabbrev Q quit
cabbrev W write

" Search for project-specific file
if filereadable("Project.vim")
	source Project.vim
endif

" Colorize popupmenu (by default it's hard to recognize on a terminal)
hi PmenuSel ctermfg=Black ctermbg=Cyan
hi Pmenu ctermfg=Black ctermbg=Gray

