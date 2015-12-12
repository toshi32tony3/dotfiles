" vimrc for 香り屋版GVim
" TODO: 不要なコマンドを洗い出して:delcommandをぶちかます
" TODO: vim-watchdogsを使えるように設定する
" TODO: vim-templateを使えるように設定する
" TODO: dicwinの改善
"       # Can't findで閉じるように
"       # 幅を2行固定に
" DONE: vim-shot-f
"       # redraw! -> redraw

"-----------------------------------------------------------------------------
" 初期設定 {{{

" 実は不要なnocompatible
" http://rbtnn.hateblo.jp/entry/2014/11/30/174749
if &compatible
  " Vi互換モードをオフ(Vimの拡張機能を有効化)
  set nocompatible
endif

" ftpluginは最後に読み込むため、一旦オフする
filetype plugin indent off

"}}}
"-----------------------------------------------------------------------------
" Plugin List {{{

" Neo Bundleでプラグインを管理する
if has('vim_starting')
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

NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet.vim'
" neosnippet-snippetsはfork版を使う
NeoBundle 'toshi32tony3/neosnippet-snippets'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vimfiler.vim'

" NeoBundleLazy 'Shougo/neomru.vim',
"   \ { 'autoload' : { 'unite_sources' : [ 'file_mru' ] } }
" NeoBundleLazy 'Shougo/neoyank.vim',
"   \ { 'autoload' : { 'unite_sources' : [ 'history/yank' ] } }
NeoBundleLazy 'Shougo/junkfile.vim',
      \ { 'autoload' : { 'unite_sources' : [ 'junkfile', 'junkfile/new' ] } }
NeoBundleLazy 'vim-scripts/gtags.vim',
      \ { 'autoload' : { 'command' : ['Gtags'] } }
NeoBundleLazy 'hewes/unite-gtags',
      \ { 'autoload' : { 'unite_sources' : [ 'gtags/ref', 'gtags/def' ] } }
NeoBundleLazy 'tacroe/unite-mark',
      \ { 'autoload' : { 'unite_sources' : [ 'mark' ] } }
NeoBundleLazy 'Shougo/unite-outline',
      \ { 'autoload' : { 'unite_sources' : [ 'outline' ] } }

NeoBundle 'thinca/vim-singleton'
NeoBundleLazy 'thinca/vim-quickrun',
      \ { 'autoload' : { 'commands' : ['QuickRun'] } }
NeoBundleLazy 'thinca/vim-ambicmd'
NeoBundleLazy 'thinca/vim-fontzoom',
      \ { 'autoload' : { 'mappings' : ['<Plug>(fontzoom-'],
      \                  'commands' : ['Fontzoom', 'Fontzoom!'] } }
NeoBundleLazy 'thinca/vim-scouter',
      \ { 'autoload' : { 'commands' : ['Scouter'] } }
NeoBundleLazy 'thinca/vim-qfreplace',
      \ { 'autoload' : { 'commands' : ['Qfreplace'] } }

" そこまで強調しなくても良い気がしてきた
" NeoBundle 'pocke/vim-hier'

NeoBundle 'osyo-manga/vim-brightest'
" NeoBundle 'osyo-manga/shabadou.vim'
" NeoBundle 'osyo-manga/vim-watchdogs'
" NeoBundle 'scrooloose/syntastic'

NeoBundle 'chriskempson/vim-tomorrow-theme'
NeoBundleLazy 'mattn/benchvimrc-vim',
      \ { 'autoload' : { 'commands' : ['BenchVimrc'] } }

" memolist.vimはmarkdown形式でメモを生成するので、markdownを使いやすくしてみる
" http://rcmdnk.github.io/blog/2013/11/17/computer-vim/#plasticboyvim-markdown
NeoBundleLazy 'glidenote/memolist.vim',
      \ { 'autoload' : { 'commands' : ['MemoNew'] } }
NeoBundle 'rcmdnk/vim-markdown'

" Previm便利だけど、IEではmermaidを使えないようなのでShibaメインになりそう
" https://github.com/rhysd/Shiba
NeoBundleLazy 'kannokanno/previm',
      \ { 'autoload' : { 'commands' : ['PrevimOpen'] } }

" リアルタイムプレビューが非常に早いのが特徴。発展途上感はある
NeoBundleLazy 'kurocode25/mdforvim',
      \ { 'autoload' : { 'commands' : ['MdPreview', 'MdConvert'] } }

NeoBundleLazy 'tyru/open-browser.vim',
      \ { 'autoload' : { 'mappings' : ['<Plug>(openbrowser-'] } }

NeoBundleLazy 'deris/vim-visualinc',
      \ { 'autoload' : { 'mappings' : ['<Plug>(visualinc-'] } }

" Restartよりも先に候補になるのが若干困るので、使う時はUnite neobundle/lazyする
NeoBundleLazy 'deris/vim-rengbang',
      \ { 'autoload' : { 'mappings' : ['<Plug>(operator-rengbang)'] } }

NeoBundle 'tpope/vim-surround'

NeoBundleLazy 'kana/vim-operator-user'
NeoBundleLazy 'kana/vim-textobj-user'

NeoBundleLazy 'kana/vim-operator-replace',
      \ { 'autoload' : { 'depends'  : ['kana/vim-operator-user'],
      \                  'mappings' : ['<Plug>(operator-replace)'] } }
NeoBundleLazy 'osyo-manga/vim-operator-search',
      \ { 'autoload' : { 'depends'  : ['kana/vim-operator-user'],
      \                  'mappings' : ['<Plug>(operator-search)'] } }
NeoBundleLazy 'kana/vim-textobj-function',
      \ { 'autoload' : { 'depends'  : ['kana/vim-textobj-user'],
      \                  'mappings' : ['<Plug>(textobj-function-'] } }

NeoBundleLazy 'kana/vim-smartchr'
NeoBundleLazy 'tyru/capture.vim',
      \ { 'autoload' : { 'commands' : ['Capture'] } }
NeoBundleLazy 't9md/vim-quickhl',
      \ { 'autoload' : { 'depends'  : ['kana/vim-operator-user'],
      \                  'mappings' : ['<Plug>(quickhl-',
      \                                '<Plug>(operator-quickhl-'] } }

NeoBundleLazy 'haya14busa/incsearch.vim',
      \ { 'autoload' : { 'mappings' : ['<Plug>(incsearch-'] } }
NeoBundleLazy 'haya14busa/incsearch-fuzzy.vim',
      \ { 'autoload' : { 'mappings' : ['<Plug>(incsearch-fuzzy-',
      \                                '<Plug>(incsearch-fuzzyspell-'] } }
NeoBundleLazy 'haya14busa/incsearch-migemo.vim',
      \ { 'autoload' : { 'mappings' : ['<Plug>(incsearch-migemo-'] } }

NeoBundleLazy 'osyo-manga/vim-anzu',
      \ { 'autoload' : { 'mappings' : ['<Plug>(anzu-'] } }
NeoBundleLazy 'haya14busa/vim-asterisk',
      \ { 'autoload' : { 'mappings' : ['<Plug>(asterisk-'] } }

NeoBundleLazy 'mhinz/vim-signify',
      \ { 'autoload' : { 'commands' : ['SignifyStart'] } }

NeoBundle 'tpope/vim-fugitive'
NeoBundleLazy 'lambdalisue/vim-gita',
      \ { 'autoload' : { 'commands' : ['Gita'] } }
NeoBundleLazy 'cohama/agit.vim',
      \ { 'autoload' : { 'commands' : ['Agit'] } }
" 何故かLazyできなかった
NeoBundle 'idanarye/vim-merginal'

NeoBundleLazy 'tyru/current-func-info.vim'

NeoBundle 'itchyny/lightline.vim'
NeoBundle 'cocopon/lightline-hybrid.vim'

" Cygwin Vimでは使う
" NeoBundleLazy 'kana/vim-fakeclip',
"   \ { 'autoload' : { 'mappings' : ['<Plug>(fakeclip-'] } }

NeoBundleLazy 'LeafCage/yankround.vim',
      \ { 'autoload' : { 'mappings' : ['<Plug>(yankround-'] } }
NeoBundleLazy 'junegunn/vim-easy-align',
      \ { 'autoload' : { 'commands' : ['EasyAlign'] } }

" 常に行末スペースを検知したいので、Lazyしない
NeoBundle 'bronson/vim-trailing-whitespace'

NeoBundleLazy 'vim-scripts/BufOnly.vim',
      \ { 'autoload' : { 'commands' : ['BOnly', 'Bonly'] } }

NeoBundleLazy 'deris/vim-shot-f',
      \ { 'autoload' : { 'mappings' : ['<Plug>(shot-f-'] } }
" incsearch.vimの高機能な検索を多用したい
" NeoBundleLazy 'rhysd/clever-f.vim',
"       \ { 'autoload' : { 'mappings' : ['<Plug>(clever-'] } }
" NeoBundleLazy 'justinmk/vim-sneak',
"       \ { 'autoload' : { 'mappings' : ['<Plug>Sneak_'] } }

NeoBundleLazy 'tyru/caw.vim',
      \ { 'autoload' : { 'mappings' : ['<Plug>(caw'] } }
NeoBundle 'kshenoy/vim-signature'

NeoBundle 'mhinz/vim-startify'

NeoBundle 'tmhedberg/matchit'

NeoBundleLazy 'basyura/J6uil.vim',
      \ { 'autoload' : { 'commands' : ['J6uil'] } }

NeoBundleLazy 'basyura/twibill.vim'
NeoBundleLazy 'basyura/TweetVim',
      \ { 'depends'  : ['basyura/twibill.vim', 'tyru/open-browser.vim'],
      \   'autoload' : { 'commands' : ['TweetVimHomeTimeline',
      \                                'TweetVimSearch'       ] } }

NeoBundle 'lambdalisue/vim-unified-diff'
NeoBundle 'lambdalisue/vim-improve-diff'

NeoBundleLazy 'tyru/skk.vim'
NeoBundleLazy 'tyru/eskk.vim',
      \ { 'autoload' : { 'mappings' : ['<Plug>(eskk'] } }

NeoBundleLazy 'tyru/restart.vim',
      \ { 'autoload' : { 'commands' : ['Restart', 'RestartWithSession'] } }

NeoBundleLazy 'thinca/vim-prettyprint',
      \ { 'autoload' : { 'commands' : ['PP'] } }

