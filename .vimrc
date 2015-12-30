" vimrc for GVim by Kaoriya
set encoding=utf-8
scriptencoding utf-8

"-----------------------------------------------------------------------------
" 基本設定 {{{

" 左手で<Leader>を入力したい
let g:mapleader = '#'

" #検索が誤って発動しないようにする
nnoremap #  <Nop>

" ##で入力待ちを解除する
nnoremap ## <Nop>

" vimrc内全体で使うaugroupを定義
augroup MyAutoCmd
  autocmd!
augroup END

" Echo startuptime on starting Vim
" -> あくまで目安なので注意。実際は「表示値+0.5secくらい」になるようだ
" -> gvim --startuptime startuptime.txt startuptime.txt
if has('vim_starting') && has('reltime')
  let g:startuptime = reltime()
  autocmd MyAutoCmd VimEnter *
        \   let g:startuptime = reltime(g:startuptime)
        \ | redraw
        \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
endif

" ファイル書き込み時の文字コード。空の場合, encodingの値が使用される
" -> vimrcで設定するものではない
" set fileencoding=

" ファイル読み込み時の変換候補
" -> 左から順に判定するので2byte文字が無いファイルだと最初の候補が選択される？
"    utf-8以外を左側に持ってきた時にうまく判定できないことがあったので要検証
" -> とりあえず香り屋版GVimのguessを使おう
if has('kaoriya')
  set fileencodings=guess
else
  set fileencodings=utf-8,cp932,euc-jp
endif

" 文字コードを指定してファイルを開き直す
nnoremap <Leader>enc :<C-u>e ++encoding=

" 改行コードを指定してファイルを開き直す
nnoremap <Leader>ff  :<C-u>e ++fileformat=

" バックアップ, スワップファイルの設定
" -> ネットワーク上ファイルの編集時に重くなる？ので作らない
" -> 生成先をローカルに指定していたからかも。要検証
set noswapfile
set nobackup
set nowritebackup

" ファイルの書き込みをしてバックアップが作られるときの設定
" yes  : 元ファイルをコピー  してバックアップにする＆更新を元ファイルに書き込む
" no   : 元ファイルをリネームしてバックアップにする＆更新を新ファイルに書き込む
" auto : noが使えるならno, 無理ならyes (noの方が処理が速い)
set backupcopy=yes

" Vim生成物の生成先ディレクトリ指定
set dir=~/vimfiles/swap
set backupdir=~/vimfiles/backup

if has('persistent_undo')
  set undodir=~/vimfiles/undo
  set undofile
endif

" Windowsは_viminfo, 他は.viminfoとする
if has('win32') || has('win64')
  set viminfo='30,<50,s100,h,rA:,rB:,n~/_viminfo
else
  set viminfo='30,<50,s100,h,rA:,rB:,n~/.viminfo
endif

" 日本語はスペルチェックから除外
set spelllang=en,cjk

" デフォルトではスペルチェックしない
set nospell
set spellfile=~/dotfiles/en.utf-8.add

" 50あれば十分すぎる
set history=50

" 編集中のファイルがVimの外部で変更された時, 自動的に読み直す
set autoread

" メッセージ省略設定
set shortmess=aoOotTWI

" ノーマルモードで<Esc>するマッピングがあってもbellを鳴らさない
" -> 本当は鳴らしたいが, search-offsetを使った時に鳴るのが気になるので...
set belloff=esc

" カーソル上下に表示する最小の行数
" -> 大きい値にするとカーソル移動時に必ず再描画されるようになる
set scrolloff=100
let g:scrolloffOn = 1
function! s:ToggleScrollOffSet()
  if g:scrolloffOn == 1
    setlocal scrolloff=0
    let g:scrolloffOn = 0
  else
    setlocal scrolloff=100
    let g:scrolloffOn = 1
  endif
  echo 'setlocal scrolloff=' . &scrolloff
endfunction
command! -nargs=0 ToggleScrollOffSet call s:ToggleScrollOffSet()
nnoremap <silent> <F2> :<C-u>ToggleScrollOffSet<CR>

" vimdiff用オプション
" filler   : 埋め合わせ行を表示する
" vertical : 縦分割する
set diffopt=filler,vertical

" makeしたらcopen
autocmd MyAutoCmd QuickfixCmdPost make if len(getqflist()) != 0 | copen | endif

"}}}
"-----------------------------------------------------------------------------
" Plugin List {{{

" ftpluginは最後に読み込むため, 一旦オフする
filetype plugin indent off

" 実は必要のないset nocompatible
" http://rbtnn.hateblo.jp/entry/2014/11/30/174749
if has('vim_starting')
  if &compatible
    " Vi互換モードをオフ(Vimの拡張機能を有効化)
    set nocompatible
  endif

  " Neo Bundleでプラグインを管理する
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle'))

" NeoBundle自体の更新をチェックする
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc.vim', {
      \   'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin'  : 'make -f make_cygwin.mak',
      \     'mac'     : 'make -f make_mac.mak',
      \     'unix'    : 'make -f make_unix.mak',
      \   },
      \ }

" 本家
" NeoBundle 'koron/dicwin-vim'
NeoBundleLazy 'toshi32tony3/dicwin-vim', {
      \   'on_map' : [['ni', '<Plug>']],
      \ }

NeoBundleLazy 'Shougo/neocomplete.vim', {
      \   'on_i' : 1,
      \ }
NeoBundleLazy 'Shougo/neosnippet.vim', {
      \   'on_i' : 1,
      \ }
NeoBundleLazy 'toshi32tony3/neosnippet-snippets', {
      \   'on_i' : 1,
      \ }
NeoBundleLazy 'Shougo/vimfiler.vim', {
      \   'depends'  : 'Shougo/unite.vim',
      \   'on_cmd'   : 'VimFilerCurrentDir',
      \   'explorer' : 1,
      \ }

NeoBundleLazy 'Shougo/unite.vim', {
      \   'on_cmd' : 'Unite',
      \ }
NeoBundleLazy 'Shougo/neomru.vim', {
      \   'depends'  : 'Shougo/unite.vim',
      \   'on_unite' : 'file_mru',
      \ }
NeoBundleLazy 'Shougo/junkfile.vim', {
      \   'depends'  : 'Shougo/unite.vim',
      \   'on_unite' : ['junkfile', 'junkfile/new'],
      \ }
NeoBundleLazy 'tacroe/unite-mark', {
      \   'depends'  : 'Shougo/unite.vim',
      \   'on_unite' : 'mark',
      \ }
NeoBundleLazy 'Shougo/unite-outline', {
      \   'depends'  : 'Shougo/unite.vim',
      \   'on_unite' : 'outline',
      \ }
NeoBundleLazy 'hewes/unite-gtags', {
      \   'depends'  : 'Shougo/unite.vim',
      \   'on_unite' : ['gtags/ref', 'gtags/def'],
      \ }

NeoBundleLazy 'vim-scripts/gtags.vim', {
      \   'on_cmd' : 'Gtags',
      \ }

" NeoBundle 'thinca/vim-singleton'
NeoBundleLazy 'thinca/vim-quickrun', {
      \   'on_cmd' : 'QuickRun',
      \ }
NeoBundleLazy 'thinca/vim-ambicmd'
NeoBundleLazy 'thinca/vim-fontzoom', {
      \   'on_map' : '<Plug>',
      \   'on_cmd' : 'Fontzoom',
      \ }
NeoBundleLazy 'thinca/vim-qfreplace', {
      \   'on_cmd' : 'Qfreplace',
      \ }

" NeoBundle 'pocke/vim-hier'
" NeoBundle 'osyo-manga/shabadou.vim'
" NeoBundle 'osyo-manga/vim-watchdogs'

" memolist.vimはmarkdown形式でメモを生成するので, markdownを使いやすくしてみる
" http://rcmdnk.github.io/blog/2013/11/17/computer-vim/#plasticboyvim-markdown
NeoBundle 'rcmdnk/vim-markdown'
NeoBundleLazy 'glidenote/memolist.vim', {
      \   'on_cmd' : ['MemoNew'],
      \ }

" 本家
" NeoBundle 'kannokanno/previm'
NeoBundleLazy 'beckorz/previm', {
      \   'depends' : 'tyru/open-browser.vim',
      \   'on_cmd'  : 'PrevimOpen',
      \ }

" " リアルタイムプレビューが非常に早いのが特徴。発展途上感はある
" NeoBundleLazy 'kurocode25/mdforvim', {
"       \   'on_cmd' : ['MdPreview', 'MdConvert'],
"       \ }

NeoBundleLazy 'tyru/open-browser.vim', {
      \   'on_map' : '<Plug>(openbrowser-',
      \ }

NeoBundle 'tpope/vim-surround'

NeoBundleLazy 'kana/vim-textobj-user'
NeoBundleLazy 'kana/vim-textobj-function', {
      \   'depends' : 'kana/vim-textobj-user',
      \   'on_map'  : [['xo', 'if', 'af', 'iF', 'aF']],
      \ }
NeoBundleLazy 'sgur/vim-textobj-parameter', {
      \   'depends' : 'kana/vim-textobj-user',
      \   'on_map'  : [['xo', 'i,', 'a,']],
      \ }

NeoBundleLazy 'kana/vim-operator-user'
NeoBundleLazy 'kana/vim-operator-replace', {
      \   'depends' : 'kana/vim-operator-user',
      \   'on_map'  : '<Plug>',
      \ }
NeoBundleLazy 'osyo-manga/vim-operator-search', {
      \   'depends' : 'kana/vim-operator-user',
      \   'on_map'  : '<Plug>',
      \ }
NeoBundleLazy 't9md/vim-quickhl', {
      \   'depends' : 'kana/vim-operator-user',
      \   'on_map'  : ['<Plug>(operator-quickhl-', '<Plug>(quickhl-'],
      \ }

NeoBundleLazy 'tyru/capture.vim', {
      \   'on_cmd' : 'Capture',
      \ }

NeoBundleLazy 'haya14busa/incsearch.vim', {
      \   'on_map' : '<Plug>',
      \ }
NeoBundleLazy 'haya14busa/incsearch-fuzzy.vim', {
      \   'depends' : 'haya14busa/incsearch.vim',
      \   'on_map'  : '<Plug>',
      \ }

NeoBundleLazy 'osyo-manga/vim-anzu', {
      \   'on_map' : '<Plug>',
      \ }
NeoBundleLazy 'haya14busa/vim-asterisk', {
      \   'on_map' : '<Plug>',
      \ }

NeoBundleLazy 'mhinz/vim-signify', {
      \   'on_cmd' : 'SignifyStart',
      \ }

NeoBundle 'tpope/vim-fugitive', {
      \   'augroup' : 'fugitive',
      \ }
NeoBundle 'idanarye/vim-merginal', {
      \   'depends' : 'tpope/vim-fugitive',
      \   'augroup' : 'merginal',
      \ }
NeoBundleLazy 'cohama/agit.vim', {
      \   'on_cmd' : 'Agit',
      \ }
NeoBundleLazy 'lambdalisue/vim-gita', {
      \   'on_cmd' : 'Gita',
      \ }

NeoBundle 'chriskempson/vim-tomorrow-theme'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'cocopon/lightline-hybrid.vim'

NeoBundleLazy 'LeafCage/yankround.vim', {
      \   'on_map' : '<Plug>',
      \ }
NeoBundleLazy 'junegunn/vim-easy-align', {
      \   'on_cmd' : 'EasyAlign',
      \ }

