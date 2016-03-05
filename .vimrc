" vimrc for GVim

"-----------------------------------------------------------------------------
" Basic {{{

" Do first!
" http://rbtnn.hateblo.jp/entry/2014/11/30/174749
setglobal encoding=utf-8
scriptencoding utf-8

" マッピング用prefixキー(<Leader>)を変更
let g:mapleader      = '[Leader]'
let g:maplocalleader = "\<S-Space>"
noremap [Leader]              <Nop>
map             <Space>       [Leader]
noremap [Leader]<Space>       <Nop>
map             <LocalLeader> [Leader]
noremap [Leader]<LocalLeader> <Nop>

" vimrc内全体で使うaugroupを定義
augroup MyAutoCmd
  autocmd!
augroup END

" SID取得関数を定義
function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\d_')
endfunction

" setglobalがVim起動直後に生成されるバッファに適用されない件の対策
function! s:regenerateFirstBuffer(path)
  if argc() >= 1 | bdelete | execute 'edit ' . a:path
  else           | new     | execute 'wincmd w'       | bdelete | endif
endfunction
autocmd MyAutoCmd VimEnter * call s:regenerateFirstBuffer(expand('%:p'))

" Vim起動時間を計測(実際のVimの起動時間は表示値+0.5秒程度)
if has('vim_starting') && has('reltime')
  let s:startuptime = reltime()
  autocmd MyAutoCmd VimEnter * echomsg 'startuptime: ' . reltimestr(reltime(s:startuptime))
endif

" " 書き込み時の文字エンコーディング(encodingと同じ値にしたい場合は設定不要)
" setglobal fileencoding=utf-8

" 読み込み時の文字エンコーディング候補
if has('kaoriya')
  setglobal fileencodings=guess
else
  setglobal fileencodings=cp932,euc-jp,utf-8
endif

" 文字エンコーディングを指定してファイルを開き直す
nnoremap <Leader>en :<C-u>e ++encoding=

"           改行コードを指定してファイルを開き直す
nnoremap <Leader>ff :<C-u>e ++fileformat=

" スワップファイルは作らない
setglobal noswapfile

" ファイル書き込み時にバックアップファイルを生成する(デフォルトの設定と同じ)
setglobal nobackup writebackup

" 元ファイルをコピーしてバックアップにする&更新を元ファイルに書き込む
setglobal backupcopy=yes

" Vim生成物の生成先ディレクトリ指定
let s:saveUndoDir = expand('~/vimfiles/undo')
if !isdirectory(s:saveUndoDir) | call mkdir(s:saveUndoDir) | endif
if has('persistent_undo')
  let &g:undodir = s:saveUndoDir
  setglobal undofile
endif

" Windowsは_viminfo, 他は.viminfoとする
if has('win32') || has('win64')
  setglobal viminfo='30,<50,s100,h,rA:,rB:,n~/_viminfo
else
  setglobal viminfo='30,<50,s100,h,rA:,rB:,n~/.viminfo
endif

setglobal nospell          " デフォルトではスペルチェックしない
setglobal spelllang=en,cjk " 日本語はスペルチェックから除外
setglobal spellfile=~/dotfiles/en.utf-8.add

" コマンドと検索の履歴は多めに保持できるようにしておく
setglobal history=1000

" 開いているファイルがVimの外部で変更された時, 自動的に読み直す
setglobal autoread

" メッセージ省略設定
setglobal shortmess=aoOotTWI

" カーソル上下に表示する最小の行数(大きい値:カーソル移動時に必ず画面再描画)
autocmd MyAutoCmd VimEnter * let &g:scrolloff = (winheight(0) / 2) | let s:scrolloffOn = 1
function! s:ToggleScrollOffSet()
  let s:scrolloffOn = (s:scrolloffOn + 1) % 2
  if  s:scrolloffOn
    let &g:scrolloff = (winheight(0) / 2) | set scrolloff?
  else
    let &g:scrolloff = 0                  | set scrolloff?
  endif
endfunction
nnoremap <silent> <F2> :<C-u>call <SID>ToggleScrollOffSet()<CR>

" vimdiff用オプション
" filler   : 埋め合わせ行を表示する
" vertical : 縦分割する
setglobal diffopt=filler,vertical

"}}}
"-----------------------------------------------------------------------------
" Plugin List {{{

" filetype関連のファイルはruntimepathの登録が終わってから読み込むため, 一旦オフ
filetype plugin indent off

" 実は必要のないset nocompatible
" http://rbtnn.hateblo.jp/entry/2014/11/30/174749
if has('vim_starting')
  if &compatible
    setglobal nocompatible " Vi互換モードをオフ(Vimの拡張機能を有効化)
  endif
  " neobundle.vimでプラグインを管理する
  " →どーしてもNeoBundleCleanを使いたいので小細工してみる
  if   isdirectory(expand('~/.vim/bundle/neobundle.vim_673be4e/'))
    setglobal runtimepath+=~/.vim/bundle/neobundle.vim_673be4e/
  else
    setglobal runtimepath+=~/.vim/bundle/neobundle.vim/
  endif
endif

" contains filetype off
call neobundle#begin(expand('~/.vim/bundle'))

" NeoBundle自体の更新をチェックする
" →どーしてもNeoBundleCleanを使いたいので実質更新チェックしない書き方にしている
NeoBundleFetch 'Shougo/neobundle.vim', {'rev' : '673be4e'}

" 日本語ヘルプを卒業したいが, なかなかできない
NeoBundleLazy 'vim-jp/vimdoc-ja'
setglobal helplang=ja

" ヴィむぷろしー
NeoBundleLazy 'Shougo/vimproc.vim', {
      \   'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \   },
      \ }

"-------------------------------------------------------------------
" Version Control System {{{

NeoBundle 'mhinz/vim-signify'

NeoBundleLazy 'lambdalisue/vim-gita', {'rev' : 'alpha-3', 'on_cmd' : 'Gita'}

" vim-gitaと依存関係は無いが一緒に読み込みたい
NeoBundleLazy 'cohama/agit.vim', {
      \   'depends' : 'lambdalisue/vim-gita',
      \   'on_cmd' : ['Agit', 'AgitFile'],
      \ }

"}}}
"-------------------------------------------------------------------
" simplify input {{{

NeoBundleLazy 'Shougo/neosnippet.vim', {
      \   'depends' : 'toshi32tony3/neosnippet-snippets',
      \   'on_i'    : 1,
      \   'on_ft'   : 'neosnippet',
      \ }
NeoBundleLazy 'toshi32tony3/neosnippet-snippets'

NeoBundleLazy 'tyru/eskk.vim',    {'on_map' : [['nic', '<Plug>']]}
NeoBundleLazy 'tyru/skkdict.vim', {'on_ft' : 'skkdict'}

NeoBundleLazy 'thinca/vim-ambicmd'

"}}}
"-------------------------------------------------------------------
" view {{{

" 本家 : 'sjl/badwolf'
NeoBundle 'toshi32tony3/badwolf'

NeoBundle 'cocopon/lightline-hybrid.vim'
NeoBundle 'itchyny/lightline.vim'

NeoBundleLazy 'thinca/vim-fontzoom', {
      \   'on_map' : '<Plug>',
      \   'on_cmd' : 'Fontzoom',
      \ }

"}}}
"-------------------------------------------------------------------
" move {{{

NeoBundleLazy 'haya14busa/incsearch.vim'
NeoBundle 'haya14busa/incsearch-index.vim', {'depends' : 'haya14busa/incsearch.vim'}

NeoBundleLazy 'osyo-manga/vim-anzu',     {'on_map' : '<Plug>'}
NeoBundleLazy 'haya14busa/vim-asterisk', {'on_map' : '<Plug>'}

NeoBundle 'deris/vim-shot-f'
NeoBundle 'justinmk/vim-sneak'

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
NeoBundleLazy 'kana/vim-textobj-indent', {
      \   'depends' : 'kana/vim-textobj-user',
      \   'on_map'  : [['xo', 'ii', 'ai', 'iI', 'aI']],
      \ }

"}}}
"-------------------------------------------------------------------
" operator {{{

NeoBundleLazy 'kana/vim-operator-user'

NeoBundleLazy 'kana/vim-operator-replace', {
      \   'depends' : 'kana/vim-operator-user',
      \   'on_map'  : [['nx', '<Plug>']],
      \ }
NeoBundleLazy 'osyo-manga/vim-operator-search', {
      \   'depends' : ['kana/vim-operator-user', 'kana/vim-textobj-function'],
      \   'on_map'  : [['nx', '<Plug>']],
      \ }
NeoBundleLazy 'sgur/vim-operator-openbrowser', {
      \   'depends' : ['kana/vim-operator-user', 'tyru/open-browser.vim'],
      \   'on_map'  : [['nx', '<Plug>']],
      \ }

NeoBundleLazy 'tyru/caw.vim', {
      \   'depends' : ['kana/vim-operator-user', 'kana/vim-textobj-indent'],
      \   'on_map'  : [['nx', '<Plug>(operator-caw)']],
      \ }
NeoBundleLazy 't9md/vim-quickhl', {
      \   'on_map'  : [['nx', '<Plug>(', '<Plug>(operator-quickhl-']],
      \ }

NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'

"}}}
"-------------------------------------------------------------------
" vimdiff {{{

NeoBundleLazy 'lambdalisue/vim-unified-diff'
NeoBundleLazy 'AndrewRadev/linediff.vim', {'on_cmd' : 'Linediff'}