NeoBundleLazy 'mtth/scratch.vim',
      \ { 'autoload' : { 'mappings' : ['<Plug>(scratch-'] } }

NeoBundleLazy 'thinca/vim-showtime',
      \ { 'autoload' : { 'commands' : ['Showtime'] } }

if has('python') && filereadable(expand($VIM . '/_curses.pyd'))
  NeoBundleLazy 'severin-lemaignan/vim-minimap',
        \ { 'autoload' : { 'commands' : ['Minimap'] } }
endif

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

"}}}
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

" Echo startup time on start
if has('vim_starting') && has('reltime')
  let g:startuptime = reltime()
  autocmd MyAutoCmd VimEnter *
        \   let g:startuptime = reltime(g:startuptime)
        \ | redraw
        \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
endif

" ネットワーク上ファイルのバックアップ、スワップを作ると重くなるので、作らない
" -> バックアップ、スワップの生成先をローカルに指定していたからかも？要調査
set noswapfile
set nobackup
set nowritebackup

" ファイルの書き込みをしてバックアップが作られるときの設定
" yes  : 元ファイルをコピー  してバックアップにする＆更新を元ファイルに上書き
" no   : 元ファイルをリネームしてバックアップにする＆更新を新ファイルに上書き
" auto : noが使えるならno, 無理ならyes (noの方が処理が速い)
set backupcopy=auto

" Vim生成物の生成先ディレクトリ指定
set dir=~/vimfiles/swap
set backupdir=~/vimfiles/backup

if has('persistent_undo')
  set undodir=~/vimfiles/undo
  set undofile
endif

set viewdir=~/vimfiles/view

" Windowsは_viminfo, Linuxは.viminfoとする
set viminfo+=n~/_viminfo

" 100あれば十分すぎる
set history=100

" 編集中のファイルがVimの外部で変更された時、自動的に読み直す
set autoread

" メッセージ省略設定
set shortmess=aoOotTWI

" カーソル上下に表示する最小の行数(大きい値にして必ず再描画させる)
set scrolloff=0

" scrolloffをスイッチ
let g:scrolloff_on = 0
function! s:ToggleScrollOffSet()
  if g:scrolloff_on == 1
    setlocal scrolloff=0
    echo 'setlocal scrolloff=0'
    let g:scrolloff_on = 0
  else
    setlocal scrolloff=100
    echo 'setlocal scrolloff=100'
    let g:scrolloff_on = 1
  endif
endfunction
command! -nargs=0 ToggleScrollOffSet call s:ToggleScrollOffSet()
nnoremap <silent> <F2> :<C-u>ToggleScrollOffSet<CR>

" VimDiffは基本縦分割とする
set diffopt+=vertical

" makeしたらcopen
autocmd MyAutoCmd QuickfixCmdPost make if len(getqflist()) != 0 | copen | endif

" Load local settings
if filereadable(expand('~/localfiles/local.rc.vim'))
  source ~/localfiles/local.rc.vim
elseif filereadable(expand('~/localfiles/template/local.rc.vim'))
  source ~/localfiles/template/local.rc.vim
endif

"}}}
"-----------------------------------------------------------------------------
" 入力 {{{

set wildmenu
set wildmode=full

" <C-p>や<C-n>でもコマンド履歴のフィルタリングを有効にする
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" タイムスタンプの挿入
function! s:PutTimeStamp()
  let @" = strftime('%Y/%m/%d(%a) %H:%M')
  normal! ""P
endfunction
command! -nargs=0 PutTimeStamp call s:PutTimeStamp()

" 区切り線＋タイムスタンプの挿入
function! s:PutMemoFormat()
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
endfunction
command! -nargs=0 PutMemoFormat call s:PutMemoFormat()

" 全角数字を半角数字に変更(eskk.vimを使っている時は意味がない設定)
inoremap ０ 0
inoremap １ 1
inoremap ２ 2
inoremap ３ 3
inoremap ４ 4
inoremap ５ 5
inoremap ６ 6
inoremap ７ 7
inoremap ８ 8
inoremap ９ 9

" 全角記号を半角記号に変更(eskk.vimを使っている時は意味がない設定)
inoremap ＃ #
inoremap ＄ $
inoremap ％ %
inoremap ． .
inoremap ， ,
inoremap ￥ \
inoremap （ (
inoremap ） )

" 汎用補完設定
" Default: complete=.,w,b,u,t,i
" . :      current buffer
" w :              buffers in other windows
" b : other loaded buffers in the buffer list
" u :     unloaded buffers in the buffer list
" U :              buffers that are not in the buffer list
" t : tag completion
"     -> タグファイルが大きいと時間がかかるので、汎用補完からtを外す
" i : current and included files
"     -> インクルードファイルが多いと時間がかかるので、汎用補完からiを外す
" d : current and included files for defined name or macro
set complete=.,w,b,u,U

set completeopt=menuone " 補完時は対象が一つでもポップアップを表示
set pumheight=10        " 補完候補は一度に10個まで表示

" チルダをoperatorのように使う
set tildeop

" 直前の置換を繰り返す際に最初のフラグ指定を継続して反映する
nnoremap & <silent> :<C-u>&&<CR>
xnoremap & <silent> :<C-u>&&<CR>

"}}}
"-----------------------------------------------------------------------------
" 表示 {{{

" 2行くらいがちょうど良い
set cmdheight=2

if has('gui_running')
  " Ricty for Powerline
  set guifont=Ricty\ for\ Powerline:h12:cSHIFTJIS

  " 行間隔[pixel]の設定(default 1 for Win32 GUI)
  set linespace=0

  if has('kaoriya') && has('win32')
    set ambiwidth=auto
  endif

  set mouse=a      " マウス機能有効
  set nomousefocus " マウスの移動でフォーカスを自動的に切替えない
  set mousehide    " 入力時にマウスポインタを隠す

  " M : メニュー・ツールバー領域を削除する
  " c : ポップアップダイアログを使用しない
  set guioptions=Mc

endif

" カーソルを点滅させない
set guicursor=a:blinkon0

" 入力モードに応じてカーソルの形を変える
" -> Cygwin環境で必要だった気がするので取っておく
if has('vim_starting')
  let &t_ti .= "\e[1 q"
  let &t_SI .= "\e[5 q"
  let &t_EI .= "\e[1 q"
  let &t_te .= "\e[0 q"
endif

set wrap             " 長いテキストの折り返し
set display=lastline " 長いテキストを省略しない

" 81行目に線を表示
set colorcolumn=81

set number           " 行番号を表示
set relativenumber   " 行番号を相対表示
nnoremap <silent> <F10> :<C-u>set relativenumber!<CR>:set relativenumber?<CR>

" 不可視文字の可視化
set list

" 不可視文字の設定(UTF-8特有の文字は使わない方が良い)
set listchars=tab:>-,trail:-,eol:\

" 入力中のキーを画面右下に表示
set showcmd

set showtabline=2 " 常にタブ行を表示する
set laststatus=2  " 常にステータス行を表示する

" 透明度をスイッチ
let g:transparency_on = 0
function! s:ToggleTransParency()
  if g:transparency_on == 1
    set transparency=255
    echo 'set transparency=255'
    let g:transparency_on = 0
  else
    set transparency=220
    echo 'set transparency=220'
    let g:transparency_on = 1
  endif
endfunction
command! -nargs=0 ToggleTransParency call s:ToggleTransParency()
nnoremap <silent> <F12> :<C-u>ToggleTransParency<CR>

" スペルチェックから日本語を除外
set spelllang+=cjk

" fold(折り畳み)機能の設定
set foldcolumn=1
set foldnestmax=1
set fillchars=vert:\|

" ファイルを開いた時点でどこまで折り畳むか
" -> 全て閉じた状態で開く
if has('vim_starting')
  set foldlevel=0
endif

" fold間の移動はzj, zkで行うのでzh, zlに閉じる/開くを割り当てるといい感じ
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
nnoremap <silent> <F9> :set foldenable!<CR>:set foldenable?<CR>

" Hack #120: gVim でウィンドウの位置とサイズを記憶する
" http://vim-jp.org/vim-users-jp/2010/01/28/Hack-120.html
let g:save_winpos_file = expand('~/vimfiles/winpos/.vimwinpos')
if filereadable(g:save_winpos_file)
  autocmd MyAutoCmd VimLeavePre * call s:save_window()
  function! s:save_window()
    let s:options = [
          \ 'set columns=' . &columns,
          \ 'set lines='   . &lines,
          \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
          \ ]
    call writefile(s:options, g:save_winpos_file)
  endfunction
  execute 'source' g:save_winpos_file
endif

"}}}
"-----------------------------------------------------------------------------
" 文字列検索 {{{

" very magic
" -> incsearch.vimでvery magic指定して上書き
nnoremap / /\v

" 大文字小文字を区別しない。区別したい時は検索パターンのどこかに\Cを付ける
set ignorecase " 検索時に大文字小文字を区別しない
set smartcase  " 大文字小文字の両方が含まれている場合は、区別する
set wrapscan   " 検索時に最後まで行ったら最初に戻る
set incsearch  " インクリメンタルサーチ
set hlsearch   " 検索マッチテキストをハイライト

" " 検索状態をバッファ毎に保持する
" " -> 便利な時もあるがバッファ間で共通の方が都合の良いケースが多い
" " http://d.hatena.ne.jp/tyru/20140129/localize_search_options
" " Localize search options.
" autocmd MyAutoCmd WinLeave *
" \     let b:vimrc_pattern = @/
" \   | let b:vimrc_hlsearch = &hlsearch
" autocmd MyAutoCmd WinEnter *
" \     let @/ = get(b:, 'vimrc_pattern', @/)
" \   | let &l:hlsearch = get(b:, 'vimrc_hlsearch', &l:hlsearch)

" " vimgrep/grep後にQuickfixを開く。ただし、候補が0件の場合、Quickfixを開かない
" " 逆にわかりにくい気がしたのでコメントアウト
" autocmd MyAutoCmd QuickfixCmdPost *grep if len(getqflist()) != 0 | copen | endif

"}}}
"-----------------------------------------------------------------------------
" 編集 {{{

if has('vim_starting')
  " Vim内部で使う文字コード
  set encoding=utf-8

  " ファイル書き込み時の文字コード
  " -> 空の場合、encodingで指定した文字コードが使用される
  set fileencoding=

  " ファイル読み込み時の変換候補
  " -> 左から順に判定するので、2byte文字が無いファイルだと最初の候補が選択される？
  "    utf-8以外を左側に持ってきた時にうまく判定できないことがあった。要検証。
  " -> よくわかってないけど, 香り屋版GVimのguessを使おう
  if has('kaoriya')
    set fileencodings=guess
  else
    set fileencodings=utf-8,cp932,euc-jp
  endif
