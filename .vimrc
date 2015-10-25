" .vimrc for 香り屋版GVim

"-----------------------------------------------------------------------------
" 初期設定 {{{

" 実は不要なnocompatible
" http://rbtnn.hateblo.jp/entry/2014/11/30/174749
if &compatible
  set nocompatible          " Vi互換モードをオフ(Vimの拡張機能を有効化)
endif
filetype plugin indent off  " ftpluginは最後に読み込むため、一旦オフする

" Neo Bundleを使う
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle'))

" NeoBundle自体の更新をチェックする
NeoBundleFetch 'Shougo/neobundle.vim'

" Vim Plugin List

NeoBundle 'Shougo/vimproc.vim', {
  \   'build' : {
  \     'windows' : 'tools\\update-dll-mingw',
  \     'cygwin'  : 'make -f make_cygwin.mak',
  \     'mac'     : 'make -f make_mac.mak',
  \     'unix'    : 'make -f make_unix.mak',
  \   },
  \ }
" NeoBundle 'Shougo/neocomplete.vim'
" NeoBundle 'Shougo/neoinclude.vim'
" NeoBundle 'Shougo/neosnippet'
" NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/unite.vim',
" NeoBundle 'Shougo/neossh.vim'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vimfiler.vim'

" NeoBundleLazy 'Shougo/neomru.vim',
"   \ { 'autoload' : { 'unite_sources' : [ 'file_mru' ] } }
" NeoBundleLazy 'Shougo/neoyank.vim',
"   \ { 'autoload' : { 'unite_sources' : [ 'history/yank' ] } }
NeoBundle 'vim-scripts/gtags.vim'
NeoBundleLazy 'hewes/unite-gtags',
  \ { 'autoload' : { 'unite_sources' : [ 'gtags/ref', 'gtags/def' ] } }
NeoBundleLazy 'Shougo/junkfile.vim',
  \ { 'autoload' : { 'unite_sources' : [ 'junkfile', 'junkfile/new' ] } }
NeoBundleLazy 'tacroe/unite-mark',
  \ { 'autoload' : { 'unite_sources' : [ 'mark' ] } }
NeoBundleLazy 'Shougo/unite-outline',
  \ { 'autoload' : { 'unite_sources' : [ 'outline' ] } }

" NeoBundle 'Valloric/YouCompleteMe'
" NeoBundle 'SirVer/ultisnips'

" === Windows 64bit YCMを頑張ってbuildする方法 === {{{
" X. 基本は下記URLのInstructions for 64-bit using MinGW64 (clang)に従う
"    https://github.com/Valloric/YouCompleteMe/wiki/Windows-Installation-Guide
"    (手順13.は不要。手順に従ってコピーすると、それ古いから。と怒られる)
" 1. python-2.7.8.amd64.msiを落としてくる。pythonを入れる
" 2. libpython27.aを落としてくる。(手順中にリンクが貼ってある)
" 3. cmake-3.0.0-win32-x86.exeを落としてくる。cmakeを入れる
" 4. llvm-3.4-mingw-w64-4.8.1-x86-posix-sjljを落として解凍、C:\LLVMにリネーム
" 5. 手順に従ってmakeすると、エラーが出る
"    (Boostの関数tss_cleanup_implemented()が多重定義)
"    YouCompleteMe\third_party\ycmd\cpp\BoostParts\libs\thread\src\win32\
"    tss_dll.cppの最終行付近のtss_cleanup_implemented()あたりをコメントアウト
" 6. make ycm_support_libsが成功したらYCMが使えるようになってるはず
" ================================================ }}}

" === Windows 32bit YCMを頑張ってbuildする方法 === {{{
" X. 基本は下記URLのInstructions for 64-bit using MinGW64 (clang)に従う
"    https://github.com/Valloric/YouCompleteMe/wiki/Windows-Installation-Guide
"    (手順13.は不要。手順に従ってコピーすると、それ古いから。と怒られる)
"    -> MinGW32の手順が無いので、64bitの手順をいい感じに読み替える
"       こちらでは"コンパイルエラーが起きないので、ファイル差し替えは不要"
" 1. python-2.7.8.msiを落としてくる。pythonを入れる
" 2. 手順1.でlibpython27.aがついてくるので何もしなくてOK。手順3に進む
" 3. cmake-3.0.0-win32-x86.exeを落としてくる。cmakeを入れる
" 4. llvm-3.4-mingw-w64-4.8.1-x86-posix-sjljを落として解凍、C:\LLVMにリネーム
" 5. 手順に従ってmakeすると、エラーが出ないので何もしなくてOK。手順6に進む
" 6. make ycm_support_libsが成功したらYCMが使えるようになってるはず
"
" Y. YCMのmake完了後、GVim起動時にランタイムエラーが出る
"    -> 環境変数からCMakeへのPathを消す。msvcrXXX.dllの異なるバージョンへPathが
"       通っているとエラーになるらしい。Kaoriya Vimだけ残し、他はすべて消す
" ================================================ }}}

" NeoBundle 'thinca/vim-singleton'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-ambicmd'
NeoBundle 'thinca/vim-fontzoom'
NeoBundleLazy 'thinca/vim-scouter',
  \ { 'autoload' : { 'commands' : ['Scouter'] } }
" NeoBundle 'thinca/vim-submode'
" NeoBundle 'thinca/vim-qfreplace'

" NeoBundle 'osyo-manga/vim-watchdogs'
" NeoBundle 'osyo-manga/shabadou.vim'
NeoBundle 'jceb/vim-hier'
NeoBundle 'osyo-manga/vim-operator-search'
NeoBundle 'osyo-manga/vim-brightest'

NeoBundle 'chriskempson/vim-tomorrow-theme'
" NeoBundle 'vim-scripts/aspvbs.vim'  " syntax for ASP/VBScript
" NeoBundle 'vim-scripts/vbnet.vim'   " syntax for VB.NET
" NeoBundleLazy 'hachibeeDI/vim-vbnet',
"   \ { 'autoload' : { 'filetypes' : ['vbnet'] } }
" NeoBundleLazy 'mattn/benchvimrc-vim',
"   \ { 'autoload' : { 'commands' : ['BenchVimrc'] } }
" NeoBundle 'koron/codic-vim'
" NeoBundle 'scrooloose/syntastic'

" memolist.vimはmarkdown形式でメモを生成するので、markdownを使いやすくしてみる
" http://rcmdnk.github.io/blog/2013/11/17/computer-vim/#plasticboyvim-markdown
NeoBundleLazy 'glidenote/memolist.vim',
  \ { 'autoload' : { 'commands' : ['MemoNew', 'MemoList'] } }
NeoBundle 'rcmdnk/vim-markdown'
NeoBundleLazy 'kannokanno/previm',
  \ { 'autoload' : { 'commands' : ['PrevimOpen'] } }

NeoBundle 'tyru/open-browser.vim'
" NeoBundle 'mattn/webapi-vim'

" NeoBundle 'tyru/vim-altercmd'
" NeoBundle 'tpope/vim-repeat'
" NeoBundle 'tpope/vim-speeddating'

" 最新Vimでは標準搭載になったぽい？
NeoBundle 'deris/vim-visualinc'

NeoBundleLazy 'deris/vim-rengbang',
  \ { 'autoload' : { 'commands' : ['RengBang'] } }
NeoBundle 'tpope/vim-surround'

NeoBundle 'kana/vim-operator-user'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kana/vim-operator-replace'
NeoBundle 'kana/vim-textobj-function'

NeoBundle 'kana/vim-smartchr'
NeoBundleLazy 'tyru/capture.vim',
  \ { 'autoload' : { 'commands' : ['Capture'] } }
NeoBundle 't9md/vim-quickhl'

NeoBundle 'haya14busa/incsearch.vim'
NeoBundle 'haya14busa/incsearch-fuzzy.vim'
NeoBundle 'haya14busa/incsearch-migemo.vim'
NeoBundle 'osyo-manga/vim-anzu'
NeoBundle 'haya14busa/vim-asterisk'

NeoBundle 'mhinz/vim-signify'

NeoBundle 'tpope/vim-fugitive'
NeoBundleLazy 'cohama/agit.vim',
  \ { 'autoload' : { 'commands' : ['Agit'] } }
NeoBundleLazy 'idanarye/vim-merginal',
  \ { 'autoload' : { 'commands' : ['Merginal'] } }

NeoBundleLazy 'majutsushi/tagbar',
  \ { 'autoload' : { 'commands' : ['TagbarToggle'] } }

NeoBundle 'itchyny/lightline.vim'
NeoBundle 'cocopon/lightline-hybrid.vim'

" 画面の再描画を含むプラグインとの相性が悪いようなので、使わないことにする
" NeoBundle 'LeafCage/foldCC.vim'

" Cygwin Vimでは使う
" NeoBundleLazy 'kana/vim-fakeclip'
NeoBundle 'LeafCage/yankround.vim'
NeoBundleLazy 'junegunn/vim-easy-align',
  \ { 'autoload' : { 'commands' : ['EasyAlign'] } }
NeoBundleLazy 'bronson/vim-trailing-whitespace',
  \ { 'autoload' : { 'commands' : ['FixWhitespace'] } }
NeoBundleLazy 'vim-scripts/BufOnly.vim',
  \ { 'autoload' : { 'commands' : ['BOnly', 'Bonly', 'BufOnly', 'Bufonly'] } }

NeoBundle 'justinmk/vim-sneak'
NeoBundle 'rhysd/clever-f.vim'

NeoBundle 'tyru/caw.vim'
NeoBundle 'kshenoy/vim-signature'

NeoBundle 'mhinz/vim-startify'

NeoBundle 'tmhedberg/matchit'