" 本家
" NeoBundle 'bronson/vim-trailing-whitespace'
NeoBundle 'toshi32tony3/vim-trailing-whitespace'

NeoBundleLazy 'vim-scripts/BufOnly.vim', {
      \   'on_cmd' : 'BufOnly',
      \ }

" 本家
" NeoBundle 'deris/vim-shot-f'
NeoBundleLazy 'toshi32tony3/vim-shot-f', {
      \   'on_map' : '<Plug>',
      \ }
NeoBundleLazy 'justinmk/vim-sneak', {
      \   'on_map' : '<Plug>Sneak_',
      \ }

NeoBundleLazy 'tyru/caw.vim', {
      \   'on_map' : '<Plug>',
      \ }
NeoBundle 'kshenoy/vim-signature'

NeoBundle 'mhinz/vim-startify'

NeoBundle 'tmhedberg/matchit'

NeoBundleLazy 'basyura/J6uil.vim', {
      \   'on_cmd' : 'J6uil',
      \ }

NeoBundleLazy 'basyura/twibill.vim'
NeoBundleLazy 'basyura/TweetVim', {
      \   'depends' : ['basyura/twibill.vim',  'tyru/open-browser.vim'],
      \   'on_cmd'  : ['TweetVimHomeTimeline', 'TweetVimSearch'],
      \ }

NeoBundle 'lambdalisue/vim-unified-diff'
NeoBundle 'lambdalisue/vim-improve-diff'

NeoBundleLazy 'tyru/skk.vim'
NeoBundleLazy 'tyru/eskk.vim', {
      \   'on_map' : [['ni', '<Plug>']]
      \ }

NeoBundleLazy 'mtth/scratch.vim', {
      \   'on_map' : '<Plug>',
      \ }

" 日本語ヘルプを卒業したい
" -> なかなかできない
NeoBundleLazy 'vim-jp/vimdoc-ja'
set helplang=ja

call neobundle#end()

" ファイルタイプの自動検出をONにする
filetype plugin indent on

" 構文解析ON
syntax enable

" vimrcに書いてあるプラグインがインストールされているかチェックする
NeoBundleCheck

" Load local settings
if filereadable(expand('~/localfiles/local.rc.vim'))
  source ~/localfiles/local.rc.vim
elseif filereadable(expand('~/localfiles/template/local.rc.vim'))
  source ~/localfiles/template/local.rc.vim
endif

"}}}
"-----------------------------------------------------------------------------
" 表示 {{{

if has('gui_running')
  " Ricty for Powerline
  set guifont=Ricty\ for\ Powerline:h12:cSHIFTJIS

  " 行間隔[pixel]の設定(default 1 for Win32 GUI)
  set linespace=0

  if has('kaoriya') && has('win32')
    set ambiwidth=auto
  endif

  " M : メニュー・ツールバー領域を削除する
  " c : ポップアップダイアログを使用しない
  set guioptions=Mc

  " カーソルを点滅させない
  set guicursor=a:blinkon0

  set mouse=a      " マウス機能有効
  set nomousefocus " マウスの移動でフォーカスを自動的に切替えない
  set mousehide    " 入力時にマウスポインタを隠す

endif

set showcmd          " 入力中のキーを画面右下に表示
set cmdheight=2      " コマンド行は2行がちょうど良い
set showtabline=2    " 常にタブ行を表示する
set laststatus=2     " 常にステータス行を表示する
set wrap             " 長いテキストを折り返す
set display=lastline " 長いテキストを省略しない
set colorcolumn=81   " 81列目に線を表示

if has('vim_starting')
  set number           " 行番号を表示
  set relativenumber   " 行番号を相対表示
endif
nnoremap <silent> <F10> :<C-u>set relativenumber!<CR>:set relativenumber?<CR>

" 不可視文字を可視化
set list

" 不可視文字の設定(UTF-8特有の文字は使わない方が良い)
set listchars=tab:>-,trail:-,eol:\

if has('kaoriya')

  " 透明度をスイッチ
  let g:transparencyOn = 0
  function! s:ToggleTransParency()
    if g:transparencyOn == 1
      set transparency=255
      echo 'set transparency=255'
      let g:transparencyOn = 0
    else
      set transparency=220
      echo 'set transparency=220'
      let g:transparencyOn = 1
    endif
  endfunction
  command! -nargs=0 ToggleTransParency call s:ToggleTransParency()
  nnoremap <silent> <F12> :<C-u>ToggleTransParency<CR>

endif

" 折り畳み機能の設定
set foldcolumn=1
set foldnestmax=1
set fillchars=vert:\|

" ファイルを開いた時点でどこまで折り畳むか
" -> 全て閉じた状態で開く
if has('vim_starting')
  set foldlevel=0
endif

" fold間の移動はzj, zkで行うのでzh, zlに閉じる/開くを割り当てる
nnoremap zh zc
nnoremap zl zo

" foldをまとめて閉じる(folds close)/まとめて開く(folds open)
nnoremap <Leader>fc zM
nnoremap <Leader>fo zR

set foldmethod=marker
if has('vim_starting')
  set commentstring=%s
endif
autocmd MyAutoCmd FileType vim setlocal commentstring=\ \"%s

" 折りたたみ機能をON/OFF
nnoremap <silent> <F9> :<C-u>set foldenable!<CR>:set foldenable?<CR>

" Hack #120: GVim でウィンドウの位置とサイズを記憶する
" http://vim-jp.org/vim-users-jp/2010/01/28/Hack-120.html
let g:saveWinposFile = expand('~/vimfiles/winpos/.vimwinpos')
if filereadable(g:saveWinposFile)
  autocmd MyAutoCmd VimLeavePre * call s:SaveWindow()
  function! s:SaveWindow()
    let s:options = [
          \   'set columns=' . &columns,
          \   'set lines='   . &lines,
          \   'winpos ' . getwinposx() . ' ' . getwinposy(),
          \ ]
    call writefile(s:options, g:saveWinposFile)
  endfunction
  execute 'source ' g:saveWinposFile
endif

"}}}
"-----------------------------------------------------------------------------
" 検索 {{{

" very magic
nnoremap / /\v

set ignorecase " 検索時に大文字小文字を区別しない。区別したい時は\Cを付ける
set smartcase  " 大文字小文字の両方が含まれている場合は, 区別する
set wrapscan   " 検索時に最後まで行ったら最初に戻る
set incsearch  " インクリメンタルサーチ
set hlsearch   " マッチしたテキストをハイライト

" vimgrep/grep結果が0件の場合, Quickfixを開かない
autocmd MyAutoCmd QuickfixCmdPost vimgrep,grep
      \ if len(getqflist()) != 0 | copen | endif

if has('kaoriya') && has('migemo')
  " 逆方向migemo検索g?を有効化
  set migemo

  " kaoriya版のmigemo searchを再マッピング
  noremap m/ g/
  noremap m? g?
endif

"}}}
"-----------------------------------------------------------------------------
" 編集 {{{

" タブ幅, シフト幅, タブ使用有無の設定
if has('vim_starting')
  set tabstop=2 shiftwidth=2 softtabstop=0 expandtab
endif
autocmd MyAutoCmd FileType c        setlocal tabstop=4 shiftwidth=4
autocmd MyAutoCmd FileType cpp      setlocal tabstop=4 shiftwidth=4
autocmd MyAutoCmd FileType makefile setlocal tabstop=4 shiftwidth=4 noexpandtab

set nrformats=hex              " <C-a>や<C-x>の対象を10進数,16進数に絞る
set virtualedit=all            " テキストが存在しない場所でも動けるようにする
set hidden                     " quit時はバッファを削除せず, 隠す
set confirm                    " 変更されたバッファがある時, どうするか確認する
set switchbuf=useopen          " すでに開いてあるバッファがあればそっちを開く
set showmatch                  " 対応する括弧などの入力時にハイライト表示する
set matchtime=3                " 対応括弧入力時カーソルが飛ぶ時間を0.3秒にする
set matchpairs=(:),{:},[:],<:> " 対応括弧に'<'と'>'のペアを追加
set backspace=indent,eol,start " <BS>でなんでも消せるようにする

" 汎用補完設定
" Default: complete=.,w,b,u,t,i
" . :      current buffer
" w :              buffers in other windows
" b : other loaded buffers in the buffer list
" u :     unloaded buffers in the buffer list
" U :              buffers that are not in the buffer list
" t : tag completion
"     -> タグファイルが大きいと時間がかかるので汎用補完に含めない
" i : current and included files
" d : current and included files for defined name or macro
"     -> インクルードファイルが多いと時間がかかるので汎用補完に含めない
set complete=.,w,b,u,U
set infercase           " 補完時に大文字小文字を区別しない
set completeopt=menuone " 補完時は対象が一つでもポップアップを表示
set pumheight=10        " 補完候補は一度に10個まで表示

" コマンドライン補完設定
set wildmenu
set wildmode=full

" <C-p>や<C-n>でもコマンド履歴のフィルタリングを有効にする
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" j : 行連結時にコメントリーダーを削除
" l : insertモードの自動改行を無効化
" m : 整形時, 255よりも大きいマルチバイト文字間でも改行する
" q : gqでコメント行を整形
autocmd MyAutoCmd BufEnter * setlocal formatoptions=jlmq

" gqで使うtextwidthを設定
autocmd MyAutoCmd BufEnter * setlocal textwidth=80

" autoindentをオフ
autocmd MyAutoCmd BufEnter * setlocal noautoindent

" インデントを入れるキーのリストを調整(コロン, 行頭の#でインデントしない)
" https://gist.github.com/myokota/8b6040da5a3d8b029be0
autocmd MyAutoCmd BufEnter * setlocal indk-=:
autocmd MyAutoCmd BufEnter * setlocal indk-=0#
autocmd MyAutoCmd BufEnter * setlocal cinkeys-=:
autocmd MyAutoCmd BufEnter * setlocal cinkeys-=0#

" Dはd$なのにYはyyと同じというのは納得がいかない
nnoremap Y y$

" 直前の置換を繰り返す際に最初のフラグ指定を継続して反映する
nnoremap & <silent> :<C-u>&&<CR>
xnoremap & <silent> :<C-u>&&<CR>

" クリップボードレジスタを使う
set clipboard=unnamed

" 現在開いているファイルのパスなどをレジスタやクリップボードへ登録する
" https://gist.github.com/pinzolo/8168337
function! s:Clip(data)
  let @* = a:data
  echo 'clipped: ' . a:data
endfunction

" 現在開いているファイルのパスをレジスタへ
command! -nargs=0 ClipPath call s:Clip(expand('%:p'))

" 現在開いているファイルのファイル名をレジスタへ
command! -nargs=0 ClipFile call s:Clip(expand('%:t'))

" 現在開いているファイルのディレクトリパスをレジスタへ
command! -nargs=0 ClipDir  call s:Clip(expand('%:p:h'))

" コマンドの出力結果をクリップボードに格納
function! s:ClipCmdOutput(cmd)
  redir @*>
  silent execute a:cmd
  redir END
endfunction
command! -nargs=1 -complete=command ClipCmdOutput call s:ClipCmdOutput(<f-args>)

"}}}
"-----------------------------------------------------------------------------
" 操作の簡単化 {{{

" キー入力タイムアウトはあると邪魔だし, 待つ意味も無い気がする
set notimeout

" 閉じる系の入力を簡易化
nnoremap <C-q><C-q> :<C-u>bdelete<CR>
nnoremap <C-w><C-w> :<C-u>close<CR>

" フォーカスがあたっているウィンドウ以外閉じる
nnoremap ,o  :<C-u>only<CR>