endif

" 文字コードを指定してファイルを開き直す
nnoremap <Leader>enc :<C-u>e ++encoding=

" 改行コードを指定してファイルを開き直す
nnoremap <Leader>ff  :<C-u>e ++fileformat=

" タブ幅、シフト幅、タブ使用有無の設定
set tabstop=2 shiftwidth=2 softtabstop=0 expandtab
autocmd MyAutoCmd FileType c        setlocal tabstop=4 shiftwidth=4
autocmd MyAutoCmd FileType cpp      setlocal tabstop=4 shiftwidth=4
autocmd MyAutoCmd FileType makefile setlocal tabstop=4 shiftwidth=4 noexpandtab

set infercase                   " 補完時に大文字小文字を区別しない
set nrformats=hex               " <C-a>や<C-x>の対象を10進数,16進数に絞る
set virtualedit=all             " テキストが存在しない場所でも動けるようにする
set hidden                      " quit時はバッファを削除せず、隠す
set confirm                     " 変更されたバッファがある時、どうするか確認する
set switchbuf=useopen           " すでに開いてあるバッファがあればそっちを開く
set showmatch                   " 対応する括弧などの入力時にハイライト表示する
set matchtime=3                 " 対応括弧入力時カーソルが飛ぶ時間を0.3秒にする
set matchpairs+=<:>             " 対応括弧に'<'と'>'のペアを追加
set backspace=indent,eol,start  " <BS>でなんでも消せるようにする

" j : 行連結時にコメントリーダーを削除
" l : insertモードの自動改行を無効化
" m : 整形時、255よりも大きいマルチバイト文字間でも改行する
" q : gqでコメント行を整形
autocmd MyAutoCmd BufEnter * setlocal formatoptions=jlmq

" gqで使うtextwidthの設定
autocmd MyAutoCmd BufEnter * setlocal textwidth=80

" autoindentをオフ
autocmd MyAutoCmd BufEnter * setlocal noautoindent

" インデントを入れるキーのリストを調整(コロン, 行頭の#でインデントしない)
" https://gist.github.com/myokota/8b6040da5a3d8b029be0
autocmd MyAutoCmd BufEnter * setlocal indk-=:
autocmd MyAutoCmd BufEnter * setlocal indk-=0#
autocmd MyAutoCmd BufEnter * setlocal cinkeys-=:
autocmd MyAutoCmd BufEnter * setlocal cinkeys-=0#

" Dは実質d$なのにYはyyと同じというのは納得がいかない
nnoremap Y y$

" クリップボードをデフォルトのレジスタとする(GVimではこの設定でOK)
set clipboard=unnamed

" 指定のデータをレジスタに登録する
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

" キー入力タイムアウトはあると邪魔だし、待つ意味も無い気がする
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

" j/kによる移動を折り返されたテキストでも自然に振る舞うようにする
nnoremap j gj
nnoremap k gk