NeoBundleLazy 'basyura/J6uil.vim',
  \ { 'autoload' : { 'commands' : ['J6uil'] } }

" NeoBundleLazy 'AndrewRadev/linediff.vim',
"   \ { 'autoload' : { 'commands' : ['Linediff'] } }
NeoBundle 'lambdalisue/vim-unified-diff'
NeoBundle 'lambdalisue/vim-improve-diff'

call neobundle#end()

filetype plugin indent on " ファイルタイプの自動検出をONにする

" 構文解析ON
syntax enable

" .vimrcに書いてあるプラグインがインストールされているかチェックする
NeoBundleCheck

" Load local settings
if filereadable(expand('$HOME/localfiles/local.rc.vim'))
  source $HOME/localfiles/local.rc.vim
elseif filereadable(expand('$HOME/localfiles/template/local.rc.vim'))
  source $HOME/localfiles/template/local.rc.vim
endif

" The end of 初期設定 }}}
"-----------------------------------------------------------------------------
" 基本設定 {{{

let g:mapleader = "#" " 左手で<Leader>を入力したい
set helplang=en     " 日本語ヘルプを卒業したい

" メッセージ省略設定
set shortmess=aoOotTWI

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
set viminfo+=n~/_viminfo    " Windowsは_viminfo, Linuxは.viminfoとする
set history=100             " 100あれば十分すぎる

" 編集中のファイルがVimの外部で変更された時、自動的に読み直す
set autoread

" " カーソル上下に表示する最小の行数(大きい値にして必ず再描画させる)
" set scrolloff=50

" 再描画がうっとおしいのでやっぱり0にする。再描画必要なら<C-e>や<C-y>を使う
set scrolloff=0

" VimDiffは基本縦分割とする
set diffopt+=vertical

" makeしたらcopen
autocmd MyAutoCmd QuickfixCmdPost make if len(getqflist()) != 0 | copen | endif

" The end of 基本設定 }}}
"-----------------------------------------------------------------------------
" 入力 {{{

set wildmenu
set wildmode=full

" <C-p>や<C-n>でもコマンド履歴のフィルタリングを有効にする
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" 区切り線＋タイムスタンプの挿入
function! s:PutMemoFormat()
  let @"='='
  normal! 080""Po
  let @"=strftime("%Y/%m/%d(%a) %H:%M")
  normal! ""PA {{{
  normal! o}}}
  normal! ko
endfunction
command! -nargs=0 PutMemoFormat call s:PutMemoFormat()

" 全角数字を半角数字に変更
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

" 全角記号を半角記号に変更
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
" w :              buffer in other windows
" b : other loaded buffer in the buffer list
" u :     unloaded buffer in the buffer list
" t : tag completion
"     -> タグファイルが大きいと時間がかかるので、汎用補完からtを外す
" i : current and included files
"     -> インクルードファイルが多いと時間がかかるので、汎用補完からiを外す
" d : current and included files for defined name or macro
set complete=.,w,b,u

" 補完時は対象が一つでもポップアップを表示
set completeopt=menuone

" 補完候補は一度に10個まで表示
set pumheight=10

" 直前の置換を繰り返す際に最初のフラグ指定を継続して反映する
nnoremap & <silent> :<C-u>&&<CR>
xnoremap & <silent> :<C-u>&&<CR>

" The end of 入力 }}}
"-----------------------------------------------------------------------------
" 表示 {{{

" 2行くらいがちょうど良い
set cmdheight=2

if has('gui_running')
  " フォント種/フォントサイズ設定
  if has('win32')
    set guifont=Ricty\ for\ Powerline:h12:cSHIFTJIS
    set linespace=0 " 行間隔[pixel]の設定(default 1 for Win32 GUI)
    if has('kaoriya')
      set ambiwidth=auto
    endif
  elseif has('mac')
    set guifont=Osaka－等幅:h14
  elseif has('xfontset')
    " UNIX用 (xfontsetを使用)
    set guifontset=a14,r14,k14
  endif

  set mouse=a      " マウス機能有効
  set nomousefocus " マウスの移動でフォーカスを自動的に切替えない
  set mousehide    " 入力時にマウスポインタを隠す

  " M : メニュー・ツールバー領域を削除する
  " c : ポップアップダイアログを使用しない
  set guioptions=Mc
  if &guioptions =~# 'M'
    let &guioptions = substitute(&guioptions, '[mT]', '', 'g')
  endif

endif

" 入力モードに応じてカーソルの形を変える
" -> Cygwin環境で必要だった気がするので取っておく
let &t_ti .= "\e[1 q"
let &t_SI .= "\e[5 q"
let &t_EI .= "\e[1 q"
let &t_te .= "\e[0 q"

set wrap             " 長いテキストの折り返し
set display=lastline " なっが～いテキストを省略しない
set colorcolumn=81   " 81行目に線を表示

set number         " 行番号の表示
set relativenumber " 行番号を相対表示
nnoremap <silent> <F10> :<C-u>set relativenumber!<CR>

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
function! ToggleTransParency()
  if g:transparency_on
    set transparency=255
    let g:transparency_on = 0
  else
    set transparency=220
    let g:transparency_on = 1
  endif
endfunction

nnoremap <silent> <F2> :<C-u>call ToggleTransParency()<CR>

" スペルチェックから日本語を除外
set spelllang+=cjk

" スペルチェック機能をスイッチ
nnoremap <silent> <F3> :<C-u>set spell!<CR>

