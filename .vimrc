" .vimrc for 香り屋版GVim

"-----------------------------------------------------------------------------
" 初期設定系 {{{
set nocompatible            " Vi互換モードをオフ(Vimの拡張機能を有効化)
filetype plugin indent off  " ftpluginは最後に読み込むため、一旦オフする

" Neo Bundleを使う
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle'))

" NeoBundle自体の更新をチェックする
NeoBundleFetch 'Shougo/neobundle.vim'

" Vim Plugin List

" Shougo_ware {{{

" Kaoriya版付属のvimprocを使用する
" -> Kaoriya版Vimからvimprocを~/.vim/bundle以下にコピーしておくこと
NeoBundle 'Shougo/vimproc'

" 環境に応じてvimprocを自動ビルドする場合
" let vimproc_updcmd = has('win64') ?
"   \ 'tools\\update-dll-mingw 64' : 'tools\\update-dll-mingw 32'
" execute "NeoBundle 'Shougo/vimproc.vim'," . string({
"   \ 'build' : {
"   \     'windows' : vimproc_updcmd,
"   \     'cygwin'  : 'make -f make_cygwin.mak',
"   \     'mac'     : 'make -f make_mac.mak',
"   \     'unix'    : 'make -f make_unix.mak',
"   \    },
"   \ })

" NeoBundle 'Shougo/neocomplete.vim'
" NeoBundle 'Shougo/neosnippet'
" NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/unite.vim',
NeoBundle 'Shougo/neossh.vim'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vimfiler.vim'

" The end of Shougo_ware }}}

" unite sources {{{

" NeoBundleLazy 'Shougo/unite-build',
"   \ { 'autoload' : { 'unite_sources' : [ 'build' ] } }
" NeoBundleLazy 'rhysd/unite-codic.vim',
"   \ { 'autoload' : { 'unite_sources' : [ 'codic' ] } }
" NeoBundleLazy 'ujihisa/unite-colorscheme',
"   \ { 'autoload' : { 'unite_sources' : [ 'colorscheme' ] } }
NeoBundleLazy 'Shougo/neomru.vim',
  \ { 'autoload' : { 'unite_sources' : [ 'file_mru' ] } }
NeoBundleLazy 'hewes/unite-gtags',
  \ { 'autoload' : { 'unite_sources' : [ 'gtags/ref', 'gtags/def' ] } }
" NeoBundleLazy 'Shougo/unite-help',
"   \ { 'autoload' : { 'unite_sources' : [ 'help' ] } }
" NeoBundleLazy 'osyo-manga/unite-highlight',
"   \ { 'autoload' : { 'unite_sources' : [ 'highlight' ] } }
NeoBundleLazy 'Shougo/junkfile.vim',
  \ { 'autoload' : { 'unite_sources' : [ 'junkfile', 'junkfile/new' ] } }
NeoBundleLazy 'tacroe/unite-mark',
  \ { 'autoload' : { 'unite_sources' : [ 'mark' ] } }
NeoBundleLazy 'Shougo/unite-outline',
  \ { 'autoload' : { 'unite_sources' : [ 'outline' ] } }
" NeoBundleLazy 'osyo-manga/unite-candidate_sorter',
"   \ { 'autoload' : { 'commands' : [ 'Unite', 'UniteWithBufferDir' ] } }

" The end of unite sources }}}

" YCM {{{

" NeoBundle 'Valloric/YouCompleteMe'
" NeoBundle 'SirVer/ultisnips'

" === Windows 64bit YCMを頑張ってbuildする方法 === {{{
" X. 基本は下記URLのInstructions for 64-bit using MinGW64 (clang)に従う。
"    https://github.com/Valloric/YouCompleteMe/wiki/Windows-Installation-Guide
"    (手順13.は不要。手順に従ってコピーすると、それ古いから。と怒られる)
" 1. python-2.7.8.amd64.msiを落としてくる。pythonを入れる。
" 2. libpython27.aを落としてくる。(手順中にリンクが貼ってある)
" 3. cmake-3.0.0-win32-x86.exeを落としてくる。cmakeを入れる。
" 4. llvm-3.4-mingw-w64-4.8.1-x86-posix-sjljを落として解凍、C:\LLVMにリネーム。
" 5. 手順に従ってmakeすると、エラーが出る。
"    (Boostの関数tss_cleanup_implemented()が多重定義)
"    YouCompleteMe\third_party\ycmd\cpp\BoostParts\libs\thread\src\win32\
"    tss_dll.cppの最終行付近のtss_cleanup_implemented()あたりをコメントアウト
" 6. make ycm_support_libsが成功したらYCMが使えるようになってるはず。
" ================================================ }}}

" === Windows 32bit YCMを頑張ってbuildする方法 === {{{
" X. 基本は下記URLのInstructions for 64-bit using MinGW64 (clang)に従う。
"    https://github.com/Valloric/YouCompleteMe/wiki/Windows-Installation-Guide
"    (手順13.は不要。手順に従ってコピーすると、それ古いから。と怒られる)
"    -> MinGW32の手順が無いので、64bitの手順をいい感じに読み替える。
"       こちらでは"コンパイルエラーが起きないので、ファイル差し替えは不要"。
" 1. python-2.7.8.msiを落としてくる。pythonを入れる。
" 2. 手順1.でlibpython27.aがついてくるので何もしなくてOK。手順3に進む。
" 3. cmake-3.0.0-win32-x86.exeを落としてくる。cmakeを入れる。
" 4. llvm-3.4-mingw-w64-4.8.1-x86-posix-sjljを落として解凍、C:\LLVMにリネーム。
" 5. 手順に従ってmakeすると、エラーが出ないので何もしなくてOK。手順6に進む。
" 6. make ycm_support_libsが成功したらYCMが使えるようになってるはず。
"
" Y. YCMのmake完了後、GVim起動時にランタイムエラーが出る。
"    -> 環境変数からCMakeへのPathを消す。msvcrXXX.dllの異なるバージョンへPathが
"       通っているとエラーになるらしい。Kaoriya Vimだけ残し、他はすべて消す。
" ================================================ }}}

" The end of YCM }}}

" thinca_ware {{{

NeoBundle 'thinca/vim-singleton'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-ambicmd'
NeoBundle 'thinca/vim-fontzoom'
NeoBundleLazy 'thinca/vim-scouter',
  \ { 'autoload' : { 'commands' : ['Scouter'] } }
" NeoBundle 'thinca/vim-submode'
" NeoBundle 'thinca/vim-visualstar'
" NeoBundle 'thinca/vim-qfreplace'

" The end of thinca_ware }}}

" osyo_ware {{{