" gj/gkで次の差分hunkへ移動
nnoremap gj ]c
nnoremap gk [c

" Cの関数名にジャンプ
nnoremap <silent> [t :<C-u>execute "normal! m'"
      \              <bar> execute "keepjumps normal! [["
      \              <bar> call search('(','b')
      \              <bar> execute "normal! B"<CR>
nnoremap <silent> ]t :<C-u>execute "normal! m'"
      \              <bar> execute "keepjumps normal! ]]"
      \              <bar> call search('(','b')
      \              <bar> execute "normal! B"<CR>

" <Esc>でヘルプを閉じる
function! s:HelpSettings()
  nnoremap <buffer> <F1>  :<C-u>q<CR>
  nnoremap <buffer> <Esc> :<C-u>q<CR>
endfunction
autocmd MyAutoCmd FileType help call s:HelpSettings()

" 最後のウィンドウがQuickfixウィンドウの場合、自動で閉じる
autocmd MyAutoCmd WinEnter * if (winnr('$') == 1) &&
      \ (getbufvar(winbufnr(0), '&buftype')) == 'quickfix' | quit | endif

" 現在開いているファイルのディレクトリに移動
function! s:ChangeDir(dir)
  lcd %:p:h
  echo 'change directory to: ' . a:dir
endfunction
command! -nargs=0 CD call s:ChangeDir(expand('%:p:h'))

" " 開いたファイルと同じ場所へ移動する
" " -> startify/vimfiler/:CDでcdするので以下の設定は使用しない
" autocmd MyAutoCmd BufEnter * execute 'lcd ' fnameescape(expand('%:p:h'))

" " 最後のカーソル位置を記憶していたらジャンプ
" " -> Gdiff時に不便なことがあったので手動でマークジャンプする
" autocmd MyAutoCmd BufRead * silent normal! `"

" 保存時にViewの状態を保存し、読み込み時にViewの状態を前回の状態に戻す
" http://ac-mopp.blogspot.jp/2012/10/vim-to.html
" -> プラグインの挙動とぶつかることもあるらしいので使わない
" -> https://github.com/Shougo/vimproc.vim/issues/116
" autocmd MyAutoCmd BufWritePost ?* mkview
" autocmd MyAutoCmd BufReadPost  ?* loadview

" 新規タブ生成
nnoremap ,tt :<C-u>tabnew<CR>

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
command! -nargs=0 MessageClear for n in range(200) | echomsg '' | endfor

"}}}
"-----------------------------------------------------------------------------
" tags, path {{{

" 新規タブでタグジャンプ
function! s:TabTagJump(funcName)
  tablast | tabnew
  " ctagsファイルを複数生成してpath登録順で優先順位を付けているなら'tag'にする
  execute 'tag' a:funcName

  " " 1つの大きいctagsファイルを生成している場合はリストから選べる'tjump'にする
  " execute 'tjump' a:funcName
  redraw
endfunction
command! -nargs=1 -complete=tag TabTagJump call s:TabTagJump(<f-args>)
nnoremap <Leader>}     :<C-u>TabTagJump <C-r><C-w><CR>

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

  function! s:SetIncludes()
    let g:syntastic_c_include_dirs = []
    for l:item in g:c_include_dirs
      call add(g:syntastic_c_include_dirs, $TARGET_DIR. '\' . l:item)
    endfor
  endfunction

  call s:SetSrcDir()
  call s:SetTags()
  call s:SetPathList()
  call s:SetCDPathList()

  if neobundle#tap('syntastic')
    call s:SetIncludes()
  endif

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

    if neobundle#tap('syntastic')
      call s:SetIncludes()
    endif

    " ソースコード切り替え後、バージョン名を出力
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
" 誤爆防止関係 {{{

" レジスタ機能のキーを<S-q>にする(Exモードは使わないので潰す)
nnoremap q     <Nop>
nnoremap <S-q> q

" 「保存して閉じる」「保存せず閉じる」を無効にする
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

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

" せっかくなので、カーソルキーでウィンドウ間を移動
nnoremap <Left>  <C-w>h
nnoremap <Down>  <C-w>j
nnoremap <Up>    <C-w>k
nnoremap <Right> <C-w>l

" せっかくなので、Shift + カーソルキーでbprevious/bnext
nnoremap <S-Left>  :<C-u>bprevious<CR>
nnoremap <S-Down>  :<C-u>bnext<CR>
nnoremap <S-Up>    :<C-u>bprevious<CR>
nnoremap <S-Right> :<C-u>bnext<CR>

" せっかくなので、 Ctrl + カーソルキーでcprevious/cnext
nnoremap <C-Left>  :<C-u>cprevious<CR>
nnoremap <C-Down>  :<C-u>cnext<CR>
nnoremap <C-Up>    :<C-u>cprevious<CR>
nnoremap <C-Right> :<C-u>cnext<CR>

" せっかくなので、  Alt + カーソルキーでtabprevious/tabnext
nnoremap <A-Left>  :<C-u>tabprevious<CR>
nnoremap <A-Down>  :<C-u>tabnext<CR>
nnoremap <A-Up>    :<C-u>tabprevious<CR>
nnoremap <A-Right> :<C-u>tabnext<CR>

" F3 command history
nnoremap <F3> <Esc>q:
nnoremap q:   <Nop>

" F4 search history
nnoremap <F4> <Esc>q/
nnoremap q/   <Nop>
nnoremap q?   <Nop>

" <C-@>  : 直前に挿入したテキストをもう一度挿入し、ノーマルモードに戻る
" <C-g>u : アンドゥ単位を区切る
" -> 割りと暴発する&あまり用途が見当たらないので、<Esc>に置き替え
" inoremap <C-@> <C-g>u<C-@>
inoremap <C-@> <Esc>
noremap  <C-@> <Esc>

" 謎のマッピングを使えないようにする
map <S-CR>    <CR>
map <C-CR>    <CR>
map <S-Space> <Space>
map <C-Space> <Space>

"}}}
"-----------------------------------------------------------------------------
" Vim scripts {{{

" カウンタ
function! s:MyCounter() "{{{
  if !exists('b:mycounter')
    let b:mycounter = 0
  else
    let b:mycounter += 1
  endif
  echomsg 'count: ' . b:mycounter

endfunction "}}}
command! -nargs=0 MyCounter call s:MyCounter()

" キーリピート時のCursorMoved autocmdを無効にする、行移動を検出する
" http://d.hatena.ne.jp/gnarl/20080130/1201624546
let g:throttleTimeSpan = 100
function! s:OnCursorMove() "{{{
  " run on normal/visual mode only
  let l:m = mode()
  if m != 'n' && m != 'v'
    let b:IsLineChanged = 0
    let b:IsCursorMoved = 0
    return
  endif

  " 初回のCursorMoved発火時の処理
  if !exists('b:LastVisitedLine')
    let b:IsCursorMoved = 0
    let b:IsLineChanged = 0
    let b:LastVisitedLine = line('.')
    let b:LastCursorMoveTime = 0
  endif

  " ミリ秒単位の現在時刻を取得
  let l:ml = matchlist(reltimestr(reltime()), '\(\d*\)\.\(\d\{3}\)')
  if l:ml == []
    return
  endif
  let l:ml[0] = ''
  let l:now = str2nr(join(l:ml, ''))

  " 前回のCursorMoved発火時からの経過時間を算出
  let l:timespan = l:now - b:LastCursorMoveTime

  " LastCursorMoveTimeを更新
  let b:LastCursorMoveTime = l:now

  " 指定時間経過しているか否かで処理分岐
  if l:timespan <= g:throttleTimeSpan
    let b:IsLineChanged = 0
    let b:IsCursorMoved = 0
    return
  endif

  " CursorMoved!!
  let b:IsCursorMoved = 1

  if b:LastVisitedLine != line('.')
    " LineChanged!!
    let b:IsLineChanged = 1
    let b:LastVisitedLine = line('.')

    " NOTE: If no "User LineChanged" events,
    " Vim says "No matching autocommands".
    autocmd MyAutoCmd User LineChanged :
    doautocmd MyAutoCmd User LineChanged
  else
    let b:IsLineChanged = 0
  endif
endfunction "}}}
autocmd MyAutoCmd CursorMoved * call s:OnCursorMove()

" foldlevel('.')はnofoldenableの時に必ず0を返すので, foldlevelを自分で数える
" NOTE: 1行, 1foldまでとする
function! s:GetFoldLevel() "{{{
  " ------------------------------------------------------------
  " 小細工
  " ------------------------------------------------------------
  " [z, ]zは'foldlevel'が1の時は動作しない。nofoldenableの時は'foldlevel'が
  " 設定される機会がないので、foldlevelに大きめの値をセットして解決する
  " NOTE: 'foldlevel'は「ファイルを開いた時点でどこまで折り畳むか」を設定する
  "       -> 勝手に変更しても問題無い、はず
  if &foldenable == 'nofoldenable'
    setlocal foldlevel=10
  endif

  " ------------------------------------------------------------
  " 前処理
  " ------------------------------------------------------------
  let l:foldlevel = 0
  let l:currentLine = getline('.')
  let l:currentLineNumber = line('.')
  let l:lastLineNumber = l:currentLineNumber

  " Viewを保存
  let l:savedView = winsaveview()

  " モーションの失敗を前提にしたVim scriptを使いたいのでbelloffを使う
  let l:belloff_tmp = &l:belloff
  let &l:belloff = 'error'

  " ------------------------------------------------------------
  " foldlevelをカウント
  " ------------------------------------------------------------
  " 現在の行にfoldmarkerが含まれているかチェック
  let l:pattern = '\v\ \{\{\{$' " for match } } }
  if match(l:currentLine, l:pattern) >= 0
    let l:foldlevel += 1
  endif

  " [zを使ってカーソルが移動していればfoldlevelをインクリメント
  while 1
    keepjumps normal! [z
    let l:currentLineNumber = line('.')
    if l:lastLineNumber == l:currentLineNumber
      break
    endif
    let l:foldlevel += 1
    let l:lastLineNumber = l:currentLineNumber
  endwhile

  " ------------------------------------------------------------
  " 後処理
  " ------------------------------------------------------------
  " 退避していたbelloffを戻す
  let &l:belloff = l:belloff_tmp

  " Viewを復元
  call winrestview(l:savedView)

  return l:foldlevel
endfunction "}}}

" カーソル位置の親Fold名を更新
" NOTE: &ft == 'vim' only
let g:currentFold = ''
function! s:UpdateCurrentFold() "{{{
  " ------------------------------------------------------------
  " 前処理
  " ------------------------------------------------------------
  " foldlevel('.')はあてにならないことがあるので自作関数で求める
  let l:foldlevel = s:GetFoldLevel()
  if l:foldlevel <= 0
    return
  endif

  " View/カーソル位置を保存
  let l:savedView = winsaveview()
  let l:cursorPosition = getcurpos()

  " モーションの失敗を前提にしたVim scriptを使いたいのでbelloffを使う
  let l:belloff_tmp = &l:belloff
  let &l:belloff = 'error'

  " 走査回数の設定
  let l:searchCounter = l:foldlevel

  " 変数初期化
  let l:foldList = []
  let l:currentFold = ''
  let l:lastLineNumber = -1

  " ------------------------------------------------------------
  " カーソル位置の親Fold名を取得
  " ------------------------------------------------------------
  while 1
    if l:searchCounter <= 0
      break
    endif
    keepjumps normal! [z
    let l:currentLine = getline('.')
    let l:currentLineNumber = line('.')
    let l:pattern = '\v^(\"\ )'
    let l:preIndex = ((match(l:currentLine, l:pattern) == -1) ? 0 : 2)
    let l:sufIndex = strlen(l:currentLine)
          \        - ((match(l:currentLine, l:pattern) == -1) ? 6 : 5)
    if l:lastLineNumber != l:currentLineNumber
      call insert(l:foldList, l:currentLine[l:preIndex : l:sufIndex], 0)
    else
      call setpos('.', l:cursorPosition)
      let l:currentLine = getline('.')
      let l:preIndex = ((match(l:currentLine, l:pattern) == -1) ? 0 : 2)
      let l:sufIndex = strlen(l:currentLine)
            \        - ((match(l:currentLine, l:pattern) == -1) ? 6 : 5)
      call add(l:foldList, l:currentLine[l:preIndex : l:sufIndex])
    endif
    let l:lastLineNumber = l:currentLineNumber
    let l:searchCounter -= 1
  endwhile

  " ------------------------------------------------------------
  " 後処理
  " ------------------------------------------------------------
  " Fold情報の生成, 結果の格納
  let l:currentFold = join(l:foldList, " \u2B81 ")
  let g:currentFold = l:currentFold

  " 退避していたbelloffを戻す
  let &l:belloff = l:belloff_tmp

  " Viewを復元
  call winrestview(l:savedView)
endfunction "}}}
command! -nargs=0 UpdateCurrentFold call s:UpdateCurrentFold()
autocmd MyAutoCmd User LineChanged call s:UpdateCurrentFold()

"}}}
"-----------------------------------------------------------------------------
" Plugin Settings {{{

" netrw(Vim標準のファイラ)は使わない {{{
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

"}}}

" スクリプト内関数を書き換える {{{
" http://mattn.kaoriya.net/software/vim/20090826003359.htm
" http://d.hatena.ne.jp/thinca/20090826/1251258056
" http://mattn.kaoriya.net/software/vim/20111202085236.htm
function! GetScriptID(filename)
  let l:snlist = ''
  redir => l:snlist
  silent! scriptnames
  redir END
  let l:smap = {}
  let l:mx = '^\s*\(\d\+\):\s*\(.*\)$'
  for l:line in split(l:snlist, "\n")
    let l:smap[tolower(expand(substitute(l:line, l:mx, '\2', '')))] =
          \ substitute(l:line, l:mx, '\1', '')
  endfor
  return l:smap[tolower(a:filename)]
endfunction

function! GetFunc(filename, funcname)
  let l:sid = GetScriptID(a:filename)
  return function("<SNR>" . l:sid . "_" . a:funcname)
endfunction

function! HookFunc(funcA, funcB)
  if type(a:funcA) == 2
    let l:funcA = substitute(string(a:funcA), "^function('\\(.*\\)')$", '\1', '')
  else
    let l:funcA = a:funcA
  endif
  if type(a:funcB) == 2
    let l:funcB = substitute(string(a:funcB), "^function('\\(.*\\)')$", '\1', '')
  else
    let l:funcB = a:funcB
  endif

  " " 置き換え前の関数定義を退避
  " " -> 退避したところでアレなのでコメントアウト
  " let l:oldfunc = ''
  " redir => l:oldfunc
  " silent! exec "function " . l:funcA
  " redir END
  " let g:hoge = l:oldfunc

  " 関数定義を上書き
  exec "function! " . l:funcA . "(...)\nreturn call('" . l:funcB . "', a:000)\nendfunction"
endfunction "}}}

" Vimでフルスクリーンモード(scrnmode.vim)@Kaoriya版付属プラグイン {{{
if has('kaoriya')

  let g:fullscreen_on = 0
  function! s:ToggleScreenMode()
    if g:fullscreen_on
      execute 'ScreenMode 0'
      let g:fullscreen_on = 0
    else
      execute 'ScreenMode 6'
      let g:fullscreen_on = 1
    endif
  endfunction
  command! -nargs=0 ToggleScreenMode call s:ToggleScreenMode()
  nnoremap <F11> :<C-u>ToggleScreenMode<CR>
  xnoremap <F11> :<C-u>ToggleScreenMode<CR>

endif "}}}

" Vimで辞書を引く(dicwin.vim)@Kaoriya版付属プラグイン {{{
if has('kaoriya')

  if filereadable(expand('~/vimfiles/dict/gene.dict'))
    autocmd MyAutoCmd BufRead *.dict setlocal filetype=dict
    function! s:DicwinSettings()
      nnoremap <buffer> <Esc> :<C-u>q<CR>
    endfunction
    autocmd MyAutoCmd FileType dict call s:DicwinSettings()
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
    " use for neosnippet and eskk.vim only
    let g:neocomplete#sources._ = ['neosnippet']
  else
    " use for eskk.vim only
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

endif "}}}

" コードスニペットによる入力補助(neosnippet.vim) {{{
if neobundle#tap('neosnippet.vim')

  let g:neosnippet#snippets_directory =
        \ '~/.vim/bundle/neosnippet-snippets/neosnippets'

  if neobundle#tap('unite.vim')
    imap <C-s> <Plug>(neosnippet_start_unite_snippet)
  endif

endif "}}}

" 検索やリスト表示の拡張(unite.vim) {{{
if neobundle#tap('unite.vim')

  let g:unite_force_overwrite_statusline = 0
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
          \   '--hidden --nogroup --nocolor --smart-case'
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_grep_encoding = 'utf-8'
  endif

  " unite.vimのデフォルトコンテキストを設定する
  " http://d.hatena.ne.jp/osyo-manga/20140627
  " -> 最初に馴染んだUIは早々変えられない
  " -> なんだかんだ非同期でやって貰う必要が無い気がする
  call unite#custom#profile('default', 'context', {
        \   'start_insert'     : 1,
        \   'prompt'           : '> ',
        \   'prompt_visible'   : 'prompt-visible',
        \   'prompt_direction' : 'top',
        \   'no_empty'         : 0,
        \   'split'            : 0,
        \   'sync'             : 1,
        \ })

  " Unite line/vimgrepの結果候補数を制限しない
  call unite#custom#source('line',    'max_candidates', 0)
  call unite#custom#source('vimgrep', 'max_candidates', 0)

  " /************************************************************************/
  " /* オプション名がやたらめったら長いので変数に入れてみたけど微妙感が漂う */
  " /************************************************************************/
  let g:u_ninp = ' -input='
  let g:u_nqui = ' -no-quit'
  let g:u_prev = ' -auto-preview'
  let g:u_sync = ' -sync'
  let g:u_fbuf = ' -buffer-name=files'
  let g:u_sbuf = ' -buffer-name=search-buffer'
  let g:u_tabo = ' -default-action=tabopen'
  let g:u_nins = ' -no-start-insert -prompt-visible'
  let g:u_hopt = ' -split -horizontal -winheight=20'
  let g:u_vopt = ' -split -vertical -winwidth=90'

  " 各 unite source に応じた変数を定義して使う
  let g:u_opt_bu = g:u_nins                       . g:u_hopt
  " let g:u_opt_bo =                       g:u_vopt
  let g:u_opt_fi =                       g:u_fbuf . g:u_ninp
  " let g:u_opt_fm =                                  g:u_fbuf
  let g:u_opt_gd = g:u_nins                       . g:u_hopt . g:u_sbuf
  let g:u_opt_gg = g:u_nins                                  . g:u_sbuf
  let g:u_opt_gr = g:u_nins                       . g:u_hopt . g:u_sbuf
  let g:u_opt_jj = ''
  let g:u_opt_jn = ''
  let g:u_opt_li = ''
  let g:u_opt_mg = g:u_nins                                  . g:u_sbuf
  let g:u_opt_mk = g:u_nins                       . g:u_hopt
  let g:u_opt_ml = ''
  let g:u_opt_mp = ''
  let g:u_opt_nl = ''
  let g:u_opt_nu = g:u_nins
  let g:u_opt_ol =                                  g:u_vopt
  let g:u_opt_op = ''
  let g:u_opt_re = g:u_nins                                  . g:u_sbuf
  " let g:u_opt_ya = g:u_nins

  " 各unite-source用のマッピング定義もここにまとめる
  " -> 空いているキーがわかりにくくなるのを避けるため
  nnoremap <expr> <Leader>bu ':<C-u>Unite buffer'           . g:u_opt_bu . '<CR>'
  " nnoremap <expr> <Leader>bo ':<C-u>Unite bookmark'       . g:u_opt_bo . '<CR>'
  nnoremap <expr> <Leader>fi ':<C-u>Unite file'             . g:u_opt_fi . '<CR>'
  " nnoremap <expr> <Leader>fm ':<C-u>Unite file_mru'       . g:u_opt_fm . '<CR>'
  nnoremap <expr> <Leader>gd ':<C-u>Unite gtags/def'        . g:u_opt_gd . '<CR>'
  nnoremap <expr> <Leader>g% ':<C-u>Unite vimgrep:%'        . g:u_opt_gg . '<CR>'
  nnoremap <expr> <Leader>g* ':<C-u>Unite vimgrep:*'        . g:u_opt_gg . '<CR>'
  nnoremap <expr> <Leader>g. ':<C-u>Unite vimgrep:.*'       . g:u_opt_gg . '<CR>'
  nnoremap <expr> <Leader>gg ':<C-u>Unite vimgrep:**'       . g:u_opt_gg . '<CR>'
  nnoremap <expr> <Leader>gr ':<C-u>Unite gtags/ref'        . g:u_opt_gr . '<CR>'
  nnoremap <expr> <Leader>jn ':<C-u>Unite junkfile/new'     . g:u_opt_jn . '<CR>'
  nnoremap <expr> <Leader>jj ':<C-u>Unite junkfile'         . g:u_opt_jj . '<CR>'
  nnoremap <expr> <Leader>li ':<C-u>Unite line'             . g:u_opt_li . '<CR>'
  nnoremap <expr> <Leader>mg ':<C-u>Unite vimgrep:~/memofiles/*'
        \                                                   . g:u_opt_mg . '<CR>'
  nnoremap <expr> <Leader>mk ':<C-u>Unite mark'             . g:u_opt_mk . '<CR>'
  nnoremap <expr> <Leader>ml ':<C-u>Unite file:~/memofiles' . g:u_opt_ml . '<CR>'
  nnoremap <expr> <Leader>mp ':<C-u>Unite mapping'          . g:u_opt_mp . '<CR>'
  nnoremap <expr> <Leader>nl ':<C-u>Unite neobundle/lazy'   . g:u_opt_nl . '<CR>'
  nnoremap <expr> <Leader>nu ':<C-u>Unite neobundle/update' . g:u_opt_nu
  nnoremap <expr> <Leader>ol ':<C-u>Unite outline'          . g:u_opt_ol . '<CR>'
  nnoremap <expr> <Leader>op ':<C-u>Unite output'           . g:u_opt_op . '<CR>'
  nnoremap <expr> <Leader>re ':<C-u>UniteResume'            . g:u_opt_re . '<CR>'
  " nnoremap <expr> <Leader>ya ':<C-u>Unite history/yank'   . g:u_opt_ya . '<CR>'

  " call unite#custom_default_action('source/bookmark/directory', 'vimfiler')
  " call unite#custom_default_action('directory_mru',             'vimfiler')

  function! s:UniteSettings()
    imap <buffer> <Esc> <Plug>(unite_insert_leave)
    nmap <buffer> <Esc> <Plug>(unite_exit)

    " Disable yankround.vim
    nnoremap <buffer> <C-n> <Nop>
    nnoremap <buffer> <C-p> <Nop>
  endfunction
  autocmd MyAutoCmd FileType unite call s:UniteSettings()

endif "}}}

" Vim上で動くシェル(vimshell) {{{
if neobundle#tap('vimshell')

  let g:vimshell_enable_start_insert = 0
  let g:vimshell_force_overwrite_statusline = 0

  " 動的プロンプトの設定
  " http://blog.supermomonga.com/articles/vim/vimshell-dynamicprompt.html
  let g:vimshell_prompt_expr = 'getcwd() . ' > ''
  let g:vimshell_prompt_pattern = '^\f\+ > '

  " 開いているファイルのパスでVimShellを開く
  nnoremap <expr> <Leader>vs ':<C-u>VimShellTab<Space>' . expand('%:h') . '<CR>'

endif "}}}

" Vim上で動くファイラ(vimfiler.vim) {{{
if neobundle#tap('vimfiler.vim')

  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_enable_auto_cd = 1
  let g:vimfiler_force_overwrite_statusline = 0
  let g:vimfiler_safe_mode_by_default = 0

  " タブで開く時は自分で指定することにした
  " let g:vimfiler_edit_action = 'tabopen'

  " 開いているファイルのパスでVimFilerを開く
  nnoremap <expr> <Leader>vf ':<C-u>VimFilerTab<Space>' . expand('%:h') . '<CR>'

  " vimfilerのマッピングを一部変更
  function! s:VimfilerSettings()
    " #を<Leader>としているのでsimilarは##にする
    nnoremap <buffer> #  <Nop>
    nmap     <buffer> ## <Plug>(vimfiler_mark_similar_lines)

    if neobundle#tap('unite.vim')
      " Unite vimgrepを使う
      nnoremap <buffer><expr> gr ':<C-u>Unite vimgrep:**' . g:u_opt_gg . '<CR>'

      " Disable yankround.vim
      nnoremap <buffer> <C-n> <Nop>
      nnoremap <buffer> <C-p> <Nop>
    endif

  endfunction
  autocmd MyAutoCmd FileType vimfiler call s:VimfilerSettings()

endif "}}}

" 使い捨てしやすいファイル生成(junkfile.vim) {{{
if neobundle#tap('junkfile.vim')

  let g:junkfile#directory = expand('~/junkfiles')

  " 不要なコマンドを削除する
  function! neobundle#hooks.on_post_source(bundle)
    delcommand JunkfileOpen

  endfunction

endif "}}}

" シンボル、関数の参照位置検索(GNU GLOBAL, gtags.vim) {{{
if neobundle#tap('gtags.vim')

endif "}}}

" for unite-gtags {{{
if neobundle#tap('unite-gtags')

  " " gtagsの結果をファイル毎のツリー形式で表示
  " " -> すごく見やすいが、ファイル名で絞込めなくなるという欠点が…要カイゼン
  " let g:unite_source_gtags_project_config = { '_' : { 'treelize' : 1 } }

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

  " " clangを使う時の設定はこんな感じ？
  " \   'cpp' : {
  " \     'type' : 'cpp/clang3_4'
  " \   },
  " \   'cpp/clang3_4' : {
  " \       'command' : 'clang++',
  " \       'exec'    : '%c %o %s -o %s:p:r',
  " \       'cmdopt'  : '-std=gnu++0x'
  " \   },

  " デフォルトの<Leader>rだと入力待ちになるので、別のキーでマッピングする
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

  " vim-fontzoomには、以下のデフォルトキーマッピングが設定されている
  " -> しかし、Vimの既知のバグでWindows環境ではC-Scrollを使えないらしい。残念。
  " -> https://github.com/vim-jp/issues/issues/73
  nmap <C-ScrollWheelUp>   <Plug>(fontzoom-larger)
  nmap <C-ScrollWheelDown> <Plug>(fontzoom-smaller)

endif "}}}

" vim力を測る(vim-scouter) {{{
if neobundle#tap('vim-scouter')

  nnoremap <leader>sc :<C-u>Scouter ~\dotfiles\.vimrc<CR>

endif "}}}

" Quickfixから置換(vim-qfreplace) {{{
if neobundle#tap('vim-qfreplace')

endif "}}}

" Quickfixに表示されている行を強調表示(vim-hier) {{{
if neobundle#tap('vim-hier')

endif "}}}

" <cword>を強調(vim-brightest) {{{
if neobundle#tap('vim-brightest')

  " " <cword>のみに反映するハイライト
  " let b:brightest#highlight_in_cursorline = {
  "   \   'group' : 'ErrorMsg',
  "   \ }

  " " 強調を始めるまで間を置く
  " set updatetime=50
  " let g:brightest#enable_on_CursorHold = 1

  " " <cword>を含め、<cword>と同じ単語を文字色で強調したい場合
  " let g:brightest#highlight = {
  "   \   'group'    : 'ErrorMsg',
  "   \   'priority' : -1,
  "   \   'format'   : "\<%s\>",
  "   \ }

  " <cword>を含め、<cword>と同じ単語をアンダーラインで強調したい場合
  let g:brightest#highlight = {
        \   'group' : 'BrightestUnderline'
        \ }

  " " <cword>を含め、<cword>と同じ単語を波線で強調したい場合
  " let g:brightest#highlight = {
  "   \   'group' : 'BrightestUndercurl'
  "   \ }

  " " ハイライトする単語のパターンを設定
  " " デフォルト(空の文字列の場合)は<cword>が使用される
  " " NOTE: <cword>は前方にある単語も検出する
  " let g:brightest#pattern = '\k\+'

  " " シンタックスがStatementの場合はハイライトしない
  " " (e.g.) let, if, function
  " let g:brightest#ignore_syntax_list = [ 'Statement' ]

  " " brightestの背景をcursorlineに合わせる
  " let g:brightest#highlight_in_cursorline = {
  "       \   'group' : 'BrightestCursorLineBg'
  "       \ }
  " set cursorline

