if &compatible
	set nocompatible
endif
" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
 call dein#begin('~/.cache/dein')
 call dein#add('~/.cache/dein')

 " color scheme
 call dein#add('KKPMW/moonshine-vim')
 call dein#add('cocopon/iceberg.vim')

 " c++
 call dein#add('octol/vim-cpp-enhanced-highlight')
 call dein#add('Shougo/neocomplete.vim')
 call dein#add('Shougo/neosnippet.vim')
 call dein#add('Shougo/neosnippet-snippets')
 call dein#add('justmao945/vim-clang')

 " ruby
 call dein#add('kana/vim-smartinput')
 call dein#add('cohama/vim-smartinput-endwise')
 call smartinput_endwise#define_default_rules()

 if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
 endif
 let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
 autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

 let g:rsenseHome = expand("/Users/kuwa/.rbenv/shims/rsence")
 let g:rsenceUseOmniFunc = 1

 " いろいろ
 call dein#add('itchyny/lightline.vim') " ステータスライン強化
 call dein#add('bronson/vim-trailing-whitespace') " 文末の空白を強調
 call dein#add('w0rp/ale') " 構文チェック
 call dein#add('luochen1990/rainbow') " かっこの深さで色分け
 " ↓入れるとimapの<CR>を最優先で書き換えるからneosniとぶつかる
 " call dein#add('jiangmiao/auto-pairs') " かっこ補完
 call dein#add('thinca/vim-quickrun') " クイックラン
 call dein#add('nathanaelkane/vim-indent-guides') " インデント可視化

 if !has('nvim')
   call dein#add('roxma/nvim-yarp')
   call dein#add('roxma/vim-hug-neovim-rpc')
 endif

 call dein#end()
 if dein#check_install()
  call dein#install()
 endif
 call dein#save_state()
endif

filetype plugin indent on
syntax enable



" neocomplete
" Vim起動時にneocompleteを有効にする
let g:neocomplete#enable_at_startup = 1
" 大文字が入力されるまで大文字小文字の区別を無視する
let g:neocomplete#enable_smart_case = 1
" 3文字以上の単語に対して補完を有効にする
let g:neocomplete#min_keyword_length = 3
" 区切り文字まで補完する
let g:neocomplete#enable_auto_delimiter = 1
" 1文字目の入力から補完のポップアップを表示
let g:neocomplete#auto_completion_start_length = 1

if has('conceal')
	set conceallevel=2 concealcursor=niv
endif
" バックスペースで補完のポップアップを閉じる
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" タブキーで補完候補の選択. スニペット内のジャンプもタブキーでジャンプ
imap <expr><TAB>
	 \ pumvisible() ? "\<C-n>" :
	 \ neosnippet#expandable_or_jumpable() ?
	 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
	 \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" エンターキーで展開
