"================================== Plugins ===================================

call plug#begin()
    Plug 'mhinz/vim-startify'
    Plug 'rust-lang/rust.vim'
    Plug 'EdenEast/nightfox.nvim'
    Plug 'itchyny/lightline.vim'
    Plug 'sheerun/vim-polyglot'
    Plug 'preservim/tagbar'
    Plug 'universal-ctags/ctags'
    Plug 'frazrepo/vim-rainbow'
    Plug 'preservim/nerdtree'
    Plug 'preservim/nerdcommenter'
    Plug 'vim-syntastic/syntastic'
    Plug 'tpope/vim-surround'
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    Plug 'tommcdo/vim-lion'
    Plug 'ntpeters/vim-better-whitespace'
call plug#end()

"================================== General ===================================

" Set colorscheme
colorscheme carbonfox

" Better search
set showmatch
set ignorecase
set hlsearch
set incsearch

" Enable mouse
set mouse=v
set mouse=a

" Better looking code
set autoindent
set smartindent
set cc=80
set noswapfile

" Position in code
set number
set ruler
set scrolloff=7

" Default file encoding
set encoding=utf-8

" Get syntax files from config folder
set runtimepath+=~/.config/nvim/syntax

" Enable clipboard
set clipboard=unnamedplus

" Don't make noise
set visualbell

" Line wrap
set wrap

" disable backup files
set nobackup
set nowritebackup

" no delays!
set updatetime=300

set cmdheight=1
set shortmess+=c

set signcolumn=yes

" Enable plugins
filetype plugin indent on
filetype plugin on

" Syntax highlighting
syntax on

"================================= Mappings ===================================

" Copy/Past with Ctrl-c/Ctrl-v
noremap <C-c> "+y
noremap <C-v> "+p

" Map F8 to Tagbar
nmap <F8> :TagbarToggle<CR>

" Toggle NerdTree with Ctrl-n
nnoremap <C-n> :NERDTreeToggle<CR>

" Disable Ctrl-z from job-controlling neovim
nnoremap <C-z> <nop>

nnoremap <C-x> :Startify<CR>

" Exit from insert mode with jk
inoremap jk <esc>

" Make on Ctrl-b
nnoremap <C-b> :make<CR>

" Disable highlighting
nnoremap <leader>n :noh<CR>
"================================= Functions ==================================

" Function to set tab width to n spaces
function! SetTab(n)
    let &l:tabstop=a:n
    let &l:softtabstop=a:n
    let &l:shiftwidth=a:n
    set expandtab
endfunction

command! -nargs=1 SetTab call SetTab(<f-args>)

" Function to trim extra whitespace in whole file
function! Trim()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

command! -nargs=0 Trim call Trim()

set laststatus=2

" ASM = FASM
augroup fasm_ft
    au!
    autocmd BufNewFile,BufRead *.asm set syntax=fasm
augroup END

"============================== Plugins configs ===============================

" CTags config
let g:Tlist_Ctags_Cmd='/usr/local/Cellar/ctags/5.8_1/bin/ctags'

"============================== Startify config ===============================

let g:startify_custom_header = [
   \'   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
   \'   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
   \'   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
   \'   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
   \'   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
   \'   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
   \ ]

let g:startify_bookmarks = [
            \ { 'z': '~/.zshrc'},
            \ { 'v': '~/.config/nvim/init.vim'},
            \ ]
let g:startify_lists = [
            \ {'header':[' Last files'], 'type':'files'},
            \ {'header':[' Bookmarks'], 'type':'bookmarks'},
            \ {'header':[' Last dir', getcwd()], 'type':'dir'},
            \ ]
let g:startify_fortune_use_unicode = 1

"================================ Coc config ==================================

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Setting up lightline
set noshowmode
let g:lightline = {
	\ 'colorscheme': 'deus',
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ],
	\             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
	\ },
	\ 'component_function': {
	\   'cocstatus': 'coc#status'
	\ },
	\ }

" Use autocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
