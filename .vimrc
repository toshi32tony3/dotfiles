" vimrc for GVim by Kaoriya

"-----------------------------------------------------------------------------
" Basic {{{

" Do first!
" http://rbtnn.hateblo.jp/entry/2014/11/30/174749
set encoding=utf-8
scriptencoding utf-8

" 左手で<Leader>を入力したい
let g:mapleader = "\<S-Space>"
nnoremap <Leader>         <Nop>
nnoremap <Leader><Leader> <Nop>

" vimrc内全体で使うaugroupを定義
augroup MyAutoCmd
  autocmd!
augroup END

" SID取得関数を定義
function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\d_')
endfunction

" Vim起動時間を計測
" -> あくまで目安なので注意。実際のVimの起動時間は(表示値+0.5秒程度)になる
" -> gvim --startuptime startuptime.txt
if has('vim_starting') && has('reltime')
  let s:startuptime = reltime()
  autocmd MyAutoCmd VimEnter *
        \   let s:startuptime = reltime(s:startuptime)
        \ | redraw
        \ | echomsg 'startuptime: ' . reltimestr(s:startuptime)
endif

" ファイル書き込み時の文字コード。空の場合, encodingの値が使用される
" -> vimrcで設定するものではない
" set fileencoding=

" ファイル読み込み時の変換候補
" -> 左から順に判定するので2byte文字が無いファイルだと最初の候補が選択される？
"    utf-8以外を左側に持ってきた時にうまく判定できないことがあったので要検証
" -> とりあえずKaoriya版GVimのguessを使おう
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

" ファイルの書き込みをしてバックアップが作られるときの設定(作らないけども)
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

" コマンドと検索の履歴は50もあれば十分すぎる
set history=50

" 編集中のファイルがVimの外部で変更された時, 自動的に読み直す
set autoread

" メッセージ省略設定
set shortmess=aoOotTWI

" カーソル上下に表示する最小の行数
" -> 大きい値にするとカーソル移動時に必ず再描画されるようになる
" -> コードを読む時は大きく, 編集する時は小さくすると良いかも
if has('vim_starting')
  set scrolloff=100
endif
let s:scrolloffOn = 1
function! s:ToggleScrollOffSet() "{{{
  if s:scrolloffOn == 1
    setlocal scrolloff=0   scrolloff?
    let s:scrolloffOn = 0
  else
    setlocal scrolloff=100 scrolloff?
    let s:scrolloffOn = 1
  endif
endfunction "}}}
command! ToggleScrollOffSet call s:ToggleScrollOffSet()
nnoremap <silent> <F2> :<C-u>ToggleScrollOffSet<CR>

" vimdiff用オプション
" filler   : 埋め合わせ行を表示する
" vertical : 縦分割する
set diffopt=filler,vertical

"}}}
"-----------------------------------------------------------------------------
" Plugin List {{{

" filetype関連のファイルはruntimepathの登録が終わってから読み込むため, 一旦オフ
filetype plugin indent off

" 実は必要のないset nocompatible
" http://rbtnn.hateblo.jp/entry/2014/11/30/174749
if has('vim_starting')
  if &compatible
    " Vi互換モードをオフ(Vimの拡張機能を有効化)
    set nocompatible
  endif

  " neobundle.vimでプラグインを管理する
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" contains filetype off
call neobundle#begin(expand('~/.vim/bundle'))

" NeoBundle自体の更新をチェックする
NeoBundleFetch 'Shougo/neobundle.vim'

" 日本語ヘルプを卒業したいが, なかなかできない
NeoBundleLazy 'vim-jp/vimdoc-ja'
set helplang=ja

" ヴィむぷろしー
NeoBundle 'Shougo/vimproc.vim', {
      \   'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'mac'     : 'make -f make_mac.mak',
      \     'unix'    : 'make -f make_unix.mak',
      \   },
      \ }

"-------------------------------------------------------------------
" Version Control System {{{

NeoBundleLazy 'mhinz/vim-signify', {
      \   'on_cmd' : 'SignifyStart',
      \ }

NeoBundle 'tpope/vim-fugitive'
NeoBundle 'idanarye/vim-merginal', {
      \   'depends' : 'tpope/vim-fugitive',
      \ }
NeoBundleLazy 'cohama/agit.vim', {
      \   'on_cmd' : 'Agit',
      \ }
NeoBundleLazy 'lambdalisue/vim-gita', {
      \   'on_cmd' : 'Gita',
      \ }

"}}}
"-------------------------------------------------------------------
" completion {{{

NeoBundleLazy 'Shougo/neocomplete.vim', {
      \   'depends' : [
      \     'Shougo/neosnippet.vim',
      \     'toshi32tony3/neosnippet-snippets',
      \   ],
      \   'on_i' : 1,
      \ }
NeoBundleLazy 'Shougo/neosnippet.vim', {
      \   'on_i' : 1,
      \ }
NeoBundleLazy 'toshi32tony3/neosnippet-snippets', {
      \   'depends' : 'Shougo/neosnippet.vim',
      \ }
NeoBundleLazy 'tyru/skk.vim'
NeoBundleLazy 'tyru/eskk.vim', {
      \   'depends' : 'Shougo/neocomplete.vim',
      \   'on_map'  : [['ni', '<Plug>']],
      \   'on_ft'   : 'skkdict',
      \ }

NeoBundleLazy 'thinca/vim-ambicmd'

"}}}
"-------------------------------------------------------------------
" view {{{

NeoBundle 'chriskempson/vim-tomorrow-theme'

NeoBundle 'cocopon/lightline-hybrid.vim'
NeoBundle 'itchyny/lightline.vim'

NeoBundleLazy 'thinca/vim-fontzoom', {
      \   'on_map' : '<Plug>',
      \   'on_cmd' : 'Fontzoom',
      \ }

"}}}
"-------------------------------------------------------------------
" move {{{

" 本家 : 'haya14busa/incsearch.vim'
NeoBundleLazy 'toshi32tony3/incsearch.vim', {
      \   'rev'    : 'add_stay_backward',
      \   'on_map' : '<Plug>',
      \ }
" 本家 : 'haya14busa/incsearch-fuzzy.vim'
NeoBundleLazy 'toshi32tony3/incsearch-fuzzy.vim', {
      \   'rev'     : 'add_stay_backward',
      \   'depends' : 'toshi32tony3/incsearch.vim',
      \   'on_map'  : '<Plug>',
      \ }

NeoBundleLazy 'osyo-manga/vim-anzu', {
      \   'on_map' : '<Plug>',
      \ }
NeoBundleLazy 'haya14busa/vim-asterisk', {
      \   'on_map' : '<Plug>',
      \ }

" 本家 : 'deris/vim-shot-f'
NeoBundleLazy 'toshi32tony3/vim-shot-f', {
      \   'on_map' : '<Plug>',
      \ }
NeoBundleLazy 'justinmk/vim-sneak', {
      \   'on_map' : '<Plug>Sneak_',
      \ }

NeoBundle 'kshenoy/vim-signature'

NeoBundle 'tmhedberg/matchit'

"}}}
"-------------------------------------------------------------------
" text-objects {{{

NeoBundleLazy 'kana/vim-textobj-user'

NeoBundleLazy 'kana/vim-textobj-function', {
      \   'depends' : 'kana/vim-textobj-user',
      \   'on_map'  : [['xo', 'if', 'af', 'iF', 'aF']],
      \ }
NeoBundleLazy 'sgur/vim-textobj-parameter', {
      \   'depends' : 'kana/vim-textobj-user',
      \   'on_map'  : [['xo', 'i,', 'a,']],
      \ }

"}}}
"-------------------------------------------------------------------
" operator {{{

NeoBundleLazy 'kana/vim-operator-user'

NeoBundleLazy 'kana/vim-operator-replace', {
      \   'depends' : 'kana/vim-operator-user',
      \   'on_map'  : [['nx', '<Plug>']],
      \ }
" 本家 : 'osyo-manga/vim-operator-search'
NeoBundleLazy 'toshi32tony3/vim-operator-search', {
      \   'rev'     : 'operator_for_line',
      \   'depends' : 'kana/vim-operator-user',
      \   'on_map'  : [['nx', '<Plug>']],
      \ }
NeoBundleLazy 't9md/vim-quickhl', {
      \   'depends' : 'kana/vim-operator-user',
      \   'on_map'  : [['nx', '<Plug>(operator-quickhl-', '<Plug>(quickhl-']],
      \ }
NeoBundleLazy 'tyru/caw.vim', {
      \   'depends' : 'kana/vim-operator-user',
      \   'on_map'  : [['nx', '<Plug>(operator-caw)']],
      \ }

NeoBundle 'tpope/vim-surround'

"}}}
"-------------------------------------------------------------------
" vimdiff {{{

NeoBundle 'lambdalisue/vim-unified-diff'

"}}}
"-------------------------------------------------------------------
" interface {{{

NeoBundle 'mhinz/vim-startify'

NeoBundleLazy 'Shougo/unite.vim', {
      \   'on_cmd' : 'Unite',
      \ }
