" ================ Initialization ==================== "

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" ================ Default ==================== "

set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching brackets.
set ignorecase              " case insensitive matching
set mouse=v                 " middle-click paste with mouse
set hlsearch                " highlight search results
set tabstop=4               " number of columns occupied by a tab character
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set cc=80                   " set an 80 column border for good coding style
set clipboard=unnamedplus   " nvim copies to system clipboard by default
set spelllang=en_us,de_de   " english & german
filetype plugin indent on   " allows auto-indenting depending on file type
syntax on                   " syntax highlighting 

" ================ Basic ==================== "

filetype plugin indent on " use vims default filetype specific indent scripts
autocmd BufNewFile,BufRead *.Rmd set filetype=rmd "make .Rmd files open with rmd flavor
"autocmd BufRead,BufNewFile *.Rmd set ft=rmd.r

" ================ Spell check ==================== "

autocmd BufRead,BufNewFile *.md setlocal spell

" ================ Plugins ==================== "
" source $HOME/.config/nvim/plugin.vim

 call plug#begin()                                                               
                                                                                 
    " Interaction between R and Vim                                             
    Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}                                    
    " Comment -- very quickly                                                   
    Plug 'preservim/nerdcommenter'                                                  
    " Better syntax suppot                                                      
    Plug 'sheerun/vim-polyglot'                                                     
    "Vimtex                                                                            
    Plug 'lervag/vimtex'                                                        
    " Arch theme
    Plug 'tpope/vim-surround'
    " Parenthesis matching                                                      
    Plug 'jiangmiao/auto-pairs'                                                     
    " For the colorscheme    
    Plug 'rafi/awesome-vim-colorschemes' 
    " Grammar and spelling 
    Plug 'rhysd/vim-grammarous' 
    "Plug 'BrandonRoehl/auto-omni'
 
call plug#end()   

"colorscheme 256_noir
colorscheme minimalist

" ================ Nvim-R ==================== "
" https://github.com/jalvesaq/Nvim-R/blob/master/doc/Nvim-R.txt
" https://www.freecodecamp.org/news/turning-vim-into-an-r-ide-cd9602e8c217/
" https://github.com/kadekillary/dotfiles/blob/master/nvim/init.vim
" https://xiaoouwang.medium.com/update-how-to-turn-vim-into-a-perfect-better-r-ide-and-rmarkdown-writer-than-rstudio-part-i-ae6e62659fab
"
let R_args = ['--no-save']  " call R with the --no-save option
let R_assign = 0 " prevent underscore to become '<-'

" ================ Reveal ==================== "
" https://bookdown.org/yihui/rmarkdown/revealjs.html#
" Turning Vim Into An R IDE
" https://www.freecodecamp.org/news/turning-vim-into-an-r-ide-cd9602e8c217/