endif "}}}

" quickrun-hook集(shabadou.vim) {{{
if neobundle#tap('shabadou.vim')

endif "}}}

" Vim上で自動構文チェック(vim-watchdogs) {{{
if neobundle#tap('vim-watchdogs')
  " Caution: 裏で実行した結果を反映しているのか、pause系の処理があると固まる

  let g:watchdogs_check_BufWritePost_enable = 1
  let g:watchdogs_check_BufWritePost_enables = {
        \   'c'    : 1,
        \   'ruby' : 1,
        \ }

  if neobundle#tap('watchdogs.vim')
    " quickrun_configにwatchdogs.vimの設定を追加
    call watchdogs#setup(g:quickrun_config)

  endif

endif "}}}

" Vim上で自動構文チェック(syntastic) {{{
if neobundle#tap('syntastic')
  " Caution: syntasticは非同期チェックできない

  " 必ず手動チェックとする
  let g:syntastic_check_on_wq = 0
  let g:syntastic_mode_map = {
        \   'mode': 'passive'
        \ }

  " エラーにジャンプ、警告は無視
  let g:syntastic_auto_jump = 3

endif "}}}

" My favorite colorscheme(vim-tomorrow-theme) {{{
if neobundle#tap('vim-tomorrow-theme')

  " 現在のカーソル位置をわかりやすくする
  autocmd MyAutoCmd ColorScheme * highlight Cursor
        \   gui=bold guifg=White guibg=Red

  " 検索中にフォーカス位置をわかりやすくする
  autocmd MyAutoCmd ColorScheme * highlight IncSearch
        \   term=reverse cterm=NONE gui=NONE guifg=#1d1f21 guibg=#f0c674

  " IME ONしていることをわかりやすくする
  if has('multi_byte_ime') || has('xim')
    autocmd MyAutoCmd ColorScheme * highlight CursorIM guibg=Purple guifg=NONE
  endif

  colorscheme Tomorrow-Night

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

  nnoremap <Leader>mn :<C-u>MemoNew<CR>