" vimrcをリロード
nnoremap ,r :<C-u>source $MYVIMRC<CR>

" 検索テキストハイライトを消す
nnoremap <silent> <Esc> :<C-u>nohlsearch<CR>

" カレントファイルをfull pathで表示(ただし$HOME以下はrelative path)
nnoremap <C-g> 1<C-g>

" j/kによる移動を折り返されたテキストでも自然に振る舞うようにする
nnoremap j gj
xnoremap j gj
nnoremap k gk
xnoremap k gk

function! s:HelpSettings()
  " <F1>でヘルプを閉じる
  nnoremap <buffer> <F1>  :<C-u>q<CR>
  " <Esc>でヘルプから抜ける
  nnoremap <buffer> <Esc> <C-w>j
endfunction
autocmd MyAutoCmd FileType help call s:HelpSettings()

" 最後のウィンドウがQuickfixウィンドウの場合, 自動で閉じる
autocmd MyAutoCmd WinEnter * if (winnr('$') == 1) &&
      \ (getbufvar(winbufnr(0), '&buftype')) == 'quickfix' | quit | endif

" 現在開いているファイルのディレクトリに移動
function! s:ChangeDir(dir)
  lcd %:p:h
  echo 'change directory to: ' . a:dir
endfunction
command! -nargs=0 CD call s:ChangeDir(expand('%:p:h'))

" " 開いたファイルと同じ場所へ移動する
" " -> startify/:CDでcdするので以下の設定は使用しない
" autocmd MyAutoCmd BufEnter * execute 'lcd ' fnameescape(expand('%:p:h'))

" " 最後のカーソル位置を記憶していたらジャンプ
" " -> Gdiff時に不便なことがあったので手動でマークジャンプする
" autocmd MyAutoCmd BufRead * silent normal! `"

" 保存時にViewの状態を保存し, 読み込み時にViewの状態を前回の状態に戻す
" http://ac-mopp.blogspot.jp/2012/10/vim-to.html
" -> プラグインの挙動とぶつかることもあるらしいので使わない
" -> https://github.com/Shougo/vimproc.vim/issues/116
" set viewdir=~/vimfiles/view
" autocmd MyAutoCmd BufWritePost ?* mkview
" autocmd MyAutoCmd BufReadPost  ?* loadview

" タブ複製
nnoremap ,t :<C-u>tab split<CR>

" 新規タブでgf
nnoremap <Leader>gf :<C-u>execute 'tablast <bar> tabfind ' . expand('<cfile>')<CR>

" 新規タブでvimdiff
" 引数が1つ     : カレントバッファと引数指定ファイルの比較
" 引数が2つ以上 : 引数指定ファイル同士の比較
" http://koturn.hatenablog.com/entry/2013/08/10/034242
function! s:TabDiff(...)
  if a:0 == 1
    tabedit %:p
    execute 'rightbelow vertical diffsplit ' . a:1
  else
    execute 'tabedit ' a:1
    for l:file in a:000[1 :]
      execute 'rightbelow vertical diffsplit ' . l:file
    endfor
  endif
endfunction
command! -nargs=+ -complete=file Diff call s:TabDiff(<f-args>)

" :messageで表示される履歴を削除
" http://d.hatena.ne.jp/osyo-manga/20130502/1367499610
command! -nargs=0 DeleteMessage  for s:n in range(200) | echomsg '' | endfor

" :jumplistを空にする
command! -nargs=0 DeleteJumpList for s:n in range(200) | mark '     | endfor

"}}}
"-----------------------------------------------------------------------------
" tags, path {{{

" 新規タブでタグジャンプ
function! s:JumpTagTab(funcName)
  tablast | tab split

  " ctagsファイルを複数生成してpath登録順で優先順位を付けているなら'tag'にする
  execute 'tag' a:funcName

  " " 1つの大きいctagsファイルを生成している場合はリストから選べる'tjump'にする
  " execute 'tjump' a:funcName

endfunction
command! -nargs=1 -complete=tag JumpTagTab call s:JumpTagTab(<f-args>)
nnoremap <Leader>} :<C-u>JumpTagTab <C-r><C-w><CR>

" ソースディレクトリの設定はローカル設定ファイルに記述する
" see: ~/localfiles/local.rc.vim
if filereadable(expand('~/localfiles/local.rc.vim'))

  function! s:SetSrcDir()
    let g:numberOfSrc = len(g:src_ver_list)
    let $TARGET_VER = g:src_ver_list[g:indexOfSrc]
    let $TARGET_DIR = $SRC_DIR . '\' . $TARGET_VER
    let $CTAGS_DIR = $TARGET_DIR . '\.tags'
  endfunction

  function! s:SetTags()
    set tags=

    for l:item in g:target_dir_ctags_list
      let $SET_TAGS = $CTAGS_DIR. '\' . g:target_dir_ctags_name_list[l:item]
      set tags+=$SET_TAGS
    endfor

    " GTAGSROOTの登録
    " -> GNU Globalのタグはプロジェクトルートで生成する
    let $GTAGSROOT = $TARGET_DIR
  endfunction

  function! s:SetPathList()
    set path=

    " 起点なしのpath登録
    for l:item in g:other_dir_path_list
      let $SET_PATH = l:item
      set path+=$SET_PATH
    endfor

    " $TARGET_DIRを起点にしたpath登録
    for l:item in g:target_dir_path_list
      let $SET_PATH = $TARGET_DIR . '\' . l:item
      set path+=$SET_PATH
    endfor
  endfunction

  function! s:SetCDPathList()
    set cdpath=

    " 起点なしのcdpath登録
    for l:item in g:other_dir_cdpath_list
      let $SET_CDPATH = l:item
      set cdpath+=$SET_CDPATH
    endfor

    " $SRC_DIR, $TARGET_DIRをcdpath登録
    set cdpath+=$SRC_DIR
    set cdpath+=$TARGET_DIR

    " $TARGET_DIRを起点にしたcdpath登録
    for l:item in g:target_dir_cdpath_list
      let $SET_CDPATH = $TARGET_DIR . '\' . l:item
      set cdpath+=$SET_CDPATH
    endfor
  endfunction

  call s:SetSrcDir()
  call s:SetTags()
  call s:SetPathList()
  call s:SetCDPathList()

  " ソースコードをスイッチ
  function! s:SwitchSource()
    let g:indexOfSrc += 1
    if g:indexOfSrc >= g:numberOfSrc
      let g:indexOfSrc = 0
    endif

    call s:SetSrcDir()
    call s:SetTags()
    call s:SetPathList()
    call s:SetCDPathList()

    " ソースコード切り替え後, バージョン名を出力
    echo 'change source to: ' . $TARGET_VER

  endfunction
  command! -nargs=0 SwitchSource call s:SwitchSource()
  nnoremap ,s :<C-u>SwitchSource<CR>

  " ctagsをアップデート
  function! s:UpdateCtags()
    if !isdirectory($CTAGS_DIR)
      call system('mkdir ' . $CTAGS_DIR)
    endif
    for l:item in g:target_dir_ctags_list
      if !has_key(g:target_dir_ctags_name_list, l:item)
        continue
      endif
      let l:updateCommand =
            \ 'ctags -f ' .
            \ $TARGET_DIR . '\.tags\' . g:target_dir_ctags_name_list[l:item] .
            \ ' -R ' .
            \ $TARGET_DIR . '\' . l:item
      call system(l:updateCommand)
    endfor
  endfunction
  command! -nargs=0 UpdateCtags call s:UpdateCtags()

endif

"}}}
"-----------------------------------------------------------------------------
" 誤爆防止 {{{

" レジスタ機能のキーを<S-q>にする(Exモードは使わないので潰す)
nnoremap q     <Nop>
nnoremap <S-q> q

" F3 command history
nnoremap <F3> <Esc>q:
nnoremap q:   <Nop>

" F4 search history
nnoremap <F4> <Esc>q/
nnoremap q/   <Nop>
nnoremap q?   <Nop>

" 「保存して閉じる」「保存せず閉じる」を無効にする
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" <C-@>  : 直前に挿入したテキストをもう一度挿入し, ノーマルモードに戻る
" <C-g>u : アンドゥ単位を区切る
" -> 割りと暴発する＆あまり用途が見当たらないので, <Esc>に置き替え
" inoremap <C-@> <C-g>u<C-@>
inoremap <C-@> <Esc>
noremap  <C-@> <Esc>

" よくわからないけどGVimが終了されて困るので防ぐ
nnoremap q<Space>   <Nop>
nnoremap <C-w><C-q> <Nop>

" よくわからないけど矩形Visualモードになるので潰す
nnoremap <C-q> <Nop>

" マウス中央ボタンは使わない
noremap  <MiddleMouse> <Nop>
inoremap <MiddleMouse> <Nop>

" 挿入モードでカーソルキーを使うとUndo単位が区切られて困るので潰す
inoremap <Left>  <Nop>
inoremap <Down>  <Nop>
inoremap <Up>    <Nop>
inoremap <Right> <Nop>

" Shift or Ctrl or Alt + カーソルキーはコマンドモードでのみ使用する
inoremap <S-Left>  <Nop>
inoremap <S-Down>  <Nop>
inoremap <S-Up>    <Nop>
inoremap <S-Right> <Nop>
inoremap <C-Left>  <Nop>
inoremap <C-Down>  <Nop>
inoremap <C-Up>    <Nop>
inoremap <C-Right> <Nop>
inoremap <A-Left>  <Nop>
inoremap <A-Down>  <Nop>
inoremap <A-Up>    <Nop>
inoremap <A-Right> <Nop>
noremap  <Left>    <Nop>
noremap  <Down>    <Nop>
noremap  <Up>      <Nop>
noremap  <Right>   <Nop>
noremap  <S-Left>  <Nop>
noremap  <S-Down>  <Nop>
noremap  <S-Up>    <Nop>
noremap  <S-Right> <Nop>
noremap  <C-Left>  <Nop>
noremap  <C-Down>  <Nop>
noremap  <C-Up>    <Nop>
noremap  <C-Right> <Nop>
noremap  <A-Left>  <Nop>
noremap  <A-Down>  <Nop>
noremap  <A-Up>    <Nop>
noremap  <A-Right> <Nop>

" せっかくなので, カーソルキーでウィンドウ間を移動
nnoremap <Left>  <C-w>h
nnoremap <Down>  <C-w>j
nnoremap <Up>    <C-w>k
nnoremap <Right> <C-w>l

" せっかくなので, Shift + カーソルキーでbprevious/bnext
nnoremap <S-Left>  :<C-u>bprevious<CR>
nnoremap <S-Down>  :<C-u>bnext<CR>
nnoremap <S-Up>    :<C-u>bprevious<CR>
nnoremap <S-Right> :<C-u>bnext<CR>

" せっかくなので,  Ctrl + カーソルキーでcprevious/cnext
nnoremap <C-Left>  :<C-u>cprevious<CR>
nnoremap <C-Down>  :<C-u>cnext<CR>
nnoremap <C-Up>    :<C-u>cprevious<CR>
nnoremap <C-Right> :<C-u>cnext<CR>

" せっかくなので,   Alt + カーソルキーで previous/next
nnoremap <A-Left>  :<C-u>previous<CR>
nnoremap <A-Down>  :<C-u>next<CR>
nnoremap <A-Up>    :<C-u>previous<CR>
nnoremap <A-Right> :<C-u>next<CR>

"}}}
"-----------------------------------------------------------------------------
" Vim scripts {{{