imap <expr><CR>
	\ (pumvisible() && neosnippet#expandable()) ?
	\ "\<Plug>(neosnippet_expand)" : "\<CR>"


" スニペット保存場所
let g:neosnippet#snippets_directory='~/.vim/snippets/'



" clang-vim
" 自動補完
let g:clang_auto = 0
" Cソース用オプション
let g:clang_c_options = '-std=c11'
" C++ソース用オプション
let g:clang_cpp_options = '-std=c++1z' " -stdlib=libc++ –pedantic-errors'
" 保存時にソースコードを整形
let g:clang_format_auto = 0
" コーディングスタイル
let g:clang_format_style = 'Google'
" 保存時にシンタックスチェック
let g:clang_check_syntax_auto = 1
" ?
let g:clang_c_completeopt   = 'menuone'
let g:clang_cpp_completeopt = 'menuone'
" パス探すやつ
function! s:get_latest_clang(search_path)
    let l:filelist = split(globpath(a:search_path, 'clang-*'), '\n')
    let l:clang_exec_list = []
    for l:file in l:filelist
        if l:file =~ '^.*clang-\d\.\d$'
            call add(l:clang_exec_list, l:file)
        endif
    endfor
    if len(l:clang_exec_list)
        return reverse(l:clang_exec_list)[0]
    else
        return 'clang'
    endif
endfunction

function! s:get_latest_clang_format(search_path)
    let l:filelist = split(globpath(a:search_path, 'clang-format-*'), '\n')
    let l:clang_exec_list = []
    for l:file in l:filelist
        if l:file =~ '^.*clang-format-\d\.\d$'
            call add(l:clang_exec_list, l:file)
        endif
    endfor
    if len(l:clang_exec_list)
        return reverse(l:clang_exec_list)[0]
    else
        return 'clang-format'
    endif
endfunction

let g:clang_exec = s:get_latest_clang('/usr/bin')
let g:clang_format_exec = s:get_latest_clang_format('/usr/bin')



" lightline
set laststatus=2 " ステータスラインを常に表示
set showmode " 現在のモードを表示
set showcmd " 打ったコマンドをステータスラインの下に表示
set ruler " ステータスラインの右側にカーソルの現在位置を表示する



" ale
let g:ale_sign_column_always = 1 " シンボルカラム表示しっぱなし
let g:lightline = {
  \'active': {
  \  'left': [
  \    ['mode', 'paste'],
  \    ['readonly', 'filename', 'modified', 'ale'],
  \  ]
  \},
  \'component_function': {
  \  'ale': 'ALEGetStatusLine'
  \}
\ }
" ステータスラインにエラーの数を常に表示
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
" エラー表記
let g:ale_sign_error = '😡'
let g:ale_sign_warning = '🤔'
" 使うlinterの選択
let g:ale_linters = {'cpp': ['gcc'], 'python': ['flake8'], 'javascript': ['eslint']}
" ↑で指定したlinter以外を勝手に使わないようにする
let g:ale_linters_explicit = 1
" gccのオプション
let g:ale_cpp_gcc_executable = 'gcc'
let g:ale_cpp_gcc_options = '-std=c++14 -Wall'
" pythonのオプション
" let g:ale_python_flake8_executable = 'python'



"Rainbow
let g:rainbow_active = 1



"quickrun
let g:quickrun_config = {'*': {'hook/time/enable': '1'},}
nnoremap <C-k> :QuickRun<Space>-input<Space>=@+<CR>
" C++14
let g:quickrun_config.cpp = {
\   'command': 'g++',
\   'cmdopt': '-std=c++14'
\ }



" setting
"文字コードをUTF-8に設定
set fenc=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd
" クリップボードにコピーできるようにする
set clipboard+=unnamed
" 行末で右に行くと次の行の先頭へ
set whichwrap=b,s,h,l,<,>,[,],~
" コマンドモードのコマンド補完
set wildmenu



" 👀見た目系👀
" カラースキーム
colorscheme iceberg
" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" 改行時に前の行のインデントを維持
set autoindent
" タブを勝手にスペースに置換しない
set expandtab
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk



" tab
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
" Tab文字の表示幅（スペースいくつ分）
set tabstop=4
" Tabを入力したときに何文字の空白を入力するか
set softtabstop=4
" 自動インデント時の空白数
set shiftwidth=4
" 改行時に次の行のインデントを調整
set smartindent



" 検索系🧐
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch



" キーマップ😇
" jjでノーマルモード
inoremap <silent> jj <ESC>
inoremap <silent> っｊ <ESC>
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" スプリット <C-w>を<s>に
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sn gt
nnoremap sp gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap sT :<C-u>Unite tab<CR>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>

" カッコ補完
inoremap { {}<Left>
inoremap {<CR> {}<Left><CR><ESC><S-o>
inoremap ( ()<Left>
inoremap [ []<Left>

" IとAを交換
nnoremap I A
nnoremap A I



" プラグインのアンインストール
call map(dein#check_clean(), "delete(v:val, 'rf')")

" 背景透過
highlight Normal ctermbg=none
highlight NonText ctermbg=none
highlight LineNr ctermbg=none
highlight Folded ctermbg=none
highlight EndOfBuffer ctermbg=none

" バックスペースが効かないことへの対処
set backspace=indent,eol,start
" マウス操作を有効に
set mouse=a
set ttymouse=xterm2

" スペース連打でカーソル位置が画面中央になるようにする
nnoremap <Space><Space> zz

" インデント可視化するやつ
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
  autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=black    ctermbg=234
  autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=black ctermbg=235