NeoBundleLazy 'Shougo/neomru.vim', {
      \   'depends'  : 'Shougo/unite.vim',
      \   'on_unite' : ['file_mru', 'directory_mru'],
      \ }
NeoBundleLazy 'hewes/unite-gtags', {
      \   'depends'  : 'Shougo/unite.vim',
      \   'on_unite' : ['gtags/ref', 'gtags/def'],
      \ }
NeoBundleLazy 'tacroe/unite-mark', {
      \   'depends'  : 'Shougo/unite.vim',
      \   'on_unite' : 'mark',
      \ }
NeoBundleLazy 'Shougo/unite-outline', {
      \   'depends'  : 'Shougo/unite.vim',
      \   'on_unite' : 'outline',
      \ }

NeoBundleLazy 'Shougo/vimfiler.vim', {
      \   'depends'  : 'Shougo/unite.vim',
      \   'on_cmd'   : 'VimFilerCurrentDir',
      \   'explorer' : 1,
      \ }

"}}}
"-------------------------------------------------------------------
" quickfix / special buffer {{{

NeoBundleLazy 'thinca/vim-qfreplace', {
      \   'on_cmd' : 'Qfreplace',
      \ }

NeoBundleLazy 'mtth/scratch.vim', {
      \   'on_map' : '<Plug>',
      \ }

" 本家 : 'koron/dicwin-vim'
NeoBundleLazy 'toshi32tony3/dicwin-vim', {
      \   'on_map' : [['ni', '<Plug>']],
      \ }

NeoBundleLazy 'tyru/capture.vim', {
      \   'on_cmd' : 'Capture',
      \ }

"}}}
"-------------------------------------------------------------------
" web / markdown {{{

NeoBundleLazy 'tyru/open-browser.vim', {
      \   'on_map' : '<Plug>(openbrowser-',
      \ }

NeoBundleLazy 'basyura/twibill.vim'
NeoBundleLazy 'basyura/TweetVim', {
      \   'depends' : ['basyura/twibill.vim',  'tyru/open-browser.vim'],
      \   'on_cmd'  : ['TweetVimHomeTimeline', 'TweetVimSearch'],
      \ }
NeoBundleLazy 'basyura/J6uil.vim', {
      \   'on_cmd' : 'J6uil',
      \ }

" 本家 : 'kannokanno/previm'
NeoBundleLazy 'beckorz/previm', {
      \   'on_ft' : 'markdown',
      \ }

" NeoBundleLazy 'kurocode25/mdforvim', {
"       \   'on_cmd' : ['MdPreview', 'MdConvert'],
"       \ }

" 本家 : 'plasticboy/vim-markdown'
NeoBundleLazy 'rcmdnk/vim-markdown', {
      \   'on_ft' : 'markdown',
      \ }
NeoBundleLazy 'glidenote/memolist.vim', {
      \   'on_cmd' : 'MemoNew',
      \ }

"}}}
"-------------------------------------------------------------------
" formatter {{{

" 本家 : 'bronson/vim-trailing-whitespace'
NeoBundle 'toshi32tony3/vim-trailing-whitespace'

NeoBundleLazy 'junegunn/vim-easy-align', {
      \   'on_cmd' : 'EasyAlign',
      \ }

"}}}
"-------------------------------------------------------------------
" quickrun {{{

NeoBundleLazy 'thinca/vim-quickrun', {
      \   'on_cmd' : 'QuickRun',
      \ }
" 本家 : 'jceb/vim-hier'
" NeoBundle 'pocke/vim-hier'

" NeoBundle 'osyo-manga/shabadou.vim'
" NeoBundle 'osyo-manga/vim-watchdogs'

"}}}
"-------------------------------------------------------------------

call neobundle#end()

" filetype関連のファイルを読み込む
filetype plugin indent on

" シンタックスハイライトを有効化(on:現在の設定を破棄する, enable:破棄しない)
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
" Edit {{{

" タブ幅, シフト幅, タブ使用有無の設定
if has('vim_starting')
  set tabstop=2 shiftwidth=2 softtabstop=0 expandtab
endif
autocmd MyAutoCmd FileType c        setlocal tabstop=4 shiftwidth=4
autocmd MyAutoCmd FileType cpp      setlocal tabstop=4 shiftwidth=4
autocmd MyAutoCmd FileType makefile setlocal tabstop=4 shiftwidth=4 noexpandtab

set nrformats=hex              " <C-a>や<C-x>の対象を10進数,16進数に絞る
set virtualedit=all            " テキストが存在しない場所でも動けるようにする
set nostartofline              " カーソルが勝手に行の先頭へ行かないようにする
set hidden                     " quit時はバッファを削除せず, 隠す
set confirm                    " 変更されたバッファがある時, どうするか確認する
set switchbuf=useopen          " すでに開いてあるバッファがあればそっちを開く
set showmatch                  " 対応する括弧などの入力時にハイライト表示する
set matchtime=3                " 対応括弧入力時カーソルが飛ぶ時間を0.3秒にする
set matchpairs=(:),{:},[:],<:> " 対応括弧に'<'と'>'のペアを追加
set backspace=indent,eol,start " <BS>でなんでも消せるようにする

" 汎用補完設定(complete)
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

" 補完オプション(completeopt)
" menuone : 対象が一つでもポップアップを表示
" longest : 候補の共通部分だけを挿入
set completeopt=menuone,longest

set noinfercase  " 補完時に大文字小文字を区別しない
set pumheight=10 " 補完候補は一度に10個まで表示

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
" B : 行連結時に, マルチバイト文字の前後に空白を挿入しない
" M : 行連結時に, マルチバイト文字同士の間に空白を挿入しない
autocmd MyAutoCmd BufEnter * setlocal formatoptions=jlmqBM

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

" クリップボードレジスタを使う
set clipboard=unnamed

" 現在開いているファイルのパスなどを選択範囲レジスタ(*)に入れる
" https://gist.github.com/pinzolo/8168337
function! s:Clip(data) "{{{
  let @* = a:data
  echo 'clipped: ' . a:data
endfunction "}}}

" 現在開いているファイルのフルパス(ファイル名含む)をレジスタへ
command! ClipPath call s:Clip(expand('%:p'))

" 現在開いているファイルのファイル名をレジスタへ
command! ClipFile call s:Clip(expand('%:t'))

" 現在開いているファイルのディレクトリパスをレジスタへ
command! ClipDir  call s:Clip(expand('%:p:h'))

" コマンドの出力結果を選択範囲レジスタ(*)に入れる
function! s:ClipCommandOutput(cmd) "{{{
  redir @*>
  silent execute a:cmd
  redir END
endfunction "}}}
command! -nargs=1 -complete=command ClipCommandOutput call s:ClipCommandOutput(<f-args>)

"}}}
"-----------------------------------------------------------------------------
" View {{{

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
  if has('kaoriya')
    set guioptions=Mc
  endif

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
  set number         " 行番号を表示
  set relativenumber " 行番号を相対表示
endif
nnoremap <silent> <F10> :<C-u>set relativenumber!<Space>relativenumber?<CR>

" 不可視文字を可視化
set list

" 不可視文字の設定(UTF-8特有の文字は使わない方が良い)
set listchars=tab:>-,trail:-,eol:\

if has('kaoriya')

  " 透明度をスイッチ
  let s:transparencyOn = 0
  function! s:ToggleTransParency() "{{{
    if s:transparencyOn == 1
      set transparency=255 transparency?
      let s:transparencyOn = 0
    else
      set transparency=220 transparency?
      let s:transparencyOn = 1
    endif
  endfunction "}}}
  command! ToggleTransParency call s:ToggleTransParency()
  nnoremap <silent> <F12> :<C-u>ToggleTransParency<CR>

endif

" 折り畳み機能の設定
set foldcolumn=1
set foldnestmax=1
set fillchars=vert:\|

" ファイルを開いた時点では折り畳みを全て閉じた状態で開く
set foldlevelstart=0

set foldmethod=marker
if has('vim_starting')
  set commentstring=%s
endif
autocmd MyAutoCmd FileType vim setlocal commentstring=\ \"%s

" 折りたたみ機能をON/OFF
nnoremap <silent> <F9> :<C-u>set foldenable! foldenable?<CR>

" Hack #120: GVim でウィンドウの位置とサイズを記憶する
" http://vim-jp.org/vim-users-jp/2010/01/28/Hack-120.html
let s:saveWinposFile = expand('~/vimfiles/winpos/.vimwinpos')
if filereadable(s:saveWinposFile)
  autocmd MyAutoCmd VimLeavePre * call s:SaveWindow()
  function! s:SaveWindow() "{{{
    let s:options = [
          \   'set columns=' . &columns,
          \   'set lines='   . &lines,
          \   'winpos ' . getwinposx() . ' ' . getwinposy(),
          \ ]
    call writefile(s:options, s:saveWinposFile)
  endfunction "}}}
  execute 'source ' s:saveWinposFile
endif

"}}}
"-----------------------------------------------------------------------------
" Search {{{

" very magic
nnoremap / /\v

set ignorecase " 検索時に大文字小文字を区別しない。区別したい時は\Cを付ける
set smartcase  " 大文字小文字の両方が含まれている場合は, 区別する
set wrapscan   " 検索時に最後まで行ったら最初に戻る
set incsearch  " インクリメンタルサーチ
set hlsearch   " マッチしたテキストをハイライト