" カウンタ
function! s:MyCounter() "{{{
  if !exists('b:myCounter')
    let b:myCounter = 0
  else
    let b:myCounter += 1
  endif
  echomsg 'count: ' . b:myCounter
endfunction "}}}
command! -nargs=0 MyCounter call s:MyCounter()

" タイムスタンプの挿入
function! s:PutTimeStamp() "{{{
  let @" = strftime('%Y/%m/%d(%a) %H:%M')
  normal! ""P
endfunction "}}}
command! -nargs=0 PutTimeStamp call s:PutTimeStamp()

" 区切り線＋タイムスタンプの挿入
function! s:PutMemoFormat() "{{{
  let @" = '='
  normal! 080""Po
  let @" = strftime('%Y/%m/%d(%a) %H:%M')
  normal! ""P
  let @" = '{'
  normal! $l3""p
  let @" = '}'
  normal! o
  normal! 03""P
  normal! ko
endfunction "}}}
command! -nargs=0 PutMemoFormat call s:PutMemoFormat()

" キーリピート時のCursorMoved autocmdを無効にする, 行移動を検出する
" http://d.hatena.ne.jp/gnarl/20080130/1201624546
let g:throttleTimeSpan = 100
function! s:OnCursorMove() "{{{
  " run on normal/visual mode only
  let l:currentMode = mode()
  if l:currentMode != 'n' && l:currentMode != 'v'
    let b:isLineChanged = 0
    let b:isCursorMoved = 0
    return
  endif

  " 初回のCursorMoved発火時の処理
  if !exists('b:lastVisitedLine')
    let b:isCursorMoved = 0
    let b:isLineChanged = 0
    let b:lastVisitedLine = line('.')
    let b:lastCursorMoveTime = 0
  endif

  " ミリ秒単位の現在時刻を取得
  let l:ml = matchlist(reltimestr(reltime()), '\(\d*\)\.\(\d\{3}\)')
  if l:ml == []
    return
  endif
  let l:ml[0] = ''
  let l:now = str2nr(join(l:ml, ''))

  " 前回のCursorMoved発火時からの経過時間を算出
  let l:timespan = l:now - b:lastCursorMoveTime

  " lastCursorMoveTimeを更新
  let b:lastCursorMoveTime = l:now

  " 指定時間経過しているか否かで処理分岐
  if l:timespan <= g:throttleTimeSpan
    let b:isLineChanged = 0
    let b:isCursorMoved = 0
    return
  endif

  " CursorMoved!!
  let b:isCursorMoved = 1

  if b:lastVisitedLine != line('.')
    " LineChanged!!
    let b:isLineChanged = 1
    let b:lastVisitedLine = line('.')

    " NOTE: If no "User LineChanged" events,
    " Vim says "No matching autocommands".
    autocmd MyAutoCmd User LineChanged :
    doautocmd MyAutoCmd User LineChanged
  else
    let b:isLineChanged = 0
  endif
endfunction "}}}
autocmd MyAutoCmd CursorMoved * call s:OnCursorMove()