" fold(折り畳み)機能の設定
set foldcolumn=1
set foldlevel=0
set foldnestmax=1
set fillchars=vert:\|
nnoremap <Leader>h  zc
nnoremap <Leader>l  zo
nnoremap <Leader>j  ]z
nnoremap <Leader>k  [z
nnoremap <Leader>fc zM
nnoremap <Leader>fo zR

set foldmethod=marker
set commentstring=%s

" " 差分ファイル確認時は折り畳み無効
" autocmd MyAutoCmd FileType diff setlocal nofoldenable

" 折りたたみ機能をスイッチ
nnoremap <silent> <F12> :set foldenable!<CR>

" The end of 表示 }}}
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
" " -> 便利な時もあるんだけど、バッファ間で共通の方が都合の良いケースが多い
" " http://d.hatena.ne.jp/tyru/20140129/localize_search_options
" " Localize search options.
" autocmd MyAutoCmd WinLeave *
" \     let b:vimrc_pattern = @/
" \   | let b:vimrc_hlsearch = &hlsearch
" autocmd MyAutoCmd WinEnter *
" \     let @/ = get(b:, 'vimrc_pattern', @/)
" \   | let &l:hlsearch = get(b:, 'vimrc_hlsearch', &l:hlsearch)

" grep結果が0件の場合、Quickfixを開かない
autocmd MyAutoCmd QuickfixCmdPost grep if len(getqflist()) != 0 | copen | endif

" The end of 文字列検索 }}}
"-----------------------------------------------------------------------------
" 編集 {{{

set encoding=utf-8                  " utf-8をデフォルトエンコーディングとする
set fileencodings=utf-8,sjis,euc-jp " 文字コード自動判定候補

" " 文字コード判別はしばらくKaoriya Vimに任せてみる
" " -> Windows(utf-8, sjis), Unix(euc-jp)意識せず両方使いたい
" if !has('win64')
"   " 以下のファイルの時は文字コードをsjisに設定
"   autocmd MyAutoCmd FileType c        set fileencoding=sjis
"   autocmd MyAutoCmd FileType cpp      set fileencoding=sjis
"   autocmd MyAutoCmd FileType make     set fileencoding=sjis
"   autocmd MyAutoCmd FileType sh       set fileencoding=sjis
"   autocmd MyAutoCmd FileType cfg      set fileencoding=sjis
"   autocmd MyAutoCmd FileType awk      set fileencoding=sjis
"   autocmd MyAutoCmd FileType dosbatch set fileencoding=sjis
"   autocmd MyAutoCmd FileType vb       set fileencoding=sjis
" endif

" 文字コードを指定してファイルを開き直す
nnoremap <Leader>enc :<C-u>e ++enc=

" 改行コードを指定してファイルを開き直す
nnoremap <Leader>ff  :<C-u>e ++ff=

" タブ幅、シフト幅、タブ使用有無の設定
autocmd MyAutoCmd BufEnter *          setlocal tabstop=2 shiftwidth=2 expandtab
autocmd MyAutoCmd BufEnter *.c        setlocal tabstop=4 shiftwidth=4 expandtab
autocmd MyAutoCmd BufEnter *.cpp      setlocal tabstop=4 shiftwidth=4 expandtab
autocmd MyAutoCmd BufEnter .gitconfig setlocal tabstop=2 shiftwidth=2 noexpandtab
autocmd MyAutoCmd BufEnter makefile   setlocal tabstop=4 shiftwidth=4 noexpandtab
autocmd MyAutoCmd BufEnter *.md       setlocal tabstop=4 shiftwidth=4 noexpandtab
autocmd MyAutoCmd BufEnter *.markdown setlocal tabstop=4 shiftwidth=4 noexpandtab

set infercase                   " 補完時に大文字小文字を区別しない
set nrformats=hex               " <C-a>や<C-x>の対象を10進数,16進数に絞る
set virtualedit=all             " テキストが存在しない場所でも動けるようにする
set hidden                      " quit時はバッファを削除せず、隠す
set switchbuf=useopen           " すでに開いてあるバッファがあればそっちを開く
set showmatch                   " 対応する括弧などの入力時にハイライト表示する
set matchtime=3                 " 対応括弧入力時カーソルが飛ぶ時間を0.3秒にする
set matchpairs& matchpairs+=<:> " 対応括弧に'<'と'>'のペアを追加
set backspace=indent,eol,start  " <BS>でなんでも消せるようにする

" " 自動改行を無効化
" set textwidth=0

" " Kaoriya版ではvimrc_exampleの都合、以下の設定をするらしいが上手くいかない
" autocmd MyAutoCmd BufEnter text setlocal textwidth=0

" autoindentをオフ
autocmd MyAutoCmd BufEnter * setlocal noautoindent

" /**************************************************************************/
" /* formatoptions (Vim default: "tcq", Vi default: "vt")                   */
" /* t : Auto-wrap text using textwidth                                     */
" /* c : Auto-wrap comments using textwidth, inserting the current comment  */
" /*     leader automatically.                                              */
" /* q : Allow formatting of comments with "gq".                            */
" /* l : Long lines are not broken in insert mode                           */
" /**************************************************************************/

" " コメント記入中に自動改行させない
" autocmd MyAutoCmd BufEnter * setlocal formatoptions-=c
"
" " コメントを自動挿入させない
" autocmd MyAutoCmd BufEnter * setlocal formatoptions-=r
" autocmd MyAutoCmd BufEnter * setlocal formatoptions-=o
"
" " 日本語も自動改行させないのでmMは削除
" autocmd MyAutoCmd BufEnter * setlocal formatoptions-=m
" autocmd MyAutoCmd BufEnter * setlocal formatoptions-=M
"
" " insertモードに入った時の自動改行はさせない
" autocmd MyAutoCmd BufEnter * setlocal formatoptions+=l

" 長々と書いてコメントアウトしているけれど、要するにこれだけあれば良い
autocmd MyAutoCmd BufEnter * setlocal formatoptions=l

" Dは実質d$なのにYはyyと同じというのは納得がいかない
nnoremap Y y$

" クリップボードをデフォルトのレジスタとする(GVimではこの設定でOK)
set clipboard=unnamed

" 指定のデータをレジスタに登録する
" https://gist.github.com/pinzolo/8168337
function! s:Clip(data)
  let @*=a:data
  echo "clipped: " . a:data
endfunction

" 現在開いているファイルのパスをレジスタへ
command! -nargs=0 ClipPath call s:Clip(expand('%:p'))

" 現在開いているファイルのファイル名をレジスタへ
command! -nargs=0 ClipFile call s:Clip(expand('%:t'))

" 現在開いているファイルのディレクトリパスをレジスタへ
command! -nargs=0 ClipDir  call s:Clip(expand('%:p:h'))

" コマンドの出力結果をクリップボードに格納
function! s:CopyCmdOutput(cmd)
  redir @*>
  silent execute a:cmd
  redir END
endfunction
command! -nargs=1 -complete=command CopyCmdOutput call s:CopyCmdOutput(<q-args>)

" " 1行以内の編集でも quote1 ～ quote9 に保存
" " http://sgur.tumblr.com/post/63476292878/vim
" " -> 無いと不便かよくわからないので、一旦コメントアウト
" function! s:update_numbered_registers()
"   let reg = getreg('"')
"   if len(split(reg, '\n')) == 1 && reg != getreg(1)
"     for s:i in range(9, 2, -1)
"       call setreg(s:i, getreg(s:i-1))
"     endfor
"     call setreg(1, reg)
"   endif
" endfunction
"
" autocmd MyAutoCmd TextChanged * call s:update_numbered_registers()

" <C-@>  : 直前に挿入したテキストをもう一度挿入し、ノーマルモードに戻る
" <C-g>u : アンドゥ単位を区切る
inoremap <C-@> <C-g>u<C-@>

" The end of 編集 }}}
"-----------------------------------------------------------------------------
" 操作の簡単化 {{{

" <C-[>はVim内部で<Esc>として扱われるので注意(<Esc>のマッピングが適用)
" <Esc>は遠いし、<C-[>は押しにくいイメージ、<C-c>はInsertLeaveが発生しない
" jjは一時的な入力が発生して精神衛生上よろしくない。そこで<C-j>を使う
" -> eskk.vimで<C-j>を使うみたいなので、試すときは注意
inoremap <C-j> <Esc>
inoremap <C-[> <Esc>

" /*******************************************************************/
" /* IMEに関して、以下のように設定しておくと良い感じになる           */
" /* -> IME OFFしたくない時は<C-[>を使う                             */
" /* MS-IMEの設定            : <C-j> 入力/変換済み文字なし ; IME OFF */
" /* MS-IMEの設定            : <Esc> 入力/変換済み文字なし ; IME OFF */
" /* Google 日本語入力の設定 : <C-j> 入力文字なし          ; IME OFF */
" /* Google 日本語入力の設定 : <Esc> 入力文字なし          ; IME OFF */
" /*******************************************************************/

" iminsert=2だとinsertモードに入った時にIME ONになって邪魔
autocmd MyAutoCmd BufEnter * setlocal iminsert=0

" 日本語検索はmigemoで十分
autocmd MyAutoCmd BufEnter * setlocal imsearch=0

" コマンドモードで日本語が使えないと何かと不便(ファイル名、ディレクトリ名など)
" if has('kaoriya')
"   autocmd MyAutoCmd InsertLeave * setlocal imdisable
"   autocmd MyAutoCmd InsertEnter * setlocal noimdisable
" endif

set notimeout " キー入力タイムアウトはあると邪魔だし、待つ意味も無い気がする

" 閉じる系の入力を簡易化
nnoremap <C-q><C-q> :<C-u>bdelete<CR>
nnoremap <C-w><C-w> :<C-u>close<CR>

" フォーカスがあたっているウィンドウ以外閉じる
nnoremap ,o  :<C-u>only<CR>

" .vimrcをリロード
nnoremap ,r :<C-u>source $MYVIMRC<CR><Esc>

" " オート版は違和感あったりlightlineの表示がおかしくなったりで微妙
" autocmd MyAutoCmd BufWritePost $MYVIMRC source $MYVIMRC

" 検索テキストハイライトを消す
nnoremap <silent> <Esc> :<C-u>nohlsearch<CR>

" j, k による移動を折り返されたテキストでも自然に振る舞うようにする
nnoremap j gj
nnoremap k gk

" カーソルキーでウィンドウ間を移動
nnoremap <Left>  <C-w>h
nnoremap <Down>  <C-w>j
nnoremap <Up>    <C-w>k
nnoremap <Right> <C-w>l

" 最後のウィンドウがQuickfixウィンドウの場合、自動で閉じる
autocmd MyAutoCmd WinEnter * if (winnr('$') == 1) &&
  \ (getbufvar(winbufnr(0), '&buftype')) == 'quickfix' | quit | endif

" " 開いたファイルと同じ場所へ移動する
" " startify/vimfilerの機能でcdするので以下の設定は使用しない
" autocmd MyAutoCmd BufEnter * execute 'lcd ' fnameescape(expand('%:p:h'))

" 保存時にViewの状態を保存し、読み込み時にViewの状態を前回の状態に戻す
" http://ac-mopp.blogspot.jp/2012/10/vim-to.html
" パターンマッチが修正前だと:helpなどにも反応してしまうので修正
" -> プラグインの挙動とぶつかってエラーになるらしいこともあるらしいので使わない
"    https://github.com/Shougo/vimproc.vim/issues/116
" autocmd MyAutoCmd BufWritePost ?* mkview
" autocmd MyAutoCmd BufReadPost  ?* loadview

" 新規タブ生成
nnoremap ,tt :<C-u>tabnew<CR>

" 新規タブでgf
nnoremap tgf :<C-u>execute 'tablast <bar> tabfind ' . expand('<cfile>')<CR>

" 新規タブでvimdiff
" 引数が1つ     : カレントバッファと引数指定ファイルの比較
" 引数が2つ以上 : 引数指定ファイル同士の比較
" http://koturn.hatenablog.com/entry/2013/08/10/034242
function! s:VimDifInNewTab(...)
  if a:0 == 1
    tabedit %:p
    execute 'rightbelow vertical diffsplit ' .a:1
  else
    execute 'tabedit ' a:1
    for l:file in a:000[1 :]
      execute 'rightbelow vertical diffsplit ' . l:file
    endfor
  endif
endfunction
command! -bar -nargs=+ -complete=file Diff call s:VimDifInNewTab(<f-args>)

" The end of 操作の簡単化 }}}
"-----------------------------------------------------------------------------
" tags, path {{{

" タグジャンプ時に候補が複数あった場合リスト表示
" -> リスト表示したい時だけg付ければ良い気がしてきた
" nnoremap <C-]> g<C-]>zz

" 新規タブでタグジャンプ
function! s:TabTagJump(ident)
  tablast | tabnew
  " ctagsファイルを複数生成して優先順位を付けているなら'tag'にする
  execute 'tag' a:ident

  " " 1つの大きいctagsファイルを生成している場合はリストから選べる'tjump'にする
  " execute 'tjump' a:ident
endfunction
command! -nargs=1 TabTagJump call s:TabTagJump(<f-args>)
nnoremap t<C-]> :<C-u>TabTagJump <C-r><C-w><CR>

" ソースディレクトリの設定はローカル設定ファイルに記述する
" see: $HOME/localfiles/local.rc.vim
if filereadable(expand('$HOME/localfiles/local.rc.vim'))

  function! s:SetSrcDir()
    let g:numberOfSrc = len(g:src_ver_list)
    let $TARGET_VER = g:src_ver_list[g:indexOfSrc]
    let $TARGET_DIR = $SRC_DIR . '\' . $TARGET_VER
    let $CTAGS_DIR = $TARGET_DIR . '\.tags'
  endfunction

  function! s:SetTags()
    set tags=

    for l:item in g:target_dir_ctags_list
      let $SET_TAGS= $CTAGS_DIR. '\' . g:target_dir_ctags_name_list[l:item]
      set tags+=$SET_TAGS
    endfor

    " GTAGSROOTの登録
    " -> GNU Globalのタグはルートで生成する
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

    " ソースコード切り替え後、バージョン名を出力
    echo "change source to: " . $TARGET_VER

  endfunction
  command! -nargs=0 SwitchSource call s:SwitchSource()
  nnoremap ,s :<C-u>SwitchSource<CR>

  " ctagsをアップデート
  function! s:UpdateCtags()
    if !isdirectory($CTAGS_DIR)
      call system('mkdir ' . $CTAGS_DIR)
    endif
    for l:item in g:target_dir_ctags_list
      let s:exists = has_key(g:target_dir_ctags_name_list, l:item)
      if !s:exists
        echo s:exists
        continue
      endif
      let l:upCmd =
        \ 'ctags -f ' .
        \ $TARGET_DIR . '\.tags\' . g:target_dir_ctags_name_list[l:item] . ' -R ' .
        \ $TARGET_DIR . '\' . l:item
      if neobundle#tap('vimproc.vim')
        call system(l:upCmd)
        " call vimproc#system(l:upCmd)
      else
        call system(l:upCmd)
      endif
    endfor
  endfunction
  command! -nargs=0 UpdateCtags call s:UpdateCtags()

endif

" 現在開いているファイルのディレクトリに移動
function! s:ChangeDir(dir)
  cd %:p:h
  echo "change directory to: " . a:dir
endfunction
command! -nargs=0 CD call s:ChangeDir(expand('%:p:h'))

" The end of tags, path }}}
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
inoremap <Up>    <Nop>
inoremap <Down>  <Nop>
inoremap <Left>  <Nop>
inoremap <Right> <Nop>

" F5 command history
nnoremap <F5> <Esc>q:
nnoremap q:   <Nop>

" F6 search history
nnoremap <F6> <Esc>q/
nnoremap q/   <Nop>
nnoremap q?   <Nop>

" The end of 誤爆防止関係 }}}
"-----------------------------------------------------------------------------
" Plugin Settings {{{

" Vimでフルスクリーンモード(scrnmode.vim)@Kaoriya版付属プラグイン {{{
if has('kaoriya')

  let g:fullscreen_on = 0
  function! s:ToggleScreenMode()
    if g:fullscreen_on
      execute "ScreenMode 0"
      let g:fullscreen_on = 0
    else
      execute "ScreenMode 6"
      let g:fullscreen_on = 1
    endif
  endfunction
  command! -nargs=0 ToggleScreenMode call s:ToggleScreenMode()
  nnoremap <F11> :<C-u>ToggleScreenMode<CR>

endif " }}}

" 入力補完(neocomplete.vim) {{{
if neobundle#tap('neocomplete.vim')

  let g:neocomplete#use_vimproc = 1
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_smart_case = 1
  let g:neocomplete#auto_completion_start_length = 2
  let g:neocomplete#skip_auto_completion_time = '0.2'

  " 使用する補完の種類を指定
  if !exists('g:neocomplete#sources')
    let g:neocomplete#sources = {}
  endif
  if neobundle#tap('neoinclude.vim')
    let g:neocomplete#sources._ =
      \ ['file/include', 'member', 'buffer', 'neosnippet']
  else
    let g:neocomplete#sources._ =
      \ ['member', 'buffer', 'neosnippet']
  endif

  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif

  " 日本語を補完候補として取得しない
  let g:neocomplete#keyword_patterns._ = '\h\w*'

endif " }}}

" インクルード補完(neoinclude.vim) {{{
if neobundle#tap('neoinclude.vim')
  call neobundle#config({
    \   'autoload' : {
    \     'on_source' : [ 'neocomplete.vim' ]
    \   }
    \ })