endif "}}}

" markdownを使いやすくする(vim-markdown) {{{
if neobundle#tap('vim-markdown')

  " markdownのfold機能を無効にする
  let g:vim_markdown_folding_disabled = 1

endif "}}}

" ファイルをブラウザで開く(previm) {{{
if neobundle#tap('previm')

  let g:previm_enable_realtime = 1

endif "}}}

" markdownをブラウザでプレビュー(mdforvim) {{{
if neobundle#tap('mdforvim')

endif "}}}

" Vimからブラウザを開く(open-browser) {{{
if neobundle#tap('open-browser.vim')

  nmap <Leader>L <Plug>(openbrowser-smart-search)
  xmap <Leader>L <Plug>(openbrowser-smart-search)

endif "}}}

" Visualモードでインクリメント/デクリメント(vim-visualinc) {{{
if neobundle#tap('vim-visualinc')

  " for Lazy
  xmap <C-a> <Plug>(visualinc-increment)
  xmap <C-x> <Plug>(visualinc-decrement)

endif "}}}

" 連番入力補助(vim-rengbang) {{{
if neobundle#tap('vim-rengbang')

  let g:rengbang_default_start = 1
  map <A-r> <Plug>(operator-rengbang)

  " 不要なコマンドを削除する
  function! neobundle#hooks.on_post_source(bundle)
    delcommand RengBang
    delcommand RengBangConfirm
    delcommand RengBangUsePrev

  endfunction

endif "}}}

" 囲む / 囲まなくする / 別の何かで囲む(vim-surround) {{{
if neobundle#tap('vim-surround')

  " " (例) sw' /* 次の単語を''で囲む */
  " nmap s <plug>Ysurround
  "
  " " (例) S'  /* カーソル行以降を''で囲む */
  " nmap S <plug>Ysurround$
  "
  " " (例) ss' /* 行を''で囲む */
  " nmap ss <plug>Yssurround

endif "}}}

" 置き換えオペレータ(vim-operator-replace) {{{
if neobundle#tap('vim-operator-replace')

  map R <Plug>(operator-replace)

  " " 置換モードは滅多に使わないし, 潰してもいいかな...
  " noremap <A-r> R

endif "}}}

" 関数内検索(vim-textobj-function with vim-operator-search) {{{
if neobundle#tap('vim-textobj-function')

  let g:textobj_function_no_default_key_mappings = 1

  if neobundle#tap('vim-operator-search')
    nmap <Leader>f/ <Plug>(operator-search)<Plug>(textobj-function-i)
  endif

endif "}}}

" 連続で打鍵した時、指定した候補をループさせる(vim-smartchr) {{{
if neobundle#tap('vim-smartchr')

  " inoremap <expr>+     smartchr#one_of('+',     '++',           ' + ')
  " inoremap <expr>-     smartchr#one_of('-',     '--',           ' - ')
  " inoremap <expr>%     smartchr#one_of('%',     '%%',           ' % ')
  " inoremap <expr>:     smartchr#one_of(':',     '::',           ' : ')
  " inoremap <expr>&     smartchr#one_of('&',     ' && ',         ' & ')
  " inoremap <expr><Bar> smartchr#one_of('<Bar>', ' <Bar><Bar> ', ' <Bar> ')
  " inoremap <expr>,     smartchr#one_of(',',     ', ')
  " inoremap <expr>?     smartchr#one_of('?',     ' ? ')

  " 「->」は入力しづらいので、..で置換え
  inoremap <expr> . smartchr#one_of('.', '->', '..')

  " " if文直後の(は自動で間に空白を入れる
  " " -> 時々空白を入れたくない時があるので、とりあえずコメントアウト
  " inoremap <expr> ( search("\<\if\%#", 'bcn') ? ' (' : '('

  " ruby / eruby の時だけ設定
  autocmd MyAutoCmd FileType ruby,eruby call s:RubySettings()
  function! s:RubySettings()
    inoremap <buffer> <expr> { smartchr#one_of('{', '#{', '{{')
    " for match }} } } }
  endfunction

endif "}}}

" コマンドの結果をバッファに表示する(capture.vim) {{{
if neobundle#tap('capture.vim')

  let g:capture_open_command = 'botright 12sp new'

  nnoremap <Leader>who :<C-u>Capture echo expand('%:p')<CR>
  nnoremap <Leader>sn  :<C-u>Capture scriptnames<CR>

endif "}}}

" 自由にテキストハイライト(vim-quickhl) {{{
if neobundle#tap('vim-quickhl')

  map <A-h> <Plug>(operator-quickhl-manual-this-motion)

  " " QuickhlManualResetも一緒にやってしまうと間違えて消すのが若干怖い
  " " -> ambicmdのおかげで :qmr<Space> で呼び出せるのでコメントアウト
  " nmap <silent> <Esc> :<C-u>nohlsearch<CR>:<C-u>QuickhlManualReset<CR>

endif "}}}

" incsearchをパワーアップ(incsearch.vim) {{{
if neobundle#tap('incsearch.vim')

  " very magic
  let g:incsearch#magic = '\v'

  " 検索後、カーソル移動すると自動でnohlsearchする
  " -> 自動でnohlsearchするべきか非常に悩ましい
  " let g:incsearch#auto_nohlsearch = 1

  if has('kaoriya') && has('migemo')
    if !neobundle#is_installed('incsearch-migemo.vim')
      " 逆方向migemo検索g?を有効化
      set migemo

      " kaoriya版のmigemo searchを再マッピング
      noremap m/ g/
      noremap m? g?
    endif
  endif

  " 入力中に飛びたくないのでstayのみ使う
  " map /  <Plug>(incsearch-forward)
  " map ?  <Plug>(incsearch-backward)
  noremap <silent> <expr> / incsearch#go({'command' : '/', 'is_stay' : 1})
  noremap <silent> <expr> ? incsearch#go({'command' : '?', 'is_stay' : 1})

  if neobundle#tap('vim-anzu')
    map n  <Plug>(incsearch-nohl)<Plug>(anzu-n-with-echo)
    map N  <Plug>(incsearch-nohl)<Plug>(anzu-N-with-echo)

  else
    map n  <Plug>(incsearch-nohl-n)
    map N  <Plug>(incsearch-nohl-N)

  endif

  " アスタリスク検索の対象をクリップボードにコピー
  if neobundle#tap('vim-asterisk') && neobundle#tap('vim-anzu')
    nmap *          yiw<Plug>(incsearch-nohl0)<Plug>(asterisk-z*)<Plug>(anzu-update-search-status-with-echo)
    omap *     <Esc>yiw<Plug>(incsearch-nohl0)<Plug>(asterisk-z*)<Plug>(anzu-update-search-status-with-echo)
    xmap *  <Esc>gvyvgv<Plug>(incsearch-nohl0)<Plug>(asterisk-z*)<Plug>(anzu-update-search-status-with-echo)

    nmap g*         yiw<Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)<Plug>(anzu-update-search-status-with-echo)
    omap g*    <Esc>yiw<Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)<Plug>(anzu-update-search-status-with-echo)
    xmap g* <Esc>gvyvgv<Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)<Plug>(anzu-update-search-status-with-echo)

  elseif neobundle#tap('vim-asterisk')
    nmap *          yiw<Plug>(incsearch-nohl0)<Plug>(asterisk-z*)
    omap *     <Esc>yiw<Plug>(incsearch-nohl0)<Plug>(asterisk-z*)
    xmap *  <Esc>gvyvgv<Plug>(incsearch-nohl0)<Plug>(asterisk-z*)

    nmap g*         yiw<Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)
    omap g*    <Esc>yiw<Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)
    xmap g* <Esc>gvyvgv<Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)

  else
    nmap *          yiw<Plug>(incsearch-nohl-*)
    omap *     <Esc>yiw<Plug>(incsearch-nohl-*)
    xmap *  <Esc>gvyvgv<Plug>(incsearch-nohl-*)

    nmap g*         yiw<Plug>(incsearch-nohl-g*)
    omap g*    <Esc>yiw<Plug>(incsearch-nohl-g*)
    xmap g* <Esc>gvyvgv<Plug>(incsearch-nohl-g*)

  endif