" foldlevel('.')はnofoldenableの時に必ず0を返すので, foldlevelを自分で数える
" NOTE: 1行, 1Foldまでとする
function! s:GetFoldLevel() "{{{
  " ------------------------------------------------------------
  " 小細工
  " ------------------------------------------------------------
  " [z, ]zは'foldlevel'が0の時は動作しない。nofoldenableの時は'foldlevel'が
  " 設定される機会がないので, foldlevelに大きめの値をセットして解決する
  " NOTE: 'foldlevel'は「ファイルを開いた時点でどこまで折り畳むか」を設定する
  "       -> 勝手に変更しても問題無い, はず
  if &foldenable == 'nofoldenable'
    setlocal foldlevel=10
  endif

  " ------------------------------------------------------------
  " 前処理
  " ------------------------------------------------------------
  let l:foldLevel = 0
  let l:currentLine = getline('.')
  let l:currentLineNumber = line('.')
  let l:lastLineNumber = l:currentLineNumber

  " Viewを保存
  let l:savedView = winsaveview()

  " モーションの失敗を前提にしたVim scriptを使いたいのでbelloffを使う
  let l:belloffTmp = &l:belloff
  let &l:belloff = 'error'

  " ------------------------------------------------------------
  " foldLevelをカウント
  " ------------------------------------------------------------
  " 現在の行にfoldmarkerが含まれているかチェック
  let l:pattern = '\v\ \{\{\{$' " for match } } }
  if match(l:currentLine, l:pattern) >= 0
    let l:foldLevel += 1
  endif

  " [zを使ってカーソルが移動していればfoldLevelをインクリメント
  while 1
    keepjumps normal! [z
    let l:currentLineNumber = line('.')
    if l:lastLineNumber == l:currentLineNumber
      break
    endif
    let l:foldLevel += 1
    let l:lastLineNumber = l:currentLineNumber
  endwhile

  " ------------------------------------------------------------
  " 後処理
  " ------------------------------------------------------------
  " 退避していたbelloffを戻す
  let &l:belloff = l:belloffTmp

  " Viewを復元
  call winrestview(l:savedView)

  return l:foldLevel
endfunction "}}}

" カーソル位置の親Fold名を取得
" NOTE: &ft == 'vim' only
let g:currentFold = ''
function! s:GetCurrentFold() "{{{
  " ------------------------------------------------------------
  " 前処理
  " ------------------------------------------------------------
  " foldlevel('.')はあてにならないことがあるので自作関数で求める
  let l:foldLevel = s:GetFoldLevel()
  if l:foldLevel <= 0
    return ''
  endif

  " View/カーソル位置を保存
  let l:savedView = winsaveview()
  let l:cursorPosition = getcurpos()

  " モーションの失敗を前提にしたVim scriptを使いたいのでbelloffを使う
  let l:belloffTmp = &l:belloff
  let &l:belloff = 'error'

  " 走査回数の設定
  let l:searchCounter = l:foldLevel

  " 変数初期化
  let l:foldList = []
  let l:currentFold = ''
  let l:lastLineNumber = -1

  " ------------------------------------------------------------
  " カーソル位置のfoldListを取得
  " ------------------------------------------------------------
  while 1
    if l:searchCounter <= 0
      break
    endif

    " 1段階親のところへ移動
    keepjumps normal! [z
    let l:currentLine       = getline('.')
    let l:currentLineNumber =    line('.')

    " 移動していなければ, 移動前のカーソル行が子Fold開始位置だったということ
    if l:lastLineNumber == l:currentLineNumber
      " カーソルを戻して子Fold行を取得
      call setpos('.', l:cursorPosition)
      let l:currentLine = getline('.')
    endif

    " コメント行か, 末尾コメントか判別してFold名を切り出す
    let l:startIndex = match   (l:currentLine, '\w'      )
    let l:endIndex   = matchend(l:currentLine, '\v^("\ )')
    let l:preIndex   = ((l:endIndex == -1) ? l:startIndex : l:endIndex)
    let l:sufIndex   = (strlen(l:currentLine) - ((l:endIndex == -1) ? 6 : 5))
    if l:lastLineNumber == l:currentLineNumber
      " 子Foldをリストに追加
      call    add(l:foldList, l:currentLine[l:preIndex : l:sufIndex]   )
    else
      " 親Foldをリストに追加
      call insert(l:foldList, l:currentLine[l:preIndex : l:sufIndex], 0)
    endif

    let l:lastLineNumber = l:currentLineNumber
    let l:searchCounter -= 1

  endwhile

  " ------------------------------------------------------------
  " 後処理
  " ------------------------------------------------------------
  " 退避していたbelloffを戻す
  let &l:belloff = l:belloffTmp

  " Viewを復元
  call winrestview(l:savedView)

  " ウィンドウ幅が十分あればfoldListを繋いで返す
  if winwidth(0) > 120
    return join(l:foldList, " \u2B81 ")
  endif

  return l:foldList[-1]
endfunction "}}}
autocmd MyAutoCmd User LineChanged
      \    if &ft == 'vim' | let g:currentFold = s:GetCurrentFold() | endif
autocmd MyAutoCmd BufEnter * let g:currentFold = s:GetCurrentFold()

" Cの関数名にジャンプ
function! s:JumpFuncNameCForward() "{{{
  if &ft != 'c'
    return
  endif

  " 現在位置をjumplistに追加
  mark '

  " Viewを保存
  let l:savedView = winsaveview()

  let l:lastLine = line('.')
  execute "keepjumps normal! ]]"
  " 検索対象が居なければViewを戻す
  if line('.') == line('$')
    " Viewを復元
    call winrestview(l:savedView)
    return
  endif
  call search('(', 'b')
  execute "normal! b"

  " Cの関数名の上から下方向検索するには, ]]を2回使う必要がある
  if l:lastLine == line('.')
    execute "keepjumps normal! ]]"
    execute "keepjumps normal! ]]"
    " 検索対象が居なければViewを戻す
    if line('.') == line('$')
      " Viewを復元
      call winrestview(l:savedView)
      return
    endif
    call search('(', 'b')
    execute "normal! b"

  endif

  " 現在位置をjumplistに追加
  mark '
endfunction " }}}
function! s:JumpFuncNameCBackward() "{{{
  if &ft != 'c'
    return
  endif

  " 現在位置をjumplistに追加
  mark '

  " Viewを保存
  let l:savedView = winsaveview()

  " カーソルがある行の1列目の文字が { ならば [[ は不要
  if getline('.')[0] != '{'
    execute "keepjumps normal! [["
    " for match } }

    " 検索対象が居なければViewを戻す
    if line('.') == 1
      " Viewを復元
      call winrestview(l:savedView)
      return
    endif
  endif

  call search('(', 'b')
  execute "normal! b"

  " 現在位置をjumplistに追加
  mark '
endfunction " }}}
command! -nargs=0 JumpFuncNameCForward  call s:JumpFuncNameCForward()
command! -nargs=0 JumpFuncNameCBackward call s:JumpFuncNameCBackward()
nnoremap <silent> ]f :<C-u>JumpFuncNameCForward<CR>
nnoremap <silent> [f :<C-u>JumpFuncNameCBackward<CR>

" Cの関数名取得
let g:currentFunc = ''
function! s:GetCurrentFuncC() "{{{
  if &ft != 'c'
    return ''
  endif

  " Viewを保存
  let l:savedView = winsaveview()

  " カーソルがある行の1列目の文字が { ならば [[ は不要
  if getline('.')[0] != '{' " for match } }

    " { よりも先に前方にセクション末尾 } がある場合, 関数定義の間なので検索不要
    execute "keepjumps normal! []"
    let l:endBracketLine = line('.')
    call winrestview(l:savedView)
    execute "keepjumps normal! [["
    if line('.') < l:endBracketLine
      call winrestview(l:savedView)
      return ''
    endif

    " 検索対象が居なければViewを戻す
    if line('.') == 1
      " Viewを復元
      call winrestview(l:savedView)
      return ''
    endif
  endif

  call search('(', 'b')
  execute "normal! b"
  let l:funcName = expand('<cword>')

  " Viewを復元
  call winrestview(l:savedView)

  return l:funcName
endfunction " }}}
autocmd MyAutoCmd User LineChanged
      \      if &ft == 'c' | let g:currentFunc = s:GetCurrentFuncC() | endif
autocmd MyAutoCmd BufEnter * let g:currentFunc = s:GetCurrentFuncC()

function! s:ClipCurrentFuncName(funcName) "{{{
  if strlen(a:funcName) == 0
    echo 'There is no function nearby cursor.'
    return
  endif

  " 選択範囲レジスタ(*)を使う
  let @* = a:funcName
  echo 'clipped: ' . a:funcName

endfunction "}}}
command! -nargs=0 ClipCurrentFuncName
      \ let g:currentFunc = s:GetCurrentFuncC() |
      \ call s:ClipCurrentFuncName(g:currentFunc)

function! s:PrintCurrentFuncName(funcName) "{{{
  if strlen(a:funcName) == 0
    echo 'There is no function nearby cursor.'
    return
  endif

  " 無名レジスタ(")を使う
  let @" = a:funcName
  normal! ""P
  echo 'printed: ' . a:funcName

endfunction "}}}
command! -nargs=0 PrintCurrentFuncName
      \ let g:currentFunc = s:GetCurrentFuncC() |
      \ call s:PrintCurrentFuncName(g:currentFunc)

"}}}
"-----------------------------------------------------------------------------
" Plugin Settings {{{

" Vimでフルスクリーンモード(scrnmode.vim) {{{
if has('kaoriya')

  let g:fullscreenOn = 0
  function! s:ToggleScreenMode()
    if g:fullscreenOn
      execute 'ScreenMode 0'
      let g:fullscreenOn = 0
    else
      execute 'ScreenMode 6'
      let g:fullscreenOn = 1
    endif
  endfunction
  command! -nargs=0 ToggleScreenMode call s:ToggleScreenMode()
  nnoremap <F11> :<C-u>ToggleScreenMode<CR>

endif "}}}

" Vimで英和辞書を引く(dicwin-vim) {{{
if neobundle#tap('dicwin-vim')

  let g:dicwin_no_default_mappings = 1
  nmap <silent> <A-k><A-k> <Plug>(dicwin-cword)
  imap <silent> <A-k><A-k> <Plug>(dicwin-cword-i)
  nmap <silent> <A-k>c     <Plug>(dicwin-close)
  imap <silent> <A-k>c     <Plug>(dicwin-close-i)
  nmap <silent> <A-/>      <Plug>(dicwin-query)

  if filereadable(expand('~/vimfiles/dict/gene.txt'))
    autocmd MyAutoCmd BufRead gene.txt setlocal filetype=dicwin
    function! s:DicwinSettings()
      nnoremap <buffer> <Esc> :<C-u>q<CR>
    endfunction
    autocmd MyAutoCmd FileType dicwin call s:DicwinSettings()
  endif

endif "}}}

" 入力補完(neocomplete.vim) {{{
if neobundle#tap('neocomplete.vim')

  let g:neocomplete#use_vimproc = 1
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_smart_case = 1
  let g:neocomplete#auto_completion_start_length = 2
  let g:neocomplete#min_keyword_length = 3
  let g:neocomplete#enable_auto_delimiter = 1
  let g:neocomplete#skip_auto_completion_time = '0.2'
  let g:neocomplete#enable_auto_close_preview = 1

  " 使用する補完の種類を指定
  if !exists('g:neocomplete#sources')
    let g:neocomplete#sources = {}
  endif

  if neobundle#tap('neosnippet.vim')
    " use for neosnippet and eskk only
    let g:neocomplete#sources._ = ['neosnippet']
  else
    " use for eskk only
    let g:neocomplete#sources._ = []
  endif

  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif

  " 日本語を補完候補として取得しない
  let g:neocomplete#keyword_patterns._ = '\h\w*'

  if neobundle#tap('neosnippet.vim')
    " neocompleteとneosnippetを良い感じに使うためのキー設定
    " http://kazuph.hateblo.jp/entry/2013/01/19/193745
    imap <expr> <TAB> pumvisible() ? "\<C-n>" :
          \  neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" :
          \  "\<TAB>"
    smap <expr> <TAB>
          \  neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" :
          \  "\<TAB>"
    inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
    imap <C-k> <Plug>(neosnippet_expand_or_jump)
    smap <C-k> <Plug>(neosnippet_expand_or_jump)

  else
    inoremap <expr>   <TAB> pumvisible() ? "\<C-n>" :   "\<TAB>"
    inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

  endif

  inoremap <expr> <C-g> neocomplete#undo_completion()
  inoremap <expr> <C-l> neocomplete#complete_common_string()

  function! neobundle#hooks.on_post_source(bundle)
    " Lockされた状態からスタートしたい
    NeoCompleteLock
  endfunction

endif "}}}

" コードスニペットによる入力補助(neosnippet.vim) {{{
if neobundle#tap('neosnippet.vim')

  let g:neosnippet#snippets_directory =
        \ '~/.vim/bundle/neosnippet-snippets/neosnippets'

  if neobundle#tap('unite.vim')
    imap <C-s> <Plug>(neosnippet_start_unite_snippet)
  endif

endif "}}}

" Vim上で動くファイラ(vimfiler.vim) {{{
if neobundle#tap('vimfiler.vim')

  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_enable_auto_cd = 1
  let g:vimfiler_force_overwrite_statusline = 0
  let g:vimfiler_safe_mode_by_default = 0

  " カレントディレクトリを開く
  nnoremap ,c :<C-u>VimFilerCurrentDir<CR>

  " vimfilerのマッピングを一部変更
  function! s:VimfilerSettings()
    " #を<Leader>としているので, similarは##にする
    nnoremap <buffer> #  <Nop>
    nmap     <buffer> ## <Plug>(vimfiler_mark_similar_lines)

    " カレントディレクトリを開く
    nnoremap <buffer> ,c :<C-u>VimFilerCurrentDir<CR>

    if neobundle#tap('unite.vim')
      " Unite vimgrepを使う
      nnoremap <buffer> <expr> gr ':<C-u>Unite vimgrep:**' . g:u_opt_gg . '<CR>'
    endif

    " Disable yankround.vim
    nnoremap <buffer> <C-n> <Nop>
    nnoremap <buffer> <C-p> <Nop>

  endfunction
  autocmd MyAutoCmd FileType vimfiler call s:VimfilerSettings()

endif "}}}

" 検索やリスト表示の拡張(unite.vim) {{{
if neobundle#tap('unite.vim')

  let g:unite_force_overwrite_statusline = 1
  let g:unite_split_rule = 'botright'
  let g:unite_source_history_yank_enable = 1
  let g:unite_enable_ignore_case = 1
  let g:unite_source_find_max_candidates = 0
  let g:unite_source_grep_max_candidates = 0

  " use pt
  " https://github.com/monochromegane/the_platinum_searcher
  if executable('pt')
    set grepprg=pt\ --hidden\ --nogroup\ --nocolor\ --smart-case
    let g:unite_source_grep_command = 'pt'
    let g:unite_source_grep_default_opts =
          \ '--hidden --nogroup --nocolor --smart-case'
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_grep_encoding = 'utf-8'
  endif

  " オプション名がやたらめったら長いので変数に入れてみたけど微妙感が漂う
  let g:u_ninp = ' -input='
  let g:u_nqui = ' -no-quit'
  let g:u_prev = ' -auto-preview'
  let g:u_nsyn = ' -no-sync'
  let g:u_sbuf = ' -buffer-name=search-buffer'
  let g:u_sins = ' -start-insert'
  let g:u_hopt = ' -split -horizontal -winheight=20'
  let g:u_vopt = ' -split -vertical -winwidth=90'

  " unite_sourcesに応じたオプション変数を定義して使う
  let g:u_opt_bu =            g:u_hopt
  let g:u_opt_bo =            g:u_hopt
  let g:u_opt_fi = g:u_sins . g:u_hopt
  let g:u_opt_fm =            g:u_hopt
  let g:u_opt_gd =            g:u_hopt
  let g:u_opt_gg =            g:u_hopt . g:u_sbuf
  let g:u_opt_gr =            g:u_hopt . g:u_sbuf . g:u_nqui
  let g:u_opt_jj = g:u_sins . g:u_hopt
  let g:u_opt_jn = g:u_sins
  let g:u_opt_li = g:u_sins
  let g:u_opt_mf = g:u_sins . g:u_hopt
  let g:u_opt_mg =            g:u_hopt . g:u_sbuf
  let g:u_opt_mk =            g:u_hopt
  let g:u_opt_mp = g:u_sins
  let g:u_opt_nl = g:u_sins
  let g:u_opt_nu = ''
  let g:u_opt_ol =            g:u_vopt
  let g:u_opt_op = g:u_sins
  let g:u_opt_re =            g:u_hopt . g:u_sbuf

  nnoremap <expr> <Leader>bu ':<C-u>Unite buffer'           . g:u_opt_bu . '<CR>'
  nnoremap <expr> <Leader>bo ':<C-u>Unite bookmark'         . g:u_opt_bo . '<CR>'
  nnoremap <expr> <Leader>fi ':<C-u>Unite file'             . g:u_opt_fi . '<CR>'
  nnoremap <expr> <Leader>fm ':<C-u>Unite file_mru'         . g:u_opt_fm . '<CR>'
  nnoremap <expr> <Leader>gd ':<C-u>Unite gtags/def'        . g:u_opt_gd . '<CR>'
  nnoremap <expr> <Leader>g% ':<C-u>Unite vimgrep:%'        . g:u_opt_gg . '<CR>'
  nnoremap <expr> <Leader>g* ':<C-u>Unite vimgrep:*'        . g:u_opt_gg . '<CR>'
  nnoremap <expr> <Leader>g. ':<C-u>Unite vimgrep:.*'       . g:u_opt_gg . '<CR>'
  nnoremap <expr> <Leader>gg ':<C-u>Unite vimgrep:**'       . g:u_opt_gg . '<CR>'
  nnoremap <expr> <Leader>gr ':<C-u>Unite gtags/ref'        . g:u_opt_gr . '<CR>'
  nnoremap <expr> <Leader>jn ':<C-u>Unite junkfile/new'     . g:u_opt_jn . '<CR>'
  nnoremap <expr> <Leader>jj ':<C-u>Unite junkfile'         . g:u_opt_jj . '<CR>'
  nnoremap <expr> <Leader>li ':<C-u>Unite line'             . g:u_opt_li . '<CR>'
  nnoremap <expr> <Leader>mf ':<C-u>Unite file:~/memofiles' . g:u_opt_mf . '<CR>'
  nnoremap <expr> <Leader>mg ':<C-u>Unite vimgrep:~/memofiles/*'
        \                                                   . g:u_opt_mg . '<CR>'
  nnoremap <expr> <Leader>mk ':<C-u>Unite mark'             . g:u_opt_mk . '<CR>'
  nnoremap <expr> <Leader>mp ':<C-u>Unite mapping'          . g:u_opt_mp . '<CR>'
  nnoremap <expr> <Leader>nl ':<C-u>Unite neobundle/lazy'   . g:u_opt_nl . '<CR>'
  nnoremap <expr> <Leader>nu ':<C-u>Unite neobundle/update' . g:u_opt_nu
  nnoremap <expr> <Leader>ol ':<C-u>Unite outline'          . g:u_opt_ol . '<CR>'
  nnoremap <expr> <Leader>op ':<C-u>Unite output'           . g:u_opt_op . '<CR>'
  nnoremap <expr> <Leader>re ':<C-u>UniteResume'            . g:u_opt_re . '<CR>'

  function! neobundle#hooks.on_post_source(bundle)
    " unite.vimのデフォルトコンテキストを設定する
    " http://d.hatena.ne.jp/osyo-manga/20140627
    " -> なんだかんだ非同期で処理させる必要は無い気がする
    " -> emptyの時にメッセージ通知を出せるか調べる
    call unite#custom#profile('default', 'context', {
          \   'no_empty'         : 1,
          \   'no_quit'          : 0,
          \   'prompt'           : '> ',
          \   'prompt_focus'     : 1,
          \   'prompt_direction' : 'top',
          \   'split'            : 0,
          \   'start_insert'     : 0,
          \   'sync'             : 1,
          \ })

    " Unite line/grep/vimgrepの結果候補数を制限しない
    call unite#custom#source('line',    'max_candidates', 0)
    call unite#custom#source('grep',    'max_candidates', 0)
    call unite#custom#source('vimgrep', 'max_candidates', 0)

    " ディレクトリが選択されたらvimfilerで開く
    call unite#custom_default_action('source/bookmark/directory', 'vimfiler')
    call unite#custom_default_action('directory_mru',             'vimfiler')

    function! s:UniteSettings()
      imap <buffer> <Esc> <Plug>(unite_insert_leave)
      nmap <buffer> <Esc> <Plug>(unite_exit)

      " Disable yankround.vim
      nnoremap <buffer> <C-n> <Nop>
      nnoremap <buffer> <C-p> <Nop>
    endfunction
    autocmd MyAutoCmd FileType unite call s:UniteSettings()
  endfunction