endif " }}}

" 入力補助(neosnippet) {{{
if neobundle#tap('neosnippet')
  call neobundle#config({
    \   'autoload' : {
    \     'on_source' : [ 'neocomplete.vim' ]
    \   }
    \ })

  " デフォルトのスニペットはコーディング規約と離れたものになっているので要修正
  let g:neosnippet#snippets_directory =
    \ '~/.vim/bundle/neosnippet-snippets/neosnippets'

  " neocompleteとneosnippetを良い感じに使うためのキー設定
  " http://kazuph.hateblo.jp/entry/2013/01/19/193745
  imap <expr> <TAB> pumvisible() ? "\<C-n>" :
    \     neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
  smap <expr> <TAB>
    \     neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
  inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
  imap <C-k> <Plug>(neosnippet_expand_or_jump)
  smap <C-k> <Plug>(neosnippet_expand_or_jump)

endif " }}}

" 検索やリスト表示の拡張(unite.vim) {{{
if neobundle#tap('unite.vim')

  let g:unite_force_overwrite_statusline = 0
  let g:unite_split_rule = 'botright'
  let g:unite_source_history_yank_enable = 1
  let g:unite_enable_ignore_case = 1
  let g:unite_source_find_max_candidates = 0

  " for jvgrep
  " -> 色付けできるらしいけど、unite grepしても単色になってる
  if executable('jvgrep')
    let $JVGREP_OUTPUT_ENCODING = 'sjis'
    let g:unite_source_grep_command = 'jvgrep'
    let g:unite_source_grep_default_opts = '-i --exclude ''\.(git|hg)'''
    let g:unite_source_grep_recursive_opt = '-R'
    let g:unite_source_grep_max_candidates = 500
  endif

  " unite.vimのデフォルトコンテキストを設定する
  " http://d.hatena.ne.jp/osyo-manga/20140627
  " -> ホントはstart-insertにしたいけど処理速度の都合でエラーが出ることがしばしば
  call unite#custom#profile('default', 'context', {
    \   'start_insert'     : 0,
    \   'prompt_direction' : 'top',
    \   'prompt_visible'   : '1',
    \   'no-empty'         : 1,
    \   'split'            : 0,
    \   'sync'             : 1,
    \ })

  " Unite lineの結果候補数を制限しない
  call unite#custom#source('line', 'max_candidates', 0)

  " /**************************************************************************/
  " /* オプション名がやたらめったら長いので変数に入れてみたけど微妙感が漂う   */
  " /**************************************************************************/
  let g:u_ninp = ' -input='
  let g:u_nqui = ' -no-quit'
  let g:u_prev = ' -auto-preview'
  let g:u_sync = ' -sync'
  let g:u_fbuf = ' -buffer-name=files'
  let g:u_sbuf = ' -buffer-name=search-buffer'
  let g:u_bufo = ' -default-action=persist_open'
  let g:u_tabo = ' -default-action=tabopen'
  let g:u_sins = ' -start-insert'
  let g:u_nins = ' -no-start-insert'
  let g:u_hopt = ' -split -horizontal'
  let g:u_vopt = ' -split -vertical -winwidth=75'

  " 各 unite source に応じた変数を定義して使う
  let g:u_opt_bu = ''
  " let g:u_opt_bo =                       g:u_vopt
  let g:u_opt_fi =            g:u_tabo            . g:u_fbuf . g:u_ninp
  " let g:u_opt_fm =                                  g:u_fbuf
  let g:u_opt_gd =                       g:u_nqui . g:u_vopt
  let g:u_opt_gg =                                  g:u_sbuf . g:u_sync
  let g:u_opt_gr =                       g:u_nqui . g:u_vopt
  let g:u_opt_jj = ''
  let g:u_opt_jn =                                             g:u_sins
  let g:u_opt_li = ''
  let g:u_opt_mm =                       g:u_vopt
  let g:u_opt_mp = ''
  let g:u_opt_ol =                       g:u_vopt            . g:u_sins
  let g:u_opt_op = ''
  let g:u_opt_re =                       g:u_sbuf
  " let g:u_opt_ya =                                             g:u_nins

  " Auto Preview が上手く動かないことが多い謎
  " -> 重すぎてプレビュー表示に時間がかかっているだけだった
  " let g:u_opt_bu =          g:u_prev
  " let g:u_opt_gd =          g:u_prev . g:u_nqui . g:u_vopt
  " let g:u_opt_gg =          g:u_prev . g:u_nqui . g:u_sbuf . g:u_sync
  " let g:u_opt_gr =          g:u_prev . g:u_nqui . g:u_vopt
  " let g:u_opt_mm =          g:u_prev            . g:u_vopt

  " 各unite-source用のマッピング定義は別に用意した方が良いが、ここにまとめる
  " -> 空いているキーがわかりにくくなるデメリットの方が大きいため
  nnoremap <expr> <Leader>bu ':<C-u>Unite buffer'       . g:u_opt_bu . '<CR>'
  " nnoremap <expr> <Leader>bo ':<C-u>Unite bookmark'     . g:u_opt_bo . '<CR>'
  nnoremap <expr> <Leader>fi ':<C-u>Unite file'         . g:u_opt_fi . '<CR>'
  " nnoremap <expr> <Leader>fm ':<C-u>Unite file_mru'     . g:u_opt_fm . '<CR>'
  nnoremap <expr> <Leader>gd ':<C-u>Unite gtags/def'    . g:u_opt_gd . '<CR>'
  nnoremap <expr> <Leader>gg ':<C-u>Unite grep:'        . g:u_opt_gg . '<CR>'
  nnoremap <expr> <Leader>gr ':<C-u>Unite gtags/ref'    . g:u_opt_gr . '<CR>'
  nnoremap <expr> <Leader>jn ':<C-u>Unite junkfile/new' . g:u_opt_jn . '<CR>'
  nnoremap <expr> <Leader>jj ':<C-u>Unite junkfile'     . g:u_opt_jj . '<CR>'
  nnoremap <expr> <Leader>li ':<C-u>Unite line'         . g:u_opt_li . '<CR>'
  nnoremap <expr> <Leader>mm ':<C-u>Unite mark'         . g:u_opt_mm . '<CR>'
  nnoremap <expr> <Leader>mp ':<C-u>Unite mapping'      . g:u_opt_mp . '<CR>'
  nnoremap <expr> <Leader>ol ':<C-u>Unite outline'      . g:u_opt_ol . '<CR>'
  nnoremap <expr> <Leader>op ':<C-u>Unite output'       . g:u_opt_op . '<CR>'
  nnoremap <expr> <Leader>re ':<C-u>UniteResume'        . g:u_opt_re . '<CR>'
  " nnoremap <expr> <Leader>ya ':<C-u>Unite history/yank' . g:u_opt_ya . '<CR>'

  let s:hooks = neobundle#get_hooks('unite.vim')
  function! s:hooks.on_source(bundle)
    " call unite#custom_default_action('source/bookmark/directory', 'vimfiler')
    " call unite#custom_default_action('directory_mru',             'vimfiler')

    function! s:unite_settings()
      nmap     <buffer> <Esc> <Plug>(unite_all_exit)
      nnoremap <buffer> <C-j> <Nop>
      nnoremap <buffer> <C-K> <Nop>
      imap     <buffer> <C-j> <Plug>(unite_insert_leave)
      imap     <buffer> <C-[> <Plug>(unite_insert_leave)
    endfunction

    autocmd MyAutoCmd FileType unite call s:unite_settings()

  endfunction

endif " }}}

" Vim上で動くシェル(vimshell) {{{
if neobundle#tap('vimshell')

  let g:vimshell_enable_start_insert = 0
  let g:vimshell_force_overwrite_statusline = 0

  " 動的プロンプトの設定
  " http://blog.supermomonga.com/articles/vim/vimshell-dynamicprompt.html
  let g:vimshell_prompt_expr = 'getcwd()." > "'
  let g:vimshell_prompt_pattern = '^\f\+ > '

  " 開いているファイルのパスでVimShellを開く
  nnoremap <expr> <Leader>vs ':<C-u>VimShellTab<Space>' . expand("%:h") . '<CR>'

endif " }}}

" Vim上で動くファイラ(vimfiler.vim) {{{
if neobundle#tap('vimfiler.vim')

  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_enable_auto_cd = 1
  let g:vimfiler_force_overwrite_statusline = 0
  let g:vimfiler_safe_mode_by_default = 0

  " タブで開く時は自分で指定することにしたのでコメントアウト
  " let g:vimfiler_edit_action = 'tabopen'

  " 開いているファイルのパスでVimFilerを開く
  nnoremap <expr> <Leader>vf ':<C-u>VimFilerTab<Space>' . expand("%:h") . '<CR>'

  " vimfilerのマッピングを一部変更(#をLeader専用にする)
  function! s:vimfiler_settings()
    " default : nmap <buffer> #  <Plug>(vimfiler_mark_similar_lines)
                nnoremap <buffer> #  <Nop>
                nmap     <buffer> ## <Plug>(vimfiler_mark_similar_lines)
  endfunction
  autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()

endif " }}}

" 使い捨てしやすいファイル生成(junkfile.vim) {{{
if neobundle#tap('junkfile.vim')

  if isdirectory(expand('~\memofiles')) != 0
    let g:junkfile#directory = '~\memofiles'
  endif

endif " }}}

" シンボル、関数の参照位置検索(GNU GLOBAL, gtags.vim) {{{
if neobundle#tap('gtags.vim')

endif " }}}

" for unite-gtags {{{
if neobundle#tap('unite-gtags')
  call neobundle#config({
    \   'autoload' : {
    \     'on_source' : [ 'unite.vim' ]
    \   }
    \ })

  " gtagsの結果をファイル毎のツリー形式で表示
  let g:unite_source_gtags_project_config = { '_' : { 'treelize' : 1 } }