endif "}}}

" incsearch.vimをパワーアップ(incsearch-fuzzy.vim) {{{
if neobundle#tap('incsearch-fuzzy.vim')

  " 入力中に飛びたくないのでstayのみ使う
  map z/ <Plug>(incsearch-fuzzy-stay)
  map zz/ <Plug>(incsearch-fuzzyspell-stay)

endif "}}}

" incsearch.vimをパワーアップ(incsearch-migemo.vim) {{{
if neobundle#tap('incsearch-migemo.vim')

  " 入力中に飛びたくないのでstayのみ使う
  map g/ <Plug>(incsearch-migemo-stay)

endif "}}}

" asterisk検索をパワーアップ(vim-asterisk) {{{

if neobundle#tap('vim-asterisk')

  if !neobundle#tap('incsearch.vim')
    nmap *          yiw<Plug>(asterisk-z*)
    omap *     <Esc>yiw<Plug>(asterisk-z*)
    xmap *  <Esc>gvyvgv<Plug>(asterisk-z*)

    nmap g*         yiw<Plug>(asterisk-gz*)
    omap g*    <Esc>yiw<Plug>(asterisk-gz*)
    xmap g* <Esc>gvyvgv<Plug>(asterisk-gz*)

  endif

endif "}}}

" 何番目の検索対象か／検索対象の総数を表示(vim-anzu) {{{
if neobundle#tap('vim-anzu')

  " " 検索対象横にechoする。視線移動は減るが結構見づらくなるので慣れが必要
  " nmap n <Plug>(anzu-mode-n)
  " nmap N <Plug>(anzu-mode-N)
  "
  " " 検索開始時にジャンプせず、その場でanzu-modeに移行する
  " nmap <expr>* ':<C-u>call anzu#mode#start('<C-R><C-W>', '', '', '')<CR>'

  " nmap * <Plug>(anzu-star-with-echo)N

  if !neobundle#tap('incsearch.vim')
    " コマンド結果出力画面にecho
    nmap n <Plug>(anzu-n-with-echo)
    nmap N <Plug>(anzu-N-with-echo)

  endif

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

  " 不要なコマンドを削除する
  function! neobundle#hooks.on_post_source(bundle)
    nmap gj <Plug>(signify-next-hunk)zz
    nmap gk <Plug>(signify-prev-hunk)zz
    nmap gh <Plug>(signify-toggle-highlight)

    delcommand SignifyDebug
    delcommand SignifyDebugDiff
    delcommand SignifyDebugUnknown
    delcommand SignifyFold
    delcommand SignifyRefresh

  endfunction

endif "}}}

" VimからGitを使う(編集、コマンド実行、vim-fugitive) {{{
if neobundle#tap('vim-fugitive')

  autocmd MyAutoCmd FileType gitcommit setlocal nofoldenable

endif "}}}

" VimからGitを使う(コミットツリー表示、管理、agit.vim) {{{
if neobundle#tap('agit.vim')

  function! s:AgitSettings()
    nmap <buffer> ch <Plug>(agit-git-cherry-pick)
    nmap <buffer> Rv <Plug>(agit-git-revert)

    " Disable yankround.vim
    nnoremap <buffer> <C-n> <Nop>
    nnoremap <buffer> <C-p> <Nop>

  endfunction
  autocmd MyAutoCmd FileType agit call s:AgitSettings()
  autocmd MyAutoCmd FileType agit_diff setlocal nofoldenable

endif "}}}

" VimからGitを使う(ブランチ管理、vim-merginal) {{{
if neobundle#tap('vim-merginal')

endif "}}}