endif "}}}

" 使い捨てしやすいファイル生成(junkfile.vim) {{{
if neobundle#tap('junkfile.vim')

  let g:junkfile#directory = expand('~/junkfiles')

  function! neobundle#hooks.on_post_source(bundle)
    " 使わないコマンドを削除する
    delcommand JunkfileOpen

  endfunction

endif "}}}

" for unite-mark {{{
if neobundle#tap('unite-mark')

  " グローバルマークに対しても有効にする
  let g:unite_source_mark_marks =
        \ 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

endif "}}}

" for unite-outline {{{
if neobundle#tap('unite-outline')

endif "}}}

" for unite-gtags {{{
if neobundle#tap('unite-gtags')

endif "}}}

" シンボル, 関数の参照位置検索(GNU GLOBAL, gtags.vim) {{{
if neobundle#tap('gtags.vim')

endif "}}}

" Vimの一つのインスタンスを使い回す(vim-singleton) {{{
if neobundle#tap('vim-singleton')

  call singleton#enable()

endif "}}}

" Vim上で書いているスクリプトをすぐ実行(vim-quickrun) {{{
if neobundle#tap('vim-quickrun')

  let g:quickrun_config = {
        \   '_' : {
        \     'outputter/buffer/split' : ':botright 24sp',
        \   },
        \   'vb' : {
        \     'command'   : 'cscript',
        \     'cmdopt'    : '//Nologo',
        \     'tempfile'  : '{tempname()}.vbs',
        \   },
        \   'c' : {
        \     'command'   : 'gcc',
        \     'cmdopt'    : '-Wall',
        \   },
        \   'cpp' : {
        \     'command'   : 'g++',
        \     'cmdopt'    : '-Wall',
        \   },
        \   'make' : {
        \     'command'   : 'make',
        \     'cmdopt'    : 'run',
        \     'exec'      : '%c %o',
        \     'outputter' : 'error:buffer:quickfix',
        \   },
        \ }

  "       " clangを使う時の設定はこんな感じ？
  "       \   'cpp' : {
  "       \     'type' : 'cpp/clang3_4',
  "       \   },
  "       \   'cpp/clang3_4' : {
  "       \       'command' : 'clang++',
  "       \       'exec'    : '%c %o %s -o %s:p:r',
  "       \       'cmdopt'  : '-std=gnu++0x',
  "       \   },

  " デフォルトの<Leader>rだと入力待ちになるので, 別のキーをマッピング
  let g:quickrun_no_default_key_mappings = 1
  nnoremap <Leader>q :<C-u>QuickRun -hook/time/enable 1<CR>
  xnoremap <Leader>q :<C-u>QuickRun -hook/time/enable 1<CR>

endif "}}}

" コマンド名補完(vim-ambicmd) {{{
if neobundle#tap('vim-ambicmd')

  " 下手にマッピングするよりもambicmdで補完する方が捗る
  cnoremap <expr> <Space> ambicmd#expand("\<Space>")

endif "}}}

" Vimの文字サイズ変更を簡易化(vim-fontzoom) {{{
if neobundle#tap('vim-fontzoom')

  nnoremap ,f :<C-u>Fontzoom!<CR>

  " for Lazy
  let g:fontzoom_no_default_key_mappings = 1
  nmap + <Plug>(fontzoom-larger)
  nmap - <Plug>(fontzoom-smaller)

  " vim-fontzoomには, 以下のデフォルトキーマッピングが設定されている
  " -> しかし, Vimの既知のバグでWindows環境ではC-Scrollを使えないらしい。残念。
  " -> https://github.com/vim-jp/issues/issues/73
  nmap <C-ScrollWheelUp>   <Plug>(fontzoom-larger)
  nmap <C-ScrollWheelDown> <Plug>(fontzoom-smaller)

endif "}}}

" Quickfixから置換(vim-qfreplace) {{{
if neobundle#tap('vim-qfreplace')

endif "}}}

" Quickfixに表示されている行を強調表示(vim-hier) {{{
if neobundle#tap('vim-hier')

endif "}}}

" quickrun-hook集(shabadou.vim) {{{
if neobundle#tap('shabadou.vim')

endif "}}}

" Vim上で自動構文チェック(vim-watchdogs) {{{
if neobundle#tap('vim-watchdogs')
  " Caution: 裏で実行した結果を反映しているのか, pause系の処理があると固まる

  let g:watchdogs_check_BufWritePost_enable = 1
  let g:watchdogs_check_BufWritePost_enables = {
        \   'c'    : 1,
        \   'ruby' : 1,
        \ }

  if neobundle#tap('vim-quickrun')
    " quickrun_configにwatchdogs.vimの設定を追加
    call watchdogs#setup(g:quickrun_config)

  endif

endif "}}}

" markdownを使いやすくする(vim-markdown) {{{
if neobundle#tap('vim-markdown')

  " " markdownのfold機能を無効にする
  " " -> むしろ有効活用したい
  " let g:vim_markdown_folding_disabled = 1
  autocmd MyAutoCmd FileType markdown setlocal foldlevel=1

endif "}}}

" メモ管理用プラグイン(memolist.vim) {{{
if neobundle#tap('memolist.vim')

  let g:memolist_path = '~/memofiles'
  let g:memolist_memo_suffix = 'md'
  let g:memolist_prompt_tags = 1

  " カテゴリまで決めるの面倒なので...
  let g:memolist_prompt_categories = 0

  " markdownテンプレートを指定
  if filereadable(expand('~/configs/template/md.txt'))
    let g:memolist_template_dir_path = '~/configs/template'
  endif

  nnoremap <Leader>ml :<C-u>edit ~/memofiles<CR>
  nnoremap <Leader>mn :<C-u>MemoNew<CR>

endif "}}}

" ファイルをブラウザで開く(previm) {{{
if neobundle#tap('previm')
  let g:previm_open_cmd = "C:/Program\\ Files/Internet\\ Explorer/iexplore.exe"
  let g:previm_enable_realtime = 1

endif "}}}

" Vimからブラウザを開く(open-browser) {{{
if neobundle#tap('open-browser.vim')

  nmap <Leader>L <Plug>(openbrowser-smart-search)
  xmap <Leader>L <Plug>(openbrowser-smart-search)

endif "}}}

" 囲む / 囲まなくする / 別の何かで囲む(vim-surround) {{{
if neobundle#tap('vim-surround')

endif "}}}

" 関数を選択するテキストオブジェクト(vim-textobj-function) {{{
if neobundle#tap('vim-textobj-function')

endif "}}}

" パラメータを選択するテキストオブジェクト(vim-textobj-parameter) {{{
if neobundle#tap('vim-textobj-parameter')

endif "}}}

" 置き換えオペレータ(vim-operator-replace) {{{
if neobundle#tap('vim-operator-replace')

  map R <Plug>(operator-replace)

  " 置換モードは滅多に使わないけど一応...
  noremap <A-r> R

endif "}}}

" 検索オペレータ(vim-operator-search) {{{
if neobundle#tap('vim-operator-search')

  " 関数内検索
  if neobundle#tap('vim-textobj-function')
    nmap <Leader>/ <Plug>(operator-search)if
  endif

endif "}}}

" 自由にテキストハイライト(vim-quickhl) {{{
if neobundle#tap('vim-quickhl')

  map <A-h>      <Plug>(operator-quickhl-manual-this-motion)
  map <A-h><A-h> <Plug>(quickhl-manual-this)

endif "}}}

" コマンドの結果をバッファに表示する(capture.vim) {{{
if neobundle#tap('capture.vim')

  let g:capture_open_command = 'botright 12sp new'

  nnoremap <Leader>who :<C-u>Capture echo expand('%:p')<CR>
  nnoremap <Leader>sn  :<C-u>Capture scriptnames<CR>

endif "}}}

" incsearchをパワーアップ(incsearch.vim) {{{
if neobundle#tap('incsearch.vim')

  " very magic
  let g:incsearch#magic = '\v'

  map <silent> /  <Plug>(incsearch-forward)
  map <silent> ?  <Plug>(incsearch-backward)
  map <silent> g/ <Plug>(incsearch-stay)
  noremap <silent> <expr> g? incsearch#go({'command' : '?', 'is_stay' : 1})

endif "}}}

" incsearch.vimをパワーアップ(incsearch-fuzzy.vim) {{{
if neobundle#tap('incsearch-fuzzy.vim')

  map  z/ <Plug>(incsearch-fuzzy-/)
  map  z? <Plug>(incsearch-fuzzy-?)
  map gz/ <Plug>(incsearch-fuzzyspell-/)
  map gz? <Plug>(incsearch-fuzzyspell-?)

endif "}}}