endif " }}}

" for unite-mark {{{
if neobundle#tap('unite-mark')
  call neobundle#config({
    \   'autoload' : {
    \     'on_source' : [ 'unite.vim' ]
    \   }
    \ })

  " グローバルマークに対しても有効にする
  let g:unite_source_mark_marks =
    \ "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

endif " }}}

" 入力補完(YouCompleteMe) {{{
if neobundle#tap('YouCompleteMe')

  let g:ycm_min_num_of_chars_for_completion = 2

  " コメント中でも補完をかけようとすると、しばしばC++ランタイムエラーが出る？
  " let g:ycm_complete_in_comments = 1

  " Exuberant Ctags formatにのみ対応。--fields=+lを付けてタグ生成すること
  let g:ycm_collect_identifiers_from_tags_files = 1

  let g:ycm_global_ycm_extra_conf = '~\dotfiles\.ycm_extra_conf.py'
  let g:ycm_max_diagnostics_to_display = 20

  " YCMでultisnipsを使うことを明示(下記変数はデフォルトで1)
  " ちなみにYCMはneosnippetに対応しないと明言されてる
  " https://github.com/Valloric/YouCompleteMe/issues/528
  let g:ycm_use_ultisnips_completer = 1

  " 'GoTo*'コマンドの挙動は以下のどれかから選択
  " [ 'same-buffer', 'horizontal-split', 'vertical-split', 'new-tab' ]
  let g:ycm_goto_buffer_command = 'same-buffer'

endif " }}}

" 入力補助(ultisnips) {{{
if neobundle#tap('ultisnips')
  call neobundle#config({
    \   'autoload' : {
    \     'on_source' : [ 'YouCompleteMe' ]
    \   }
    \ })

  " YCMとultisnipsを組み合わせる時に<TAB>の使い方がコンフリクトするらしい
  " -> YCM的には「いい感じに設定してね」という風に読めたのでググってコピペ
  " http://stackoverflow.com/questions/14896327/ultisnips-and-youcompleteme
  let g:UltiSnipsExpandTrigger = '<TAB>'
  let g:UltiSnipsJumpForwardTrigger = '<TAB>'
  let g:UltiSnipsJumpBackwardTrigger = '<S-TAB>'
  let g:UltiSnipsListSnippets = '<C-e>'

  " snippetの作成先を以下で指定
  let g:UltiSnipsSnippetsDir = '~/vimfiles/UltiSnips'

  " snippetの居場所を以下で指定。runtimepathのサブディレクトリを検索する
  let g:UltiSnipsSnippetDirectories=[ 'UltiSnips' ]

  function! g:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
      if pumvisible()
        return "\<C-n>"
      else
        call UltiSnips#JumpForwards()
        if g:ulti_jump_forwards_res == 0
          return "\<TAB>"
        endif
      endif
    endif
    return ""
  endfunction

  autocmd MyAutoCmd BufEnter * execute "inoremap <silent> "
    \ . g:UltiSnipsExpandTrigger . " <C-r>=g:UltiSnips_Complete()<CR>"

  " this mapping Enter key to <C-y> to chose the current highlight item
  " and close the selection list, same as other IDEs.
  " CONFLICT with some plugins like tpope/Endwise
  inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  function! g:UltiSnips_Reverse()
    call UltiSnips#JumpBackwards()
    if g:ulti_jump_backwards_res == 0
      return "\<C-p>"
    endif
    return ""
  endfunction

  autocmd MyAutoCmd BufEnter * execute "inoremap <silent> "
    \ . g:UltiSnipsJumpBackwardTrigger . " <C-r>=g:UltiSnips_Reverse()<CR>"

endif " }}}

" Vimの一つのインスタンスを使い回す(vim-singleton) {{{
if neobundle#tap('vim-singleton')

  call singleton#enable()

endif " }}}

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

    " watchdogsを使う時の設定はこんな感じ？
    " \   'watchdogs_checker/_' : {
    " \     'runner/vimproc/updatetime'       : 40,
    " \     'hook/close_quickfix/enable_exit' :  1,
    " \   },
    " \   'watchdogs_checker/gcc' : {
    " \     'command'   : 'gcc',
    " \     'cmdopt'    : '-Wall',
    " \     'exec'      : '%c %o -fsyntax-only %s:p ',
    " \   },
    " \   'c/watchdogs_checker' : {
    " \     'type' : 'watchdogs_checker/gcc',
    " \   },
    " \   'watchdogs_checker/ruby' : {
    " \     'command'   : 'ruby',
    " \     'exec'      : '%c %o -c %s:p ',
    " \   },
    " \   'ruby/watchdogs_checker' : {
    " \     'type' : 'watchdogs_checker/ruby',
    " \   },

    " " clangを使う時の設定はこんな感じ？
    " \   'cpp' : {
    " \     'type' : 'cpp/clang3_4'
    " \   },
    " \   'cpp/clang3_4' : {
    " \       'command' : 'clang++',
    " \       'exec'    : '%c %o %s -o %s:p:r',
    " \       'cmdopt'  : '-std=gnu++0x'
    " \   },

  " デフォルトの<Leader>rだと入力待ちがあるので、別のキーでマッピングする
  let g:quickrun_no_default_key_mappings = 1
  nnoremap <Leader>q :<C-u>QuickRun -hook/time/enable 1<CR>
  vnoremap <Leader>q :<C-u>QuickRun -hook/time/enable 1<CR>

endif " }}}

" コマンド名補完(vim-ambicmd) {{{
if neobundle#tap('vim-ambicmd')

  " 下手にマッピングするよりもambicmdで補完した方が捗る
  cnoremap <expr> <Space> ambicmd#expand("\<Space>")

endif " }}}

" Vimの文字サイズ変更を簡易化(vim-fontzoom) {{{
if neobundle#tap('vim-fontzoom')

  nnoremap <silent> ,f :<C-u>Fontzoom!<CR>
  " vim-fontzoomには、以下のデフォルトキーマッピングが設定されている
  " nnoremap <C-ScrollWheelUp>   <Plug>(fontzoom-larger)
  " nnoremap <C-ScrollWheelDown> <Plug>(fontzoom-smaller)
  " -> しかし、Vimの既知のバグでWindows環境ではC-Scrollを使えないらしい
  " -> (参考URL)https://github.com/vim-jp/issues/issues/73

