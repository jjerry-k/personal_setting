call plug#begin('~/.vim/plugged')
Plug 'davidhalter/jedi-vim'
Plug 'preservim/nerdtree'
Plug 'jeetsukumaran/vim-pythonsense'
Plug 'jiangmiao/auto-pairs'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'dense-analysis/ale'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'liuchengxu/vista.vim'
Plug 'sheerun/vim-polyglot'
" Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop'  }
Plug 'junegunn/seoul256.vim'
call plug#end()

" 세부 정보 출력
set nu
set title
set showmatch
set ruler

" 구문 강조 사용
if has("syntax")
        syntax on
endif

" 들여쓰기 설정
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set expandtab

" 한글 입력 설정
set encoding=utf-8
set termencoding=utf-8
" 커서가 있는 줄을 강조함
set cursorline
" 상태바 표시를 항상한다
set laststatus=2
set statusline=\ %<%l:%v\ [%P]%=%a\ %h%m%r\ %F\
" 검색 설정
set ignorecase
" 마지막으로 수정된 곳에 커서를 위치함
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "norm g`\"" |
\ endif

" Python 실행 커맨드
autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

" seoul256 테마 설정
let g:seoul256_background = 233
"let g:molokai_original = 1
colo seoul256
"set background=dark