"}}}
"-------------------------------------------------------------------
" interface {{{

NeoBundle 'mhinz/vim-startify'

NeoBundleLazy 'Shougo/unite.vim', {'on_cmd' : 'Unite'}

" 遅延読み込みすると候補収集されないので, Vim起動直後に読み込む
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/neoyank.vim'

NeoBundle 'hewes/unite-gtags',    {'depends' : 'Shougo/unite.vim'}
NeoBundle 'tacroe/unite-mark',    {'depends' : 'Shougo/unite.vim'}
NeoBundle 'Shougo/unite-outline', {'depends' : 'Shougo/unite.vim'}

NeoBundleLazy 'Shougo/vimshell.vim', {
      \   'depends' : 'Shougo/unite.vim',
      \   'on_path' : '.*',
      \ }

NeoBundleLazy 'Shougo/vimfiler.vim', {
      \   'depends' : 'Shougo/unite.vim',
      \   'on_path' : '.*',
      \ }

"}}}
"-------------------------------------------------------------------
" quickfix / special buffer {{{

NeoBundleLazy 'thinca/vim-qfreplace', {'on_cmd' : 'Qfreplace'}

NeoBundleLazy 'mtth/scratch.vim', {
      \   'on_map' : '<Plug>',
      \   'on_cmd' : ['Scratch', 'ScratchPreview'],
      \ }

" 本家 : 'koron/dicwin-vim'
NeoBundleLazy 'toshi32tony3/dicwin-vim', {'on_map' : [['ni', '<Plug>']]}

"}}}
"-------------------------------------------------------------------
" web / markdown {{{

NeoBundleLazy 'tyru/open-browser.vim', {
      \   'on_map' : '<Plug>(open',
      \   'on_cmd' : ['OpenBrowser', 'OpenBrowserSearch', 'OpenBrowserSmartSearch'],
      \ }

NeoBundleLazy 'basyura/twibill.vim'
NeoBundleLazy 'basyura/TweetVim', {
      \   'depends' : ['basyura/twibill.vim',  'tyru/open-browser.vim'],
      \   'on_cmd'  : ['TweetVimHomeTimeline', 'TweetVimSearch'],
      \ }
NeoBundleLazy 'basyura/J6uil.vim', {'on_cmd' : 'J6uil'}

" 本家 : 'kannokanno/previm'
NeoBundleLazy 'beckorz/previm', {'on_ft' : 'markdown'}

" 本家 : 'plasticboy/vim-markdown'
NeoBundleLazy 'rcmdnk/vim-markdown',    {'on_ft'  : 'markdown'}
NeoBundleLazy 'glidenote/memolist.vim', {'on_cmd' : 'MemoNew' }

NeoBundleLazy 'lambdalisue/vim-gista', {'on_cmd' : 'Gista'}

"}}}
"-------------------------------------------------------------------
" formatter {{{

" 本家 : 'bronson/vim-trailing-whitespace'
NeoBundle 'toshi32tony3/vim-trailing-whitespace'

NeoBundleLazy 'junegunn/vim-easy-align', {'on_cmd' : 'EasyAlign'}

"}}}
"-------------------------------------------------------------------
" quickrun {{{

NeoBundleLazy 'thinca/vim-quickrun', {'on_cmd' : 'QuickRun'}

" " 本家 : 'jceb/vim-hier'
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
setglobal tabstop=2 shiftwidth=2 softtabstop=0 expandtab
autocmd MyAutoCmd FileType c,cpp,make setlocal tabstop=4 shiftwidth=4
autocmd MyAutoCmd FileType make       setlocal noexpandtab

setglobal nrformats=hex              " <C-a>や<C-x>の対象を10進数,16進数に絞る
setglobal virtualedit=all            " テキストが存在しない場所でも動きたい
setglobal nostartofline              " カーソルが勝手に行の先頭へ行くのは嫌
setglobal hidden                     " quit時はバッファを削除せず, 隠す
setglobal confirm                    " 変更されたバッファを閉じる時に確認する
setglobal switchbuf=useopen          " 既に開かれていたら, そっちを使う
setglobal showmatch                  " 対応する括弧などの入力時にハイライト表示
setglobal matchtime=3                " 対応括弧入力時カーソルが飛ぶ時間を0.3秒に
setglobal backspace=indent,eol,start " <BS>でなんでも消せるようにする

" 矢印(->)を打つと対応が取れない括弧と認識され, bellが鳴るのでコメントアウト
" → 矢印は(→)を使おう
setglobal matchpairs+=<:>            " 対応括弧に'<'と'>'のペアを追加

" 汎用補完設定(complete)
" Default: complete=.,w,b,u,t,i
" . :      current buffer
" w :              buffers in other windows
" b : other loaded buffers in the buffer list
" u :     unloaded buffers in the buffer list
" U :              buffers that are not in the buffer list
" t : tag completion
"     → タグファイルが大きいと時間がかかるので汎用補完に含めない
" i : current and included files
" d : current and included files for defined name or macro
"     → インクルードファイルが多いと時間がかかるので汎用補完に含めない
setglobal complete=.,w,b,u,U

" 補完オプション(completeopt)
" menuone : 対象が一つでもポップアップを表示
setglobal completeopt=menuone

setglobal noinfercase  " 補完時にマッチした単語をそのまま挿入
setglobal pumheight=10 " 補完候補は一度に10個まで表示

" コマンドライン補完設定
setglobal wildmenu wildmode=full

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
autocmd MyAutoCmd BufEnter * setlocal textwidth=78

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
setglobal clipboard=unnamed

" クリップボード関連のコマンドを定義
command! ClipFilePath let @* = expand('%:p')   | echo 'clipped: ' . @*
command! ClipFileName let @* = expand('%:t')   | echo 'clipped: ' . @*
command! ClipFileDir  let @* = expand('%:p:h') | echo 'clipped: ' . @*
function! s:ClipCommandOutput(cmd)
  redir @*> | silent execute a:cmd | redir END
  " 先頭の改行文字を取り除く
  if len(@*) != 0 | let @* = @*[1 :] | endif
endfunction
command! -nargs=1 -complete=command ClipCommandOutput call s:ClipCommandOutput(<f-args>)

"}}}
"-----------------------------------------------------------------------------
" View {{{

if neobundle#is_installed('badwolf')
  autocmd MyAutoCmd colorscheme badwolf highlight link SignifySignDelete DiffAdd
  colorscheme badwolf
endif

if has('gui_running')
  " Windowsのフォントは「Ricty for Powerline」&「MacTypePortable」が良い
  let &g:guifont = 'Ricty for Powerline:h12:cSHIFTJIS'

  setglobal linespace=0 " 行間隔[pixel]の設定(default 1 for Win32 GUI)

  " M : メニュー・ツールバー領域を削除する
  " c : ポップアップダイアログを使用しない
  setglobal guioptions=Mc

  setglobal guicursor=a:blinkon0 " カーソルを点滅させない
  setglobal nomousefocus         " マウス移動でフォーカスを自動的に切り替えない
  setglobal mousehide            " 入力時にマウスポインタを隠す
endif

if has('kaoriya') && has('win32')
  setglobal ambiwidth=auto
endif

setglobal mouse=a          " マウス機能有効
setglobal showcmd          " 入力中のキーを画面右下に表示
setglobal cmdheight=2      " コマンド行は2行がちょうど良い
setglobal showtabline=2    " 常にタブ行を表示する
setglobal laststatus=2     " 常にステータス行を表示する
setglobal wrap             " 長いテキストを折り返す
setglobal display=lastline " 長いテキストを省略しない
setglobal colorcolumn=81   " 81列目に線を表示

setglobal number relativenumber " 行番号を相対表示
nnoremap <silent> <F10> :<C-u>set relativenumber! relativenumber?<CR>

" 不可視文字の設定
setglobal list listchars=tab:>-,trail:-,eol:\

if has('kaoriya')
  " 透明度をスイッチ
  if !exists('s:transparencyOn') | let s:transparencyOn = 0 | endif
  function! s:ToggleTransParency()
    let s:transparencyOn = (s:transparencyOn + 1) % 2
    if  s:transparencyOn | set transparency=220 transparency?
    else                 | set transparency=255 transparency? | endif
  endfunction
  nnoremap <silent> <F12> :<C-u>call <SID>ToggleTransParency()<CR>
endif

" foldmarkerを使って折り畳みを作成する
setglobal foldmethod=marker

" cの時はsytanxを使って折り畳みを作成する
autocmd MyAutoCmd FileType c
      \   setlocal foldmethod=syntax
      \ | setlocal foldnestmax=1
      \ | setlocal nofoldenable

" foldmethodがindent, syntaxの時に生成する折り畳みの深さの最大値
" → marker以外使わない気がするので, 余計な負荷がかからないように小さくしておく
setglobal foldnestmax=2

" 基本的にはfoldmarkerに余計なものを付けない
setglobal commentstring=%s

" filetypeがvimの時はvimのコメント行markerを前置してfoldmarkerを付ける
autocmd MyAutoCmd FileType vim setlocal commentstring=\ \"%s

" 画面左端に折り畳み状態, レベルを表示する列を1列設ける
setglobal foldcolumn=1

" Default: fillchars=vert:\|,fold:-
" foldを指定すると折り畳み行がウィンドウ幅まで指定した文字でfillされる
" → fill不要なので, fillcharsからfoldを削除
setglobal fillchars=vert:\|