endif " }}}

" Vim力を測る(vim-scouter) {{{
if neobundle#tap('vim-scouter')

  nnoremap <Leader>sc :<C-u>Scouter $HOME\dotfiles\.vimrc<CR>

endif " }}}

" キー連打を便利に。ただし再描画がうっとおしい(vim-submode) {{{
if neobundle#tap('vim-submode')

  let g:submode_timeout = 0

  function s:SID()
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
  endfunction

  function! s:modulo(n, m)
    let d = a:n * a:m < 0 ? 1 : 0
    return a:n + (-(a:n + (0 < a:m ? d : -d)) / a:m + d) * a:m
  endfunction

  " gtttttt...で次のタブへ移動
  " -> <C-PageDown><C-Pageup>の方が良い
  " -> [N]gtだと一発。こっちは1 origin
  call submode#enter_with('changetab', 'n', '', 'gt', 'gt')
  call submode#enter_with('changetab', 'n', '', 'gT', 'gT')
  call submode#map       ('changetab', 'n', '', 't',  'gt')
  call submode#map       ('changetab', 'n', '', 'T',  'gT')

  " <Leader>gtttttt...で現在フォーカスされているタブを移動
  " -> [N]tabm[ove]だと一発。こっちは移動量を[N]で指定する
  function! s:movetab(nr)
    execute 'tabmove' s:modulo((tabpagenr() + (a:nr - 1)), tabpagenr('$'))
  endfunction
  let s:movetab = ':<C-u>call ' . s:SID() . 'movetab(%d)<CR>'
  call submode#enter_with('movetab', 'n', '', '#gt', printf(s:movetab,  1))
  call submode#enter_with('movetab', 'n', '', '#gT', printf(s:movetab, -1))
  call submode#map       ('movetab', 'n', '', 't',   printf(s:movetab,  1))
  call submode#map       ('movetab', 'n', '', 'T',   printf(s:movetab, -1))
  unlet s:movetab

endif " }}}

" Vim上で自動構文チェック(vim-watchdogs) {{{
if neobundle#tap('vim-watchdogs')
  " Caution: 裏で実行した結果を反映しているのか、pause系の処理があると固まる

  call neobundle#config({
    \   'autoload' : {
    \     'on_source' : [ 'vim-quickrun' ]
    \   }
    \ })

  let g:watchdogs_check_BufWritePost_enable = 1
  let g:watchdogs_check_BufWritePost_enables = {
    \   'c'    : 1,
    \   'ruby' : 1,
    \ }

  " quickrun_configにwatchdogs.vimの設定を追加
  call watchdogs#setup(g:quickrun_config)

endif " }}}

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
  "   \   "group"    : "ErrorMsg",
  "   \   "priority" : -1,
  "   \   "format"   : '\<%s\>',
  "   \ }

  " <cword>を含め、<cword>と同じ単語をアンダーラインで強調したい場合
  let g:brightest#highlight = {
    \   "group" : "BrightestUnderline"
    \ }

  " " <cword>を含め、<cword>と同じ単語を波線で強調したい場合
  " let g:brightest#highlight = {
  "   \   "group" : "BrightestUndercurl"
  "   \ }

  " " ハイライトする単語のパターンを設定
  " " デフォルト（空の文字列の場合）は <cword> が使用される
  " " NOTE: <cword> の場合は前方にある単語も検出する
  " let g:brightest#pattern = '\k\+'

  " " シンタックスが Statement の場合はハイライトしない
  " " e.g. Vim script だと let とか if とか function とか
  " let g:brightest#ignore_syntax_list = [ "Statement" ]

  " " brightestの背景をcursorlineに合わせる
  " let g:brightest#highlight_in_cursorline = { "group" : "BrightestCursorLineBg" }
  " set cursorline

endif " }}}

" My favorite colorscheme(vim-tomorrow-theme) {{{
if neobundle#tap('vim-tomorrow-theme')
  " 現在のカーソル位置をわかりやすくする
  autocmd MyAutoCmd ColorScheme * highlight Cursor
    \  term=bold cterm=bold gui=bold
    \  ctermfg=15 ctermbg=12 guifg=White guibg=Red

  " 検索中にフォーカス位置をわかりやすくする
  autocmd MyAutoCmd ColorScheme * highlight IncSearch
    \  term=reverse cterm=NONE gui=NONE
    \  ctermfg=16 ctermbg=222 guifg=#1d1f21 guibg=#f0c674

  " IME ONしていることをわかりやすくする
  if has('multi_byte_ime') || has('xim')
    autocmd MyAutoCmd ColorScheme * highlight CursorIM guibg=Purple guifg=NONE
  endif

  colorscheme Tomorrow-Night

endif " }}}

" Vim上で自動構文チェック(syntastic) {{{
if neobundle#tap('syntastic')
  " Caution: syntasticは非同期チェックできない

  let g:syntastic_check_on_wq = 0
  let g:syntastic_mode_map = { 'mode': 'passive',
    \ 'active_filetypes': ['ruby'] }

  " " rubocopが使える環境でrubyの構文チェックをする時
  " let g:syntastic_ruby_checkers = ['rubocop']

endif " }}}

" メモ管理用プラグイン(memolist.vim) {{{
if neobundle#tap('memolist.vim')

  nnoremap <Leader>mn :<C-u>MemoNew<CR>
  nnoremap <Leader>ml :<C-u>MemoList<CR>

  if neobundle#tap('unite.vim')
    nnoremap <expr> <Leader>mg ':<C-u>Unite grep:~/memo' . g:u_opt_mg . '<CR>'
  endif

endif " }}}

" markdownを使いやすくする(vim-markdown) {{{
if neobundle#tap('vim-markdown')
  " markdownのfold機能を無効にする
  let g:vim_markdown_folding_disabled = 1

endif " }}}

" Vimからブラウザを開く(open-browser) {{{
if neobundle#tap('open-browser.vim')
  nmap <Leader>L <Plug>(openbrowser-smart-search)
  vmap <Leader>L <Plug>(openbrowser-smart-search)

endif " }}}

" コマンド名を置き換える(vim-altercmd) {{{
if neobundle#tap('vim-altercmd')
  call altercmd#load()

endif " }}}

" 連番入力補助(vim-rengbang) {{{
if neobundle#tap('vim-rengbang')

  let g:rengbang_default_start = 1

endif " }}}

" 囲む / 囲まなくする / 別の何かで囲む(vim-surround) {{{
if neobundle#tap('vim-surround')

  " " s-sneakとclever-fの使い分けに慣れるため、コメントアウトしておく
  " " (例) sw' /* 次の単語を''で囲む */
  " nmap s <plug>Ysurround
  "
  " " (例) S'  /* カーソル行以降を''で囲む */
  " nmap S <plug>Ysurround$
  "
  " " (例) ss' /* 行を''で囲む */
  " nmap ss <plug>Yssurround

endif " }}}

" 置き換えオペレータ(vim-operator-replace) {{{
if neobundle#tap('vim-operator-replace')

  map R <Plug>(operator-replace)
  noremap <F4> R

endif " }}}

" 関数内検索(vim-textobj-function with vim-textobj-function) {{{
if neobundle#tap('vim-textobj-function')

  let g:textobj_function_no_default_key_mappings = 1

  if neobundle#tap('vim-textobj-function')
    nmap <Leader>f/ <Plug>(operator-search)<Plug>(textobj-function-i)
  endif

endif " }}}

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
  " inoremap <expr> ( search('\<\if\%#', 'bcn') ? ' (' : '('

  " ruby / eruby の時だけ設定
  autocmd MyAutoCmd FileType ruby,eruby call s:RubySettings()
  function! s:RubySettings()
    inoremap <buffer><expr> { smartchr#one_of('{', '#{', '{{')
  endfunction

  " for matchit }} } } }

endif " }}}

" コマンドの結果をバッファに表示する(capture.vim) {{{
if neobundle#tap('capture.vim')

  let g:capture_open_command = 'botright 12sp new'

  nnoremap <Leader>who :<C-u>Capture echo expand("%:p")<CR>
  nnoremap <Leader>sn  :<C-u>Capture scriptnames<CR>

endif " }}}

" 自由にテキストハイライト(vim-quickhl) {{{
if neobundle#tap('vim-quickhl')

  nmap <Leader>H <Plug>(quickhl-manual-this)
  map          H <Plug>(operator-quickhl-manual-this-motion)

  " " QuickhlManualResetも一緒にやってしまうと間違えて消すのが若干怖い
  " " -> ambicmdのおかげで :qmr<Space> で呼び出せるのでコメントアウト
  " nmap <silent> <Esc> :<C-u>nohlsearch<CR>:<C-u>QuickhlManualReset<CR>

endif " }}}

" incsearchをパワーアップ(incsearch.vim) {{{
if neobundle#tap('incsearch.vim')

  " very magic
  let g:incsearch#magic = '\v'

  " 検索後、カーソル移動すると自動でnohlsearchする
  let g:incsearch#auto_nohlsearch = 1

  map / <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  map g? <Plug>(incsearch-stay)

  " 入力中に飛びたくないのでstayのみ使う
  " -> 検索をモーションとして使う時にフベンだったので元に戻す
  " map / <Plug>(incsearch-stay)
  " map ? <Plug>(incsearch-stay)

  if neobundle#tap('vim-anzu')
    map n  <Plug>(incsearch-nohl)<Plug>(anzu-n-with-echo)
    map N  <Plug>(incsearch-nohl)<Plug>(anzu-N-with-echo)

  else
    map n  <Plug>(incsearch-nohl-n)
    map N  <Plug>(incsearch-nohl-N)
  endif

  if neobundle#tap('vim-asterisk') && neobundle#tap('vim-anzu')
    nmap *          yiw<Plug>(incsearch-nohl0)<Plug>(asterisk-z*)<Plug>(anzu-update-search-status-with-echo)
    omap *     <Esc>yiw<Plug>(incsearch-nohl0)<Plug>(asterisk-z*)<Plug>(anzu-update-search-status-with-echo)
    vmap *  <Esc>gvyvgv<Plug>(incsearch-nohl0)<Plug>(asterisk-z*)<Plug>(anzu-update-search-status-with-echo)

    nmap g*         yiw<Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)<Plug>(anzu-update-search-status-with-echo)
    omap g*    <Esc>yiw<Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)<Plug>(anzu-update-search-status-with-echo)
    vmap g* <Esc>gvyvgv<Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)<Plug>(anzu-update-search-status-with-echo)
  elseif neobundle#tap('vim-asterisk')
    nmap *          yiw<Plug>(incsearch-nohl0)<Plug>(asterisk-z*)
    omap *     <Esc>yiw<Plug>(incsearch-nohl0)<Plug>(asterisk-z*)
    vmap *  <Esc>gvyvgv<Plug>(incsearch-nohl0)<Plug>(asterisk-z*)

    nmap g*         yiw<Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)
    omap g*    <Esc>yiw<Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)
    vmap g* <Esc>gvyvgv<Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)
  else
    nmap *          yiw<Plug>(incsearch-nohl-*)
    omap *     <Esc>yiw<Plug>(incsearch-nohl-*)
    vmap *  <Esc>gvyvgv<Plug>(incsearch-nohl-*)

    nmap g*         yiw<Plug>(incsearch-nohl-g*)
    omap g*    <Esc>yiw<Plug>(incsearch-nohl-g*)
    vmap g* <Esc>gvyvgv<Plug>(incsearch-nohl-g*)
  endif