" カーソル位置の関数を取得(current-func-info.vim) {{{
let g:currentFunc = ''
if neobundle#tap('current-func-info.vim')

  " 処理負荷が気になるのでUser LineChangedでcurrentFuncを更新
  " autocmd MyAutoCmd User LineChanged
  "       \   if &ft == 'c'
  "       \ | try | let g:currentFunc = cfi#get_func_name() | endtry
  "       \ | endif

  function! s:ClipCurrentTag(funcName)
    if strlen(a:funcName) == 0
      echo 'There is no function nearby cursor.'
      return
    endif

    " 選択範囲レジスタ(*)を使う
    let @* = a:funcName
    echo 'clipped: ' . a:funcName

    " ついでにcurrentFuncを更新
    if &ft == 'c'
      try | let g:currentFunc = cfi#get_func_name() | endtry
    endif
  endfunction
  command! -nargs=0 ClipCurrentTag
        \ call s:ClipCurrentTag(cfi#get_func_name())

  function! s:PrintCurrentTag(funcName)
    if strlen(a:funcName) == 0
      echo 'There is no function nearby cursor.'
      return
    endif

    " 無名レジスタ(")を使う
    let @" = a:funcName
    normal! ""P
    echo 'print current tag: ' . a:funcName

    " ついでにcurrentFuncを更新
    if &ft == 'c'
      try | let g:currentFunc = cfi#get_func_name() | endtry
    endif
  endfunction
  command! -nargs=0 PrintCurrentTag
        \ call s:PrintCurrentTag(cfi#get_func_name())

endif "}}}

" カッコいいステータスラインを使う(lightline.vim) {{{
if neobundle#tap('lightline.vim')

  let g:lightline = {}

  if neobundle#tap('lightline-hybrid.vim')
    let g:lightline.colorscheme = 'hybrid'
  endif

  let g:lightline.mode_map     = { 'c'    : 'NORMAL'                     }
  let g:lightline.separator    = { 'left' : "\u2B80", 'right' : "\u2B82" }
  let g:lightline.subseparator = { 'left' : "\u2B81", 'right' : "\u2B83" }
  let g:lightline.tabline      = { 'left': [ [ 'tabs' ] ], 'right': []   }

  let g:lightline.active = {
        \   'left'  : [ [ 'mode' ],
        \               [ 'skkmode', 'fugitive', 'filename', 'currentfunc' ], ],
        \   'right' : [ [ 'lineinfo' ],
        \               [ 'percent' ],
        \               [ 'fileformat', 'fileencoding', 'filetype' ], ]
        \ }

  " for using git properly
  " \               [ 'skk-mode', 'gita-branch', 'filename', 'currenttag' ], ],

  let g:lightline.component_function = {
        \   'modified'     : 'MyModified',
        \   'readonly'     : 'MyReadonly',
        \   'filename'     : 'MyFilename',
        \   'fileformat'   : 'MyFileformat',
        \   'filetype'     : 'MyFiletype',
        \   'fileencoding' : 'MyFileencoding',
        \   'mode'         : 'MyMode',
        \   'skkmode'      : 'MySKKMode',
        \   'fugitive'     : 'MyFugitive',
        \   'currentfunc'  : 'MyCurrentFunc',
        \ }

  " for using git properly
  " \   'gita-branch'  : 'MyGitaBranch',

  function! MyModified()
    return &ft =~ 'help\|vimfiler\'   ? ''          :
          \               &modified   ? "\<Space>+" :
          \               &modifiable ? ''          : "\<Space>-"
  endfunction

  function! MyReadonly()
    return &ft !~? 'help\|vimfiler\' && &readonly ? "\<Space>\u2B64" : ''
  endfunction

  function! MyFilename()
    " 以下の条件を満たすと処理負荷が急激に上がる。理由は不明
    " ・Vimのカレントディレクトリがネットワーク上
    " ・ネットワーク上のファイルを開いており、ファイル名をフルパス(%:p)出力
    " -> GVIMウィンドウ上部にフルパスが表示されているので、そちらを参照する
    if       neobundle#is_installed('unite.vim')    &&
          \  neobundle#is_installed('vimfiler.vim') &&
          \  neobundle#is_installed('vimshell.vim')
      return (&ft == 'unite'       ? unite#get_status_string()    :
            \ &ft == 'vimfiler'    ? vimfiler#get_status_string() :
            \ &ft == 'vimshell'    ? vimshell#get_status_string() :
            \  '' != expand('%:t') ? expand('%:t')                : '[No Name]') .
            \ ('' != MyReadonly()  ? MyReadonly()                 : ''         ) .
            \ ('' != MyModified()  ? MyModified()                 : ''         )
    else
      return (&ft == 'unite'       ? ''            :
            \ &ft == 'vimfiler'    ? ''            :
            \ &ft == 'vimshell'    ? ''            :
            \  '' != expand('%:t') ? expand('%:t') : '[No Name]') .
            \ ('' != MyReadonly()  ? MyReadonly()  : ''         ) .
            \ ('' != MyModified()  ? MyModified()  : ''         )
    endif
    return ''
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
    if neobundle#is_installed('eskk.vim')
      let l:CurrentMode = eskk#statusline()

      " 初回の処理
      if !exists('b:LastMode')
        " モードを覚えておく
        let b:LastMode = l:CurrentMode
        NeoCompleteLock
      endif

      " モード変更時の処理
      if l:CurrentMode != b:LastMode
        " normal -> skk
        if b:LastMode == ''
          " 必要ならunlock
          if neocomplete#get_current_neocomplete().lock == 0
            let b:IsAlreadyUnlocked = 1
          else
            NeoCompleteUnlock
          endif

          " skk -> normal
        else
          " 必要ならlock
          if exists('b:IsAlreadyUnlocked')
            unlet b:IsAlreadyUnlocked
          else
            NeoCompleteLock
          endif

        endif
        " 直前のモード情報を更新
        let b:LastMode = l:CurrentMode
      endif

      return winwidth(0) > 30 ? l:CurrentMode : ''
    endif
    return ''
  endfunction

  function! MyCurrentFunc()
    if &ft == 'vim'
      return winwidth(0) > 70 ? g:currentFold : ''
    else
      return winwidth(0) > 70 ? g:currentFunc : ''
    endif
  endfunction

  function! MyFugitive()
    if &ft != 'vimfiler' && neobundle#is_installed('vim-fugitive')
      try
        let l:_ = fugitive#head()
        return winwidth(0) > 30 ? (strlen(l:_) ? '⭠ ' . l:_ : '') : ''
      endtry
    endif
    return ''
  endfunction

  function! MyGitaBranch()
    if &ft != 'vimfiler' && neobundle#is_installed('vim-gita')
      try
        let l:_ = gita#statusline#preset('branch_fancy')
        return winwidth(0) > 30 ? (strlen(l:_) ? l:_ : '') : ''
      endtry
    endif
    return ''
  endfunction

endif "}}}

" Cygwin Vimでクリップボード連携(vim-fakeclip) {{{
if neobundle#tap('vim-fakeclip')

  xmap <Leader>y <Plug>(fakeclip-y)
  nmap <Leader>p <Plug>(fakeclip-p)

endif "}}}

" pからの<C-n>,<C-p>でクリップボード履歴をぐるぐる(yankround.vim) {{{
if neobundle#tap('yankround.vim')

  let g:yankround_dir = '~/.cache/yankround'
  let g:yankround_region_hl_groupname = 'ErrorMsg'

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

" f検索を便利に(clever-f.vim) {{{
if neobundle#tap('clever-f.vim')

  let g:clever_f_smart_case = 1

  " " fは進む、Fは戻るで固定する
  " " -> Vimの標準の挙動は0
  " let g:clever_f_fix_key_direction = 1

  " let g:clever_f_chars_match_any_signs = ';'

  " for Lazy
  let g:clever_f_not_overwrites_standard_mappings = 1
  nmap f <Plug>(clever-f-f)
  xmap f <Plug>(clever-f-f)
  omap f <Plug>(clever-f-f)
  nmap F <Plug>(clever-f-F)
  xmap F <Plug>(clever-f-F)
  omap F <Plug>(clever-f-F)
  nmap t <Plug>(clever-f-t)
  xmap t <Plug>(clever-f-t)
  omap t <Plug>(clever-f-t)
  nmap T <Plug>(clever-f-T)
  xmap T <Plug>(clever-f-T)
  omap T <Plug>(clever-f-T)

endif "}}}

" f検索の2文字版(vim-sneak) {{{
if neobundle#tap('vim-sneak')

  let g:sneak#s_next = 1     " clever-sな挙動にする
  let g:sneak#use_ic_scs = 1 " ignorecaseやらsmartcaseの設定を反映する

  " " sは進む、Sは戻るで固定する
  " " -> Vimの標準の挙動は0
  " let g:sneak#absolute_dir = 1

  " s-sneak
  nmap s <Plug>Sneak_s
  nmap S <Plug>Sneak_S
  xmap s <Plug>Sneak_s
  xmap S <Plug>Sneak_S
  omap s <Plug>Sneak_s
  omap S <Plug>Sneak_S

endif "}}}

" コメントアウト/コメントアウト解除を簡単に(caw.vim) {{{
if neobundle#tap('caw.vim')

  nmap <Leader>c <Plug>(caw:i:toggle)
  xmap <Leader>c <Plug>(caw:i:toggle)

endif "}}}

" Vimのマーク機能を使いやすく(vim-signature) {{{
if neobundle#tap('vim-signature')

  " " お試しとして、グローバルマークだけ使うようにしてみる
  " " -> viminfoに直接書き込まれるためか、消しても反映されないことが多々
  " let g:SignatureIncludeMarks = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

  " _viminfoファイルからグローバルマークの削除を行う
  " -> Unix系だと「~/.viminfo」、Windowsだと「~/_viminfo」を対象とする
  " -> Windowsでは_viminfoが書き込み禁止になり削除失敗するので無効化する
  let g:SignatureForceRemoveGlobal = 0

  " これだけあれば十分
  " mm       : ToggleMarkAtLine
  " m<Space> : PurgeMarks
  nmap mm m.

  " 不要なコマンドを削除する
  function! neobundle#hooks.on_post_source(bundle)
    delcommand SignatureListMarkers
    delcommand SignatureListMarks
    delcommand SignatureRefresh
    delcommand SignatureToggleSigns

  endfunction

endif "}}}

" vimにスタート画面を用意(vim-startify) {{{
if neobundle#tap('vim-startify')

  let g:startify_files_number = 2
  let g:startify_change_to_dir = 1
  let g:startify_session_dir = '~/vimfiles/session'

  " ブックマークの設定はローカル設定ファイルに記述する
  " see: ~/localfiles/local.rc.vim
  " let g:startify_bookmarks = [
  "   \   '.',
  "   \   '~\.vimrc',
  "   \ ]

  let g:startify_list_order = [
        \   [ 'My bookmarks:' ],        'bookmarks',
        \   [ 'My sessions:' ],         'sessions',
        \   [ 'Recently used files:' ], 'files',
        \ ]

  nnoremap ,, :<C-u>Startify<CR>

  " 不要なコマンドを削除する
  function! neobundle#hooks.on_post_source(bundle)
    delcommand StartifyDebug

    " :Restartすると何故かGVimがエラー終了するPCがあるので...
    " delcommand SLoad
    " delcommand SSave
    " delcommand SDelete

    " SCloseは期待する動作ではないので消す
    delcommand SClose

  endfunction

endif "}}}

" %で対応するキーワードを増やす(matchit) {{{
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

" vimdiffをパワーアップする(vim-improved-diff) {{{
if neobundle#tap('vim-improved-diff')

endif "}}}

" vimでskkする(eskk.vim) {{{
if neobundle#tap('eskk.vim')

  if has('kaoriya')
    autocmd MyAutoCmd VimEnter * set imdisable
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
  " nmap <expr> <C-i> "i\<C-j>"
  nmap <expr> <C-j> "i\<C-j>"

  " インクリメントは潰せない
  " nmap <expr> <C-a> "a\<C-j>"
  nmap <expr> <A-j> "a\<C-j>"

  " もっとすぐにskkしたい
  nmap <expr> <A-i> "I\<C-j>"
  nmap <expr> <A-a> "A\<C-j>"

  " " oも使いたいが、<C-o>はjumplist戻るなので潰せない。Oは我慢
  " nmap <expr> <C-o> "o\<C-j>"
  nmap <expr> <A-o> "o\<C-j>"

  " もっともっとすぐにskkしたい
  nmap <expr> <C-s> "s\<C-j>"
  nmap <expr> <A-c> "C\<C-j>"
  nmap <expr> <A-s> "S\<C-j>"

  autocmd MyAutoCmd User eskk-initialize-pre call s:eskk_initial_pre()
  function! s:eskk_initial_pre()
    let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
    " hankaku -> zenkaku
    call t.add_map('~',  '～')

    call eskk#register_mode_table('hira', t)
  endfunction

  " skk-jisyoをソートしたい
  if filereadable(expand('~/dotfiles/.skk-jisyo'))
    function! s:SortSKKDictionary()
      let l:savedView = winsaveview()
      execute "keepjumps normal! 0ggjv/okuri\<CR>k:sort\<CR>v\<Esc>"
      execute "keepjumps normal! /okuri\<CR>0jvG:sort\<CR>\<Esc>"
      call winrestview(l:savedView)
      echo 'ソートしました!!'
    endfunction

    function! s:SKKDictionarySettings()
      command! -nargs=0 -buffer SortSKKDictionary call s:SortSKKDictionary()
    endfunction
    autocmd MyAutoCmd FileType skkdict call s:SKKDictionarySettings()
  endif

endif "}}}

" 元の状態を復元してVimを再起動(restart.vim) {{{
if neobundle#tap('restart.vim')

  command! -nargs=0 -bar RestartWithSession
        \   let g:restart_sessionoptions =
        \   'blank,curdir,folds,help,localoptions,tabpages'
        \ | Restart

endif "}}}

" VimScript変数の中身を整形して出力(vim-prettyprint) {{{
if neobundle#tap('vim-prettyprint')

  " 不要なコマンドを削除する
  function! neobundle#hooks.on_post_source(bundle)
    delcommand PrettyPrint

  endfunction

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
    nnoremap <buffer> <Esc> :<C-u>q<CR>
  endfunction
  autocmd MyAutoCmd FileType scratch call s:ScratchVimSettings()

  " 不要なコマンドを削除する
  function! neobundle#hooks.on_post_source(bundle)
    delcommand Scratch
    delcommand ScratchInsert
    delcommand ScratchSelection

  endfunction

endif "}}}

" Vimでプレゼンテーション(vim-showtime) {{{
if neobundle#tap('vim-showtime')

  " s:hide_cursorを置き換えたい
  function! s:hide_cursor()
    highlight Cursor gui=NONE ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE
  endfunction

  " " Sourceされてもautoloadは実行時まで読み込まれないので、以下はできないはず…
  " function! neobundle#hooks.on_post_source(bundle)
  "   call HookFunc(GetFunc(expand('~/.vim/bundle/vim-showtime/autoload/showtime.vim'), 'hide_cursor'),
  "         \       GetFunc(expand('~/.vimrc'), 'hide_cursor'))
  " endfunction

  " 初回実行時は必ず失敗するコマンドをsilentで実行してautoloadを読ませて置き換え
  " -> イケてないけど動くしいいか...
  let g:showtime_vim = expand('~/.vim/bundle/vim-showtime/autoload/showtime.vim')
  if neobundle#tap('vim-brightest')
    command! -nargs=0 -bar Showtime
          \   silent! ShowtimeResume
          \ | call HookFunc(GetFunc(g:showtime_vim    , 'hide_cursor'),
          \                 GetFunc(expand('~/.vimrc'), 'hide_cursor'))
          \ | BrightestDisable
          \ | ShowtimeStart
          \ | delcommand Showtime
  else
    command! -nargs=0 -bar Showtime
          \   silent! ShowtimeResume
          \ | call HookFunc(GetFunc(g:showtime_vim    , 'hide_cursor'),
          \                 GetFunc(expand('~/.vimrc'), 'hide_cursor'))
          \ | ShowtimeStart
          \ | delcommand Showtime
  endif

endif "}}}

" Vimでミニマップ(vim-minimap) {{{
if has('python') && filereadable(expand($VIM . '/_curses.pyd'))
  if neobundle#tap('vim-minimap')
    map <Leader>mm :Minimap<CR>

    function! neobundle#hooks.on_post_source(bundle)
      set virtualedit=onemore
    endfunction
  endif
endif "}}}

"}}}
"-----------------------------------------------------------------------------