" asterisk検索をパワーアップ(vim-asterisk) {{{
if neobundle#tap('vim-asterisk')

  " 検索開始時のカーソル位置を保持する
  let g:asterisk#keeppos = 1

  " g:incsearch#magic使用時の検索履歴問題の暫定対処
  " https://github.com/haya14busa/incsearch.vim/issues/22
  " http://lingr.com/room/vim/archives/2014/10/27#message-20478448
  " NOTE: star検索の対象になりそうなものをカバーしたつもりだが, 多分完全ではない
  function! s:ModSearchHistory() "{{{
    if g:incsearch#magic != '\v'
      return ''
    endif

    let l:currentMode = mode()
    if l:currentMode != 'n' && l:currentMode != 'no'
      return ''
    endif

    let l:lastHistory = histget('/', -1)
    let l:endIndex = matchend(l:lastHistory, '^\\<.*\\>')
    if l:endIndex >= 0
      let l:lastHistory = '<' . l:lastHistory[2 : (l:endIndex - 3)] . '>'
            \                 . l:lastHistory[l:endIndex : ]
    endif

    if match(l:lastHistory, '(') >= 0
      let l:lastHistory = substitute(l:lastHistory, '(', '\\(', 'g')
    endif

    if match(l:lastHistory, ')') >= 0
      let l:lastHistory = substitute(l:lastHistory, ')', '\\)', 'g')
    endif

    if match(l:lastHistory, '|') >= 0
      let l:lastHistory = substitute(l:lastHistory, '|', '\\|', 'g')
    endif

    if match(l:lastHistory, '{') >= 0
      let l:lastHistory = substitute(l:lastHistory, '{', '\\{', 'g')
    endif

    if match(l:lastHistory, '}') >= 0
      let l:lastHistory = substitute(l:lastHistory, '}', '\\}', 'g')
    endif

    if      (match(l:lastHistory, '+'          ) >=  0) &&
          \ (match(l:lastHistory, '\v/(b|e|s)+') == -1)
      let l:lastHistory = substitute(l:lastHistory, '+', '\\+', 'g')
    endif

    if match(l:lastHistory, '=') >= 0
      let l:lastHistory = substitute(l:lastHistory, '=', '\\=', 'g')
    endif

    if match(l:lastHistory, '@') >= 0
      let l:lastHistory = substitute(l:lastHistory, '@', '\\@', 'g')
    endif

    if match(l:lastHistory, '?') >= 0
      let l:lastHistory = substitute(l:lastHistory, '?', '\\?', 'g')
    endif

    if match(l:lastHistory, '&') >= 0
      let l:lastHistory = substitute(l:lastHistory, '&', '\\&', 'g')
    endif

    if match(l:lastHistory, '%') >= 0
      let l:lastHistory = substitute(l:lastHistory, '%', '\\%', 'g')
    endif

    if l:lastHistory == '<'
      let l:lastHistory = substitute(l:lastHistory, '<', '\\<', 'g')
    endif

    if l:lastHistory == '<='
      let l:lastHistory = substitute(l:lastHistory, '<=', '\\<\\=', 'g')
    endif

    if l:lastHistory == '<?'
      let l:lastHistory = substitute(l:lastHistory, '<?', '\\<\\?', 'g')
    endif

    if l:lastHistory == '>'
      let l:lastHistory = substitute(l:lastHistory, '>', '\\>', 'g')
    endif

    if l:lastHistory == '>='
      let l:lastHistory = substitute(l:lastHistory, '>=', '\\>\\=', 'g')
    endif

    if l:lastHistory == '>?'
      let l:lastHistory = substitute(l:lastHistory, '>?', '\\>\\?', 'g')
    endif

    if l:lastHistory == '<>'
      let l:lastHistory = substitute(l:lastHistory, '<>', '\\<\\>', 'g')
    endif

    call histdel('/', -1)
    call histadd('/', l:lastHistory)

    return ''
  endfunction "}}}
  noremap <expr> <Plug>(_ModSearchHistory) <SID>ModSearchHistory()
  command! -nargs=0 ModSearchHistory call s:ModSearchHistory()

  " star-search対象をクリップボードに入れる
  function! s:SilentClip(data) "{{{
    let @* = a:data
    return ''
  endfunction "}}}
  noremap <expr> <Plug>(_ClipCword) <SID>SilentClip(expand('<cword>'))

  if neobundle#tap('incsearch.vim') && neobundle#tap('vim-anzu')
    nmap *       <Plug>(_ClipCword)<Plug>(asterisk-z*)<Plug>(anzu-update-search-status-with-echo)<Plug>(_ModSearchHistory)
    omap *  <Esc><Plug>(_ClipCword)<Plug>(asterisk-z*)<Plug>(anzu-update-search-status-with-echo)<Plug>(_ModSearchHistory)
    xmap *              <Esc>gvyvgv<Plug>(asterisk-z*)<Plug>(anzu-update-search-status-with-echo)

    nmap g*      <Plug>(_ClipCword)<Plug>(asterisk-gz*)<Plug>(anzu-update-search-status-with-echo)
    omap g* <Esc><Plug>(_ClipCword)<Plug>(asterisk-gz*)<Plug>(anzu-update-search-status-with-echo)
    xmap g*             <Esc>gvyvgv<Plug>(asterisk-gz*)<Plug>(anzu-update-search-status-with-echo)
  else
    nmap *       <Plug>(_ClipCword)<Plug>(asterisk-z*)<Plug>(_ModSearchHistory)
    omap *  <Esc><Plug>(_ClipCword)<Plug>(asterisk-z*)<Plug>(_ModSearchHistory)
    xmap *              <Esc>gvyvgv<Plug>(asterisk-z*)

    nmap g*      <Plug>(_ClipCword)<Plug>(asterisk-gz*)
    omap g* <Esc><Plug>(_ClipCword)<Plug>(asterisk-gz*)
    xmap g*             <Esc>gvyvgv<Plug>(asterisk-gz*)
  endif

endif "}}}

" 何番目の検索対象か／検索対象の総数を表示(vim-anzu) {{{
if neobundle#tap('vim-anzu')

  " " 検索対象横にechoする。視線移動は減るが結構見づらくなるので慣れが必要
  " nmap n <Plug>(anzu-mode-n)
  " nmap N <Plug>(anzu-mode-N)
  "
  " " 検索開始時にジャンプせず, その場でanzu-modeに移行する
  " nmap <expr>* ':<C-u>call anzu#mode#start('<C-R><C-W>', '', '', '')<CR>'

  " コマンド結果出力画面にecho
  nmap n <Plug>(anzu-n-with-echo)
  nmap N <Plug>(anzu-N-with-echo)

endif "}}}