endif " }}}

" incsearch.vimをパワーアップ(incsearch-fuzzy.vim) {{{
if neobundle#tap('incsearch-fuzzy.vim')
  call neobundle#config({
    \   'autoload' : {
    \     'on_source' : [ 'incsearch.vim' ]
    \   }
    \ })

  " map z/ <Plug>(incsearch-fuzzy-/)
  " map z? <Plug>(incsearch-fuzzy-?)
  " map zg/ <Plug>(incsearch-fuzzy-stay)

  " map z/ <Plug>(incsearch-fuzzyspell-/)
  " map z? <Plug>(incsearch-fuzzyspell-?)
  " map zg/ <Plug>(incsearch-fuzzyspell-stay)

  " 入力中に飛びたくないのでstayのみ使う
  map z/ <Plug>(incsearch-fuzzy-stay)
  map z? <Plug>(incsearch-fuzzy-stay)
  " map g/ <Plug>(incsearch-fuzzyspell-stay)
  " map g? <Plug>(incsearch-fuzzyspell-stay)

endif " }}}

" incsearch.vimをパワーアップ(incsearch-migemo.vim) {{{
if neobundle#tap('incsearch-migemo.vim')
  call neobundle#config({
    \   'autoload' : {
    \     'on_source' : [ 'incsearch.vim' ]
    \   }
    \ })

  " map m/ <Plug>(incsearch-migemo-/)
  " map m? <Plug>(incsearch-migemo-?)
  " map mg/ <Plug>(incsearch-migemo-stay)

  " 入力中に飛びたくないのでstayのみ使う
  map m/ <Plug>(incsearch-migemo-stay)
  map m? <Plug>(incsearch-migemo-stay)

endif " }}}

" asterisk検索をパワーアップ(vim-asterisk) {{{

if neobundle#tap('vim-asterisk')

  if !neobundle#tap('incsearch.vim')
    nmap *          yiw<Plug>(asterisk-z*)
    omap *     <Esc>yiw<Plug>(asterisk-z*)
    vmap *  <Esc>gvyvgv<Plug>(asterisk-z*)

    nmap g*         yiw<Plug>(asterisk-gz*)
    omap g*    <Esc>yiw<Plug>(asterisk-gz*)
    vmap g* <Esc>gvyvgv<Plug>(asterisk-gz*)
  endif

endif " }}}

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

endif " }}}

" VCSの差分をVimのsignで表示(vim-signify) {{{
if neobundle#tap('vim-signify')

  nmap gj <Plug>(signify-next-hunk)zz
  nmap gk <Plug>(signify-prev-hunk)zz
  nmap gh <Plug>(signify-toggle-highlight)

endif " }}}

" VimからGitを使う(編集、コマンド実行、vim-fugitive) {{{
if neobundle#tap('vim-fugitive')

  autocmd MyAutoCmd FileType gitcommit setlocal nofoldenable
endif " }}}

" VimからGitを使う(コミットツリー表示、管理、agit.vim) {{{
if neobundle#tap('agit.vim')
  function! s:my_agit_setting()
    nmap <buffer> ch <Plug>(agit-git-cherry-pick)
    nmap <buffer> Rv <Plug>(agit-git-revert)
  endfunction
  autocmd MyAutoCmd FileType agit call s:my_agit_setting()
  autocmd MyAutoCmd FileType agit_diff setlocal nofoldenable
endif " }}}

" VimからGitを使う(ブランチ管理、vim-merginal) {{{
if neobundle#tap('vim-merginal')

endif " }}}