" ファイルを開いた時点では折り畳みを全て閉じた状態で開く
setglobal foldlevelstart=0

" 折りたたみ機能をON/OFF
nnoremap <silent> <F9> :<C-u>setlocal foldenable! foldenable?<CR>

" Hack #120: GVim でウィンドウの位置とサイズを記憶する
" http://vim-jp.org/vim-users-jp/2010/01/28/Hack-120.html
let s:saveWinposDir = expand('~/vimfiles/winpos')
if !isdirectory(s:saveWinposDir) | call mkdir(s:saveWinposDir) | endif
function! s:SaveWindow()
  let s:options = [
        \   'setglobal columns=' . &columns,
        \   'setglobal lines='   . &lines,
        \   'winpos ' . getwinposx() . ' ' . getwinposy(),
        \ ]
  call writefile(s:options, s:saveWinposDir . '/.winpos')
endfunction
autocmd MyAutoCmd VimLeavePre * call s:SaveWindow()

if has('vim_starting') && filereadable(s:saveWinposDir . '/.winpos')
  execute 'source ' s:saveWinposDir . '/.winpos'
endif

"}}}
"-----------------------------------------------------------------------------
" Search {{{

setglobal ignorecase " 検索時に大文字小文字を区別しない。区別する時は\Cを使う
setglobal smartcase  " 大文字小文字の両方が含まれている場合は, 区別する
setglobal wrapscan   " 検索時に最後まで行ったら最初に戻る
setglobal incsearch  " インクリメンタルサーチ
setglobal hlsearch   " マッチしたテキストをハイライト

" grep/vimgrep結果が0件の場合, Quickfixを開かない
autocmd MyAutoCmd QuickfixCmdPost grep,vimgrep if len(getqflist()) != 0 | copen | endif

if has('kaoriya') && has('migemo')
  setglobal migemo " 逆方向migemo検索g?を有効化

  " kaoriya版のmigemo searchを再マッピング
  noremap m/ g/
  noremap m? g?
endif

"}}}
"-----------------------------------------------------------------------------
" Simplify operation {{{

" キー入力タイムアウトはあると邪魔だし, 待つ意味も無い気がする
setglobal notimeout

" make後, 自動でQuickfixウィンドウを開く
autocmd MyAutoCmd QuickfixCmdPost make if len(getqflist()) != 0 | copen | endif

" 最後のウィンドウのbuftypeがquickfixであれば, 自動で閉じる
" → buftypeがnofileかつ特定のfiletypeの追加を試みたが,
"    暴発する度にfiletypeを追加することになるのでやめた
autocmd MyAutoCmd WinEnter * if winnr('$') == 1 && &buftype == 'quickfix' | quit | endif

" 検索テキストハイライトを消す
nnoremap <silent> <Esc> :<C-u>nohlsearch<CR>

" j/kによる移動を折り返されたテキストでも自然に振る舞うようにする
noremap <silent> j gj
noremap <silent> k gk

" :cdのディレクトリ名の補完に'cdpath'を使うようにする
" http://whileimautomaton.net/2007/09/24141900
function! s:CommandCompleteCDPath(arglead, cmdline, cursorpos) "{{{
  let l:pattern = substitute($HOME, '\\', '\\\\','g')
  return split(substitute(globpath(&cdpath, a:arglead . '*/'), l:pattern, '~', 'g'), "\n")
endfunction "}}}

" 引数なし : 現在開いているファイルのディレクトリに移動
" 引数あり : 指定したディレクトリに移動
function! s:LCD(...) "{{{
  if a:0 == 0
    execute 'lcd ' . expand('%:p:h')
  else
    execute 'lcd ' . a:1
  endif
  echo 'change directory to: ' .
        \ substitute(getcwd(), substitute($HOME, '\\', '\\\\','g'), '~', 'g')
endfunction "}}}
command! -complete=customlist,<SID>CommandCompleteCDPath -nargs=? LCD call s:LCD(<f-args>)

" 引数なし : 現在開いているファイルのディレクトリに移動
" 引数あり : 指定したディレクトリに移動
function! s:CD(...) "{{{
  if a:0 == 0
    execute 'cd ' . expand('%:p:h')
  else
    execute 'cd ' . a:1
  endif
  echo 'change directory to: ' .
        \ substitute(getcwd(), substitute($HOME, '\\', '\\\\','g'), '~', 'g')
endfunction "}}}
command! -complete=customlist,<SID>CommandCompleteCDPath -nargs=? CD call s:CD(<f-args>)

" vim-ambicmdでは補完できないパターンを補うため, リストを使った補完を併用する
let s:MyCMapEntries = []
function! s:AddMyCMap(originalPattern, alternateName) "{{{
  execute 'cnoreabbrev ' . a:originalPattern . ' ' . a:alternateName
  call add(s:MyCMapEntries, ['^' . a:originalPattern . '$', a:alternateName])
endfunction "}}}

" リストに登録されている   : 登録されたコマンド名を返す
" リストに登録されていない : vim-ambicmdで変換を試みる
function! s:MyCMap(cmdline) "{{{
  for [originalPattern, alternateName] in s:MyCMapEntries
    if a:cmdline =~# originalPattern
      return "\<C-u>" . alternateName . "\<Space>"
    endif
  endfor
  if neobundle#is_installed('vim-ambicmd')
    return ambicmd#expand("\<Space>")
  endif
  return "\<Space>"
endfunction "}}}
cnoremap <expr> <Space> <SID>MyCMap(getcmdline())

" リストへの変換候補登録(My Command)
call s:AddMyCMap( 'cd',  'CD')
call s:AddMyCMap('lcd', 'LCD')
call s:AddMyCMap( 'CD',  'cd')
call s:AddMyCMap('LCD', 'lcd')
call s:AddMyCMap('cfd', 'ClipFileDir')
call s:AddMyCMap( 'uc', 'UpdateCtags')
call s:AddMyCMap( 'pd', 'PutDateTime')
call s:AddMyCMap( 'cm', 'ClearMessage')

" リストへの変換候補登録(Plugin's command)
if neobundle#is_installed('scratch.vim')
  call s:AddMyCMap('sc',  'Scratch')
  call s:AddMyCMap('scp', 'ScratchPreview')
endif
if neobundle#is_installed('TweetVim')
  call s:AddMyCMap('tvs', 'TweetVimSearch')
endif
if neobundle#is_installed('vim-gita')
  call s:AddMyCMap('gb', 'Gita!')
  call s:AddMyCMap('gi', 'Gita')
  call s:AddMyCMap('gaa', 'Gita add %')
  call s:AddMyCMap('gap', 'Gita add --patch --split')
  call s:AddMyCMap('gbl', 'Gita blame')
  call s:AddMyCMap('gbr', 'Gita branch')
  call s:AddMyCMap('gch', 'Gita checkout')
  call s:AddMyCMap('gca', 'Gita commit --amend')
  call s:AddMyCMap('gco', 'Gita commit')
  call s:AddMyCMap('gdi', 'Gita diff')
  call s:AddMyCMap('gds', 'Gita diff --split')
  call s:AddMyCMap('gdl', 'Gita diff-ls')
  call s:AddMyCMap('gls', 'Gita ls')
  call s:AddMyCMap('gpl', 'Gita pull')
  call s:AddMyCMap('gps', 'Gita push')
  call s:AddMyCMap('gre', 'Gita reset')
  call s:AddMyCMap('grp', 'Gita reset --patch --split')
  call s:AddMyCMap('gst', 'Gita status')
endif

" " 開いたファイルと同じ場所へ移動する
" " → startify/vimfiler/:LCD/:CDで十分
" autocmd MyAutoCmd BufEnter * execute 'lcd ' fnameescape(expand('%:p:h'))
" " 最後のカーソル位置を記憶していたらジャンプ
" " → Gdiff時に不便なことがあったのでコメントアウト
" autocmd MyAutoCmd BufRead * silent execute 'normal! `"'

" " 保存時にViewの状態を保存し, 読み込み時にViewの状態を前回の状態に戻す
" " http://ac-mopp.blogspot.jp/2012/10/vim-to.html
" " → プラグインの挙動とぶつかることもあるらしいので使わない
" " → https://github.com/Shougo/vimproc.vim/issues/116
" setglobal viewdir=~/vimfiles/view
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
    tabnew %:p
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
nnoremap <silent> <Leader>] :<C-u>call <SID>JumpTagTab(expand('<cword>'))<CR>