" VCSの差分をVimのsignで表示(vim-signify) {{{
if neobundle#tap('vim-signify')

  let g:signify_vcs_list = ['git', 'cvs']
  let g:signify_disable_by_default = 1
  let g:signify_update_on_bufenter = 0
  let g:signify_update_on_focusgained = 1

  " Lazy状態からSignifyToggleすると一発目がオフ扱いになるようなので2連発
  command! -nargs=0 -bar SignifyStart
        \ | SignifyToggle
        \ | SignifyToggle
        \ | delcommand SignifyStart

  function! neobundle#hooks.on_post_source(bundle)
    nmap ]c <Plug>(signify-next-hunk)zz
    nmap [c <Plug>(signify-prev-hunk)zz

    " 使わないコマンドを削除する
    delcommand SignifyDebug
    delcommand SignifyDebugDiff
    delcommand SignifyDebugUnknown
    delcommand SignifyFold
    delcommand SignifyRefresh

  endfunction

endif "}}}

" VimからGitを使う(編集, コマンド実行, vim-fugitive) {{{
if neobundle#tap('vim-fugitive')

  autocmd MyAutoCmd FileType gitcommit setlocal nofoldenable

endif "}}}

" VimからGitを使う(ブランチ管理, vim-merginal) {{{
if neobundle#tap('vim-merginal')

endif "}}}

" VimからGitを使う(コミットツリー表示, 管理, agit.vim) {{{
if neobundle#tap('agit.vim')

  function! s:AgitSettings()
    nmap <buffer> ch <Plug>(agit-git-cherry-pick)
    nmap <buffer> Rv <Plug>(agit-git-revert)

    " Disable yankround.vim
    nnoremap <buffer> <C-n> <Nop>
    nnoremap <buffer> <C-p> <Nop>

  endfunction
  autocmd MyAutoCmd FileType agit          call s:AgitSettings()
  autocmd MyAutoCmd FileType agit_diff setlocal nofoldenable

endif "}}}

" VimからGitを使う(編集, コマンド実行, vim-gita) {{{
if neobundle#tap('vim-gita')

endif "}}}

" My favorite colorscheme(vim-tomorrow-theme) {{{
if neobundle#tap('vim-tomorrow-theme')

  " 現在のカーソル位置をわかりやすくする
  autocmd MyAutoCmd ColorScheme * highlight Cursor guifg=White guibg=Red

  " 検索中にフォーカス位置をわかりやすくする
  autocmd MyAutoCmd ColorScheme * highlight IncSearch
        \ term=NONE cterm=NONE gui=NONE guifg=#1d1f21 guibg=#f0c674

  colorscheme Tomorrow-Night

endif "}}}

" カッコいいステータスラインを使う(lightline.vim) {{{
if neobundle#tap('lightline.vim')

  let g:lightline = {}

  if neobundle#tap('lightline-hybrid.vim')
    let g:lightline.colorscheme = 'hybrid'
  endif

  let g:lightline.mode_map     = {
        \   'c' :
        \     'NORMAL'
        \ }
  let g:lightline.separator    = {
        \   'left'  : "\u2B80",
        \   'right' : "\u2B82",
        \ }
  let g:lightline.subseparator = {
        \   'left'  : "\u2B81",
        \   'right' : "\u2B83",
        \ }
  let g:lightline.tabline = {
        \   'left'  : [
        \     ['tabs'],
        \   ],
        \   'right' : [
        \   ],
        \ }

  let g:lightline.active = {
        \   'left'  : [
        \     ['mode'],
        \     ['skk-mode', 'fugitive', 'filename', 'currentfunc'],
        \   ],
        \   'right' : [
        \     ['lineinfo'],
        \     ['percent'],
        \     ['fileformat', 'fileencoding', 'filetype'],
        \   ],
        \ }

  " for using git properly
  " \           ['skk-mode', 'gita-branch', 'filename', 'currenttag'],

  let g:lightline.component_function = {
        \   'modified'     : 'MyModified',
        \   'readonly'     : 'MyReadonly',
        \   'filename'     : 'MyFilename',
        \   'fileformat'   : 'MyFileformat',
        \   'filetype'     : 'MyFiletype',
        \   'fileencoding' : 'MyFileencoding',
        \   'mode'         : 'MyMode',
        \   'skk-mode'     : 'MySKKMode',
        \   'fugitive'     : 'MyFugitive',
        \   'currentfunc'  : 'MyCurrentFunc',
        \ }

  " for using git properly
  " \   'gita-branch'  : 'MyGitaBranch',

  function! MyModified()
    return &ft =~ 'help\|vimfiler\' ? ''          :
          \             &modified   ? "\<Space>+" :
          \             &modifiable ? ''          : "\<Space>-"
  endfunction

  function! MyReadonly()
    return &ft !~? 'help\|vimfiler\' && &readonly ? "\<Space>\u2B64" : ''
  endfunction

  function! MyFilename()
    " 以下の条件を満たすと処理負荷が急激に上がる。理由は不明
    " ・Vimのカレントディレクトリがネットワーク上
    " ・ネットワーク上のファイルを開いており, ファイル名をフルパス(%:p)出力
    " -> GVIMウィンドウ上部にフルパスが表示されているので, そちらを参照する
    return (&ft == 'unite'       ? ''            :
          \ &ft == 'vimfiler'    ? ''            :
          \  '' != expand('%:t') ? expand('%:t') : '[No Name]') .
          \ ('' != MyReadonly()  ? MyReadonly()  : ''         ) .
          \ ('' != MyModified()  ? MyModified()  : ''         )
  endfunction

  function! MyFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
  endfunction

  function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
  endfunction

  function! MyFileencoding()
    return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
  endfunction

  function! MyMode()
    return winwidth(0) > 30 ? lightline#mode() : ''
  endfunction

  function! MySKKMode()
    if !neobundle#is_sourced('eskk.vim') || !neobundle#is_sourced('neocomplete.vim')
      return ''
    endif
    let l:CurrentMode = eskk#statusline()

    " 初回の処理
    if !exists('b:LastMode')
      let b:LastMode = ''
    endif

    " モードが変更されていなければ何もしない
    if l:CurrentMode == b:LastMode
      return winwidth(0) > 30 ? l:CurrentMode : ''
    endif

    " normal -> skk
    if b:LastMode == ''
      " 必要ならunlock
      if neocomplete#get_current_neocomplete().lock == 1
        NeoCompleteUnlock
      else
        let b:IsAlreadyUnlocked = 1
      endif

    " skk -> normal
    else
      " 必要ならlock
      if !exists('b:IsAlreadyUnlocked')
        NeoCompleteLock
      else
        unlet b:IsAlreadyUnlocked
      endif

    endif

    " 直前のモード情報を更新
    let b:LastMode = l:CurrentMode

    return winwidth(0) > 30 ? l:CurrentMode : ''
  endfunction

  function! MyCurrentFunc()
    if &ft == 'vim'
      return winwidth(0) > 100 ? g:currentFold : ''
    else
      return winwidth(0) > 100 ? g:currentFunc : ''
    endif
  endfunction

  function! MyFugitive()
    if !neobundle#tap('vim-fugitive') || &ft == 'vimfiler'
      return ''
    endif
    let l:_ = fugitive#head()
    return winwidth(0) > 30 ? (strlen(l:_) ? '⭠ ' . l:_ : '') : ''
  endfunction

  function! MyGitaBranch()
    if !neobundle#tap('vim-gita') || &ft == 'vimfiler'
      return ''
    endif
    return winwidth(0) > 30 ? gita#statusline#preset('branch_fancy') : ''
  endfunction

endif "}}}

" pからの<C-n>,<C-p>でクリップボード履歴をぐるぐる(yankround.vim) {{{
if neobundle#tap('yankround.vim')

  let g:yankround_dir = '~/.cache/yankround'
  let g:yankround_use_region_hl = 1
  let g:yankround_region_hl_groupname = 'Search'

  nmap p     <Plug>(yankround-p)
  xmap p     <Plug>(yankround-p)
  nmap P     <Plug>(yankround-P)
  nmap gp    <Plug>(yankround-gp)
  xmap gp    <Plug>(yankround-gp)
  nmap gP    <Plug>(yankround-gP)
  nmap <C-n> <Plug>(yankround-next)
  nmap <C-p> <Plug>(yankround-prev)

endif "}}}

" テキスト整形を簡易化(vim-easy-align) {{{
if neobundle#tap('vim-easy-align')

  xnoremap <silent> <CR> :EasyAlign<CR>

endif "}}}

" 文末の空白削除を簡易化(vim-trailing-whitespace) {{{
if neobundle#tap('vim-trailing-whitespace')

endif "}}}

" カレントバッファ以外をbdelete(BufOnly.vim) {{{
if neobundle#tap('BufOnly.vim')

  function! neobundle#hooks.on_post_source(bundle)
    " 使わないコマンドを削除する
    delcommand Bufonly
    delcommand BOnly
    delcommand Bonly

  endfunction
endif "}}}

" f検索を便利に(vim-shot-f) {{{
if neobundle#tap('vim-shot-f')

  " for Lazy
  let g:shot_f_no_default_key_mappings = 1
  nmap f <Plug>(shot-f-f)
  nmap F <Plug>(shot-f-F)
  nmap t <Plug>(shot-f-t)
  nmap T <Plug>(shot-f-T)
  xmap f <Plug>(shot-f-f)
  xmap F <Plug>(shot-f-F)
  xmap t <Plug>(shot-f-t)
  xmap T <Plug>(shot-f-T)
  omap f <Plug>(shot-f-f)
  omap F <Plug>(shot-f-F)
  omap t <Plug>(shot-f-t)
  omap T <Plug>(shot-f-T)

endif "}}}

" f検索の2文字版(vim-sneak) {{{
if neobundle#tap('vim-sneak')

  " clever-s
  let g:sneak#s_next = 1

  " smartcase
  let g:sneak#use_ic_scs = 1

  " for Lazy
  nmap s <Plug>Sneak_s
  nmap S <Plug>Sneak_S
  xmap s <Plug>Sneak_s
  xmap S <Plug>Sneak_S
  omap s <Plug>Sneak_s
  omap S <Plug>Sneak_S

endif "}}}

" コメントアウト/コメントアウト解除を簡単に(caw.vim) {{{
if neobundle#tap('caw.vim')

  nmap co <Plug>(caw:i:toggle)
  xmap co <Plug>(caw:i:toggle)

endif "}}}

" Vimのマーク機能を使いやすく(vim-signature) {{{
if neobundle#tap('vim-signature')

  " " お試しとして, グローバルマークだけ使うようにしてみる
  " " -> viminfoに直接書き込まれるためか, 消しても反映されないことが多々
  " let g:SignatureIncludeMarks = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

  " _viminfoファイルからグローバルマークの削除を行う
  " -> Unix系だと「~/.viminfo」, Windowsだと「~/_viminfo」を対象とする
  " -> Windowsでは_viminfoが書き込み禁止になり削除失敗するので無効化する
  let g:SignatureForceRemoveGlobal = 0

  " これだけあれば十分
  " mm       : ToggleMarkAtLine
  " m<Space> : PurgeMarks
  nmap     mm m.

  function! neobundle#hooks.on_post_source(bundle)
    " 使わないコマンドを削除する
    delcommand SignatureToggleSigns
    delcommand SignatureRefresh
    delcommand SignatureListMarks
    delcommand SignatureListMarkers

  endfunction

endif "}}}

" Vimにスタート画面を用意(vim-startify) {{{
if neobundle#tap('vim-startify')

  let g:startify_files_number = 2
  let g:startify_change_to_dir = 1
  let g:startify_session_dir = '~/vimfiles/session'
  let g:startify_session_delete_buffers = 1

  " ブックマークの設定はローカル設定ファイルに記述する
  " see: ~/localfiles/local.rc.vim
  " let g:startify_bookmarks = [
  "   \   '.',
  "   \   '~\.vimrc',
  "   \ ]

  let g:startify_list_order = [
        \   ['My bookmarks:'       ], 'bookmarks',
        \   ['My sessions:'        ], 'sessions',
        \   ['Recently used files:'], 'files',
        \ ]

  nnoremap ,, :<C-u>Startify<CR>

  function! neobundle#hooks.on_post_source(bundle)
    " 使わないコマンドを削除する
    delcommand StartifyDebug
    delcommand SClose

  endfunction

endif "}}}

" 対応するキーワードを増やす(matchit) {{{
if neobundle#tap('matchit')

endif "}}}

" VimからLingrを見る(J6uil.vim) {{{
if neobundle#tap('J6uil.vim')

  let g:J6uil_config_dir = expand('~/.cache/J6uil')

endif "}}}

" VimからTwitterを見る(TweetVim) {{{
if neobundle#tap('TweetVim')

  let g:tweetvim_config_dir = expand('~/.cache/TweetVim')

  function! s:TweetVimSettings()
    nnoremap <buffer> <C-CR>     :<C-u>TweetVimSay<CR>
    nmap     <buffer> <Leader>rt <Plug>(tweetvim_action_retweet)
  endfunction
  autocmd MyAutoCmd FileType tweetvim call s:TweetVimSettings()

endif "}}}

" vimdiffに別のDiffアルゴリズムを適用する(vim-unified-diff) {{{
if neobundle#tap('vim-unified-diff')

endif "}}}

" vimdiffをパワーアップする(vim-improve-diff) {{{
if neobundle#tap('vim-improve-diff')

endif "}}}

" Vimでskkする(eskk.vim) {{{
if neobundle#tap('eskk.vim')

  if has('vim_starting') && has('kaoriya')
    set imdisable
  endif

  if neobundle#tap('skk.vim')
    " disable skk.vim
    " -> Helpを見るためにskk.vim自体は入れておきたい
    let g:plugin_skk_disable = 1

  endif

  let g:eskk#directory = '~/.cache/eskk'
  let g:eskk#dictionary = {
        \   'path'    : '~/dotfiles/.skk-jisyo',
        \   'sorted'  : 0,
        \   'encoding': 'utf-8',
        \ }
  if filereadable(expand('~/vimfiles/dict/SKK-JISYO.L'))
    let g:eskk#large_dictionary = {
          \   'path'    : '~/vimfiles/dict/SKK-JISYO.L',
          \   'sorted'  : 1,
          \   'encoding': 'euc-jp',
          \ }
  endif

  let g:eskk#show_annotation = 1
  let g:eskk#tab_select_completion = 1
  let g:eskk#start_completion_length = 2

  " see : http://tyru.hatenablog.com/entry/20101214/vim_de_skk
  let g:eskk#egg_like_newline = 1
  let g:eskk#egg_like_newline_completion = 1
  let g:eskk#rom_input_style = 'msime'

  " for Lazy
  imap <C-j> <Plug>(eskk:toggle)

  " すぐにskkしたい
  " Vimで<C-i>は<Tab>と同義かつjumplist進むなので潰せない
  " nmap <C-i> i<Plug>(eskk:toggle)
  " nmap <C-j> i<Plug>(eskk:toggle)
  nmap <C-j> i<Plug>(eskk:toggle)

  " インクリメントは潰せない
  " nmap <C-a> a<Plug>(eskk:toggle)
  nmap <A-j> a<Plug>(eskk:toggle)

  " もっとすぐにskkしたい
  nmap <A-i> I<Plug>(eskk:toggle)
  nmap <A-a> A<Plug>(eskk:toggle)

  " <C-o>はjumplist戻るなので潰せない。Oは我慢
  " nmap <C-o> o<Plug>(eskk:toggle)
  nmap <A-o> o<Plug>(eskk:toggle)

  " もっともっとすぐにskkしたい
  nmap <A-c>  C<Plug>(eskk:toggle)
  nmap <C-s> cl<Plug>(eskk:toggle)
  nmap <A-s> ^C<Plug>(eskk:toggle)

  autocmd MyAutoCmd User eskk-initialize-pre call s:eskk_initial_pre()
  function! s:eskk_initial_pre()
    let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
    " hankaku -> zenkaku
    call t.add_map('~',  '～')

    " special
    call t.add_map('z~', '~')
    call t.add_map('z:', ': ')
    call t.add_map('z,', ', ')
    call t.add_map('z.', '.')

    call eskk#register_mode_table('hira', t)
  endfunction

  " skk-jisyoをソートしたい
  if filereadable(expand('~/dotfiles/.skk-jisyo'))
    function! s:SortSKKDictionary()
      let l:savedView = winsaveview()
      execute "keepjumps normal! 0ggjv/okuri\<CR>k:sort\<CR>v\<Esc>"
      execute "keepjumps normal! /okuri\<CR>0jvG:sort\<CR>"
      call winrestview(l:savedView)
      echo 'ソートしました!!'
    endfunction

    function! s:SKKDictionarySettings()
      command! -nargs=0 -buffer SortSKKDictionary call s:SortSKKDictionary()
    endfunction
    autocmd MyAutoCmd FileType skkdict call s:SKKDictionarySettings()
  endif

endif "}}}

" スクラッチバッファ(scratch.vim) {{{
if neobundle#tap('scratch.vim')

  let g:scratch_autohide = 0
  let g:scratch_insert_autohide = 0
  let g:scratch_filetype = 'scratch'
  let g:scratch_height = 10

  " for Lazy
  let g:scratch_no_mappings = 1
  nmap gs <Plug>(scratch-insert-reuse)
  nmap gS <Plug>(scratch-insert-clear)
  xmap gs <Plug>(scratch-selection-reuse)
  xmap gS <Plug>(scratch-selection-clear)

  function! s:ScratchVimSettings()
    nnoremap <buffer> <Esc> <C-w>j
  endfunction
  autocmd MyAutoCmd FileType scratch call s:ScratchVimSettings()

  function! neobundle#hooks.on_post_source(bundle)
    " 使わないコマンドを削除する
    delcommand Scratch
    delcommand ScratchInsert
    delcommand ScratchSelection

  endfunction

endif "}}}

"}}}
"-----------------------------------------------------------------------------