" grep/vimgrep結果が0件の場合, Quickfixを開かない
autocmd MyAutoCmd QuickfixCmdPost grep,vimgrep
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
" Simplify operation {{{

" キー入力タイムアウトはあると邪魔だし, 待つ意味も無い気がする
set notimeout

" vimrcをリロード
nnoremap ,r :<C-u>source $MYVIMRC<CR>

" フォーカスがあたっているウィンドウ以外閉じる
nnoremap ,o :<C-u>only<CR>

" 閉じる系の入力を簡易化
nnoremap <C-q><C-q> :<C-u>bdelete<CR>
nnoremap <C-w><C-w> :<C-u>close<CR>

" make後, 自動でQuickfixウィンドウを開く
autocmd MyAutoCmd QuickfixCmdPost make if len(getqflist()) != 0 | copen | endif

" 最後のウィンドウのbuftypeがquickfixであれば, 自動で閉じる
" -> buftypeがnofileかつ特定のfiletypeの追加を試みたが,
"    暴発する度にfiletypeを追加することになるのでやめた
autocmd MyAutoCmd WinEnter * if (winnr('$') == 1) &&
      \ ((getbufvar(winbufnr(0), '&buftype')) == 'quickfix') | quit | endif

" 簡単にhelpを閉じる, 抜ける
function! s:HelpSettings() "{{{
  nnoremap <buffer> <F1>  :<C-u>q<CR>
  nnoremap <buffer> <Esc> <C-w>j
endfunction "}}}
autocmd MyAutoCmd FileType help call s:HelpSettings()

" 検索テキストハイライトを消す
nnoremap <silent> <Esc> :<C-u>nohlsearch<CR>

" カレントファイルをfull pathで表示(ただし$HOME以下はrelative path)
nnoremap <C-g> 1<C-g>

" j/kによる移動を折り返されたテキストでも自然に振る舞うようにする
nnoremap j gj
xnoremap j gj
nnoremap k gk
xnoremap k gk

" 現在開いているファイルのディレクトリに移動
command! LCD echo 'change directory to:' <bar> lcd %:p:h

" " 開いたファイルと同じ場所へ移動する
" " -> startify/vimfiler/:LCDで十分なのでコメントアウト
" autocmd MyAutoCmd BufEnter * execute 'lcd ' fnameescape(expand('%:p:h'))

" " 最後のカーソル位置を記憶していたらジャンプ
" " -> Gdiff時に不便なことがあったのでコメントアウト
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
nnoremap <Leader>gf :<C-u>execute 'tabfind ' . expand('<cfile>')<CR>

" 新規タブでvimdiff
" 引数が1つ     : カレントバッファと引数指定ファイルの比較
" 引数が2つ以上 : 引数指定ファイル同士の比較
" http://koturn.hatenablog.com/entry/2013/08/10/034242
function! s:TabDiff(...) "{{{
  if a:0 == 1
    tabedit %:p
    execute 'rightbelow vertical diffsplit ' . a:1
  else
    execute 'tabedit ' a:1
    for l:file in a:000[1 :]
      execute 'rightbelow vertical diffsplit ' . l:file
    endfor
  endif
endfunction "}}}
command! -nargs=+ -complete=file Diff call s:TabDiff(<f-args>)

"}}}
"-----------------------------------------------------------------------------
" tags, path {{{

" 新規タブでタグジャンプ
function! s:JumpTagTab(funcName) "{{{
  tab split

  " ctagsファイルを複数生成してpath登録順で優先順位を付けているなら'tag'にする
  execute 'tag ' . a:funcName

  " " 1つの大きいctagsファイルを生成している場合はリストから選べる'tjump'にする
  " execute 'tjump ' . a:funcName

endfunction "}}}
command! -nargs=1 -complete=tag JumpTagTab call s:JumpTagTab(<f-args>)
nnoremap <Leader>} :<C-u>JumpTagTab <C-r><C-w><CR>