" ソースディレクトリの設定はローカル設定ファイルに記述する
" see: ~/localfiles/template/local.rc.vim
if filereadable(expand('~/localfiles/template/local.rc.vim'))

  function! s:SetSrcDir() "{{{
    let g:local_rc_src_dir         = g:local_rc_src_list[g:local_rc_src_index]
    let g:local_rc_current_src_dir = g:local_rc_base_dir . '\' . g:local_rc_src_dir
    let g:local_rc_ctags_dir       = g:local_rc_current_src_dir . '\.ctags'
  endfunction "}}}

  function! s:SetTags() "{{{
    " tagsをセット
    set tags=
    for l:item in g:local_rc_ctags_list
      if l:item == '' | break | endif
      let &tags = &tags . ',' . g:local_rc_ctags_dir . '\' . g:local_rc_ctags_name_list[l:item]
    endfor
    " 1文字目の','を削除
    if &tags != '' | let &tags = &tags[1 :] | endif
    " GTAGSROOTの登録
    " → GNU GLOBALのタグはプロジェクトルートで生成する
    let $GTAGSROOT = g:local_rc_current_src_dir
  endfunction "}}}

  function! s:SetPathList() "{{{
    set path=
    " 起点なしのpath登録
    for l:item in g:local_rc_other_dir_path_list
      if l:item == '' | break | endif
      let &path = &path . ',' . l:item
    endfor
    " g:local_rc_current_src_dirを起点にしたpath登録
    for l:item in g:local_rc_current_src_dir_path_list
      if l:item == '' | break | endif
      let &path = &path . ',' . g:local_rc_current_src_dir . '\' . l:item
    endfor
    " 1文字目の','を削除
    if &path != '' | let &path = &path[1 :] | endif
  endfunction "}}}

  function! s:SetCDPathList() "{{{
    set cdpath=
    " 起点なしのcdpath登録
    for l:item in g:local_rc_other_dir_cdpath_list
      if l:item == '' | break | endif
      let &cdpath = &cdpath . ',' . l:item
    endfor
    let &cdpath = &cdpath . ',' . g:local_rc_base_dir
    let &cdpath = &cdpath . ',' . g:local_rc_current_src_dir
    " g:local_rc_current_src_dirを起点にしたcdpath登録
    for l:item in g:local_rc_current_src_dir_cdpath_list
      if l:item == '' | break | endif
      let &cdpath = &cdpath . ',' . g:local_rc_current_src_dir . '\' . l:item
    endfor
    " 1文字目の','を削除
    if &cdpath != '' | let &cdpath = &cdpath[1 :] | endif
  endfunction "}}}

  " ソースコードをスイッチ
  function! s:SwitchSource() "{{{
    let g:local_rc_src_index += 1
    if  g:local_rc_src_index >= len(g:local_rc_src_list)
      let g:local_rc_src_index = 0
    endif
    call s:SetSrcDir()
    call s:SetTags()
    call s:SetPathList()
    call s:SetCDPathList()
    call g:SetEnvironmentVariables()
    " ソースコード切り替え後, ソースディレクトリ名を出力
    echo 'switch source to: ' . g:local_rc_src_dir
  endfunction "}}}
  nnoremap <silent> ,s :<C-u>call <SID>SwitchSource()<CR>

  " カレントのソースディレクトリにcd
  function! s:ChangeToCurrentSourceDirectory() "{{{
    if isdirectory(g:local_rc_current_src_dir)
      execute 'cd ' . g:local_rc_current_src_dir
      if exists('g:IsLoadedChangeToCurrentSourceDirectory')
        echo 'change directory to current source: ' . g:local_rc_current_src_dir
      endif
    endif
    let g:IsLoadedChangeToCurrentSourceDirectory = 1
  endfunction "}}}
  command! ChangeToCurrentSourceDirectory call s:ChangeToCurrentSourceDirectory()

  " 初回のtags, path設定/ディレクトリ移動
  autocmd MyAutoCmd VimEnter *
        \   call s:SetSrcDir()
        \ | call s:SetTags()
        \ | call s:SetPathList()
        \ | call s:SetCDPathList()
        \ | call SetEnvironmentVariables()
        \ | call s:ChangeToCurrentSourceDirectory()

  " ctagsをアップデート
  function! s:UpdateCtags() "{{{
    if !executable('ctags') | echomsg 'ctagsが見つかりません' | return | endif
    " ディレクトリを削除してから再生成
    call delete(g:local_rc_ctags_dir, 'rf')
    if !isdirectory(g:local_rc_ctags_dir)
      call    mkdir(g:local_rc_ctags_dir)
    endif
    for l:item in g:local_rc_ctags_list
      if l:item == '' | break | endif
      if !has_key(g:local_rc_ctags_name_list, l:item) | continue | endif
      let l:updateCommand =
            \ 'ctags -f ' .
            \ g:local_rc_ctags_dir . '\' . g:local_rc_ctags_name_list[l:item] .
            \ ' -R ' .
            \ g:local_rc_current_src_dir . '\' . l:item
      if has('win32')
        " 処理中かどうかわかるように/minを使う
        silent execute '!start /min ' . l:updateCommand
      else
        call system(l:updateCommand)
      endif
    endfor
  endfunction "}}}
  command! UpdateCtags call s:UpdateCtags()

  " GNU GLOBALのタグをアップデート
  function! s:UpdateGtags() "{{{
    if !executable('gtags') | echomsg 'gtagsが見つかりません' | return | endif
    let l:currentDir = getcwd()
    execute 'cd ' . $GTAGSROOT
    let l:updateCommand = 'gtags -iv'
    if has('win32')
      " 処理中かどうかわかるように/minを使う
      execute '!start /min ' . l:updateCommand
    else
      call system(l:updateCommand)
    endif
    execute 'cd ' . l:currentDir
  endfunction "}}}
  command! UpdateGtags call s:UpdateGtags()

endif

"}}}
"-----------------------------------------------------------------------------
" Prevent erroneous input {{{

" レジスタ機能のキーをQにする(Exモードを使う時はgQを使おう)
nnoremap q <Nop>
nnoremap Q q

" 「保存して閉じる」「保存せず閉じる」を無効にする
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" <C-g>u : アンドゥ単位を区切る
" <C-@>は良く誤爆するので潰す
" inoremap <C-@> <C-g>u<C-@>
inoremap <C-@> <Esc>
inoremap <C-a> <C-g>u<C-a>

" :quitのショートカットは潰す
nnoremap <C-w><C-q> <Nop>
nnoremap <C-w>q     <Nop>

" mswin.vim有効時<C-v>がペーストに使われるため, 代替として<C-q>が用意されている
" → そもそもmswin.vimは使わないし, 紛らわしいので潰す
nnoremap <C-q> <Nop>

" マウス中央ボタンは使わない
noremap  <MiddleMouse> <Nop>
inoremap <MiddleMouse> <Nop>

" 挿入モードでカーソルキーを使うとUndo単位が区切られて困るので潰す
inoremap <Down> <Nop>
inoremap <Up>   <Nop>

" Undo単位を区切らない(<C-g>Uは行移動を伴わない場合のみ使える)
inoremap <Left>  <C-g>U<Left>
inoremap <Right> <C-g>U<Right>

" カーソルキーでウィンドウ間を移動
nnoremap <Left>  <C-w>h
nnoremap <Down>  <C-w>j
nnoremap <Up>    <C-w>k
nnoremap <Right> <C-w>l

" Shift + カーソルキーでbprevious/bnextまたはtabnext/tabprevious
nnoremap <S-Left>  :bprevious<CR>
nnoremap <S-Right> :bnext<CR>
nnoremap <S-Up>    :tabnext<CR>
nnoremap <S-Down>  :tabprevious<CR>

"  Ctrl + カーソルキーでcprevious/cnextまたはlprevious/lnext
nnoremap <C-Left>  :cprevious<CR>
nnoremap <C-Right> :cnext<CR>
nnoremap <C-Up>    :lprevious<CR>
nnoremap <C-Down>  :lnext<CR>

if neobundle#is_installed('unite.vim')
  " Alt + カーソルキーでUnitePrevious/UniteNext
  nnoremap <silent> <A-Left>  :UnitePrevious<CR>
  nnoremap <silent> <A-Right> :UniteNext<CR>
endif

"}}}
"-----------------------------------------------------------------------------
" Scripts {{{

" タイムスタンプの挿入
function! s:PutDateTime() "{{{
  let l:tmp = @"
  let @" = strftime('%Y/%m/%d(%a) %H:%M')
  normal! ""P
  let @" = l:tmp
endfunction "}}}
command! PutDateTime call s:PutDateTime()

" 区切り線&タイムスタンプの挿入
function! s:PutMemoFormat() "{{{
  let l:tmp = @"
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
  let @" = l:tmp
endfunction "}}}
command! PutMemoFormat call s:PutMemoFormat()

" :messageで表示される履歴を削除
" → 空文字で埋めているだけ。:ClipCommandOutput messageすると202行になる
" http://d.hatena.ne.jp/osyo-manga/20130502/1367499610
command! ClearMessage  for s:n in range(250) | echomsg '' | endfor

" :jumplistを空にする
command! ClearJumpList for s:n in range(250) | mark '     | endfor

" キーリピート時のCursorMoved autocmdを無効にする, 行移動を検出する
" http://d.hatena.ne.jp/gnarl/20080130/1201624546
let s:throttleTimeSpan = 200
function! s:OnCursorMove() "{{{
  " normalかvisualの時のみ判定
  let     l:currentMode  = mode(1)
  if      l:currentMode !=  'n'  &&
        \ l:currentMode !=  'no' &&
        \ l:currentMode !=# 'v'  &&
        \ l:currentMode !=# 'V'  &&
        \ l:currentMode !=  "\<C-v>"
    return
  endif

  " 初回の処理
  if !exists('b:lastVisitedLine')
    let b:lastVisitedLine = line('.')
    let b:lastCursorMoveTime = 0
  endif

  " ミリ秒単位の現在時刻を取得
  let l:ml = matchlist(reltimestr(reltime()), '\v(\d*)\.(\d{3})')
  if  l:ml == [] | return | endif
  let l:ml[0] = ''
  let l:now = str2nr(join(l:ml, ''))

  " 前回のCursorMoved発火時から指定時間経過していなければ何もせず抜ける
  let l:timespan = l:now - b:lastCursorMoveTime
  if  l:timespan <= s:throttleTimeSpan | return | endif

  " CursorMoved!!
  if exists('#User#MyCursorMoved') | doautocmd User MyCursorMoved | endif

  " lastCursorMoveTimeを更新
  let b:lastCursorMoveTime = l:now

  " 行移動していなければ抜ける
  if b:lastVisitedLine == line('.') | return | endif

  " LineChanged!!
  if exists('#User#MyLineChanged') | doautocmd User MyLineChanged | endif

  " lastVisitedLineを更新
  let b:lastVisitedLine = line('.')