" NeoBundle 'osyo-manga/vim-watchdogs'
" NeoBundle 'osyo-manga/shabadou.vim'
" NeoBundle 'jceb/vim-hier'
" let g:watchdogs_check_BufWritePost_enable = 1
" let g:watchdogs_check_BufWritePost_enables = {
"   \   'c'    : 1,
"   \   'ruby' : 1,
"   \ }
NeoBundle 'osyo-manga/vim-operator-search'
NeoBundle 'osyo-manga/vim-anzu'
NeoBundle 'osyo-manga/vim-brightest'
NeoBundle 'osyo-manga/vim-over'

" The end of osyo_ware }}}

" other Vim plugins {{{

NeoBundle 'vim-scripts/aspvbs.vim'    " syntax for ASP/VBScript
" NeoBundle 'vim-scripts/vbnet.vim'   " syntax for VB.NET
NeoBundleLazy 'hachibeeDI/vim-vbnet', {"autoload" : { "filetypes" : ["vbnet"], }}
" NeoBundleLazy 'mattn/benchvimrc-vim',
"   \ { 'autoload' : { 'commands' : ['BenchVimrc'] } }
" NeoBundle 'koron/codic-vim'
" NeoBundle 'scrooloose/syntastic'

" memolist.vimはmarkdown形式でメモを生成するので、markdownを使いやすくしてみる
" http://rcmdnk.github.io/blog/2013/11/17/computer-vim/#plasticboyvim-markdown
NeoBundle 'glidenote/memolist.vim'
NeoBundle 'rcmdnk/vim-markdown'
NeoBundle 'kannokanno/previm'
NeoBundle 'tyru/open-browser.vim'

" NeoBundle 'tyru/vim-altercmd'
" NeoBundle 'tpope/vim-repeat'
" NeoBundle 'tpope/vim-speeddating'
NeoBundle 'deris/vim-visualinc'
NeoBundle 'deris/vim-rengbang'
NeoBundle 'tpope/vim-surround'

" NeoBundle 'kana/vim-niceblock'
NeoBundle 'kana/vim-operator-user'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kana/vim-operator-replace'
NeoBundle 'kana/vim-textobj-function'

NeoBundle 'kana/vim-smartchr'
NeoBundle 'tyru/capture.vim'
NeoBundle 't9md/vim-quickhl'

" NeoBundle 'haya14busa/incsearch.vim'
NeoBundle 'mhinz/vim-signify'
" NeoBundle 'tpope/vim-fugitive'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'cocopon/lightline-hybrid.vim'
NeoBundle 'LeafCage/foldCC'

" NeoBundleLazy 'kana/vim-fakeclip'
NeoBundle 'LeafCage/yankround.vim'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'bronson/vim-trailing-whitespace'
NeoBundle 'vim-scripts/BufOnly.vim'
" NeoBundle 'rhysd/clever-f.vim'
NeoBundle 'justinmk/vim-sneak'
NeoBundle 'tyru/caw.vim'
NeoBundle 'kshenoy/vim-signature'
NeoBundle 'mhinz/vim-startify'
NeoBundle 'vim-scripts/gtags.vim'

NeoBundle 'mattn/webapi-vim'
NeoBundle 'tmhedberg/matchit'

NeoBundle 'basyura/J6uil.vim'
NeoBundle 'AndrewRadev/linediff.vim'

" other Vim plugins }}}

" The end of Vim Plugin List

call neobundle#end()

filetype plugin indent on " ファイルタイプの自動検出をONにする

" 構文解析ON
syntax enable

" .vimrcに書いてあるプラグインがインストールされているかチェックする
NeoBundleCheck

" The end of 初期設定系 }}}
"-----------------------------------------------------------------------------
" 基本設定系 {{{

let mapleader = "#"         " 左手で<Leader>を入力したい
set helplang=en             " 日本語ヘルプを卒業したい。例え英語が読めなくとも

" vimrc内全体で使うaugroupを定義
augroup MyAutoCmd
  autocmd!
augroup END

" Echo startup time on start
if has('vim_starting') && has('reltime')
  let g:startuptime = reltime()
  augroup MyAutoCmd
    autocmd! VimEnter * let g:startuptime = reltime(g:startuptime) | redraw
    \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
  augroup END
endif

" SID取得関数を定義
function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zesid$')
endfunction

" " Swap, Backupファイルは作る(Vimクラッシュ時のファイルロストこわい)
" set noswapfile
" set nobackup
" set nowritebackup

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
set viminfo+=n~/_viminfo        " Windowsは_viminfo, Linuxは.viminfoとする
set history=100                 " 100あれば十分すぎる

" 編集中のファイルがVimの外部で変更された時、自動的に読み直す
set autoread

" " カーソル上下に表示する最小の行数(大きい値にして必ず再描画させる)
" set scrolloff=50

" 再描画がうっとおしいのでやっぱり0にする。再描画必要なら<C-e>や<C-y>を使う。
set scrolloff=0