" ソースディレクトリの設定はローカル設定ファイルに記述する
" see: ~/localfiles/local.rc.vim
if filereadable(expand('~/localfiles/local.rc.vim'))

  function! s:SetSrcDir() "{{{
    let g:local_rc#src_dir         = g:local_rc#src_list[g:local_rc#src_index]
    let g:local_rc#current_src_dir = g:local_rc#base_dir . '\' . g:local_rc#src_dir
    let g:local_rc#ctags_dir       = g:local_rc#current_src_dir . '\.tags'
  endfunction "}}}

  function! s:SetTags() "{{{
    " tagsをセット
    set tags=
    for l:item in g:local_rc#ctags_list
      let &tags = &tags . ',' . g:local_rc#ctags_dir . '\' . g:local_rc#ctags_name_list[l:item]
    endfor

    " 1文字目の','を削除
    if &tags != '' | let &tags = &tags[1:] | endif

    " GTAGSROOTの登録
    " -> GNU GLOBALのタグはプロジェクトルートで生成する
    let $GTAGSROOT = g:local_rc#current_src_dir
  endfunction "}}}

  function! s:SetPathList() "{{{
    set path=

    " 起点なしのpath登録
    for l:item in g:local_rc#other_dir_path_list
      let &path = &path . ',' . l:item
    endfor

    " g:local_rc#current_src_dirを起点にしたpath登録
    for l:item in g:local_rc#current_src_dir_path_list
      let &path = &path . ',' . g:local_rc#current_src_dir . '\' . l:item
    endfor

    " 1文字目の','を削除
    if &path != '' | let &path = &path[1:] | endif
  endfunction "}}}

  function! s:SetCDPathList() "{{{
    set cdpath=

    " 起点なしのcdpath登録
    for l:item in g:local_rc#other_dir_cdpath_list
      let &cdpath = &cdpath . ',' . l:item
    endfor

    " g:local_rc#base_dir, g:local_rc#current_src_dirをcdpath登録
    let &cdpath = &cdpath . ',' . g:local_rc#base_dir
    let &cdpath = &cdpath . ',' . g:local_rc#current_src_dir

    " g:local_rc#current_src_dirを起点にしたcdpath登録
    for l:item in g:local_rc#current_src_dir_cdpath_list
      let &cdpath = &cdpath . ',' . g:local_rc#current_src_dir . '\' . l:item
    endfor

    " 1文字目の','を削除
    if &cdpath != '' | let &cdpath = &cdpath[1:] | endif
  endfunction "}}}

  autocmd MyAutoCmd VimEnter *
        \   call s:SetSrcDir()
        \ | call s:SetTags()
        \ | call s:SetPathList()
        \ | call s:SetCDPathList()

  " ソースコードをスイッチ
  function! s:SwitchSource() "{{{
    let g:local_rc#src_index += 1
    if  g:local_rc#src_index >= len(g:local_rc#src_list)
      let g:local_rc#src_index = 0
    endif

    call s:SetSrcDir()
    call s:SetTags()
    call s:SetPathList()
    call s:SetCDPathList()

    " ソースコード切り替え後, バージョン名を出力
    echo 'switch source to: ' . g:local_rc#src_dir

  endfunction "}}}
  command! SwitchSource call s:SwitchSource()
  nnoremap ,s :<C-u>SwitchSource<CR>

  " ctagsをアップデート
  function! s:UpdateCtags() "{{{
    if !isdirectory(g:local_rc#ctags_dir)
      call    mkdir(g:local_rc#ctags_dir)
    endif
    for l:item in g:local_rc#ctags_list
      if !has_key(g:local_rc#ctags_name_list, l:item)
        continue
      endif
      let l:updateCommand =
            \ 'ctags -f ' .
            \ g:local_rc#current_src_dir . '\.tags\' . g:local_rc#ctags_name_list[l:item] .
            \ ' -R ' .
            \ g:local_rc#current_src_dir . '\' . l:item
      call system(l:updateCommand)
    endfor
  endfunction "}}}
  command! UpdateCtags call s:UpdateCtags()

endif

"}}}
"-----------------------------------------------------------------------------
" Prevent erroneous input {{{

" レジスタ機能のキーをQにする(Exモードを使う時はgQ)
nnoremap q <Nop>
nnoremap Q q

" F3 command history (使わないが, 一応退避)
nnoremap <F3> <Esc>q:
nnoremap q:   <Nop>

" F4  search history (使わないが, 一応退避)
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

" :quitのショートカットは潰す
nnoremap <C-w><C-q> <Nop>
nnoremap <C-w>q     <Nop>

" mswin.vim有効時<C-v>がペーストに使われるため, 代替として<C-q>が用意されている
" -> そもそもmswin.vimは使わないし, 紛らわしいので潰す
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
" -> と思ったが, とりあえず潰しておいて, 一部再利用するマッピングを行う
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
nnoremap <S-Left>  :bprevious<CR>
nnoremap <S-Right> :bnext<CR>

" せっかくなので,  Ctrl + カーソルキーでcprevious/cnext
nnoremap <C-Left>  :cprevious<CR>
nnoremap <C-Right> :cnext<CR>

" せっかくなので,   Alt + カーソルキーで previous/next
nnoremap <A-Left>  :previous<CR>
nnoremap <A-Right> :next<CR>

"}}}
"-----------------------------------------------------------------------------
" Scripts {{{

" タイムスタンプの挿入
function! s:PutDateTime() "{{{
  let @" = strftime('%Y/%m/%d(%a) %H:%M')
  normal! ""P
endfunction "}}}
command! PutDateTime call s:PutDateTime()

" 区切り線+タイムスタンプの挿入
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
command! PutMemoFormat call s:PutMemoFormat()

" :messageで表示される履歴を削除
" http://d.hatena.ne.jp/osyo-manga/20130502/1367499610
command! DeleteMessage  for s:n in range(200) | echomsg '' | endfor

" :jumplistを空にする
command! DeleteJumpList for s:n in range(200) | mark '     | endfor

" キーリピート時のCursorMoved autocmdを無効にする, 行移動を検出する
" http://d.hatena.ne.jp/gnarl/20080130/1201624546
let s:throttleTimeSpan = 200
function! s:OnCursorMove() "{{{
  " normalかvisualの時のみ判定
  let     l:currentMode  = mode(1)
  if      l:currentMode !=  'n' &&
        \ l:currentMode != 'no' &&
        \ l:currentMode !=# 'v' &&
        \ l:currentMode !=# 'V' &&
        \ l:currentMode != ''
    return
  endif

  " 初回の処理
  if !exists('b:lastVisitedLine')
    let b:lastVisitedLine = line('.')
    let b:lastCursorMoveTime = 0
  endif

  " ミリ秒単位の現在時刻を取得
  let l:ml = matchlist(reltimestr(reltime()), '\v(\d*)\.(\d{3})')
  if  l:ml == []
    return
  endif
  let l:ml[0] = ''
  let l:now = str2nr(join(l:ml, ''))

  " 前回のCursorMoved発火時から指定時間経過していなければ何もせず抜ける
  let l:timespan = l:now - b:lastCursorMoveTime
  if  l:timespan <= s:throttleTimeSpan
    return
  endif

  " CursorMoved!!
  autocmd   MyAutoCmd User MyCursorMoved :
  doautocmd MyAutoCmd User MyCursorMoved

  " lastCursorMoveTimeを更新
  let b:lastCursorMoveTime = l:now

  if b:lastVisitedLine == line('.')
    return
  endif

  " LineChanged!!
  autocmd   MyAutoCmd User MyLineChanged :
  doautocmd MyAutoCmd User MyLineChanged

  " lastVisitedLineを更新
  let b:lastVisitedLine = line('.')
endfunction "}}}
autocmd MyAutoCmd CursorMoved * call s:OnCursorMove()

" 引数に渡した行のFold名を取得
" NOTE: 対応ファイルタイプ : vim/markdown
function! s:GetFoldName(line) "{{{
  if     &ft == 'vim'
    " コメント行か, 末尾コメントか判別してFold名を切り出す
    let l:startIndex = match   (a:line, '\w')
    let l:endIndex   = matchend(a:line, '\v^("\ )')
    let l:preIndex   = (l:endIndex == -1) ? l:startIndex : l:endIndex
    let l:sufIndex   = strlen(a:line) - ((l:endIndex == -1) ? 6 : 5)
    return a:line[l:preIndex : l:sufIndex]
  elseif &ft == 'markdown'
    let l:foldName = split(a:line, "\<Space>")
    return empty(l:foldName) ? '' : join(l:foldName[1:], "\<Space>")
  endif
  return ''
endfunction "}}}

" foldlevel('.')はnofoldenableの時に必ず0を返すので, foldlevelを自分で数える
" NOTE: 1行, 1Foldまでとする
" NOTE: 対応ファイルタイプ : vim/markdown
function! s:GetFoldLevel() "{{{
  " ------------------------------------------------------------
  " 小細工
  " ------------------------------------------------------------
  " foldlevelに大きめの値をセットして[z, ]zを使えるようにする
  if &foldenable == 'nofoldenable'
    setlocal foldlevel=10
  endif

  " ------------------------------------------------------------
  " 前処理
  " ------------------------------------------------------------
  let l:foldLevel         = 0
  let l:currentLineNumber = line('.')
  let l:lastLineNumber    = l:currentLineNumber

  " Viewを保存
  let l:savedView = winsaveview()

  " モーションの失敗を前提にしているのでbelloffを使う
  let l:belloffTmp = &l:belloff
  let &l:belloff   = 'error'

  " ------------------------------------------------------------
  " foldLevelをカウント
  " ------------------------------------------------------------
  if &ft == 'markdown'
    let l:pattern = '^#'

    " markdownの場合, (現在の行 - 1)にfoldmarkerが含まれていれば, foldLevel+=1
    let l:foldLevel += (match(getline((line('.') - 1)), l:pattern) >= 0) ? 1 : 0
  else
    let l:pattern = '{{{$' " for match }}}
  endif

  " 現在の行にfoldmarkerが含まれていれば, foldLevel+=1
  let l:foldLevel += (match(getline('.'), l:pattern) >= 0) ? 1 : 0

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
command! EchoFoldLevel echo s:GetFoldLevel()

" カーソル位置の親Fold名を取得
" NOTE: 対応ファイルタイプ : vim/markdown
let s:currentFold = ''
function! s:GetCurrentFold() "{{{
  if &ft != 'vim' && &ft != 'markdown'
    return ''
  endif

  " ------------------------------------------------------------
  " 前処理
  " ------------------------------------------------------------
  " foldlevel('.')はあてにならないことがあるので自作関数で求める
  let l:foldLevel = s:GetFoldLevel()
  if  l:foldLevel <= 0
    return ''
  endif

  " View/カーソル位置を保存
  let l:savedView      = winsaveview()
  let l:cursorPosition = getcurpos()

  " モーションの失敗を前提にしているのでbelloffを使う
  let l:belloffTmp = &l:belloff
  let &l:belloff   = 'error'

  " 走査回数の設定
  let l:searchCounter = l:foldLevel

  " 変数初期化
  let l:foldList = []
  let l:lastLineNumber = line('.')

  " ------------------------------------------------------------
  " カーソル位置のfoldListを取得
  " ------------------------------------------------------------
  while 1
    if l:searchCounter <= 0
      break
    endif

    " 1段階親のところへ移動
    keepjumps normal! [z
    let l:currentLineNumber = line('.')

    " 移動していなければ, 移動前のカーソル行が子Fold開始位置だったということ
    if l:lastLineNumber == l:currentLineNumber
      " カーソルを戻して子FoldをfoldListに追加
      call setpos('.', l:cursorPosition)
      let l:currentLine = (&ft == 'markdown') &&
            \             (match(getline('.'), '^#') == -1)
            \           ? getline((line('.') - 1))
            \           : getline('.')
      let l:foldName = s:GetFoldName(l:currentLine)
      if  l:foldName != ''
        call add(l:foldList, l:foldName)
      endif
    else
      let l:currentLine = (&ft == 'markdown')
            \           ? getline((line('.') - 1))
            \           : getline('.')
      " 親FoldをfoldListに追加
      let l:foldName = s:GetFoldName(l:currentLine)
      if  l:foldName != ''
        call insert(l:foldList, l:foldName, 0)
      endif
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

  " ウィンドウ幅が十分ある場合, foldListを繋いで返す
  if winwidth(0) > 120
    return join(l:foldList, " \u2B81 ")
  endif
  " ウィンドウ幅が広くない場合, 直近のFold名を返す
  return get(l:foldList, -1, '')
endfunction "}}}
command! EchoCurrentFold echo s:GetCurrentFold()
autocmd MyAutoCmd User MyLineChanged let s:currentFold = s:GetCurrentFold()
autocmd MyAutoCmd BufEnter *         let s:currentFold = s:GetCurrentFold()

" Cの関数名にジャンプ
function! s:JumpFuncNameCForward() "{{{
  if &ft != 'c'
    return
  endif

  " 現在位置をjumplistに追加
  mark '

  " Viewを保存
  let l:savedView = winsaveview()

  let l:lastLine  = line('.')
  execute "keepjumps normal! ]]"

  " 検索対象が居なければViewを戻して処理終了
  if line('.') == line('$')
    call winrestview(l:savedView)
    return
  endif

  call search('(', 'b')
  execute 'normal! b'

  " Cの関数名の上から下方向検索するには, ]]を2回使う必要がある
  if l:lastLine == line('.')
    execute 'keepjumps normal! ]]'
    execute 'keepjumps normal! ]]'

    " 検索対象が居なければViewを戻して処理終了
    if line('.') == line('$')
      call winrestview(l:savedView)
      return
    endif
    call search('(', 'b')
    execute 'normal! b'

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
    execute 'keepjumps normal! [['
    " for match } }

    " 検索対象が居なければViewを戻して処理終了
    if line('.') == 1
      call winrestview(l:savedView)
      return
    endif
  endif

  call search('(', 'b')
  execute 'normal! b'

  " 現在位置をjumplistに追加
  mark '
endfunction " }}}
command! JumpFuncNameCForward  call s:JumpFuncNameCForward()
command! JumpFuncNameCBackward call s:JumpFuncNameCBackward()
nnoremap <silent> ]f :<C-u>JumpFuncNameCForward<CR>
nnoremap <silent> [f :<C-u>JumpFuncNameCBackward<CR>

" Cの関数名取得
let s:currentFunc = ''
function! s:GetCurrentFuncC() "{{{
  if &ft != 'c'
    return ''
  endif

  " Viewを保存
  let l:savedView = winsaveview()

  " カーソルがある行の1列目の文字が { ならば [[ は不要
  if getline('.')[0] != '{' " for match } }

    " { よりも先に前方にセクション末尾 } がある場合, 関数定義の間なので検索不要
    execute 'keepjumps normal! []'
    let l:endBracketLine = line('.')
    call winrestview(l:savedView)
    execute 'keepjumps normal! [['
    if line('.') < l:endBracketLine
      call winrestview(l:savedView)
      return ''
    endif

    " 検索対象が居なければViewを戻して処理終了
    if line('.') == 1
      call winrestview(l:savedView)
      return ''
    endif
  endif

  call search('(', 'b')
  execute 'normal! b'
  let l:funcName = expand('<cword>')

  " Viewを復元
  call winrestview(l:savedView)

  return l:funcName
endfunction " }}}
autocmd MyAutoCmd User MyLineChanged
      \      if &ft == 'c' | let s:currentFunc = s:GetCurrentFuncC() | endif
autocmd MyAutoCmd BufEnter * let s:currentFunc = s:GetCurrentFuncC()

function! s:ClipCurrentFuncName(funcName) "{{{
  if strlen(a:funcName) == 0
    echo 'There is no function nearby cursor.'
    return
  endif

  " 選択範囲レジスタ(*)を使う
  let @* = a:funcName
  echo 'clipped: ' . a:funcName
endfunction "}}}
command! ClipCurrentFuncName
      \ let s:currentFunc = s:GetCurrentFuncC() |
      \ call s:ClipCurrentFuncName(s:currentFunc)

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
command! PrintCurrentFuncName
      \ let s:currentFunc = s:GetCurrentFuncC() |
      \ call s:PrintCurrentFuncName(s:currentFunc)

"}}}
"-----------------------------------------------------------------------------
" Plugin Settings {{{

" VCSの差分をVimのsignで表示(vim-signify) {{{
if neobundle#tap('vim-signify')

  let g:signify_vcs_list = ['git', 'cvs']
  let g:signify_disable_by_default = 1
  let g:signify_update_on_bufenter = 0
  let g:signify_update_on_focusgained = 1

  " Lazy状態からSignifyToggleすると一発目がオフ扱いになるようなので2連発
  " -> SignifyEnableでも2連発する必要があったので, 読み込み時の都合かも
  if has('vim_starting')
    command! -bar SignifyStart
          \ | SignifyToggle
          \ | SignifyToggle
          \ | delcommand SignifyStart
  endif

  function! neobundle#hooks.on_post_source(bundle)
    " ↑で定義しているSignifyStartを使うまでautoloadは読み込まれない。
    " そのため, on_post_sourceでマッピングする
    nmap ]c <Plug>(signify-next-hunk)zz
    nmap [c <Plug>(signify-prev-hunk)zz

    " 使わないコマンドを削除する
    delcommand SignifyEnable
    delcommand SignifyDisable
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

  function! s:AgitSettings() "{{{
    nmap <buffer> ch <Plug>(agit-git-cherry-pick)
    nmap <buffer> Rv <Plug>(agit-git-revert)

  endfunction "}}}
  autocmd MyAutoCmd FileType agit          call s:AgitSettings()
  autocmd MyAutoCmd FileType agit_diff setlocal nofoldenable

endif "}}}

" VimからGitを使う(編集, コマンド実行, vim-gita) {{{
if neobundle#tap('vim-gita')

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

  if neobundle#is_installed('neosnippet.vim')
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

  if !neobundle#is_installed('neosnippet.vim')
    inoremap <expr>   <TAB> pumvisible() ? "\<C-n>" :   "\<TAB>"
    inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
  endif

  inoremap <expr> <C-g> neocomplete#undo_completion()
  inoremap <expr> <C-l> neocomplete#complete_common_string()

  function! neobundle#hooks.on_post_source(bundle)
    " Lockされた状態からスタートしたい
    NeoCompleteLock

    " 処理順を明確にするため, neobundle#hooks.on_post_source()を
    " 使ってプラグインの読み込み完了フラグを立てることにした
    let s:IsNeoCompleteLoaded = 1
  endfunction

endif "}}}

" コードスニペットによる入力補助(neosnippet.vim) {{{
if neobundle#tap('neosnippet.vim')

  let g:neosnippet#snippets_directory =
        \ '~/.vim/bundle/neosnippet-snippets/neosnippets'

  imap     <expr>   <TAB> pumvisible() ? "\<C-n>" :
        \        neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" :
        \        "\<TAB>"
  inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
  imap <C-k> <Plug>(neosnippet_expand_or_jump)

  if neobundle#is_installed('unite.vim')
    imap <C-s> <Plug>(neosnippet_start_unite_snippet)
  endif

  " smap対策(http://d.hatena.ne.jp/thinca/20090526/1243267812)
  function! s:neosnippetSettings()
    smapclear
    smapclear <buffer>
    smap <expr> <TAB>
          \ neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" :
          \ "\<TAB>"
    smap <C-k> <Plug>(neosnippet_expand_or_jump)
  endfunction
  autocmd MyAutoCmd BufEnter * call s:neosnippetSettings()

endif "}}}

" Vimでskkする(eskk.vim) {{{
if neobundle#tap('eskk.vim')

  if has('vim_starting') && has('kaoriya')
    set imdisable
  endif

  if neobundle#is_installed('skk.vim')
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
  " <C-s>と<A-s>は他の用途で使うので潰せない
  nmap <C-c>l      cl<Plug>(eskk:toggle)
  nmap <C-c>aw    caw<Plug>(eskk:toggle)
  nmap <C-c>iw    ciw<Plug>(eskk:toggle)
  nmap <C-c>aW    caW<Plug>(eskk:toggle)
  nmap <C-c>iW    ciW<Plug>(eskk:toggle)
  nmap <C-c>as    cas<Plug>(eskk:toggle)
  nmap <C-c>is    cis<Plug>(eskk:toggle)
  nmap <C-c>ap    cap<Plug>(eskk:toggle)
  nmap <C-c>ip    cip<Plug>(eskk:toggle)
  nmap <C-c>a]    ca]<Plug>(eskk:toggle)
  nmap <C-c>a[    ca[<Plug>(eskk:toggle)
  nmap <C-c>i]    ci]<Plug>(eskk:toggle)
  nmap <C-c>i[    ci[<Plug>(eskk:toggle)
  nmap <C-c>a)    ca)<Plug>(eskk:toggle)
  nmap <C-c>a(    ca(<Plug>(eskk:toggle)
  nmap <C-c>ab    cab<Plug>(eskk:toggle)
  nmap <C-c>i)    ci)<Plug>(eskk:toggle)
  nmap <C-c>i(    ci(<Plug>(eskk:toggle)
  nmap <C-c>ib    cib<Plug>(eskk:toggle)
  nmap <C-c>a}    ca}<Plug>(eskk:toggle)
  nmap <C-c>a{    ca{<Plug>(eskk:toggle)
  nmap <C-c>aB    caB<Plug>(eskk:toggle)
  nmap <C-c>i}    ci}<Plug>(eskk:toggle)
  nmap <C-c>i{    ci{<Plug>(eskk:toggle)
  nmap <C-c>iB    ciB<Plug>(eskk:toggle)
  nmap <C-c><C-c>  cc<Plug>(eskk:toggle)
  nmap <A-c>        C<Plug>(eskk:toggle)

  autocmd MyAutoCmd User eskk-initialize-pre call s:eskk_initial_pre()
  function! s:eskk_initial_pre() "{{{
    let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
    " hankaku -> zenkaku
    call t.add_map('~',  '～')

    " zenkaku -> hankaku
    call t.add_map('z~', '~')
    call t.add_map('z:', ":\<Space>")
    call t.add_map('z;', ";\<Space>")
    call t.add_map('z,', ",\<Space>")
    call t.add_map('z.', '.')
    call t.add_map('z?', '?')

    call eskk#register_mode_table('hira', t)
  endfunction "}}}

  " skk-jisyoをソートしたい
  if filereadable(expand('~/dotfiles/.skk-jisyo'))
    function! s:SortSKKDictionary() "{{{
      let l:savedView = winsaveview()
      execute "keepjumps normal! 0ggjv/okuri\<CR>k:sort\<CR>v\<Esc>"
      execute "keepjumps normal! /okuri\<CR>0jvG:sort\<CR>"
      call winrestview(l:savedView)
      echo 'ソートしました!!'
    endfunction "}}}

    function! s:SKKDictionarySettings() "{{{
      command! -buffer SortSKKDictionary call s:SortSKKDictionary()
    endfunction "}}}
    autocmd MyAutoCmd FileType skkdict call s:SKKDictionarySettings()
  endif

  function! neobundle#hooks.on_post_source(bundle)
    " wake up!
    " -> 1発目の処理がeskk#statusline()だと不都合なので, eskk#toggle()を2連発
    call eskk#toggle()
    call eskk#toggle()

    " 処理順を明確にするため, neobundle#hooks.on_post_source()を
    " 使ってプラグインの読み込み完了フラグを立てることにした
    let s:IsEskkLoaded = 1
  endfunction

endif "}}}

" コマンド名補完(vim-ambicmd) {{{
if neobundle#tap('vim-ambicmd')

  " 下手にマッピングするよりもambicmdで補完する方が捗る
  cnoremap <expr> <Space> ambicmd#expand("\<Space>")

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

  if neobundle#is_installed('lightline-hybrid.vim')
    let g:lightline.colorscheme = 'hybrid'
  endif

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

  function! MyModified() "{{{
    return &ft =~  'help\|vimfiler\' ? ''          :
          \              &modified   ? "\<Space>+" :
          \              &modifiable ? ''          : "\<Space>-"
  endfunction "}}}

  function! MyReadonly() "{{{
    return &ft !~? 'help\|vimfiler\' && &readonly ? "\<Space>\u2B64" : ''
  endfunction "}}}

  function! MyFilename() "{{{
    " 以下の条件を満たすと処理負荷が急激に上がる。理由は不明
    " ・Vimのカレントディレクトリがネットワーク上
    " ・ネットワーク上のファイルを開いており, ファイル名をフルパス(%:p)出力
    " -> GVIMウィンドウ上部にフルパスが表示されているので, そちらを参照する
    return (&ft == 'unite'       ? ''            :
          \ &ft == 'vimfiler'    ? ''            :
          \  '' != expand('%:t') ? expand('%:t') : '[No Name]') .
          \ ('' != MyReadonly()  ? MyReadonly()  : ''         ) .
          \ ('' != MyModified()  ? MyModified()  : ''         )
  endfunction "}}}

  function! MyFileformat() "{{{
    return winwidth(0) > 70 ? &fileformat : ''
  endfunction "}}}

  function! MyFiletype() "{{{
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
  endfunction "}}}

  function! MyFileencoding() "{{{
    return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
  endfunction "}}}

  function! MyMode() "{{{
    return winwidth(0) > 30 ? lightline#mode() : ''
  endfunction "}}}

  function! MySKKMode() "{{{
    " 処理順を明確にするため, neobundle#hooks.on_post_source()を
    " 使ってプラグインの読み込み完了フラグを立てることにした
    " -> 一応neobundle#is_sourced()を使っても問題無く動くことは確認した
    if !exists('s:IsNeoCompleteLoaded') || !exists('s:IsEskkLoaded')
      return ''
    endif

    " 初回の処理
    if !exists('b:LastMode')
      let b:LastMode = ''
    endif

    let l:CurrentMode = eskk#statusline()

    " モードが変更されていなければ何もしない
    if l:CurrentMode == b:LastMode
      return winwidth(0) > 30 ? l:CurrentMode : ''
    endif

    " モード切り替わり(normal <-> skk)を監視するついでにneocompleteをlock/unlock
    if b:LastMode == ''
      " normal -> skk : 必要ならunlock
      if neocomplete#get_current_neocomplete().lock == 1
        NeoCompleteUnlock
      else
        let b:IsAlreadyUnlocked = 1
      endif

    else
      " skk -> normal : 必要ならlock
      if !exists('b:IsAlreadyUnlocked')
        NeoCompleteLock
      else
        unlet b:IsAlreadyUnlocked
      endif

    endif

    " 直前のモード情報を更新
    let b:LastMode = l:CurrentMode

    return winwidth(0) > 30 ? l:CurrentMode : ''
  endfunction "}}}

  function! MyCurrentFunc() "{{{
    if &ft == 'vim' || &ft == 'markdown'
      return winwidth(0) > 100 ? s:currentFold : ''
    else
      return winwidth(0) > 100 ? s:currentFunc : ''
    endif
  endfunction "}}}

  function! MyFugitive() "{{{
    if !neobundle#is_installed('vim-fugitive') || &ft == 'vimfiler'
      return ''
    endif
    let l:_ = fugitive#head()
    return winwidth(0) > 30 ? (strlen(l:_) ? '⭠ ' . l:_ : '') : ''
  endfunction "}}}

endif "}}}

" フォントサイズ変更を簡易化(vim-fontzoom) {{{
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

" フルスクリーンモード(scrnmode.vim) {{{
if has('kaoriya')

  let s:fullscreenOn = 0
  function! s:ToggleScreenMode() "{{{
    if s:fullscreenOn
      execute 'ScreenMode 0'
      let s:fullscreenOn = 0
    else
      execute 'ScreenMode 6'
      let s:fullscreenOn = 1
    endif
  endfunction "}}}
  command! ToggleScreenMode call s:ToggleScreenMode()
  nnoremap <F11> :<C-u>ToggleScreenMode<CR>

endif "}}}

" incsearchをパワーアップ(incsearch.vim) {{{
if neobundle#tap('incsearch.vim')

  " very magic
  let g:incsearch#magic = '\v'

  map /  <Plug>(incsearch-/)
  map ?  <Plug>(incsearch-?)
  map g/ <Plug>(incsearch-stay-/)
  map g? <Plug>(incsearch-stay-?)

endif "}}}

" incsearch.vimをパワーアップ(incsearch-fuzzy.vim) {{{
if neobundle#tap('incsearch-fuzzy.vim')

  map  z/ <Plug>(incsearch-fuzzy-/)
  map  z? <Plug>(incsearch-fuzzy-?)
  map gz/ <Plug>(incsearch-fuzzy-stay-/)
  map gz? <Plug>(incsearch-fuzzy-stay-?)

endif "}}}

" asterisk検索をパワーアップ(vim-asterisk) {{{
if neobundle#tap('vim-asterisk')

  " 検索開始時のカーソル位置を保持する
  let g:asterisk#keeppos = 1

  " g:incsearch#magic使用時の検索履歴問題の暫定対処
  " https://github.com/haya14busa/incsearch.vim/issues/22
  " http://lingr.com/room/vim/archives/2014/10/27#message-20478448
  function! s:ModSearchHistory() "{{{
    if !exists('g:incsearch#magic') | return '' | endif
    if g:incsearch#magic != '\v'    | return '' | endif
    if mode() != 'n'                | return '' | endif

    " hogeをstar検索すると履歴は\<hoge\>となる
    "                           ^     ^  ←この'\'を取り除きたい
    "                           12345678 ←文字数
    "                                  ^ ←matchend
    "                           01234567 ←文字列のindex
    " NOTE: 単語区切りは単語を構成する文字のみ付加される
    let l:lastHistory = histget('/', -1)
    let l:endIndex = matchend(l:lastHistory, '^\\<.*\\>')
    if  l:endIndex >= 0
      let l:lastHistory = '<' . l:lastHistory[2 : (l:endIndex - 3)] . '>'
            \                 . l:lastHistory[l:endIndex :]
    endif
    call histdel('/', -1)
    call histadd('/', l:lastHistory)

    return ''
  endfunction "}}}
  noremap <expr> <Plug>(_ModSearchHistory) <SID>ModSearchHistory()
  command! ModSearchHistory call s:ModSearchHistory()

  " star-search対象をクリップボードに入れる
  function! s:ClipCword(data) "{{{
    let    l:currentMode  = mode(1)
    if     l:currentMode == 'n'
      let @* = a:data
      return ''
    elseif l:currentMode == 'no'
      let @* = a:data
      return "\<Esc>"
    elseif  l:currentMode ==# 'v' ||
          \ l:currentMode ==# 'V' ||
          \ l:currentMode == ''
      return "\<Esc>gvygv"
    endif
    echomsg 'You can use ClipCword() on following modes : n/no/v/V/CTRL-V'
    return ''
  endfunction "}}}
  noremap <expr> <Plug>(_ClipCword) <SID>ClipCword(expand('<cword>'))

  if neobundle#is_installed('vim-anzu')
    map *  <Plug>(_ClipCword)<Plug>(asterisk-z*)<Plug>(anzu-update-search-status-with-echo)<Plug>(_ModSearchHistory)
    map #  <Plug>(_ClipCword)<Plug>(asterisk-z#)<Plug>(anzu-update-search-status-with-echo)<Plug>(_ModSearchHistory)
    map g* <Plug>(_ClipCword)<Plug>(asterisk-gz*)<Plug>(anzu-update-search-status-with-echo)
    map g# <Plug>(_ClipCword)<Plug>(asterisk-gz#)<Plug>(anzu-update-search-status-with-echo)
  else
    map *  <Plug>(_ClipCword)<Plug>(asterisk-z*)<Plug>(_ModSearchHistory)
    map #  <Plug>(_ClipCword)<Plug>(asterisk-z#)<Plug>(_ModSearchHistory)
    map g* <Plug>(_ClipCword)<Plug>(asterisk-gz*)
    map g# <Plug>(_ClipCword)<Plug>(asterisk-gz#)
  endif

endif "}}}

" 何番目の検索対象か／検索対象の総数を表示(vim-anzu) {{{
if neobundle#tap('vim-anzu')

  " " 検索対象横にechoする。視線移動は減るが結構見づらくなるので慣れが必要
  " nmap n <Plug>(anzu-mode-n)
  " nmap N <Plug>(anzu-mode-N)
  "
  " " 検索開始時にジャンプせず, その場でanzu-modeに移行する
  " nmap <expr> * ':<C-u>call anzu#mode#start('<C-R><C-W>', '', '', '')<CR>'

  " コマンド結果出力画面にecho
  nmap n <Plug>(anzu-n-with-echo)
  nmap N <Plug>(anzu-N-with-echo)

endif "}}}

" f検索を便利に(vim-shot-f) {{{
if neobundle#tap('vim-shot-f')

  " for Lazy
  let g:shot_f_no_default_key_mappings = 1
  map f <Plug>(shot-f-f)
  map F <Plug>(shot-f-F)
  map t <Plug>(shot-f-t)
  map T <Plug>(shot-f-T)

endif "}}}

" f検索の2文字版(vim-sneak) {{{
if neobundle#tap('vim-sneak')

  " clever-s
  let g:sneak#s_next = 1

  " smartcase
  let g:sneak#use_ic_scs = 1

  " for Lazy
  map s <Plug>Sneak_s
  map S <Plug>Sneak_S

endif "}}}

" Vimのマーク機能を使いやすく(vim-signature) {{{
if neobundle#tap('vim-signature')

  " " お試しとして, グローバルマークだけ使うようにしてみる
  " " -> viminfoに直接書き込まれるためか, マークの削除が反映されないことが多々
  " let g:SignatureIncludeMarks = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

  " _viminfoファイルからグローバルマークの削除を行う
  " -> Unix系だと「~/.viminfo」, Windowsだと「~/_viminfo」を対象とする
  " -> Windowsでは_viminfoが書き込み禁止になり削除失敗するので無効化する
  let g:SignatureForceRemoveGlobal = 0

  " これだけあれば十分
  " mm       : ToggleMarkAtLine
  " m<Space> : PurgeMarks
  nmap mm m.

  function! neobundle#hooks.on_post_source(bundle)
    " 使わないコマンドを削除する
    delcommand SignatureToggleSigns
    delcommand SignatureRefresh
    delcommand SignatureListMarks
    delcommand SignatureListMarkers

  endfunction

endif "}}}

" 対応するキーワードを増やす(matchit) {{{
if neobundle#tap('matchit')

endif "}}}

" 関数を選択するテキストオブジェクト(vim-textobj-function) {{{
if neobundle#tap('vim-textobj-function')

endif "}}}

" パラメータを選択するテキストオブジェクト(vim-textobj-parameter) {{{
if neobundle#tap('vim-textobj-parameter')

endif "}}}

" 置き換えオペレータ(vim-operator-replace) {{{
if neobundle#tap('vim-operator-replace')

  map <A-r> <Plug>(operator-replace)

endif "}}}

" 検索オペレータ(vim-operator-search) {{{
if neobundle#tap('vim-operator-search')

  map <A-s> <Plug>(operator-search)

endif "}}}

" 自由にテキストハイライト(vim-quickhl) {{{
if neobundle#tap('vim-quickhl')

  nmap <A-h> <Plug>(operator-quickhl-manual-this-motion)
  xmap <A-h> <Plug>(operator-quickhl-manual-this-motion)

  " オペレータは2回繰り返すと行に対して処理するが, <cword>に対して処理したい
  nmap <A-h><A-h> <Plug>(quickhl-manual-this)

endif "}}}

" コメントアウト/コメントアウト解除(caw.vim) {{{
if neobundle#tap('caw.vim')

  let g:caw_no_default_keymappings = 1

  " caw.vimをオペレータとして使う
  " https://github.com/rhysd/dogfiles/blob/master/vimrc
  function! s:OperatorCawCommentToggle(motionWise)
    if a:motionWise ==# 'char'
      execute "normal `[v`]\<Plug>(caw:wrap:toggle)"
    else
      execute "normal `[V`]\<Plug>(caw:i:toggle)"
    endif
  endfunction
  function! neobundle#hooks.on_source(bundle)
    call operator#user#define('caw', s:SID() . 'OperatorCawCommentToggle')
  endfunction

  map co <Plug>(operator-caw)

endif "}}}

" 囲む / 囲まなくする / 別の何かで囲む(vim-surround) {{{
if neobundle#tap('vim-surround')

endif "}}}

" vimdiffに別のDiffアルゴリズムを適用する(vim-unified-diff) {{{
if neobundle#tap('vim-unified-diff')

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
        \   ['My bookmarks:'          ], 'bookmarks',
        \   ['My sessions:'           ], 'sessions',
        \   ['Most recent used files:'], 'files',
        \ ]

  nnoremap ,, :<C-u>Startify<CR>

  function! neobundle#hooks.on_post_source(bundle)
    " 使わないコマンドを削除する
    delcommand StartifyDebug
    delcommand SClose

  endfunction

endif "}}}

" 検索やリスト表示の拡張(unite.vim) {{{
if neobundle#tap('unite.vim')

  let g:unite_force_overwrite_statusline = 1
  let g:unite_split_rule = 'botright'

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
  let g:u_nqui = '-no-quit '
  let g:u_nsyn = '-no-sync '
  let g:u_prev = '-auto-preview '
  let g:u_sbuf = '-buffer-name=search-buffer '
  let g:u_sins = '-start-insert '
  let g:u_hopt = '-split -horizontal -winheight=20 '
  let g:u_vopt = '-split -vertical -winwidth=90 '

  " unite_sourcesに応じたオプション変数を定義して使ってみたけど微妙感が漂う
  let g:u_opt_bu = 'Unite '       . g:u_hopt
  let g:u_opt_bo = 'Unite '       . g:u_hopt
  let g:u_opt_dm = 'Unite '       . g:u_hopt . g:u_sins
  let g:u_opt_fi = 'Unite '       . g:u_hopt . g:u_sins
  let g:u_opt_fm = 'Unite '       . g:u_hopt . g:u_sins
  let g:u_opt_fr = 'Unite '       . g:u_hopt . g:u_sins
  let g:u_opt_gd = 'Unite '       . g:u_hopt
  let g:u_opt_gg = 'Unite '       . g:u_hopt            . g:u_sbuf
  let g:u_opt_gr = 'Unite '       . g:u_hopt            . g:u_sbuf . g:u_nqui
  let g:u_opt_li = 'Unite '                  . g:u_sins . g:u_sbuf
  let g:u_opt_mf = 'Unite '       . g:u_hopt . g:u_sins
  let g:u_opt_mg = 'Unite '       . g:u_hopt            . g:u_sbuf
  let g:u_opt_mk = 'Unite '       . g:u_hopt . g:u_sins . g:u_prev
  let g:u_opt_mp = 'Unite '                  . g:u_sins
  let g:u_opt_nl = 'Unite '                  . g:u_sins
  let g:u_opt_nu = 'Unite '                             . g:u_nsyn
  let g:u_opt_ol = 'Unite '       . g:u_vopt . g:u_sins
  let g:u_opt_op = 'Unite '                  . g:u_sins
  let g:u_opt_re = 'UniteResume ' . g:u_hopt            . g:u_sbuf

  nnoremap <expr> <Leader>bu ':<C-u>' . g:u_opt_bu . 'buffer'           . '<CR>'
  nnoremap <expr> <Leader>bo ':<C-u>' . g:u_opt_bo . 'bookmark'         . '<CR>'
  nnoremap <expr> <Leader>dm ':<C-u>' . g:u_opt_dm . 'directory_mru'    . '<CR>'
  nnoremap <expr> <Leader>fi ':<C-u>' . g:u_opt_fi . 'file:'
  nnoremap <expr> <Leader>fm ':<C-u>' . g:u_opt_fm . 'file_mru'         . '<CR>'
  nnoremap <expr> <Leader>fr ':<C-u>' . g:u_opt_fr . 'file_rec'         . '<CR>'
  nnoremap <expr> <Leader>gd ':<C-u>' . g:u_opt_gd . 'gtags/def:'
  nnoremap <expr> <Leader>g% ':<C-u>' . g:u_opt_gg . 'vimgrep:%'        . '<CR>'
  nnoremap <expr> <Leader>g* ':<C-u>' . g:u_opt_gg . 'vimgrep:*'        . '<CR>'
  nnoremap <expr> <Leader>g. ':<C-u>' . g:u_opt_gg . 'vimgrep:.*'       . '<CR>'
  nnoremap <expr> <Leader>gg ':<C-u>' . g:u_opt_gg . 'vimgrep:**'       . '<CR>'
  nnoremap <expr> <Leader>gr ':<C-u>' . g:u_opt_gr . 'gtags/ref:'
  nnoremap <expr> <Leader>li ':<C-u>' . g:u_opt_li . 'line:'
  nnoremap <expr> <Leader>mf ':<C-u>' . g:u_opt_mf . 'file:~/memo'      . '<CR>'
  nnoremap <expr> <Leader>mg ':<C-u>' . g:u_opt_mg . 'vimgrep:~/memo/*' . '<CR>'
  nnoremap <expr> <Leader>mk ':<C-u>' . g:u_opt_mk . 'mark'             . '<CR>'
  nnoremap <expr> <Leader>mp ':<C-u>' . g:u_opt_mp . 'mapping'          . '<CR>'
  nnoremap <expr> <Leader>nl ':<C-u>' . g:u_opt_nl . 'neobundle/lazy'   . '<CR>'
  nnoremap <expr> <Leader>nu ':<C-u>' . g:u_opt_nu . 'neobundle/update'
  nnoremap <expr> <Leader>ol ':<C-u>' . g:u_opt_ol . 'outline'          . '<CR>'
  nnoremap <expr> <Leader>op ':<C-u>' . g:u_opt_op . 'output'           . '<CR>'
  nnoremap <expr> <Leader>re ':<C-u>' . g:u_opt_re                      . '<CR>'

  function! neobundle#hooks.on_post_source(bundle)
    " unite.vimのデフォルトコンテキストを設定する
    " http://d.hatena.ne.jp/osyo-manga/20140627
    " -> なんだかんだ非同期で処理させる必要は無い気がする
    " -> emptyの時にメッセージ通知を出せるか調べる
    call unite#custom#profile('default', 'context', {
          \   'no_empty'         : 1,
          \   'no_quit'          : 0,
          \   'prompt'           : '> ',
          \   'prompt_direction' : 'top',
          \   'prompt_focus'     : 1,
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

    function! s:UniteSettings() "{{{
      imap <buffer> <Esc> <Plug>(unite_insert_leave)
      nmap <buffer> <Esc> <Plug>(unite_exit)

      " <Leader>がデフォルトマッピングで使用されていた場合の対策
      nnoremap <buffer> <Leader>         <Nop>
      nnoremap <buffer> <Leader><Leader> <Nop>

    endfunction "}}}
    autocmd MyAutoCmd FileType unite call s:UniteSettings()
  endfunction

endif "}}}

" for unite-file_mru {{{
if neobundle#tap('neomru.vim')

endif "}}}

" for unite-gtags {{{
if neobundle#tap('unite-gtags')

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

" Vim上で動くファイラ(vimfiler.vim) {{{
if neobundle#tap('vimfiler.vim')

  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_enable_auto_cd = 1
  let g:vimfiler_force_overwrite_statusline = 0
  let g:vimfiler_safe_mode_by_default = 0

  " カレントディレクトリを開く
  nnoremap ,c :<C-u>VimFilerCurrentDir<CR>

  " vimfilerのマッピングを一部変更
  function! s:VimfilerSettings() "{{{
    " カレントディレクトリを開く
    nnoremap <buffer> ,c :<C-u>VimFilerCurrentDir<CR>

    " grepはUniteを使うので潰しておく
    nnoremap <buffer> gr <Nop>

    " <Leader>がデフォルトマッピングで使用されていた場合の対策
    nnoremap <buffer> <Leader>         <Nop>
    nnoremap <buffer> <Leader><Leader> <Nop>

  endfunction "}}}
  autocmd MyAutoCmd FileType vimfiler call s:VimfilerSettings()

endif "}}}

" Quickfixから置換(vim-qfreplace) {{{
if neobundle#tap('vim-qfreplace')

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
  xmap gs <Plug>(scratch-selection-reuse)
  nmap gS <Plug>(scratch-insert-clear)
  xmap gS <Plug>(scratch-selection-clear)

  function! s:ScratchVimSettings() "{{{
    nnoremap <buffer> <Esc> <C-w>j
  endfunction "}}}
  autocmd MyAutoCmd FileType scratch call s:ScratchVimSettings()

  function! neobundle#hooks.on_post_source(bundle)
    " 使わないコマンドを削除する
    delcommand Scratch
    delcommand ScratchInsert
    delcommand ScratchSelection

  endfunction

endif "}}}

" Vimで英和辞書を引く(dicwin-vim) {{{
if neobundle#tap('dicwin-vim')

  let g:dicwin_no_default_mappings = 1
  nmap <silent> <A-k>      <Nop>
  nmap <silent> <A-k><A-k> <Plug>(dicwin-cword)
  imap <silent> <A-k>      <Nop>
  imap <silent> <A-k><A-k> <Plug>(dicwin-cword-i)
  nmap <silent> <A-k>c     <Plug>(dicwin-close)
  imap <silent> <A-k>c     <Plug>(dicwin-close-i)
  nmap <silent> <A-/>      <Plug>(dicwin-query)

  if filereadable(expand('~/vimfiles/dict/gene.txt'))
    autocmd MyAutoCmd BufRead gene.txt setlocal filetype=dicwin
    function! s:DicwinSettings() "{{{
      nnoremap <buffer> <Esc> :<C-u>q<CR>
    endfunction "}}}
    autocmd MyAutoCmd FileType dicwin call s:DicwinSettings()
  endif

endif "}}}

" コマンドの結果をバッファに表示する(capture.vim) {{{
if neobundle#tap('capture.vim')

  let g:capture_open_command = 'botright 12sp new'

  nnoremap <Leader>who :<C-u>Capture echo expand('%:p')<CR>
  nnoremap <Leader>sn  :<C-u>Capture scriptnames<CR>

endif "}}}

" Vimからブラウザを開く(open-browser) {{{
if neobundle#tap('open-browser.vim')

  nmap <Leader>L <Plug>(openbrowser-smart-search)
  xmap <Leader>L <Plug>(openbrowser-smart-search)

endif "}}}

" VimからTwitterを見る(TweetVim) {{{
if neobundle#tap('TweetVim')

  let g:tweetvim_config_dir = expand('~/.cache/TweetVim')

  function! s:TweetVimSettings() "{{{
    nnoremap <buffer> <C-CR>     :<C-u>TweetVimSay<CR>
    nmap     <buffer> <Leader>rt <Plug>(tweetvim_action_retweet)
  endfunction "}}}
  autocmd MyAutoCmd FileType tweetvim call s:TweetVimSettings()

endif "}}}

" VimからLingrを見る(J6uil.vim) {{{
if neobundle#tap('J6uil.vim')

  let g:J6uil_config_dir = expand('~/.cache/J6uil')

  function! s:J6uilSaySetting() "{{{
    if neobundle#is_installed('eskk.vim')
      nmap     <buffer> <C-j> i<Plug>(eskk:toggle)
    else
      nnoremap <buffer> <C-j> <Nop>
    endif
  endfunction "}}}
  autocmd MyAutoCmd FileType J6uil_say call s:J6uilSaySetting()
endif "}}}

" ファイルをブラウザで開く(previm) {{{
if neobundle#tap('previm')

  if has('win32')
    let g:previm_open_cmd = 'start'
  endif
  let g:previm_enable_realtime = 1

endif "}}}

" markdownを使いやすくする(vim-markdown) {{{
if neobundle#tap('vim-markdown')

  " " markdownのfold機能を無効にする
  " " -> むしろ有効活用したい
  " let g:vim_markdown_folding_disabled = 1

  " 折り畳みを1段階閉じた状態で開く
  " -> autocmd FileTypeでfoldlevelstartを変えても意味がないぽい
  " -> foldlevelをいじる
  autocmd MyAutoCmd FileType markdown setlocal foldlevel=1

endif "}}}

" メモ管理用プラグイン(memolist.vim) {{{
if neobundle#tap('memolist.vim')

  let g:memolist_path = '~/memo'
  let g:memolist_memo_suffix = 'md'
  let g:memolist_prompt_tags = 1

  " カテゴリまで決めるの面倒なので...
  let g:memolist_prompt_categories = 0

  " markdownテンプレートを指定
  if filereadable(expand('~/configs/template/md.txt'))
    let g:memolist_template_dir_path = '~/configs/template'
  endif

  nnoremap <Leader>ml :<C-u>edit ~/memo<CR>
  nnoremap <Leader>mn :<C-u>MemoNew<CR>

endif "}}}

" 文末の空白削除を簡易化(vim-trailing-whitespace) {{{
if neobundle#tap('vim-trailing-whitespace')

endif "}}}

" テキスト整形を簡易化(vim-easy-align) {{{
if neobundle#tap('vim-easy-align')

  xnoremap <silent> <CR> :EasyAlign<CR>

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

" Quickfixに表示されている行を強調表示(vim-hier) {{{
if neobundle#tap('vim-hier')

endif "}}}

" quickrun-hook集(shabadou.vim) {{{
if neobundle#tap('shabadou.vim')

endif "}}}

" Vimで自動構文チェック(vim-watchdogs) {{{
if neobundle#tap('vim-watchdogs')
  " Caution: 裏で実行した結果を反映しているのか, 入力待ち系の処理があると固まる

  let g:watchdogs_check_BufWritePost_enable = 1
  let g:watchdogs_check_BufWritePost_enables = {
        \   'c'    : 1,
        \   'ruby' : 1,
        \ }

  if neobundle#is_installed('vim-quickrun')
    " quickrun_configにwatchdogs.vimの設定を追加
    call watchdogs#setup(g:quickrun_config)

  endif

endif "}}}

"}}}
"-----------------------------------------------------------------------------