endfunction "}}}
autocmd MyAutoCmd CursorMoved * call s:OnCursorMove()

" 引数に渡した行のFold名を取得
" NOTE: 対応ファイルタイプ : vim/markdown
function! s:GetFoldName(line) "{{{
  if     &filetype == 'vim'
    " コメント行か, 末尾コメントか判別してFold名を切り出す
    let l:startIndex = match   (a:line, '\w')
    let l:endIndex   = matchend(a:line, '\v^("\ )')
    let l:preIndex   = (l:endIndex == -1) ? l:startIndex : l:endIndex
    let l:sufIndex   = strlen(a:line) - ((l:endIndex == -1) ? 6 : 5)
    return a:line[l:preIndex : l:sufIndex]
  elseif &filetype == 'markdown'
    let l:foldName = split(a:line, "\<Space>")
    return empty(l:foldName) ? '' : join(l:foldName[1 :], "\<Space>")
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
  if &filetype == 'markdown'
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
    if l:lastLineNumber == l:currentLineNumber | break | endif
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
  if &filetype != 'vim' && &filetype != 'markdown' | return '' | endif

  " ------------------------------------------------------------
  " 前処理
  " ------------------------------------------------------------
  " foldlevel('.')はあてにならないことがあるので自作関数で求める
  let l:foldLevel = s:GetFoldLevel()
  if  l:foldLevel <= 0 | return '' | endif

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
    if l:searchCounter <= 0 | break | endif

    " 1段階親のところへ移動
    keepjumps normal! [z
    let l:currentLineNumber = line('.')

    " 移動していなければ, 移動前のカーソル行が子Fold開始位置だったということ
    if l:lastLineNumber == l:currentLineNumber
      " カーソルを戻して子FoldをfoldListに追加
      call setpos('.', l:cursorPosition)
      let l:currentLine = (&filetype == 'markdown') &&
            \             (match(getline('.'), '^#') == -1)
            \           ? getline((line('.') - 1))
            \           : getline('.')
      let l:foldName = s:GetFoldName(l:currentLine)
      if  l:foldName != ''
        call add(l:foldList, l:foldName)
      endif
    else
      let l:currentLine = (&filetype == 'markdown')
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
  if winwidth(0) > 120 | return join(l:foldList, " \u2B81 ") | endif

  " ウィンドウ幅が広くない場合, 直近のFold名を返す
  return get(l:foldList, -1, '')
endfunction "}}}
command! EchoCurrentFold echo s:GetCurrentFold()
autocmd MyAutoCmd User MyLineChanged let s:currentFold = s:GetCurrentFold()
autocmd MyAutoCmd BufEnter *         let s:currentFold = s:GetCurrentFold()

" Cの関数名にジャンプ
let g:cFuncUsePattern = '\v\zs<\a+\u+\l+\w+>\ze\('
let g:cFuncDefPattern = '\v(static\s+)?\a\s+\zs<\a+\u+\l+\w+>\ze\('
nnoremap <silent> ]f :<C-u>call search(g:cFuncUsePattern, 's')<CR>
nnoremap <silent> [f :<C-u>call search(g:cFuncUsePattern, 'bs')<CR>
nnoremap <silent> ]F :<C-u>call search(g:cFuncDefPattern, 's')<CR>
nnoremap <silent> [F :<C-u>call search(g:cFuncDefPattern, 'bs')<CR>

" ブラケットの前の単語にジャンプ
let g:bracketPattern = '\v\zs<\w+>\ze\('
nnoremap <silent> ]b :<C-u>call search(g:bracketPattern, 's')<CR>
nnoremap <silent> [b :<C-u>call search(g:bracketPattern, 'bs')<CR>

" Cの関数名取得
let s:currentFunc = ''
function! s:GetCurrentFuncC() "{{{
  if &filetype != 'c' | return '' | endif

  " Viewを保存
  let l:savedView = winsaveview()

  " カーソルがある行の1列目の文字が { ならば [[ は不要
  if getline('.')[0] != '{' " for match } }

    " { よりも先に前方にセクション末尾 } がある場合, 関数定義の間なので検索不要
    keepjumps normal! []
    let l:endBracketLine = line('.')
    call winrestview(l:savedView)
    keepjumps normal! [[
    if line('.') < l:endBracketLine | call winrestview(l:savedView) | return '' | endif

    " 検索対象が居なければViewを戻して処理終了
    if line('.') == 1 | call winrestview(l:savedView) | return '' | endif
  endif

  call search('(', 'b')
  keepjumps normal! b
  let l:funcName = expand('<cword>')

  " Viewを復元
  call winrestview(l:savedView)

  return l:funcName
endfunction " }}}
autocmd MyAutoCmd User MyLineChanged
      \ if &filetype == 'c' | let s:currentFunc = s:GetCurrentFuncC() | endif
autocmd MyAutoCmd BufEnter *  let s:currentFunc = s:GetCurrentFuncC()

function! s:ClipCurrentFunc(funcName) "{{{
  if strlen(a:funcName) == 0
    echo 'There is no function nearby cursor.'
    return
  endif
  let @* = a:funcName | echo 'clipped: ' . a:funcName
endfunction "}}}
command! ClipCurrentFunc
      \ let s:currentFunc = s:GetCurrentFuncC() |
      \ call s:ClipCurrentFunc(s:currentFunc)

function! s:PutCurrentFunc(funcName) "{{{
  if strlen(a:funcName) == 0
    echo 'There is no function nearby cursor.'
    return
  endif
  let l:tmp = @"
  let @" = a:funcName
  normal! ""P
  let @" = l:tmp
endfunction "}}}
command! PutCurrentFunc
      \ let s:currentFunc = s:GetCurrentFuncC() |
      \ call s:PutCurrentFunc(s:currentFunc)

"}}}
"-----------------------------------------------------------------------------
" Plugin Settings {{{

" バッファをHTML形式に変換(2html.vim) {{{

" 選択範囲をHTML変換してヤンクする
command! -range=% -bar ClipHTML
      \ :<line1>,<line2>TOhtml | execute "normal! ggyG" | silent execute "bd!"
cnoreabbrev ch ClipHTML

"}}}

" VCSの差分をVimのsignで表示(vim-signify) {{{
if neobundle#tap('vim-signify')

  " use git only
  let g:signify_vcs_list = ['git']

  " let g:signify_vcs_list = ['git', 'cvs']
  " let g:signify_disable_by_default = 1

  " Hunk text object
  omap ic <Plug>(signify-motion-inner-pending)
  xmap ic <Plug>(signify-motion-inner-visual)
  omap ac <Plug>(signify-motion-outer-pending)
  xmap ac <Plug>(signify-motion-outer-visual)

  function! neobundle#hooks.on_post_source(bundle)
    " 使わないコマンドを削除する
    if exists(':SignifyEnable')       | delcommand SignifyEnable       | endif
    if exists(':SignifyDisable')      | delcommand SignifyDisable      | endif
    " if exists(':SignifyToggle')       | delcommand SignifyToggle       | endif
    if exists(':SignifyDebug')        | delcommand SignifyDebug        | endif
    if exists(':SignifyDebugDiff')    | delcommand SignifyDebugDiff    | endif
    if exists(':SignifyDebugUnknown') | delcommand SignifyDebugUnknown | endif
    if exists(':SignifyFold')         | delcommand SignifyFold         | endif
    if exists(':SignifyRefresh')      | delcommand SignifyRefresh      | endif
  endfunction

endif "}}}

" VimからGitを使う(編集, コマンド実行, vim-gita) {{{
if neobundle#tap('vim-gita')

  autocmd MyAutoCmd BufWinEnter gita:* setlocal nofoldenable

endif "}}}

" VimからGitを使う(コミットツリー表示, 管理, agit.vim) {{{
if neobundle#tap('agit.vim')

  let g:agit_enable_auto_show_commit = 0
  let g:agit_max_log_lines = 50

  function! s:AgitSettings()
    nmap <buffer> ch <Plug>(agit-git-cherry-pick)
    nmap <buffer> Rv <Plug>(agit-git-revert)
  endfunction
  autocmd MyAutoCmd FileType agit          call s:AgitSettings()
  autocmd MyAutoCmd FileType agit_diff setlocal nofoldenable

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

  " smap対策
  " http://d.hatena.ne.jp/thinca/20090526/1243267812
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

  if has('kaoriya')
    setglobal imdisable
  endif

  let g:eskk#directory = '~/.cache/eskk'
  let g:eskk#dictionary = {
        \   'path'    : '~/dotfiles/.skk-jisyo',
        \   'sorted'  : 0,
        \   'encoding': 'utf-8',
        \ }
  let g:eskk#large_dictionary = {
        \   'path'    : '~/vimfiles/dict/SKK-JISYO.L',
        \   'sorted'  : 1,
        \   'encoding': 'euc-jp',
        \ }

  " " neocompleteを使わない場合は設定不要
  " let g:eskk#show_annotation = 1
  " let g:eskk#tab_select_completion = 1
  " let g:eskk#start_completion_length = 2

  " http://tyru.hatenablog.com/entry/20101214/vim_de_skk
  let g:eskk#egg_like_newline = 1
  let g:eskk#egg_like_newline_completion = 1
  let g:eskk#rom_input_style = 'msime'

  " すぐにskkしたい
  imap <C-j>  <Plug>(eskk:enable)
  nmap <C-j> i<Plug>(eskk:enable)
  cmap <C-j>  <Plug>(eskk:toggle)
  nmap <A-i> I<Plug>(eskk:enable)
  nmap <A-a> A<Plug>(eskk:enable)
  nmap <A-o> O<Plug>(eskk:enable)

  function! s:EskkInitialPreSettings()
    let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
    " hankaku → zenkaku
    call t.add_map('~',  '～')
    " zenkaku → hankaku
    call t.add_map('z~', '~')
    call t.add_map('z:', ":\<Space>")
    call t.add_map('z;', ";\<Space>")
    call t.add_map('z,', ",\<Space>")
    call t.add_map('z.', '.')
    call t.add_map('z?', '?')
    call eskk#register_mode_table('hira', t)
  endfunction
  autocmd MyAutoCmd User eskk-initialize-pre call s:EskkInitialPreSettings()

  function! neobundle#hooks.on_post_source(bundle)
    " wake up!
    " → 1発目の処理がeskk#statusline()だと不都合なので, eskk#toggle()を2連発
    call eskk#toggle()
    call eskk#toggle()

    " 処理順を明確にするため, neobundle#hooks.on_post_source()を
    " 使ってプラグインの読み込み完了フラグを立てることにした
    let s:IsEskkLoaded = 1
  endfunction

endif "}}}

" コマンド名補完(vim-ambicmd) {{{
if neobundle#tap('vim-ambicmd')

  " " 下手にマッピングするよりもambicmdで補完する方が捗る
  " " リスト補完を併用することにした。→s:MyCMap()を参照のこと
  " cnoremap <expr> <Space> ambicmd#expand("\<Space>")

endif "}}}

" カッコいいステータスラインを使う(lightline.vim) {{{
if neobundle#tap('lightline.vim')

  let g:lightline = {}

  if neobundle#is_installed('lightline-hybrid.vim')
    let g:lightline.colorscheme = 'hybrid'
  endif

  " COMMANDに遷移するタイミングが微妙なので, COMMANDでもNORMALと表示させる
  let g:lightline.mode_map = {'c' : 'NORMAL'}

  let g:lightline.separator    = {'left' : "\u2B80",   'right' : "\u2B82"}
  let g:lightline.subseparator = {'left' : "\u2B81",   'right' : "\u2B83"}
  let g:lightline.tabline      = {'left' : [['tabs']], 'right' : []      }

  let g:lightline.active = {
        \   'left'  : [
        \     ['mode'],
        \     ['skk-mode', 'git', 'filename', 'currentfunc'],
        \   ],
        \   'right' : [
        \     ['lineinfo'],
        \     ['percent'],
        \     ['fileformat', 'fileencoding', 'filetype'],
        \   ],
        \ }

  let g:lightline.component_function = {
        \   'mode'         : 'MyMode',
        \   'skk-mode'     : 'MySKKMode',
        \   'git'          : 'MyGit',
        \   'filename'     : 'MyFileName',
        \   'currentfunc'  : 'MyCurrentFunc',
        \   'fileformat'   : 'MyFileFormat',
        \   'fileencoding' : 'MyFileEncoding',
        \   'filetype'     : 'MyFileType',
        \ }

  function! MyMode()
    return winwidth(0) < 30 ? '' : lightline#mode()
  endfunction

  function! MySKKMode()
    if !neobundle#is_sourced('eskk.vim')
      return ''
    endif
    return winwidth(0) < 30 ? '' : eskk#statusline()
  endfunction

  function! MyGit()
    if !neobundle#is_sourced('vim-gita')
      return ''
    endif
    let l:_ = gita#statusline#format('%lb')
    return winwidth(0) < 30 ? '' : strlen(l:_) ? "\u2B60 " . l:_ : ''
  endfunction

  function! MyFileName()
    return (expand('%:t') == '' || expand('%:t') == '.') ? '[No Name]' :
          \ expand('%:t') . ( &readonly   ? "\<Space>\u2B64" : '')
          \               . (!&modifiable ? "\<Space>-"      :
          \                   &modified   ? "\<Space>+"      : '')
  endfunction

  function! MyCurrentFunc()
    if &filetype == 'vim' || &filetype == 'markdown'
      return winwidth(0) < 100 ? '' : s:currentFold
    else
      return winwidth(0) < 70  ? '' : s:currentFunc
    endif
  endfunction

  function! MyFileFormat()
    return winwidth(0) < 70 ? '' : &fileformat
  endfunction

  function! MyFileEncoding()
    return winwidth(0) < 70 ? '' : strlen(&fileencoding) ? &fileencoding : &encoding
  endfunction

  function! MyFileType()
    return winwidth(0) < 70 ? '' : strlen(&filetype) ? &filetype : 'no ft'
  endfunction

endif "}}}

" フォントサイズ変更を簡易化(vim-fontzoom) {{{
if neobundle#tap('vim-fontzoom')

  nnoremap ,f :<C-u>Fontzoom!<CR>

  " for Lazy
  let g:fontzoom_no_default_key_mappings = 1
  nmap + <Plug>(fontzoom-larger)
  nmap - <Plug>(fontzoom-smaller)

  " vim-fontzoomには, 以下のデフォルトキーマッピングが設定されている
  " → しかし, Vimの既知のバグでWindows環境ではC-Scrollを使えないらしい。残念。
  " → https://github.com/vim-jp/issues/issues/73
  nmap <C-ScrollWheelUp>   <Plug>(fontzoom-larger)
  nmap <C-ScrollWheelDown> <Plug>(fontzoom-smaller)

endif "}}}

" フルスクリーンモード(scrnmode.vim) {{{
if has('kaoriya')

  if !exists('s:fullscreenOn') | let s:fullscreenOn = 0 | endif
  function! s:ToggleScreenMode()
    let s:fullscreenOn = (s:fullscreenOn + 1) % 2
    if  s:fullscreenOn
      execute 'ScreenMode 6'
    else
      execute 'ScreenMode 0'
    endif
  endfunction
  nnoremap <silent> <F11> :<C-u>call <SID>ToggleScreenMode()<CR>

endif "}}}

" incsearchをパワーアップ(incsearch.vim) {{{
if neobundle#tap('incsearch.vim')

  noremap <silent> <expr> z/ incsearch#go({'command' : '/', 'is_stay' : 1})
  noremap <silent> <expr> z? incsearch#go({'command' : '?', 'is_stay' : 1})

endif "}}}

" incsearch.vimを更にパワーアップ(incsearch-index.vim) {{{
if neobundle#tap('incsearch-index.vim')

  map g/ <Plug>(incsearch-index-/)
  map g? <Plug>(incsearch-index-?)

endif "}}}

" asterisk検索をパワーアップ(vim-asterisk) {{{
if neobundle#tap('vim-asterisk')

  " 検索開始時のカーソル位置を保持する
  let g:asterisk#keeppos = 1

  " star-search対象を選択レジスタに入れる
  function! s:ClipCword(data) "{{{
    let     l:currentMode  = mode(1)
    if      l:currentMode == 'n' ||
          \ l:currentMode == 'no'
      let @* = a:data
      return ''
    elseif  l:currentMode ==# 'v' ||
          \ l:currentMode ==# 'V' ||
          \ l:currentMode ==  "\<C-v>"
      return "\<Esc>gvygv"
    endif
    return ''
  endfunction "}}}
  noremap <silent> <expr> <Plug>(_ClipCword) <SID>ClipCword(expand('<cword>'))

  if neobundle#is_installed('vim-anzu')
    map *  <Plug>(_ClipCword)<Plug>(asterisk-z*)<Plug>(anzu-update-search-status-with-echo)
    map #  <Plug>(_ClipCword)<Plug>(asterisk-z#)<Plug>(anzu-update-search-status-with-echo)
    map g* <Plug>(_ClipCword)<Plug>(asterisk-gz*)<Plug>(anzu-update-search-status-with-echo)
    map g# <Plug>(_ClipCword)<Plug>(asterisk-gz#)<Plug>(anzu-update-search-status-with-echo)
  else
    map *  <Plug>(_ClipCword)<Plug>(asterisk-z*)
    map #  <Plug>(_ClipCword)<Plug>(asterisk-z#)
    map g* <Plug>(_ClipCword)<Plug>(asterisk-gz*)
    map g# <Plug>(_ClipCword)<Plug>(asterisk-gz#)
  endif

endif "}}}

" 何番目の検索対象か／検索対象の総数を表示(vim-anzu) {{{
if neobundle#tap('vim-anzu')

  " コマンド結果出力画面にecho
  nmap n <Plug>(anzu-n-with-echo)
  nmap N <Plug>(anzu-N-with-echo)

endif "}}}

" f検索を便利に(vim-shot-f) {{{
if neobundle#tap('vim-shot-f')

endif "}}}

" f検索の2文字版(vim-sneak) {{{
if neobundle#tap('vim-sneak')

  " clever-s
  let g:sneak#s_next = 1

  " smartcase
  let g:sneak#use_ic_scs = 1

endif "}}}

" Vimのマーク機能を使いやすく(vim-signature) {{{
if neobundle#tap('vim-signature')

  " " お試しとして, グローバルマークだけ使うようにしてみる
  " " → viminfoに直接書き込まれるためか, マークの削除が反映されないことが多々
  " let g:SignatureIncludeMarks = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

  " _viminfoファイルからグローバルマークの削除を行う
  " → Unix系だと「~/.viminfo」, Windowsだと「~/_viminfo」を対象とする
  " → Windowsでは_viminfoが書き込み禁止になり削除失敗するので無効化する
  let g:SignatureForceRemoveGlobal = 0

  " これだけあれば十分
  " mm       : ToggleMarkAtLine
  " m<Space> : PurgeMarks
  nmap mm m.

  function! neobundle#hooks.on_post_source(bundle)
    " 使わないコマンドを削除する
    if exists(':SignatureToggleSigns') | delcommand SignatureToggleSigns | endif
    if exists(':SignatureRefresh')     | delcommand SignatureRefresh     | endif
    if exists(':SignatureListMarks')   | delcommand SignatureListMarks   | endif
    if exists(':SignatureListMarkers') | delcommand SignatureListMarkers | endif
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

" 同インデント範囲を選択するテキストオブジェクト(vim-textobj-indent) {{{
if neobundle#tap('vim-textobj-indent')

endif "}}}

" 置き換えオペレータ(vim-operator-replace) {{{
if neobundle#tap('vim-operator-replace')

  map <A-r> <Plug>(operator-replace)

endif "}}}

" 検索オペレータ(vim-operator-search) {{{
if neobundle#tap('vim-operator-search')

  map <A-s> <Plug>(operator-search)

endif "}}}

" Web検索オペレータ(vim-operator-openbrowser) {{{
if neobundle#tap('vim-operator-openbrowser')

  nmap <A-l> <Plug>(operator-openbrowser)
  xmap <A-l> <Plug>(operator-openbrowser)

endif "}}}

" コメントアウト/コメントアウト解除(caw.vim) {{{
if neobundle#tap('caw.vim')

  let g:caw_no_default_keymappings = 1

  " caw.vimをオペレータとして使う
  " https://github.com/rhysd/dogfiles/blob/master/vimrc
  function! s:OperatorCawCommentToggle(motionWise)
    if a:motionWise == 'char'
      execute "normal `[v`]\<Plug>(caw:wrap:toggle)"
    else
      execute "normal `[V`]\<Plug>(caw:i:toggle)"
    endif
  endfunction

  function! neobundle#hooks.on_source(bundle)
    if neobundle#is_installed('vim-operator-user')
      call operator#user#define('caw', s:SID() . 'OperatorCawCommentToggle')
    endif
  endfunction
  map <A-c> <Plug>(operator-caw)

endif "}}}

" 自由にテキストハイライト(vim-quickhl) {{{
if neobundle#tap('vim-quickhl')

  nmap <A-h> <Plug>(operator-quickhl-manual-this-motion)
  xmap <A-h> <Plug>(operator-quickhl-manual-this-motion)

  " オペレータは2回繰り返すと行に対して処理するが, <cword>に対して処理したい
  nmap <A-h><A-h> <Plug>(quickhl-manual-this)

endif "}}}

" 囲む / 囲まなくする / 別の何かで囲む(vim-surround) {{{
if neobundle#tap('vim-surround')

endif "}}}

" もっと繰り返し可能にする(vim-repeat) {{{
if neobundle#tap('vim-repeat')

endif "}}}

" vimdiffに別のDiffアルゴリズムを適用する(vim-unified-diff) {{{
if neobundle#tap('vim-unified-diff')

  setglobal diffexpr=unified_diff#diffexpr()

endif "}}}

" 指定した行をVimDiff(linediff.vim) {{{
if neobundle#tap('linediff.vim')

endif "}}}

" Vimにスタート画面を用意(vim-startify) {{{
if neobundle#tap('vim-startify')

  let g:startify_files_number = 2
  let g:startify_change_to_dir = 1
  let g:startify_session_dir = '~/vimfiles/session'
  let g:startify_session_delete_buffers = 1

  " ブックマークの設定はローカル設定ファイルに記述する
  " see: ~/localfiles/template/local.rc.vim
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
    if exists(':StartifyDebug') | delcommand StartifyDebug | endif
    if exists(':SClose')        | delcommand SClose        | endif
  endfunction

endif "}}}

" 検索やリスト表示を拡張(unite.vim) {{{
if neobundle#tap('unite.vim')

  let g:unite_force_overwrite_statusline = 1
  let g:unite_split_rule = 'botright'

  " use pt
  " https://github.com/monochromegane/the_platinum_searcher
  if executable('pt')
    setglobal grepprg=pt\ --hidden\ --nogroup\ --nocolor\ --smart-case
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
  let g:u_imme = '-immediately '
  let g:u_fbuf = '-buffer-name=file-buffer '
  let g:u_sbuf = '-buffer-name=search-buffer '
  let g:u_nins = '-no-start-insert '
  let g:u_nspl = '-no-split '
  let g:u_hopt =    '-split -horizontal -winheight=20 '
  let g:u_vopt =    '-split -vertical   -winwidth=90 '

  " unite_sourcesに応じたオプション変数を定義して使ってみたけど微妙感が漂う
  let g:u_opt_bu = 'Unite '       . g:u_hopt . g:u_nins
  let g:u_opt_bo = 'Unite '       . g:u_hopt
  let g:u_opt_de = 'Unite '       . g:u_hopt            . g:u_imme
  let g:u_opt_dm = 'Unite '       . g:u_hopt
  let g:u_opt_fb = 'UniteResume ' . g:u_hopt                       . g:u_fbuf
  let g:u_opt_fg = 'Unite '       . g:u_hopt
  let g:u_opt_fi = 'Unite '       . g:u_hopt
  let g:u_opt_fm = 'Unite '       . g:u_hopt
  let g:u_opt_fr = 'Unite '       . g:u_hopt                       . g:u_fbuf
  let g:u_opt_gr = 'Unite '       . g:u_hopt                       . g:u_sbuf
  let g:u_opt_hy = 'Unite '       . g:u_hopt
  let g:u_opt_li = 'Unite '       . g:u_nspl                       . g:u_sbuf
  let g:u_opt_mf = 'Unite '       . g:u_hopt
  let g:u_opt_mg = 'Unite '       . g:u_hopt                       . g:u_sbuf
  let g:u_opt_mk = 'Unite '       . g:u_hopt            . g:u_prev
  let g:u_opt_mp = 'Unite '       . g:u_nspl
  let g:u_opt_nl = 'Unite '       . g:u_nspl
  let g:u_opt_nu = 'Unite '       . g:u_nspl . g:u_nins . g:u_nsyn
  let g:u_opt_ol = 'Unite '       . g:u_vopt            . g:u_nqui
  let g:u_opt_op = 'Unite '       . g:u_nspl
  let g:u_opt_re = 'Unite '       . g:u_hopt            . g:u_nqui . g:u_sbuf
  let g:u_opt_sb = 'UniteResume ' . g:u_hopt                       . g:u_sbuf

  nnoremap <expr> <Leader>bu ':<C-u>' . g:u_opt_bu . 'buffer'           . '<CR>'
  nnoremap <expr> <Leader>bo ':<C-u>' . g:u_opt_bo . 'bookmark'         . '<CR>'
  nnoremap <expr> <Leader>de ':<C-u>' . g:u_opt_de . 'gtags/def:'
  nnoremap <expr> <Leader>dm ':<C-u>' . g:u_opt_dm . 'directory_mru'    . '<CR>'
  nnoremap <expr> <Leader>fb ':<C-u>' . g:u_opt_fb                      . '<CR>'
  nnoremap <expr> <Leader>fg ':<C-u>' . g:u_opt_fg . 'file_rec/git'     . '<CR>'
  nnoremap <expr> <Leader>fi ':<C-u>' . g:u_opt_fi . 'file:'
  nnoremap <expr> <Leader>fm ':<C-u>' . g:u_opt_fm . 'file_mru'         . '<CR>'
  nnoremap <expr> <Leader>fr ':<C-u>' . g:u_opt_fr . 'file_rec'
  nnoremap <expr> <Leader>g% ':<C-u>' . g:u_opt_gr . 'vimgrep:%'        . '<CR>'
  nnoremap <expr> <Leader>g* ':<C-u>' . g:u_opt_gr . 'vimgrep:*'        . '<CR>'
  nnoremap <expr> <Leader>g. ':<C-u>' . g:u_opt_gr . 'vimgrep:.*'       . '<CR>'
  nnoremap <expr> <Leader>gg ':<C-u>' . g:u_opt_gr . 'grep/git:/'       . '<CR>'
  nnoremap <expr> <Leader>gr ':<C-u>' . g:u_opt_gr . 'vimgrep:**'
  nnoremap <expr> <Leader>hy ':<C-u>' . g:u_opt_hy . 'history/yank'     . '<CR>'
  nnoremap <expr> <Leader>re ':<C-u>' . g:u_opt_re . 'gtags/ref:'
  nnoremap <expr> <Leader>li ':<C-u>' . g:u_opt_li . 'line:'
  nnoremap <expr> <Leader>mf ':<C-u>' . g:u_opt_mf . 'file:~/memo'      . '<CR>'
  nnoremap <expr> <Leader>mg ':<C-u>' . g:u_opt_mg . 'vimgrep:~/memo/*' . '<CR>'
  nnoremap <expr> <Leader>mk ':<C-u>' . g:u_opt_mk . 'mark'             . '<CR>'
  nnoremap <expr> <Leader>mp ':<C-u>' . g:u_opt_mp . 'mapping'          . '<CR>'
  nnoremap <expr> <Leader>nl ':<C-u>' . g:u_opt_nl . 'neobundle/lazy'   . '<CR>'
  nnoremap <expr> <Leader>nu ':<C-u>' . g:u_opt_nu . 'neobundle/update'
  nnoremap <expr> <Leader>ol ':<C-u>' . g:u_opt_ol . 'outline'          . '<CR>'
  nnoremap <expr> <Leader>op ':<C-u>' . g:u_opt_op . 'output'           . '<CR>'
  nnoremap <expr> <Leader>sb ':<C-u>' . g:u_opt_sb                      . '<CR>'

  function! s:UniteSettings()
    " <Leader>がデフォルトマッピングで使用されていた場合の対策
    nmap <buffer> <LocalLeader> <Leader>

    nmap <buffer> <Esc> <Plug>(unite_exit)
  endfunction
  autocmd MyAutoCmd FileType unite call s:UniteSettings()

  function! neobundle#hooks.on_post_source(bundle)
    " unite.vimのデフォルトコンテキストを設定する
    " http://d.hatena.ne.jp/osyo-manga/20140627
    " → なんだかんだ非同期で処理させる必要は無い気がする
    " → emptyの時にメッセージ通知を出せるか調べる
    call unite#custom#profile('default', 'context', {
          \   'no_empty'         : 1,
          \   'no_quit'          : 0,
          \   'prompt'           : '> ',
          \   'prompt_direction' : 'top',
          \   'prompt_focus'     : 1,
          \   'split'            : 1,
          \   'start_insert'     : 1,
          \   'sync'             : 1,
          \ })

    " Unite line/grep/vimgrepの結果候補数を制限しない
    call unite#custom#source('line',    'max_candidates', 0)
    call unite#custom#source('grep',    'max_candidates', 0)
    call unite#custom#source('vimgrep', 'max_candidates', 0)

    " ディレクトリが選択されたらvimfilerで開く
    call unite#custom_default_action('source/bookmark/directory', 'vimfiler')
    call unite#custom_default_action('directory_mru',             'vimfiler')

  endfunction