" The end of 基本設定系 }}}
"-----------------------------------------------------------------------------
" 入力補助系 " {{{

set wildmenu
set wildmode=full

" <C-p>や<C-n>でもコマンド履歴のフィルタリングを有効にする
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" コーディング規約の都合でタブを使いたくないので全部スペースでインデントする
set expandtab

" タイムスタンプの挿入
imap <F3>  <C-R>=strftime("%Y/%m/%d(%a) %H:%M")<CR>
nmap <F3> i<C-R>=strftime("%Y/%m/%d(%a) %H:%M")<CR><ESC>

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
" d : current and included files for defined name or macro
"     -> 試しにdを追加
set complete=.,w,b,u,i,d

" The end of 入力補助系 }}}
"-----------------------------------------------------------------------------
" 視覚情報系 "{{{

" いまひとつ.gvimrcでしかできない設定というのがわからない...
" -> とりあえず移動したやつを列挙していこうかな
" ① highlight CursorIM guibg=Purple guifg=NONE
" ② ...
if has('gui_running')

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

  set cmdheight=2

  " Vimでフルスクリーンモード by scrnmode.vim (Kaoriya版付属プラグイン)
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

  nnoremap <F11> :<C-u>call<SID>ToggleScreenMode()<CR>

  set mouse=a      " マウス機能有効
  set nomousefocus " マウスの移動でフォーカスを自動的に切替えない
  set mousehide    " 入力時にマウスポインタを隠す

  " M : メニュー・ツールバー領域を削除する
  " c : ポップアップダイアログを使用しない
  set guioptions=Mc
  if &guioptions =~# 'M'
    let &guioptions = substitute(&guioptions, '[mT]', '', 'g')
  endif

  " 補完時は対象が一つでもポップアップを表示
  set completeopt=menuone

  " 印刷用フォント(とりあえずgvimrcサンプルのデフォルト値とする)
  if has('printer')
    if has('win32')
      set printfont=MS_Mincho:h12:cSHIFTJIS
    endif
  endif

endif " endif of has('gui_running')

" NeoBundle 'chriskempson/vim-tomorrow-theme'
" vimrcリロード時にcolorschemeが見つかりませんエラーががが...
" -> ~/vimfiles/colorsに移動してしまう作戦で一時しのぎ
colorscheme Tomorrow-Night

" 入力モードに応じてカーソルの形を変える
" -> Cygwin使ってた頃は必要だった気がするので取っておく
let &t_ti .= "\e[1 q"
let &t_SI .= "\e[5 q"
let &t_EI .= "\e[1 q"
let &t_te .= "\e[0 q"

set wrap           " 長いテキストの折り返し
set colorcolumn=81 " 81行目に線を表示

set number         " 行番号の表示
set relativenumber " 行番号を相対表示
nnoremap <silent><F10> :<C-u>set relativenumber!<CR>

" 不可視文字の可視化
set list

" 不可視文字は普通のやつを使う
set listchars=tab:>-,trail:-,eol:\

" 入力中のキーを画面右下に表示
set showcmd

set showtabline=2 " 常にタブ行を表示する
set laststatus=2  " 常にステータス行を表示する

" 差分ファイル確認時は折り畳み無効
autocmd MyAutoCmd FileType diff setlocal nofoldenable

" 折りたたみ機能をスイッチ
nnoremap <silent><F12> :set foldenable!<CR>

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

nnoremap <silent><F7> :<C-u>call ToggleTransParency()<CR>

" スペルチェックから日本語を除外
set spelllang+=cjk
nnoremap <silent><F9> :<C-u>set spell!<CR>

" The end of 視覚情報系 }}}
"-----------------------------------------------------------------------------
" 文字列検索系 "{{{

" very magic
nnoremap / /\v

" 大文字小文字を区別しない。区別したい時は検索パターンのどこかに\Cを付ける
set ignorecase " 検索時に大文字小文字を区別しない
set smartcase  " 大文字小文字の両方が含まれている場合は、区別する
set wrapscan   " 検索時に最後まで行ったら最初に戻る
set incsearch  " インクリメンタルサーチ
set hlsearch   " 検索マッチテキストをハイライト

" " 検索状態をバッファ毎に保持する。
" " -> 便利な時もあるんだけど、バッファ間で共通の方が都合の良いケースが多い
" " http://d.hatena.ne.jp/tyru/20140129/localize_search_options
" " Localize search options.
" autocmd MyAutoCmd WinLeave *
" \     let b:vimrc_pattern = @/
" \   | let b:vimrc_hlsearch = &hlsearch
" autocmd MyAutoCmd WinEnter *
" \     let @/ = get(b:, 'vimrc_pattern', @/)
" \   | let &l:hlsearch = get(b:, 'vimrc_hlsearch', &l:hlsearch)

" 検索開始時にジャンプせず、その場に留まる＠ちらつかない
" -> saihooooooooさんのvimrcからのコピペ
" -> プラグインvisualstarだとちらつくので不採用とした
nnoremap <silent>* viw:<C-u>call <SID>StarSearch()<CR>:<C-u>set hlsearch<CR>`<
xnoremap <silent>*    :<C-u>call <SID>StarSearch()<CR>:<C-u>set hlsearch<CR>
function! s:StarSearch()
  let orig = @"
  normal! gvy
  let text = @"
  let @/ = '\V' . substitute(escape(text, '\/'), '\n', '\\n', 'g')
  let @" = orig
endfunction

" grep結果が0件の場合、Quickfixを開かない
autocmd QuickfixCmdPost grep if len(getqflist()) != 0 | copen | endif

" The end of 文字列検索系 }}}
"-----------------------------------------------------------------------------
" 編集系 "{{{

set encoding=utf-8                  " utf-8をデフォルトエンコーディングとする
set fileencodings=utf-8,sjis,euc-jp " 文字コード自動判定候補

if !has('win64')
  " 以下のファイルの時は文字コードをsjisに設定
  autocmd MyAutoCmd FileType c        set fileencoding=sjis
  autocmd MyAutoCmd FileType cpp      set fileencoding=sjis
  autocmd MyAutoCmd FileType make     set fileencoding=sjis
  autocmd MyAutoCmd FileType sh       set fileencoding=sjis
  autocmd MyAutoCmd FileType cfg      set fileencoding=sjis
  autocmd MyAutoCmd FileType awk      set fileencoding=sjis
  autocmd MyAutoCmd FileType dosbatch set fileencoding=sjis
  autocmd MyAutoCmd FileType vb       set fileencoding=sjis
endif

" 文字コードを指定してファイルを開き直す
nnoremap <Leader>enc :<C-u>e ++enc=

" 改行コードを指定してファイルを開き直す
nnoremap <Leader>ff  :<C-u>e ++ff=

" タブ幅、シフト幅の設定
autocmd MyAutoCmd BufEnter *          setlocal tabstop=2 shiftwidth=2
autocmd MyAutoCmd BufEnter *.c        setlocal tabstop=4 shiftwidth=4
autocmd MyAutoCmd BufEnter *.cpp      setlocal tabstop=4 shiftwidth=4
autocmd MyAutoCmd BufEnter *.md       setlocal tabstop=4 shiftwidth=4
autocmd MyAutoCmd BufEnter *.markdown setlocal tabstop=4 shiftwidth=4

set infercase                   " 補完時に大文字小文字を区別しない
set nrformats=hex               " <C-a>や<C-x>の対象を10進数,16進数に絞る
set virtualedit=all             " テキストが存在しない場所でも動けるようにする
set hidden                      " quit時はバッファを削除せず、隠す
set switchbuf=useopen           " すでに開いてあるバッファがあればそっちを開く
set showmatch                   " 対応する括弧などの入力時にハイライト表示する
set matchtime=3                 " 対応括弧入力時のハイライト表示を3秒にする
set matchpairs& matchpairs+=<:> " 対応括弧に'<'と'>'のペアを追加
set backspace=indent,eol,start  " <BS>でなんでも消せるようにする

" " 自動改行を無効化
" set textwidth=0
"
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
function! s:func_copy_cmd_output(cmd)
  redir @*>
  silent execute a:cmd
  redir END
endfunction
command! -nargs=1 -complete=command CopyCmdOutput call s:func_copy_cmd_output(<q-args>)

" 1行以内の編集でも quote1 ～ quote9 に保存
" http://sgur.tumblr.com/post/63476292878/vim
function! s:update_numbered_registers()
  let reg = getreg('"')
  if len(split(reg, '\n')) == 1 && reg != getreg(1)
    for i in range(9, 2, -1)
      call setreg(i, getreg(i-1))
    endfor
    call setreg(1, reg)
  endif
endfunction

autocmd MyAutoCmd TextChanged * call s:update_numbered_registers()

" <C-@>  : 直前に挿入したテキストをもう一度挿入し、ノーマルモードに戻る
" <C-g>u : アンドゥ単位を区切る
inoremap <C-@> <C-g>u<C-@>

" The end of 編集系 }}}
"-----------------------------------------------------------------------------
" 操作の簡単化 "{{{

" <C-[>はVim内部で<Esc>として扱われるみたいなので注意(<Esc>のマッピングが適用)
" <Esc>は遠いし、<C-[>は押しにくいイメージ、<C-c>はInsertLeaveが発生しない。
" jjは一時的な入力が発生して精神衛生上よろしくない。そこで<C-j>を使う。
" -> eskk.vimで<C-j>を使うみたいなので、試すときは注意。
inoremap <C-j> <Esc>
inoremap <C-[> <Esc>

" /*******************************************************************/
" /* IMEに関して、以下のように設定しておくと良い感じになる           */
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

" タブ操作を簡単化
nnoremap ,tt :<C-u>tabnew<CR>

" .vimrcをリロード
nmap ,r :<C-u>source $MYVIMRC<CR><Esc>

" " オート版は違和感あったりlightlineの表示がおかしくなったりで微妙
" autocmd MyAutoCmd BufWritePost $MYVIMRC source $MYVIMRC

" 検索テキストハイライトを消す
nmap <silent><Esc> :<C-u>nohlsearch<CR>

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

" " 最後のウィンドウがuniteでも自動で閉じたい...けどやり方がわからない
" " -> 閉じたくないこともあるのでとりあえず放置
" autocmd MyAutoCmd WinEnter *
"   \ if (winnr('$') == 1) &&
"   \ ((getbufvar(winbufnr(0), '&buftype')) == 'quickfix' ||
"   \  (getbufvar(winbufnr(0), '&buftype')) == 'unite') | quit | endif

" " 開いたファイルと同じ場所へ移動する
" " ネットワーク上のファイルにアクセスした時に問題が起きる？
" " -> 基本VimFilerを使うので let g:vimfiler_enable_auto_cd = 1 しておけばOK
" autocmd MyAutoCmd BufEnter * execute 'lcd ' fnameescape(expand('%:p:h'))

" 保存時にViewの状態を保存し、読み込み時にViewの状態を前回の状態に戻す
" http://ac-mopp.blogspot.jp/2012/10/vim-to.html
" パターンマッチが修正前だと:helpなどにも反応してしまうので修正
" -> プラグインの挙動とぶつかってエラーになるらしいこともあるらしい
"    https://github.com/Shougo/vimproc.vim/issues/116
autocmd MyAutoCmd BufWritePost ?* mkview
autocmd MyAutoCmd BufReadPost  ?* loadview

" 新規タブでgf
nnoremap tgf :<C-u>execute 'tablast <bar> tabfind ' . expand('<cfile>')<CR>

" The end of 操作の簡単化 }}}
"-----------------------------------------------------------------------------
" tags, pathの設定 "{{{

" タグジャンプ時に候補が複数あった場合リスト表示
nnoremap <C-]> g<C-]>zz

" 新規タブでタグジャンプ
function! s:TabTagJump(funcName)
  tablast | tabnew
  " ctagsファイルを複数生成して優先順位を付けているなら'tag'にする
  " execute 'tag' a:funcName

  " 1つの大きいctagsファイルを生成している場合はリストから選べる'tjump'にする
  execute 'tjump' a:funcName
endfunction
command! -nargs=1 TabTagJump call s:TabTagJump(<f-args>)
nnoremap t<C-]> :<C-u>TabTagJump <C-r><C-w><CR>

let g:code_list = [
    \   'hoge',
    \ ]
let g:numberOfCode = len(g:code_list)
let g:indexOfCode = 0

" Gtagsのタグファイルがあるディレクトリの指定
function! s:set_src_dir()
  let $SRC_DIR = 'D:\hogehoge\'
  let $TARGET_VER = g:code_list[g:indexOfCode]
  let $TARGET_DIR = $SRC_DIR . $TARGET_VER
  let $GTAGSROOT = $TARGET_DIR
endfunction

" pathの設定(ここに設定したパスはfind等の検索対象に含まれる)
let g:path_list = [
  \   'hoge',
  \   'fuga',
  \ ]

function! s:set_path_list()
  set path=
  for item in g:path_list
    let $SET_PATH = $TARGET_DIR . item
    set path+=$SET_PATH
  endfor
endfunction

let g:cdpath_list = [
  \   '',
  \   '\foo',
  \   '\foo\bar',
  \ ]

" pathの設定(ここに設定したパスはfind等の検索対象に含まれる)
function! s:set_cdpath_list()
  set cdpath=
  set cdpath+=D:\hoge\fuga
  for item in g:cdpath_list
    let $SET_CDPATH = $TARGET_DIR . item
    set cdpath+=$SET_CDPATH
  endfor
endfunction

" ctagsのタグファイルがあるディレクトリの指定
function! s:set_tags()
  set tags=
  let $SET_TAGS = $TARGET_DIR . '\tags'
  set tags+=$SET_TAGS
endfunction

if has('vim_starting')
  call s:set_src_dir()
  call s:set_path_list()
  call s:set_cdpath_list()
  call s:set_tags()
endif

" 使用するコード(環境変数)をスイッチする
function! s:SwitchSource()
  let g:indexOfCode += 1
  if g:indexOfCode >= g:numberOfCode
    let g:indexOfCode = 0
  endif

  call s:set_src_dir()
  call s:set_path_list()
  call s:set_cdpath_list()
  call s:set_tags()

  " ソース切り替え後のバージョン名を出力
  echo "change source to: " . $TARGET_VER

endfunction
command! -nargs=0 SwitchSource call s:SwitchSource()
nnoremap ,s :<C-u>SwitchSource<CR>

" 現在開いているファイルのディレクトリに移動
function! s:ChangeDir(dir)
  cd %:p:h
  echo "change directory to: " . a:dir
endfunction
command! -nargs=0 CD call s:ChangeDir(expand('%:p:h'))

" The end of tags, pathの設定 }}}
"-----------------------------------------------------------------------------
" 誤爆防止関係 " {{{

" レジスタ機能のキーを<S-q>にする(Exモードは使わないので潰す)
nnoremap q     <Nop>
nnoremap <S-q> q

" 「保存して閉じる」「保存せず閉じる」を無効にする
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" よくわからないけど終了されて困るので防ぐ
nnoremap q<Space> <Nop>

" よくわからないけど矩形Visualモードになるので潰す
nnoremap <C-q> <Nop>

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
" Plugin Settings " {{{

" 入力補完(neocomplete.vim)  " {{{
if neobundle#tap('neocomplete.vim')

  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_smart_case = 1
  let g:neocomplete#auto_completion_start_length = 2
  let g:neocomplete#skip_auto_completion_time = '0.2'

  " 使用する補完の種類を減らす
  " 現在のsourceの取得は :echo keys(neocomplete#variables#get_sources())
  " ['file', 'tag', 'vimshell/history', 'neosnippet', 'vim', 'dictionary',
  "  'omni', 'vimshell', 'member', 'syntax', 'include', 'buffer', 'file/include']
  " http://alpaca.tc/blog/vim/neocomplete-vs-youcompleteme.html
  if !exists('g:neocomplete#sources')
    let g:neocomplete#sources = {}
  endif
  let g:neocomplete#sources._ =
    \ ['buffer', 'member', 'tag', 'file', 'neosnippet']

  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif

  " 日本語を補完候補として取得しないようにする
  let g:neocomplete#keyword_patterns._ = '\h\w*'

endif " }}}

" 入力補助(neosnippet) " {{{
if neobundle#tap('neosnippet')
  call neobundle#config({
    \   'autoload' : {
    \     'on_source' : [ 'neocomplete.vim' ]
    \   }
    \ })

  " デフォルトのスニペットがコーディング規約と離れたものになっているので要修正
  let g:neosnippet#snippets_directory =
    \ '~/.vim/bundle/neosnippet-snippets/neosnippets'

  " neocompleteとneosnippetを良い感じに使うためのキー設定
  " http://kazuph.hateblo.jp/entry/2013/01/19/193745
  imap <expr><TAB> pumvisible() ? "\<C-n>" :
    \     neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
  smap <expr><TAB>
    \     neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
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
  " if executable('jvgrep')
  "   let $JVGREP_OUTPUT_ENCODING = 'sjis'
  "   let g:unite_source_grep_command = 'jvgrep'
  "   let g:unite_source_grep_default_opts = '-i --exclude ''\.(git|hg)'''
  "   let g:unite_source_grep_recursive_opt = '-R'
  "   let g:unite_source_grep_max_candidates = 0
  " endif

  if executable('pt')
    let g:unite_source_grep_command = 'pt'
    let g:unite_source_grep_default_opts = '--nocolor --nogroup'
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_grep_encoding = 'utf-8'
    let g:unite_source_grep_max_candidates = 0
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
  let g:u_opt_bo =                       g:u_vopt
  " let g:u_opt_co =                       g:u_hopt            . g:u_sins
  " let g:u_opt_cs =                       g:u_prev            . g:u_nins
  let g:u_opt_fi =            g:u_tabo            . g:u_fbuf . g:u_ninp
  let g:u_opt_fm =                                  g:u_fbuf
  let g:u_opt_gd =                       g:u_nqui . g:u_vopt
  let g:u_opt_gg =                                  g:u_sbuf . g:u_sync
  let g:u_opt_gr =                       g:u_nqui . g:u_vopt
  " let g:u_opt_he =                                             g:u_sins
  " let g:u_opt_hl =                                             g:u_nins
  let g:u_opt_jj = ''
  let g:u_opt_jn =                                               g:u_sins
  let g:u_opt_li = ''
  " let g:u_opt_li =                                             g:u_sins
  " let g:u_opt_mg =            g:u_tabo            . g:u_sbuf . g:u_sync
  let g:u_opt_mm =                         g:u_vopt
  let g:u_opt_mp = ''
  let g:u_opt_ol =                       g:u_vopt            . g:u_sins
  let g:u_opt_op = ''
  let g:u_opt_re =                         g:u_sbuf
  " let g:u_opt_us =                       g:u_vopt            . g:u_sins
  let g:u_opt_ya =                                             g:u_nins

  " Auto Preview が上手く動かないことが多い謎。
  " -> 重すぎてプレビュー表示に時間がかかっているだけだった。
  " let g:u_opt_bu =                     g:u_prev
  " let g:u_opt_fm =          g:u_tabo . g:u_prev            . g:u_fbuf
  " let g:u_opt_gd =          g:u_tabo . g:u_prev . g:u_vopt
  " let g:u_opt_gg =          g:u_tabo . g:u_prev . g:u_sbuf . g:u_sync . g:u_nqui
  " let g:u_opt_gr =          g:u_tabo . g:u_prev . g:u_vopt            . g:u_nqui
  " let g:u_opt_mm =          g:u_tabo . g:u_prev . g:u_vopt

  nnoremap <expr><Leader>bu ':<C-u>Unite buffer'       . g:u_opt_bu . '<CR>'
  nnoremap <expr><Leader>bo ':<C-u>Unite bookmark'     . g:u_opt_bo . '<CR>'
  nnoremap <expr><Leader>fi ':<C-u>Unite file'         . g:u_opt_fi . '<CR>'
  nnoremap <expr><Leader>fm ':<C-u>Unite file_mru'     . g:u_opt_fm . '<CR>'
  nnoremap <expr><Leader>gd ':<C-u>Unite gtags/def'    . g:u_opt_gd . '<CR>'
  nnoremap <expr><Leader>gg ':<C-u>Unite grep:'        . g:u_opt_gg . '<CR>'
  nnoremap <expr><Leader>gr ':<C-u>Unite gtags/ref'    . g:u_opt_gr . '<CR>'
  nnoremap <expr><Leader>jn ':<C-u>Unite junkfile/new' . g:u_opt_jn . '<CR>'
  nnoremap <expr><Leader>jj ':<C-u>Unite junkfile'     . g:u_opt_jj . '<CR>'
  nnoremap <expr><Leader>li ':<C-u>Unite line'         . g:u_opt_li . '<CR>'
  nnoremap <expr><Leader>mm ':<C-u>Unite mark'         . g:u_opt_mm . '<CR>'
  nnoremap <expr><Leader>mp ':<C-u>Unite mapping'      . g:u_opt_mp . '<CR>'
  nnoremap <expr><Leader>op ':<C-u>Unite output'       . g:u_opt_op . '<CR>'
  nnoremap <expr><Leader>re ':<C-u>UniteResume'        . g:u_opt_re . '<CR>'
  nnoremap <expr><Leader>ya ':<C-u>Unite history/yank' . g:u_opt_ya . '<CR>'
  nnoremap <expr><Leader>ol ':<C-u>Unite outline'      . g:u_opt_ol . '<CR>'
  " nnoremap <expr><Leader>op ':<C-u>Unite output'       . g:u_opt_op . '<CR>'
  " nnoremap <expr><Leader>us ':<C-u>Unite ultisnips'    . g:u_opt_us . '<CR>'

  let s:hooks = neobundle#get_hooks('unite.vim')
  function! s:hooks.on_source(bundle)
    call unite#custom_default_action('source/bookmark/directory', 'vimfiler')
    call unite#custom_default_action('directory',                 'vimfiler')
    call unite#custom_default_action('directory_mru',             'vimfiler')
    autocmd MyAutoCmd FileType unite call s:unite_settings()
    function! s:unite_settings()
      nmap <buffer><Esc> <Plug>(unite_all_exit)
      nmap <buffer><C-j> <Nop>
      nmap <buffer><C-K> <Nop>

      " " unite-candidate_sorter
      " nmap <buffer>S <Plug>(unite-candidate_sort)

      " unite中はdicwinを無効化。ローカルで辞書検索できるdicwinの代替が欲しい。
      nmap <buffer><C-k><C-w> <Nop>
      nmap <buffer><C-k><C-p> <Nop>
      nmap <buffer><C-k><C-n> <Nop>
      nmap <buffer><C-k><C-k> <Nop>
      nmap <buffer><C-k>/     <Nop>
      nmap <buffer><C-k>c     <Nop>
      nmap <buffer><C-k>w     <Nop>
      nmap <buffer><C-k>p     <Nop>
      nmap <buffer><C-k>n     <Nop>

      imap <buffer><C-j> <Plug>(unite_insert_leave)
      imap <buffer><C-[> <Plug>(unite_insert_leave)
    endfunction
  endfunction

endif " }}}

" Vim上で動くシェル(vimshell) {{{
if neobundle#tap('vimshell')

  let g:vimshell_force_overwrite_statusline = 0

  " 開いているファイルのパスでVimShellを開く
  nnoremap <expr><Leader>vs ':<C-u>VimShellTab<Space>' . expand("%:h") . '<CR>'

endif " }}}

" Vim上で動くファイラ(vimfiler.vim) {{{
if neobundle#tap('vimfiler.vim')

  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_edit_action = 'tabopen'
  let g:vimfiler_enable_auto_cd = 1
  let g:vimfiler_force_overwrite_statusline = 0
  let g:vimfiler_safe_mode_by_default = 0

  " 開いているファイルのパスでVimFilerを開く
  nnoremap <expr><Leader>vf ':<C-u>VimFilerTab<Space>' . expand("%:h") . '<CR>'

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

" 入力補完(YouCompleteMe) " {{{
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

  " 'GoTo*'コマンドの挙動は以下のどれかから選択。
  " [ 'same-buffer', 'horizontal-split', 'vertical-split', 'new-tab' ]
  let g:ycm_goto_buffer_command = 'same-buffer'

endif " }}}

" 入力補助(ultisnips) " {{{
if neobundle#tap('ultisnips')
  call neobundle#config({
    \   'autoload' : {
    \     'on_source' : [ 'YouCompleteMe' ]
    \   }
    \ })

  " YCMとultisnipsを組み合わせる時に<TAB>の使い方がコンフリクトするらしい。
  " YCM的には「いい感じに設定してね」という風に読めたのでググってコピペ。
  " http://stackoverflow.com/questions/14896327/ultisnips-and-youcompleteme
  let g:UltiSnipsExpandTrigger = '<TAB>'
  let g:UltiSnipsJumpForwardTrigger = '<TAB>'
  let g:UltiSnipsJumpBackwardTrigger = '<S-TAB>'
  let g:UltiSnipsListSnippets = '<C-e>'

  " snippetの作成先を以下で指定。
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
  inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

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

" Vimの起動速度UP(vim-singleton) {{{
if neobundle#tap('vim-singleton')

  call singleton#enable()

endif " }}}

" Vim上で書いているスクリプトをすぐ実行(vim-quickrun) {{{
if neobundle#tap('vim-quickrun')

  let g:quickrun_config = {
    \   '_' : {
    \     'outputter/buffer/split' : ':botright 12sp',
    \   },
    \   'vb' : {
    \     'command'  : 'cscript',
    \     'cmdopt'   : '//Nologo',
    \     'tempfile' : '{tempname()}.vbs',
    \   },
    \ }

"   \   'watchdogs_checker/_' : {
"   \     'runner/vimproc/updatetime'       : 40,
"   \     'hook/close_quickfix/enable_exit' :  1,
"   \   },
"   \   'watchdogs_checker/gcc' : {
"   \     'command' : 'gcc',
"   \     'cmdopt'  : '-Wall',
"   \     'exec'    : '%c %o -fsyntax-only %s:p ',
"   \   },
"   \   'c/watchdogs_checker' : {
"   \     'type' : 'watchdogs_checker/gcc',
"   \   },
"   \   'watchdogs_checker/ruby' : {
"   \     'command' : 'ruby',
"   \     'exec'    : '%c %o -c %s:p ',
"   \   },
"   \   'ruby/watchdogs_checker' : {
"   \     'type' : 'watchdogs_checker/ruby',
"   \   },
"   \ }

" " clangを使う時の設定はこんな感じ？
"   \   'cpp' : {
"   \     'type' : 'cpp/clang3_4'
"   \   },
"   \   'cpp/clang3_4' : {
"   \       'command' : 'C:\LLVM\bin\clang++.exe',
"   \       'exec'    : '%c %o %s -o %s:p:r',
"   \       'cmdopt'  : '-std=gnu++0x'
"   \   },

  " デフォルトの<Leader>rだと入力待ちがあるので、別のキーでマッピングする
  let g:quickrun_no_default_key_mappings = 1
  nnoremap <Leader>qr :<C-u>QuickRun -hook/time/enable 1<CR>
  vnoremap <Leader>qr :<C-u>QuickRun -hook/time/enable 1<CR>

endif " }}}

" コマンド名補完(vim-ambicmd)
" ->下手にマッピングするよりもambicmdに補完させた方がイイ {{{
if neobundle#tap('vim-ambicmd')

  cnoremap <expr><Space> ambicmd#expand("\<Space>")

endif " }}}

" Vimの文字サイズ変更を簡易化(vim-fontzoom) {{{
if neobundle#tap('vim-fontzoom')

  nnoremap <silent>,f :<C-u>Fontzoom!<CR>
  " vim-fontzoomには、以下のデフォルトキーマッピングが設定されている。
  " nnoremap <C-ScrollWheelUp>   <Plug>(fontzoom-larger)
  " nnoremap <C-ScrollWheelDown> <Plug>(fontzoom-smaller)
  " -> しかし、Vimの既知のバグでWindows環境ではC-Scrollを使えないらしい。
  " -> (参考URL)https://github.com/vim-jp/issues/issues/73

endif " }}}

" キー連打を便利に。ただし再描画がうっとおしい(vim-submode) {{{
if neobundle#tap('vim-submode')

  let g:submode_timeout = 0

  " " gtttttt...で次のタブへ移動
  " -> <C-PageDown><C-Pageup>の方が良い。
  " -> [N]gtだと一発。こっちは1 origin
  " call submode#enter_with('changetab', 'n', '', 'gt', 'gt')
  " call submode#enter_with('changetab', 'n', '', 'gT', 'gT')
  " call submode#map       ('changetab', 'n', '', 't',  'gt')
  " call submode#map       ('changetab', 'n', '', 'T',  'gT')

  function! s:modulo(n, m)
    let d = a:n * a:m < 0 ? 1 : 0
    return a:n + (-(a:n + (0 < a:m ? d : -d)) / a:m + d) * a:m
  endfunction

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

" アスタリスク検索開始時にジャンプせず、その場に留まる(visualstar) {{{
if neobundle#tap('visualstar')

  " 飛んだ時にちらつく...
  " -> set lazyredrawで解決する？と思ったがzzが内蔵されているぽいのでダメだった
  " set lazyredraw " 手動で行ってない操作は完了するまで画面を再描画しない
  vmap * <Plug>(visualstar-*)N

endif " }}}

" Vim上で自動構文チェック(vim-watchdogs)
" -> 裏で実行した結果を反映するからか、pause系の処理があると固まる {{{
if neobundle#tap('vim-watchdogs')
  call neobundle#config({
    \   'autoload' : {
    \     'on_source' : [ 'vim-quickrun' ]
    \   }
    \ })

  " quickrun_configにwatchdogs.vimの設定を追加
  call watchdogs#setup(g:quickrun_config)

endif " }}}

" 何番目の検索対象か／検索対象の総数を表示(vim-anzu) {{{
if neobundle#tap('vim-anzu')

  " " 検索対象横にechoする。視線移動は減るが結構見づらくなるので慣れが必要
  " nmap n <Plug>(anzu-mode-n)
  " nmap N <Plug>(anzu-mode-N)
  "
  " " 検索開始時にジャンプせず、その場でanzu-modeに移行する
  " nmap <expr>* ':<C-u>call anzu#mode#start("<C-R><C-W>", "", "", "")<CR>'

  " コマンド結果出力画面にecho
  nmap n <Plug>(anzu-n-with-echo)
  nmap N <Plug>(anzu-N-with-echo)
  " nmap * <Plug>(anzu-star-with-echo)N

endif " }}}

" <cword>を強調(vim-brightest) {{{
if neobundle#tap('vim-brightest')

  " " 文字色で強調したい場合
  " let g:brightest#highlight = {
  "   \   "group"    : "WarningMsg",
  "   \   "priority" : -1,
  "   \   "format"   : '\<%s\>',
  "   \ }

  " アンダーラインで強調したい場合
  let g:brightest#highlight = {
    \   "group" : "BrightestUnderline"
    \ }

  " " 波線で強調したい場合
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

" 文字列置換を視覚的にわかりやすく(vim-over) {{{
if neobundle#tap('vim-over')

  let g:over_enable_auto_nohlsearch = 0

  nnoremap <Leader>ss :<C-u>OverCommandLine %s/<CR>

endif " }}}

" Vim上で自動構文チェック(syntastic)
" -> syntasticは非同期チェックできない {{{
if neobundle#tap('syntastic')

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
  nnoremap <expr><Leader>mg ':<C-u>Unite grep:~/memo' . g:u_opt_mg . '<CR>'

endif " }}}

" markdownを使いやすくする(vim-markdown) {{{
if neobundle#tap('vim-markdown')

  " markdownのfold機能を無効にする
  let g:vim_markdown_folding_disabled = 1

  nmap <Leader>L <Plug>(openbrowser-smart-search)
  vmap <Leader>L <Plug>(openbrowser-smart-search)

endif " }}}

" コマンド名を置き換える(vim-altercmd) {{{
if neobundle#tap('vim-altercmd')
  call altercmd#load()

endif " }}}

" 連番入力補助(vim-rengbang) " {{{
if neobundle#tap('vim-rengbang')

  let g:rengbang_default_start = 1

endif " }}}

" 囲む / 囲まなくする / 別の何かで囲む(vim-surround) " {{{
if neobundle#tap('vim-surround')

  " (例) sw' /* 次の単語を''で囲む */
  nmap s <plug>Ysurround

  " (例) S'  /* カーソル行以降を''で囲む */
  nmap S <plug>Ysurround$

  " (例) ss' /* 行を''で囲む */
  nmap ss <plug>Yssurround

endif " }}}

" 他のVisualモードでも矩形Visualモード挿入できるようにする(vim-niceblock) " {{{
if neobundle#tap('vim-niceblock')

  " 矩形Visualモード以外のVisualモードでも2byte文字の文字幅を考慮した置換を行う
  xnoremap <expr>r niceblock#force_blockwise('r')

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
    nmap sf/ <Plug>(operator-search)<Plug>(textobj-function-i)
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
  inoremap <expr>. smartchr#one_of('.', '->', '..')

  " " if文直後の(は自動で間に空白を入れる
  " " -> 時々空白を入れたくない時があるので、とりあえずコメントアウト
  " inoremap <expr>( search('\<\if\%#', 'bcn') ? ' (' : '('

  " ruby / eruby の時だけ設定
  autocmd MyAutoCmd FileType ruby,eruby call s:ruby_settings()
  function! s:ruby_settings()
    inoremap <buffer><expr>{ smartchr#one_of('{', '#{', '{{')
  endfunction

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
  " nmap <silent><Esc> :<C-u>nohlsearch<CR>:<C-u>QuickhlManualReset<CR>

endif " }}}

" incsearchをパワーアップ(incsearch.vim) {{{
if neobundle#tap('incsearch.vim')

  map / <Plug>(incsearch-forward)

endif " }}}

" VCSの差分をVimのsignで表示(vim-signify) {{{
if neobundle#tap('vim-signify')

  nmap gj <Plug>(signify-next-hunk)zz
  nmap gk <Plug>(signify-prev-hunk)zz
  nmap gh <Plug>(signify-toggle-highlight)

endif " }}}

" VimからGitを使う(vim-fugitive) {{{
if neobundle#tap('vim-fugitive')

endif " }}}

" ctagsを使ってアウトラインを作成(tagbar) {{{
if neobundle#tap('tagbar')

  " tagbarでctags日本語版を使うとエラーが出るみたい
  let g:tagbar_ctags_bin = '$VIM\ctags.exe'
  let g:tagbar_sort = 0
  let g:tagbar_type_vim = {
    \   'kinds'       : [
    \     'v:variables',
    \     'f:functions',
    \   ]
    \ }
  nmap <silent><F8> :<C-u>TagbarToggle<CR>

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
    \               [ 'filename',   'fugitive',     'currenttag' ], ],
    \   'right' : [ [ 'lineinfo',   'syntastic'],
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
    return (&ft == 'unite'       ? unite#get_status_string()    :
      \     &ft == 'vimfiler'    ? vimfiler#get_status_string() :
      \     &ft == 'vimshell'    ? vimshell#get_status_string() :
      \      '' != expand('%:p') ? expand('%:p')                : '[No Name]') .
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
    if &l:filetype ==# 'vim'
      return FoldCCnavi()
    endif
    return tagbar#currenttag('%s', '')
  endfunction

  function! MyFugitive()
    try
      if &ft !~? 'vimfiler' && exists('*fugitive#head')
        let _ = fugitive#head()
        return strlen(_) ? '⭠ ' . _ : ''
      endif
    catch
    endtry
    return ''
  endfunction

endif " }}}

" vimの折り畳み(fold)機能を便利に(foldCC) {{{
if neobundle#tap('foldCC')

  let g:foldCCtext_enable_autofdc_adjuster = 1
  set foldtext=FoldCCtext()
  set foldcolumn=1
  set foldlevel=1
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

endif " }}}

" Cygwin vimでクリップボード連携(vim-fakeclip) {{{
if neobundle#tap('vim-fakeclip')

  vmap <Leader>y <Plug>(fakeclip-y)
  nmap <Leader>p <Plug>(fakeclip-p)

endif " }}}

" ペースト-><C-n>or<C-p>でクリップボードの履歴をぐるぐる(yankround.vim) {{{
if neobundle#tap('yankround.vim')

  let g:yankround_region_hl_groupname = 'ErrorMsg'

  nmap p     <Plug>(yankround-p)
  nmap P     <Plug>(yankround-P)
  nmap gp    <Plug>(yankround-gp)
  nmap gP    <Plug>(yankround-gP)
  nmap <C-n> <Plug>(yankround-next)
  nmap <C-p> <Plug>(yankround-prev)

endif " }}}

" 簡単にテキスト整形(vim-easy-align) {{{
if neobundle#tap('vim-easy-align')

  vnoremap <silent><CR> :EasyAlign<CR>

endif " }}}

" vimのf検索を便利に(clever-f.vim) {{{
if neobundle#tap('clever-f.vim')

  let g:clever_f_smart_case = 1
  let g:clever_f_fix_key_direction = 1
  let g:clever_f_chars_match_any_signs = ';'

endif " }}}

" clever-fの2文字版(vim-sneak) {{{
if neobundle#tap('vim-sneak')

  let g:sneak#s_next = 1     " clever-f ならぬ clever-s な動作にする
  let g:sneak#use_ic_scs = 1 " ignorecaseやらsmartcaseの設定を反映する

  " sは潰されやすいが、fは潰されるケースが少ないのでfを使う
  " -> 下記設定により、繰り返し時も f / F を使うようになる
  nmap f <Plug>Sneak_s
  nmap F <Plug>Sneak_S
  xmap f <Plug>Sneak_s
  xmap F <Plug>Sneak_S
  omap f <Plug>Sneak_s
  omap F <Plug>Sneak_S

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

  nnoremap ,, :<C-u>Startify<CR>
  let g:startify_files_number = 4
  let g:startify_change_to_dir = 1
  let g:startify_bookmarks = [
    \   '.',
    \   '~\.vimrc',
    \ ]

  let g:startify_list_order = [
    \   [ 'My bookmarks:'               ], 'bookmarks',
    \   [ 'Last recently opened files:' ], 'files',
    \ ]

endif " }}}

" シンボル、関数の参照位置検索(GNU GLOBAL, gtags.vim) {{{
if neobundle#tap('gtags.vim')

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

" The end of Plugin Settings }}}
"-----------------------------------------------------------------------------
" 趣味＠正式採用前の設定 "{{{

" ミニマップってあったら便利？
" " -> あったらあったで結構良いかも。アウトライン系で十分な気もする
" " -> swapファイルに怒られるので必ず読み取り専用で開いてほしい…
" set noswapfile
" NeoBundle 'mattn/minimap-vim'
" まだ開発初期っぽいので、今後に期待。
" NeoBundle 'severin-lemaignan/vim-minimap'

" " 画面内移動を楽にするプラグイン
" " 試した感じ、けっこうイケてる、けど若干見た目が精神衛生上よろしくない
" " 個人的にはclever-f, vim-sneakがあれば良いかなあと
" NeoBundle 'haya14busa/vim-easymotion'

" " テキスト整形する
" " -> なんだかんだで使ってない。
" NeoBundle 'h1mesuke/vim-alignta'
" NeoBundle 'osyo-manga/vim-operator-alignta'

" " HTMLコーディングを爆速化するらしい
" " -> HTML書く機会が無かった。そのうち使いたい。
" NeoBundle 'mattn/emmet-vim'

" " Gistへの投稿がすごく楽になったりするらしい
" " -> Gist書く機会が無かった。そのうち使いたい。
" NeoBundle 'mattn/gist-vim'

" " 空ファイルテンプレートを実現する
" " -> 使いたい候補上位だけど、まだ使ってない。
" NeoBundle 'thinca/vim-template'

" " リッチなカレンダー
" " -> 試してみたら確かにリッチだった。実用性はよくわからない。
" NeoBundle 'itchyny/calendar.vim'

" " 幅の違う矩形オブジェクトに対するオペレータ(の動作をエミュレートしたもの)
" " -> なんだかんだと出番がありそうなオペレータ。割り当てるキーを確保したい
" NeoBundle 'osyo-manga/vim-operator-blockwise'

" " <CR>で良い感じにテキストオブジェクトを選択し、Vim力を下げるプラグイン
" " -> 面白い、が今ひとつ使う機会が無い。
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
"     let options = [
"       \ 'set columns=' . &columns,
"       \ 'set lines=' . &lines,
"       \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
"       \ ]
"     call writefile(options, g:save_window_file)
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
"   let window_counter = 0
"   windo let window_counter = window_counter + 1
"
"   if window_counter == 1
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