" ctagsを使ってアウトラインを作成(tagbar) {{{
if neobundle#tap('tagbar')

  " http://hp.vector.co.jp/authors/VA025040/ctags/
  let g:tagbar_ctags_bin = '$VIM\ctags.exe'
  let g:tagbar_sort = 0
  let g:tagbar_type_vim = {
    \   'kinds'       : [
    \     'v:variables',
    \     'f:functions',
    \   ]
    \ }
  let g:tagbar_type_c = {
    \   'kinds'       : [
    \     'd:macros',
    \     'v:variables',
    \     'f:functions',
    \   ]
    \ }
  nnoremap <silent> <F9> :<C-u>TagbarToggle<CR>

  " tagbarの機能を使って現在の関数名を取得するショートカットコマンドを作る
  function! s:ClipCurrentTag(data)
    " 選択範囲レジスタ(*)を使う
    let @*=a:data
    echo "clipped: " . a:data
  endfunction
  command! -nargs=0 ClipCurrentTag
    \ call s:ClipCurrentTag(tagbar#currenttag('%s', ''))

  function! s:PrintCurrentTag(data)
    " 無名レジスタ(")を使う
    let @"=a:data
    normal! ""P
    echo "print current tag: " . a:data
  endfunction
  command! -nargs=0 PrintCurrentTag
    \ call s:PrintCurrentTag(tagbar#currenttag('%s', ''))

endif " }}}

" カッコいいステータスラインを使う(lightline.vim) {{{
if neobundle#tap('lightline.vim')

  let g:lightline = {}
  let g:lightline.colorscheme  = 'hybrid'
  let g:lightline.mode_map     = { 'c'    : 'NORMAL'                     }
  let g:lightline.separator    = { 'left' : "\u2B80", 'right' : "\u2B82" }
  let g:lightline.subseparator = { 'left' : "\u2B81", 'right' : "\u2B83" }
  let g:lightline.tabline = { 'left': [ [ 'tabs' ] ], 'right': [] }

  let g:lightline.active = {
    \   'left'  : [ [ 'mode', 'paste' ],
    \               [ 'fugitive', 'filename', 'currenttag' ], ],
    \   'right' : [ [ 'lineinfo' ],
    \               [ 'percent' ],
    \               [ 'fileformat', 'fileencoding', 'filetype' ], ]
    \ }

  let g:lightline.component_function = {
    \   'modified'     : 'MyModified',
    \   'readonly'     : 'MyReadonly',
    \   'filename'     : 'MyFilename',
    \   'fileformat'   : 'MyFileformat',
    \   'filetype'     : 'MyFiletype',
    \   'fileencoding' : 'MyFileencoding',
    \   'mode'         : 'MyMode',
    \   'currenttag'   : 'MyCurrentTag',
    \   'fugitive'     : 'MyFugitive',
    \ }

  function! MyModified()
    return &ft =~ 'help\|vimfiler\'   ? ''  :
      \                   &modified   ? '+' :
      \                   &modifiable ? ''  : '-'
  endfunction

  function! MyReadonly()
    return &ft !~? 'help\|vimfiler\' && &readonly ? "\u2B64" : ''
  endfunction

  function! MyFilename()
    " 以下の条件を満たすと処理負荷が急激に上がる。理由は不明
    " ・Vimのカレントディレクトリがネットワーク上
    " ・ネットワーク上のファイルを開いており、ファイル名をフルパス(%:p)出力
    " -> GVIMウィンドウ上部にフルパスが表示されているので、そちらを参照する
    return (&ft == 'unite'       ? unite#get_status_string()    :
      \     &ft == 'vimfiler'    ? vimfiler#get_status_string() :
      \     &ft == 'vimshell'    ? vimshell#get_status_string() :
      \      '' != expand('%:t') ? expand('%:t')                : '[No Name]') .
      \    ( '' != MyReadonly()  ? ' ' . MyReadonly()           : ''         ) .
      \    ( '' != MyModified()  ? ' ' . MyModified()           : ''         )
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
    return winwidth(0) > 60 ? lightline#mode() : ''
  endfunction

  function! MyCurrentTag()
    if &ft == 'vim' && exists('*FoldCCnavi()')
      let l:_ = FoldCCnavi()
      return strlen(l:_) ? l:_ : ''
    else
      let l:_ = tagbar#currenttag('%s', '')
      return strlen(l:_) ? l:_ : ''
    endif
  endfunction

  function! MyFugitive()
    try
      if &ft != 'vimfiler'
        let l:_ = fugitive#head()
        return strlen(l:_) ? '⭠ ' . l:_ : ''
      endif
    catch
    endtry
      return ''
    else
      return ''
    endif
  endfunction

endif " }}}

" vimの折り畳み(fold)機能を便利に(foldCC) {{{
if neobundle#tap('foldCC')

  let g:foldCCtext_enable_autofdc_adjuster = 1
  set foldtext=FoldCCtext()

endif " }}}

" Cygwin Vimでクリップボード連携(vim-fakeclip) {{{
if neobundle#tap('vim-fakeclip')

  vmap <Leader>y <Plug>(fakeclip-y)
  nmap <Leader>p <Plug>(fakeclip-p)

endif " }}}

" ペーストからの<C-n>,<C-p>でクリップボードの履歴をぐるぐる(yankround.vim) {{{
if neobundle#tap('yankround.vim')

  let g:yankround_region_hl_groupname = 'ErrorMsg'

  nmap p     <Plug>(yankround-p)
  xmap p     <Plug>(yankround-p)
  nmap P     <Plug>(yankround-P)
  nmap gp    <Plug>(yankround-gp)
  xmap gp    <Plug>(yankround-gp)
  nmap gP    <Plug>(yankround-gP)
  nmap <C-n> <Plug>(yankround-next)
  nmap <C-p> <Plug>(yankround-prev)

endif " }}}

" 簡単にテキスト整形(vim-easy-align) {{{
if neobundle#tap('vim-easy-align')

  vnoremap <silent> <CR> :EasyAlign<CR>

endif " }}}

" clever-fの2文字版(vim-sneak) {{{
if neobundle#tap('vim-sneak')

  let g:sneak#s_next = 1     " clever-f ならぬ clever-s な動作にする
  let g:sneak#use_ic_scs = 1 " ignorecaseやらsmartcaseの設定を反映する

  " " sは進む、Sは戻るで固定する
  " " -> 標準Vimの挙動は0
  " let g:sneak#absolute_dir = 1

  if neobundle#tap('clever-f.vim')

    " clever-fと併用する時はs-sneak
    nmap s <Plug>Sneak_s
    nmap S <Plug>Sneak_S
    xmap s <Plug>Sneak_s
    xmap S <Plug>Sneak_S
    omap s <Plug>Sneak_s
    omap S <Plug>Sneak_S
  else
    " clever-fと併用しない時はf-sneak
    nmap f <Plug>Sneak_s
    nmap F <Plug>Sneak_S
    xmap f <Plug>Sneak_s
    xmap F <Plug>Sneak_S
    omap f <Plug>Sneak_s
    omap F <Plug>Sneak_S
  endif

endif " }}}

" f検索を便利に(clever-f.vim) {{{
if neobundle#tap('clever-f.vim')

  let g:clever_f_smart_case = 1

  " " fは進む、Fは戻るで固定する
  " " -> 標準Vimの挙動は0
  " let g:clever_f_fix_key_direction = 1

  " let g:clever_f_chars_match_any_signs = ';'

endif " }}}

" コメントアウト/コメントアウト解除を簡単に(caw.vim) {{{
if neobundle#tap('caw.vim')

  nmap <Leader>c <Plug>(caw:i:toggle)
  vmap <Leader>c <Plug>(caw:i:toggle)

endif " }}}

" Vimのマーク機能を使いやすく(vim-signature) {{{
if neobundle#tap('vim-signature')

  " " お試しとして、グローバルマークだけ使うようにしてみる
  " " -> viminfoに直接書き込まれるためか、消しても反映されないことが多々
  " let g:SignatureIncludeMarks = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

  " " _viminfoファイルからグローバルマークの削除を行う
  " " -> *nix系だと「~/.viminfo」、Windowsだと「~/_viminfo」を対象とすることに注意
  " let g:SignatureForceRemoveGlobal = 1

  " これだけあれば十分
  " mm       : ToggleMarkAtLine
  " m<Space> : PurgeMarks
  nmap mm m.

endif " }}}

" vimにスタート画面を用意(vim-startify) {{{
if neobundle#tap('vim-startify')

  let g:startify_files_number = 4
  let g:startify_change_to_dir = 1
  let g:startify_session_dir = '~/vimfiles/session'

  " ブックマークの設定はローカル設定ファイルに記述する
  " see: $HOME/localfiles/local.rc.vim
  " let g:startify_bookmarks = [
  "   \   '.',
  "   \   '~\.vimrc',
  "   \ ]

  let g:startify_list_order = [
    \   [ 'My bookmarks:'               ], 'bookmarks',
    \   [ 'Recently used files:' ], 'files',
    \   [ 'My sessions:' ], 'sessions',
    \ ]

  nnoremap ,, :<C-u>Startify<CR>

endif " }}}

" %で対応するキーワードを増やす(matchit) {{{
if neobundle#tap('matchit')

endif " }}}

" VimからLingrを見る(J6uil.vim) {{{
if neobundle#tap('J6uil.vim')

  let g:J6uil_config_dir = expand('~/.cache/J6uil')

endif " }}}

" Visualモードで選択した2つの領域をDiffする(linediff.vim) {{{
if neobundle#tap('linediff.vim')

endif " }}}

" vimdiffに別のDiffアルゴリズムを適用する(vim-unified-diff) {{{
if neobundle#tap('vim-unified-diff')

endif " }}}

" vimdiffをパワーアップする(vim-improved-diff) {{{
if neobundle#tap('vim-improved-diff')

endif " }}}

" The end of Plugin Settings }}}
"-----------------------------------------------------------------------------
" 趣味＠正式採用前の設定 {{{

" ミニマップってあったら便利？
" " -> あったらあったで結構良いかも。アウトライン系で十分な気もする
" " -> swapファイルに怒られるので必ず読み取り専用で開いてほしい…
" set noswapfile
" NeoBundle 'koron/minimap-vim'
"
" まだ開発初期っぽいので、今後に期待
" -> python依存っぽいのでちょっと使えないかな...
" NeoBundle 'severin-lemaignan/vim-minimap'

" " 画面内移動を楽にするプラグイン
" " 試した感じ、けっこうイケてる、けど若干見た目が精神衛生上よろしくない
" " 個人的にはclever-f, vim-sneakがあれば良いかなあと
" NeoBundle 'haya14busa/vim-easymotion'

" " HTMLコーディングを爆速化するらしい
" " -> HTML書く機会が無かった。そのうち使いたい
" NeoBundle 'mattn/emmet-vim'

" " Gistへの投稿がすごく楽になったりするらしい
" " -> Gist書く機会が無かった。そのうち使いたい
" NeoBundle 'mattn/gist-vim'

" " 空ファイルテンプレートを実現する
" " -> 使いたい候補上位だけど、まだ使ってない
" NeoBundle 'thinca/vim-template'

" " リッチなカレンダー
" " -> 試してみたら確かにリッチだった。実用性はよくわからない
" NeoBundle 'itchyny/calendar.vim'

" " 幅の違う矩形オブジェクトに対するオペレータ(の動作をエミュレートしたもの)
" " -> なんだかんだと出番がありそうなオペレータ。割り当てるキーを確保したい
" NeoBundle 'osyo-manga/vim-operator-blockwise'

" " <CR>で良い感じにテキストオブジェクトを選択し、Vim力を下げるプラグイン
" " -> 面白い、が今ひとつ使う機会が無い
" NeoBundle 'gcmt/wildfire.vim'
" map <CR> <Plug>(wildfire-fuel)
" map <BS> <Plug>(wildfire-water)

" " Hack #120: gVim でウィンドウの位置とサイズを記憶する
" " http://vim-jp.org/vim-users-jp/2010/01/28/Hack-120.html
" " -> Windowsのスナップ機能を使った時に位置情報記録できてない
" let g:save_window_file = expand('~/vimfiles/winpos/.vimwinpos')
" augroup SaveWindow
"   autocmd!
"   autocmd VimLeavePre * call s:save_window()
"   function! s:save_window()
"     let s:options = [
"       \ 'set columns=' . &columns,
"       \ 'set lines=' . &lines,
"       \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
"       \ ]
"     call writefile(s:options, g:save_window_file)
"   endfunction
" augroup END
"
" if filereadable(g:save_window_file)
"   execute 'source' g:save_window_file
" endif

" 最後のwindowをquitする時に確認してくれるようにする
" -> 面白いし欲しかったような機能だけど、タブの数を数える方法が間違ってる？
" -> 最近は :bdelete しまくってから最後に :q するので実用上は問題無い
" http://toqoz.hateblo.jp/entry/2013/11/19/171928

" command! Q :call s:gentle_quitman()
"
" function! s:gentle_quitman()
"   let s:window_counter = 0
"   windo let s:window_counter = s:window_counter + 1
"
"   if s:window_counter == 1
"     let a = input("Really quit last window? [n]|y ")
"     if a == "y"
"       q
"     endif
"   else
"     q
"   endif
" endfunction
"
" AlterCommand q Q
" AlterCommand Q q

" c-family semantic source code highlighting, based on Clang
" only for Linux ?
" NeoBundle 'bbchung/clighter'
" let g:clighter_autostart = 0
" let g:clighter_libclang_file = 'D:\LLVM\bin'
" let g:clighter_realtime = 1

" " Visualモードの選択範囲を拡張、縮小できるようにする
" NeoBundle 'kana/vim-textobj-line'
" NeoBundle 'kana/vim-textobj-entire'
" NeoBundle 'terryma/vim-expand-region'

" The end of 趣味関係＠正式採用前の設定 " }}}
"-----------------------------------------------------------------------------