endif "}}}

" for unite-file_mru {{{
if neobundle#tap('neomru.vim')

  let g:neomru#do_validate = 0

endif "}}}

" for unite-history/yank {{{
if neobundle#tap('neoyank.vim')

  let g:neoyank#limit = 15

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

" Vim上で動くシェル (vimshell.vim) {{{
if neobundle#tap('vimshell.vim')

  " 動的プロンプトの設定
  let g:vimshell_prompt_expr = 'fnamemodify(getcwd(), ":~") . "> "'
  let g:vimshell_prompt_pattern = '^\%(\f\|\\.\)\+> '

  " 横分割大きめで開く
  let g:vimshell_popup_height = 70

  " vimshellのマッピングを一部変更
  function! s:VimShellSettings()
    " <C-l>を普通のシェルのclearと同じ挙動にする
    nnoremap <buffer> <C-l> zt

    " neocompleteに依存しない通常の汎用補完を使う
    inoremap <buffer> <C-n> <C-n>
    inoremap <buffer> <C-p> <C-p>
  endfunction
  autocmd MyAutoCmd FileType vimshell call s:VimShellSettings()

endif "}}}

" Vim上で動くファイラ(vimfiler.vim) {{{
if neobundle#tap('vimfiler.vim')

  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_force_overwrite_statusline = 0

  function! neobundle#hooks.on_post_source(bundle)
    call vimfiler#custom#profile('default', 'context', {
          \   'auto_cd' : 1,
          \   'parent'  : 0,
          \   'safe'    : 0,
          \ })
  endfunction

  " vimfilerのマッピングを一部変更
  function! s:VimfilerSettings()
    " <Leader>がデフォルトマッピングで使用されていた場合の対策
    nmap <buffer> <LocalLeader> <Leader>

    " grepはUniteを使うので潰しておく
    nnoremap <buffer> gr <Nop>

    " ソート用マッピングを変えたい
    if neobundle#is_installed('vim-sneak')
      map <buffer>         S <Plug>Sneak_S
      map <buffer> <Leader>S <Plug>(vimfiler_select_sort_type)
    endif
  endfunction
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

  function! s:ScratchVimSettings()
    nnoremap <buffer> <Esc> <C-w>j
  endfunction
  autocmd MyAutoCmd FileType scratch call s:ScratchVimSettings()

  function! neobundle#hooks.on_post_source(bundle)
    " 使わないコマンドを削除する
    if exists(':ScratchInsert')    | delcommand ScratchInsert    | endif
    if exists(':ScratchSelection') | delcommand ScratchSelection | endif
  endfunction

endif "}}}

" Vimで英和辞書を引く(dicwin-vim) {{{
if neobundle#tap('dicwin-vim')

  let g:dicwin_no_default_mappings = 1
  nmap <A-k>      <Nop>
  nmap <A-k><A-k> <Plug>(dicwin-cword)
  imap <A-k>      <Nop>
  imap <A-k><A-k> <Plug>(dicwin-cword-i)
  nmap <A-k>c     <Plug>(dicwin-close)
  imap <A-k>c     <Plug>(dicwin-close-i)
  nmap <A-/>      <Plug>(dicwin-query)

  if filereadable(expand('~/vimfiles/dict/gene.txt'))
    autocmd MyAutoCmd BufRead gene.txt setlocal filetype=dicwin
    function! s:DicwinSettings()
      nnoremap <buffer> <Esc> :<C-u>q<CR>
    endfunction
    autocmd MyAutoCmd FileType dicwin call s:DicwinSettings()
  endif

endif "}}}

" Vimからブラウザを開く(open-browser.vim) {{{
if neobundle#tap('open-browser.vim')

  " オペレータは2回繰り返すと行に対して処理するが, <cword>に対して処理したい
  nmap <A-l><A-l> <Plug>(openbrowser-smart-search)

endif "}}}

" VimからTwitterを見る(TweetVim) {{{
if neobundle#tap('TweetVim')

  let g:tweetvim_config_dir = expand('~/.cache/TweetVim')
  function! s:TweetVimSettings()
    nnoremap <buffer> s :<C-u>TweetVimSay<CR>
  endfunction
  autocmd MyAutoCmd FileType tweetvim call s:TweetVimSettings()
endif "}}}

" VimからLingrを見る(J6uil.vim) {{{
if neobundle#tap('J6uil.vim')

  let g:J6uil_config_dir = expand('~/.cache/J6uil')

  function! s:J6uilSaySetting()
    " bd!の誤爆防止(入力が記憶されてたら嬉しいのだけれど)
    nnoremap <buffer> <C-j> <Nop>
    nnoremap <buffer> <Esc> <Nop>
  endfunction
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
  " " → むしろ有効活用したい
  " let g:vim_markdown_folding_disabled = 1

  " 折り畳みを1段階閉じた状態で開く
  " → foldlevelstartを変えても意味がないっぽいのでfoldlevelをいじる
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

  let g:easy_align_delimiters = {
        \   '/' : {
        \     'pattern'         : '//\+\|/\*\|\*/',
        \     'delimiter_align' : 'l',
        \     'ignore_groups'   : ['!Comment'],
        \   },
        \   'h' : {
        \     'pattern'         : '\v\/\*#%(\s{4})+|#\*\/',
        \     'delimiter_align' : 'l',
        \     'ignore_groups'   : ['!Comment'],
        \   },
        \ }

  xnoremap <CR> :EasyAlign<CR>

endif "}}}

" Vim上で書いているスクリプトをすぐ実行(vim-quickrun) {{{
if neobundle#tap('vim-quickrun')

  let g:quickrun_config = {
        \   '_' : {
        \     'outputter'                 : 'loclist',
        \     'runner'                    : 'vimproc',
        \     'runner/vimproc/updatetime' : 50,
        \   },
        \   'vb' : {
        \     'command'  : 'cscript',
        \     'cmdopt'   : '//Nologo',
        \     'tempfile' : '{tempname()}.vbs',
        \   },
        \   'c' : {
        \     'type'     : 'c/clang4_7_1',
        \   },
        \   'c/gcc4_8_1' : {
        \     'command'  : 'gcc',
        \     'cmdopt'   : '-g -Wall',
        \   },
        \   'c/clang4_7_1' : {
        \     'command'  : 'clang',
        \     'cmdopt'   : '-g -Wall',
        \   },
        \   'cpp' : {
        \     'type' : 'cpp/clang4_7_1',
        \   },
        \   'cpp/gcc4_8_1' : {
        \     'command'  : 'g++',
        \     'cmdopt'   : '-g -Wall',
        \   },
        \   'cpp/clang4_7_1' : {
        \     'command'  : 'clang++',
        \     'cmdopt'   : '-g -Wall',
        \   },
        \   'make' : {
        \     'command'  : 'make',
        \     'cmdopt'   : 'run',
        \   },
        \ }

  " デフォルトの<Leader>rだと入力待ちになるので, 別のキーをマッピング
  let g:quickrun_no_default_key_mappings = 1
  noremap <Leader>qq :<C-u>QuickRun -hook/time/enable 1
  noremap <Leader>qt :<C-u>QuickRun -hook/time/enable 1 -type<Space>
  noremap <Leader>qa :<C-u>QuickRun -hook/time/enable 1 -args<Space>""<Left>

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

