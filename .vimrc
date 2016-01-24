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
  if     bufname('%') == ''
    " 無名バッファなら, バッファを再生成
    new     | execute "normal! \<C-w>\<C-w>" | bdelete
  elseif argc() >= 1
    " ファイルが指定されていたら最初のファイルをbdeleteして開き直す
    bdelete | execute 'edit ' . a:path
  endif
endfunction
autocmd MyAutoCmd VimEnter * call s:regenerateFirstBuffer(expand('%:p'))

" Vim起動時間を計測
" → あくまで目安なので注意。実際のVimの起動時間は(表示値+0.5秒程度)になる
" → gvim --startuptime startuptime.txt
if has('vim_starting') && has('reltime')
  let s:startuptime = reltime()
  autocmd MyAutoCmd VimEnter *
        \   let s:startuptime = reltime(s:startuptime)
        \ | redraw
        \ | echomsg 'startuptime: ' . reltimestr(s:startuptime)
endif

" " ファイル書き込み時の文字コード。空の場合, encodingの値を使う
" " → デフォルト値が空であるため, encodingと同じ値にしたい場合は設定不要
" setglobal fileencoding=utf-8

" ファイル読み込み時の変換候補
" → 左から順に判定するので2byte文字が無いファイルだと最初の候補が選択される？
"    utf-8以外を左側に持ってきた時にうまく判定できないことがあったので要検証
" → とりあえずKaoriya版GVimのguessを使おう
if has('kaoriya')
  setglobal fileencodings=guess
else
  setglobal fileencodings=utf-8,cp932,euc-jp
endif

" 文字コードを指定してファイルを開き直す
nnoremap <Leader>en :<C-u>e ++encoding=

" 改行コードを指定してファイルを開き直す
nnoremap <Leader>ff :<C-u>e ++fileformat=

" バックアップ, スワップファイルの設定
" → ネットワーク上ファイルの編集時に重くなる？ので作らない
" → 生成先をローカルに指定していたからかも。要検証
setglobal noswapfile
setglobal nobackup
setglobal nowritebackup

" ファイルの書き込みをしてバックアップが作られるときの設定(作らないけども)
" yes  : 元ファイルをコピー  してバックアップにする＆更新を元ファイルに書き込む
" no   : 元ファイルをリネームしてバックアップにする＆更新を新ファイルに書き込む
" auto : noが使えるならno, 無理ならyes (noの方が処理が速い)
setglobal backupcopy=yes

" Vim生成物の生成先ディレクトリ指定
let s:saveSwapDir = expand('~/vimfiles/swap')
if !isdirectory(s:saveSwapDir)   | call mkdir(s:saveSwapDir)   | endif
let &g:dir = s:saveSwapDir

let s:saveBackupDir = expand('~/vimfiles/backup')
if !isdirectory(s:saveBackupDir) | call mkdir(s:saveBackupDir) | endif
let &g:backupdir = s:saveBackupDir

let s:saveUndoDir = expand('~/vimfiles/undo')
if !isdirectory(s:saveUndoDir)   | call mkdir(s:saveUndoDir)   | endif
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

" カーソル上下に表示する最小の行数
" → 大きい値にするとカーソル移動時に必ず再描画されるようになる
" → コードを読む時は大きく, 編集する時は小さくすると良いかも
set scrolloff=100
let s:scrolloffOn = 1
function! s:ToggleScrollOffSet()
  if s:scrolloffOn == 1
    set scrolloff=0   scrolloff?
    let s:scrolloffOn = 0
  else
    set scrolloff=100 scrolloff?
    let s:scrolloffOn = 1
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
  setglobal runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" contains filetype off
call neobundle#begin(expand('~/.vim/bundle'))

" NeoBundle自体の更新をチェックする
NeoBundleFetch 'Shougo/neobundle.vim'

" 日本語ヘルプを卒業したいが, なかなかできない
NeoBundleLazy 'vim-jp/vimdoc-ja'
setglobal helplang=ja

" ヴィむぷろしー
NeoBundle 'Shougo/vimproc.vim', {
      \   'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
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
      \   'on_cmd' : ['Agit', 'AgitFile'],
      \ }
NeoBundleLazy 'lambdalisue/vim-gita', {
      \   'external_command' : 'git',
      \   'on_cmd'           : 'Gita',
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
      \   'depends'  : 'toshi32tony3/neosnippet-snippets',
      \   'on_i'     : 1,
      \   'on_ft'    : 'neosnippet',
      \   'on_unite' : ['neosnippet', 'neosnippet/user', 'neosnippet/runtime'],
      \ }
NeoBundleLazy 'toshi32tony3/neosnippet-snippets'
NeoBundleLazy 'tyru/skk.vim'
NeoBundleLazy 'tyru/eskk.vim', {
      \   'depends' : 'Shougo/neocomplete.vim',
      \   'on_map'  : [['ni', '<Plug>']],
      \ }
NeoBundleLazy 'tyru/skkdict.vim', {
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

" 遅延読み込みが追い付かないことがあるのでLazyしない
NeoBundle 'haya14busa/incsearch.vim'

NeoBundleLazy 'osyo-manga/vim-anzu', {
      \   'on_map' : '<Plug>',
      \ }
NeoBundleLazy 'haya14busa/vim-asterisk', {
      \   'on_map' : '<Plug>',
      \ }

" 本家 : 'deris/vim-shot-f'
NeoBundleLazy 'toshi32tony3/vim-shot-f', {
      \   'rev'    : 'develop',
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
" 本家 : 'osyo-manga/vim-operator-search'
NeoBundleLazy 'toshi32tony3/vim-operator-search', {
      \   'rev'     : 'operator_for_line',
      \   'depends' : 'kana/vim-operator-user',
      \   'on_map'  : [['nx', '<Plug>']],
      \ }
NeoBundleLazy 'sgur/vim-operator-openbrowser', {
      \   'depends' : ['kana/vim-operator-user', 'tyru/open-browser.vim'],
      \   'on_map'  : [['nx', '<Plug>(operator-openbrowser)']],
      \   'on_cmd'  : ['OpenBrowser', 'OpenBrowserSearch', 'OpenBrowserSmartSearch'],
      \ }
NeoBundleLazy 'tyru/caw.vim', {
      \   'depends' : 'kana/vim-operator-user',
      \   'on_map'  : [['nx', '<Plug>(operator-caw)']],
      \ }
NeoBundleLazy 't9md/vim-quickhl', {
      \   'on_map'  : [['nx', '<Plug>', '<Plug>(operator-quickhl-']],
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

" 遅延読み込みすると候補収集されないので, Vim起動直後に読み込む
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/neoyank.vim'

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
      \   'depends' : 'Shougo/unite.vim',
      \   'on_cmd'  : 'VimFilerCurrentDir',
      \   'on_path' : '.*',
      \ }

"}}}
"-------------------------------------------------------------------
" quickfix / special buffer {{{

NeoBundleLazy 'thinca/vim-qfreplace', {
      \   'on_cmd' : 'Qfreplace',
      \ }

NeoBundleLazy 'mtth/scratch.vim', {
      \   'on_map' : '<Plug>',
      \   'on_cmd' : ['Scratch', 'ScratchPreview'],
      \ }

" 本家 : 'koron/dicwin-vim'
NeoBundleLazy 'toshi32tony3/dicwin-vim', {
      \   'on_map' : [['ni', '<Plug>']],
      \ }

"}}}
"-------------------------------------------------------------------
" web / markdown {{{

NeoBundleLazy 'tyru/open-browser.vim', {
      \   'on_map' : '<Plug>(',
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

NeoBundle 'lambdalisue/vim-gista', {
      \   'on_cmd' : 'Gista',
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
" longest : 候補の共通部分だけを挿入
setglobal completeopt=menuone,longest

setglobal noinfercase  " 補完時にマッチした単語をそのまま挿入
setglobal pumheight=10 " 補完候補は一度に10個まで表示

" コマンドライン補完設定
setglobal wildmenu
setglobal wildmode=full

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
setglobal clipboard=unnamed

" 現在開いているファイルのフルパス(ファイル名含む)をレジスタへ
command! ClipFilePath let @* = expand('%:p')   | echo 'clipped: ' . @*

" 現在開いているファイルのファイル名をレジスタへ
command! ClipFileName let @* = expand('%:t')   | echo 'clipped: ' . @*

" 現在開いているファイルのディレクトリパスをレジスタへ
command! ClipFileDir  let @* = expand('%:p:h') | echo 'clipped: ' . @*

" コマンドの出力結果を選択範囲レジスタ(*)へ
function! s:ClipCommandOutput(cmd)
  redir @*> | silent execute a:cmd | redir END
  " 先頭の改行文字を取り除く
  if len(@*) != 0 | let @* = @*[1 :] | endif
endfunction
command! -nargs=1 -complete=command ClipCommandOutput call s:ClipCommandOutput(<f-args>)

"}}}
"-----------------------------------------------------------------------------
" View {{{

if has('gui_running')
  " Ricty for Powerline
  setglobal guifont=Ricty\ for\ Powerline:h12:cSHIFTJIS

  " 行間隔[pixel]の設定(default 1 for Win32 GUI)
  setglobal linespace=0

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

setglobal number         " 行番号を表示
setglobal relativenumber " 行番号を相対表示
nnoremap <silent> <F10> :<C-u>set relativenumber!<Space>relativenumber?<CR>

" 不可視文字を可視化
setglobal list

" 不可視文字の設定(UTF-8特有の文字は使わない方が良い)
setglobal listchars=tab:>-,trail:-,eol:\

if has('kaoriya')

  " 透明度をスイッチ
  let s:transparencyOn = 0
  function! s:ToggleTransParency()
    if s:transparencyOn == 1
      set transparency=255 transparency?
      let s:transparencyOn = 0
    else
      set transparency=220 transparency?
      let s:transparencyOn = 1
    endif
  endfunction
  nnoremap <silent> <F12> :<C-u>call <SID>ToggleTransParency()<CR>

endif

" foldmarkerを使って折り畳みを作成する
setglobal foldmethod=marker

" 基本的にはfoldmarkerに余計なものを付けない
setglobal commentstring=%s

" filetypeがvimの時はvimのコメント行markerを前置してfoldmarkerを付ける
autocmd MyAutoCmd FileType vim setlocal commentstring=\ \"%s

" 画面左端に折り畳み状態, レベルを表示する列を1列設ける
setglobal foldcolumn=1

" foldmethodがindent, syntaxの時に生成する折り畳みの深さの最大値
" → marker以外使わない気がするので, 余計な負荷がかからないように小さくしておく
setglobal foldnestmax=2

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
if !isdirectory(s:saveWinposDir)
  call    mkdir(s:saveWinposDir)
endif
let s:saveWinposFile = expand('~/vimfiles/winpos/.winpos')
autocmd MyAutoCmd VimLeavePre * call s:SaveWindow()
function! s:SaveWindow()
  let s:options = [
        \   'setglobal columns=' . &columns,
        \   'setglobal lines='   . &lines,
        \   'winpos ' . getwinposx() . ' ' . getwinposy(),
        \ ]
  call writefile(s:options, s:saveWinposFile)
endfunction
if filereadable(s:saveWinposFile)
  execute 'source ' s:saveWinposFile
endif

"}}}
"-----------------------------------------------------------------------------
" Search {{{

" very magic
nnoremap / /\v<Left><Left>

setglobal ignorecase  " 検索時に大文字小文字を区別しない。区別したい時は\Cを付ける
setglobal smartcase   " 大文字小文字の両方が含まれている場合は, 区別する
setglobal wrapscan    " 検索時に最後まで行ったら最初に戻る
setglobal noincsearch " インクリメンタルサーチしない
setglobal hlsearch    " マッチしたテキストをハイライト

" grep/vimgrep結果が0件の場合, Quickfixを開かない
autocmd MyAutoCmd QuickfixCmdPost grep,vimgrep if len(getqflist()) != 0 | copen | endif

if has('kaoriya') && has('migemo')
  " 逆方向migemo検索g?を有効化
  setglobal migemo

  " kaoriya版のmigemo searchを再マッピング
  noremap m/ g/
  noremap m? g?
endif

"}}}
"-----------------------------------------------------------------------------
" Simplify operation {{{

" キー入力タイムアウトはあると邪魔だし, 待つ意味も無い気がする
setglobal notimeout

" vimrcをリロード
nnoremap ,r :<C-u>source $MYVIMRC<CR>

" make後, 自動でQuickfixウィンドウを開く
autocmd MyAutoCmd QuickfixCmdPost make if len(getqflist()) != 0 | copen | endif

" 最後のウィンドウのbuftypeがquickfixであれば, 自動で閉じる
" → buftypeがnofileかつ特定のfiletypeの追加を試みたが,
"    暴発する度にfiletypeを追加することになるのでやめた
autocmd MyAutoCmd WinEnter * if winnr('$') == 1 && &buftype == 'quickfix' | quit | endif

" 検索テキストハイライトを消す
nnoremap <silent> <Esc> :<C-u>nohlsearch<CR>

" j/kによる移動を折り返されたテキストでも自然に振る舞うようにする
nnoremap <silent> j  gj
xnoremap <silent> j  gj
nnoremap <silent> k  gk
xnoremap <silent> k  gk
nnoremap <silent> gj j
xnoremap <silent> gj j
nnoremap <silent> gk k
xnoremap <silent> gk k

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
  call add(s:MyCMapEntries, [a:originalPattern, a:alternateName])
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
call s:AddMyCMap( '^cd$',  'CD')
call s:AddMyCMap('^lcd$', 'LCD')
call s:AddMyCMap( '^CD$',  'cd')
call s:AddMyCMap('^LCD$', 'lcd')
call s:AddMyCMap('^cfd$', 'ClipFileDir')
call s:AddMyCMap( '^uc$', 'UpdateCtags')
call s:AddMyCMap( '^pd$', 'PutDateTime')
call s:AddMyCMap( '^cm$', 'ClearMessage')

" リストへの変換候補登録(Plugin's command)
if neobundle#is_installed('scratch.vim')
  call s:AddMyCMap('^sc$',  'Scratch')
  call s:AddMyCMap('^scp$', 'ScratchPreview')
endif

" " 開いたファイルと同じ場所へ移動する
" " → startify/vimfiler/:LCD/:CDで十分なのでコメントアウト
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
    let g:local_rc#src_dir         = g:local_rc#src_list[g:local_rc#src_index]
    let g:local_rc#current_src_dir = g:local_rc#base_dir . '\' . g:local_rc#src_dir
    let g:local_rc#ctags_dir       = g:local_rc#current_src_dir . '\.tags'
  endfunction "}}}

  function! s:SetTags() "{{{
    " tagsをセット
    set tags=
    for l:item in g:local_rc#ctags_list
      if l:item == '' | break | endif
      let &tags = &tags . ',' . g:local_rc#ctags_dir . '\' . g:local_rc#ctags_name_list[l:item]
    endfor
    " 1文字目の','を削除
    if &tags != '' | let &tags = &tags[1 :] | endif
    " GTAGSROOTの登録
    " → GNU GLOBALのタグはプロジェクトルートで生成する
    let $GTAGSROOT = g:local_rc#current_src_dir
  endfunction "}}}

  function! s:SetPathList() "{{{
    set path=
    " 起点なしのpath登録
    for l:item in g:local_rc#other_dir_path_list
      if l:item == '' | break | endif
      let &path = &path . ',' . l:item
    endfor
    " g:local_rc#current_src_dirを起点にしたpath登録
    for l:item in g:local_rc#current_src_dir_path_list
      if l:item == '' | break | endif
      let &path = &path . ',' . g:local_rc#current_src_dir . '\' . l:item
    endfor
    " 1文字目の','を削除
    if &path != '' | let &path = &path[1 :] | endif
  endfunction "}}}

  function! s:SetCDPathList() "{{{
    set cdpath=
    " 起点なしのcdpath登録
    for l:item in g:local_rc#other_dir_cdpath_list
      if l:item == '' | break | endif
      let &cdpath = &cdpath . ',' . l:item
    endfor
    let &cdpath = &cdpath . ',' . g:local_rc#base_dir
    let &cdpath = &cdpath . ',' . g:local_rc#current_src_dir
    " g:local_rc#current_src_dirを起点にしたcdpath登録
    for l:item in g:local_rc#current_src_dir_cdpath_list
      if l:item == '' | break | endif
      let &cdpath = &cdpath . ',' . g:local_rc#current_src_dir . '\' . l:item
    endfor
    " 1文字目の','を削除
    if &cdpath != '' | let &cdpath = &cdpath[1 :] | endif
  endfunction "}}}

  " 初回のtags, path設定
  autocmd MyAutoCmd VimEnter *
        \   call s:SetSrcDir()
        \ | call s:SetTags()
        \ | call s:SetPathList()
        \ | call s:SetCDPathList()
        \ | call SetEnvironmentVariables()

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
    call g:SetEnvironmentVariables()
    " ソースコード切り替え後, ソースディレクトリ名を出力
    echo 'switch source to: ' . g:local_rc#src_dir
  endfunction "}}}
  nnoremap <silent> ,s :<C-u>call <SID>SwitchSource()<CR>

  " ctagsをアップデート
  function! s:UpdateCtags() "{{{
    if !executable('ctags') | echomsg 'ctagsが見つかりません' | return | endif
    if !isdirectory(g:local_rc#ctags_dir)
      call    mkdir(g:local_rc#ctags_dir)
    endif
    for l:item in g:local_rc#ctags_list
      if l:item == '' | break | endif
      if !has_key(g:local_rc#ctags_name_list, l:item) | continue | endif
      let l:updateCommand =
            \ 'ctags -f ' .
            \ g:local_rc#current_src_dir . '\.tags\' . g:local_rc#ctags_name_list[l:item] .
            \ ' -R ' .
            \ g:local_rc#current_src_dir . '\' . l:item
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

" " <C-@>  : 直前に挿入したテキストをもう一度挿入し, ノーマルモードに戻る
" " <C-g>u : アンドゥ単位を区切る
" inoremap <C-@> <C-g>u<C-@>

" <C-@>は割りと暴発する＆あまり用途が見当たらないので, <Esc>に置き替え
inoremap <C-@> <Esc>
noremap  <C-@> <Esc>

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
inoremap <Left>  <Nop>
inoremap <Down>  <Nop>
inoremap <Up>    <Nop>
inoremap <Right> <Nop>

" Shift or Ctrl or Alt + カーソルキーはコマンドモードでのみ使用する
" → と思ったが, とりあえず潰しておいて, 一部再利用するマッピングを行う
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

" ただ潰すのは勿体無いので,         カーソルキーでウィンドウ間を移動
nnoremap <Left>  <C-w>h
nnoremap <Down>  <C-w>j
nnoremap <Up>    <C-w>k
nnoremap <Right> <C-w>l

" ただ潰すのは勿体無いので, Shift + カーソルキーでbprevious/bnext
nnoremap <S-Left>  :bprevious<CR>
nnoremap <S-Right> :bnext<CR>

" ただ潰すのは勿体無いので,  Ctrl + カーソルキーでcprevious/cnext
nnoremap <C-Left>  :cprevious<CR>
nnoremap <C-Right> :cnext<CR>

" ただ潰すのは勿体無いので,   Alt + カーソルキーでlprevious/lnext
nnoremap <A-Left>  :lprevious<CR>
nnoremap <A-Right> :lnext<CR>

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

" 区切り線+タイムスタンプの挿入
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
  if      l:currentMode !=  'n' &&
        \ l:currentMode != 'no' &&
        \ l:currentMode !=# 'v' &&
        \ l:currentMode !=# 'V' &&
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
  autocmd   MyAutoCmd User MyCursorMoved :
  doautocmd MyAutoCmd User MyCursorMoved

  " lastCursorMoveTimeを更新
  let b:lastCursorMoveTime = l:now

  " 行移動していなければ抜ける
  if b:lastVisitedLine == line('.') | return | endif

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
function! s:JumpFuncNameCForward() "{{{
  if &filetype != 'c' | return | endif

  " Viewを保存
  let l:savedView = winsaveview()

  let l:lastLine  = line('.')
  keepjumps normal! ]]

  " 検索対象が居なければViewを戻して処理終了
  if line('.') == line('$') | call winrestview(l:savedView) | return | endif

  call search('(', 'b')
  keepjumps normal! b

  " 行移動していたら処理終了
  if l:lastLine != line('.') | return  | endif

  " 行移動していなければ, 開始位置がCの関数名上だったということ
  " → 下方向検索するには, ]]を2回使う必要がある
  keepjumps normal! ]]
  keepjumps normal! ]]

  " 検索対象が居なければViewを戻して処理終了
  if line('.') == line('$') | call winrestview(l:savedView) | return | endif

  call search('(', 'b')
  keepjumps normal! b
endfunction " }}}
function! s:JumpFuncNameCBackward() "{{{
  if &filetype != 'c' | return | endif

  " Viewを保存
  let l:savedView = winsaveview()

  " カーソルがある行の1列目の文字が { ならば [[ は不要 " for match }
  if getline('.')[0] != '{'                            " for match }
    keepjumps normal! [[

    " 検索対象が居なければViewを戻して処理終了
    if line('.') == 1 | call winrestview(l:savedView) | return | endif
  endif

  call search('(', 'b')
  keepjumps normal! b
endfunction " }}}
nnoremap <silent> ]f :<C-u>call <SID>JumpFuncNameCForward()<CR>
nnoremap <silent> [f :<C-u>call <SID>JumpFuncNameCBackward()<CR>

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

" VCSの差分をVimのsignで表示(vim-signify) {{{
if neobundle#tap('vim-signify')

  let g:signify_vcs_list = ['git', 'cvs']
  let g:signify_disable_by_default = 1
  let g:signify_update_on_bufenter = 0
  let g:signify_update_on_focusgained = 1

  " Lazy状態からSignifyToggleすると一発目がオフ扱いになるようなので2連発
  " → SignifyEnableでも2連発する必要があったので, 読み込み時の都合かも
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

    " Hunk text object
    omap ic <Plug>(signify-motion-inner-pending)
    xmap ic <Plug>(signify-motion-inner-visual)
    omap ac <Plug>(signify-motion-outer-pending)
    xmap ac <Plug>(signify-motion-outer-visual)

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

  function! s:AgitSettings()
    nmap <buffer> ch <Plug>(agit-git-cherry-pick)
    nmap <buffer> Rv <Plug>(agit-git-revert)
  endfunction
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

  if has('kaoriya')
    setglobal imdisable
  endif

  if neobundle#is_installed('skk.vim')
    " disable skk.vim
    " → Helpを見るためにskk.vim自体は入れておきたい
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

  " http://tyru.hatenablog.com/entry/20101214/vim_de_skk
  let g:eskk#egg_like_newline = 1
  let g:eskk#egg_like_newline_completion = 1
  let g:eskk#rom_input_style = 'msime'

  " for Lazy
  imap        <C-j> <Plug>(eskk:enable)
  cmap <expr> <C-j> eskk#toggle()

  " すぐにskkしたい
  nmap <Leader>i i<Plug>(eskk:enable)
  nmap <Leader>a a<Plug>(eskk:enable)
  nmap <A-i>     I<Plug>(eskk:enable)
  nmap <A-a>     A<Plug>(eskk:enable)

  " <C-o>はjumplist戻るなので潰せない。Oは我慢
  nmap <A-o>     o<Plug>(eskk:enable)

  " もっとすぐにskkしたい
  nmap <silent> <Leader>c :<C-u>call <SID>EnableEskkAfterOperation('c')<CR>
  nmap <A-c>              C<Plug>(eskk:enable)

  function! s:EnableEskkAfterOperation(cmd)
    let  l:firstChar = nr2char(getchar())
    if   l:firstChar !=# 'a' && l:firstChar !=# 'i' | return | endif
    let l:secondChar = nr2char(getchar())
    call feedkeys(a:cmd . l:firstChar . l:secondChar)
    call eskk#enable()
  endfunction

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

" My favorite colorscheme(vim-tomorrow-theme) {{{
if neobundle#tap('vim-tomorrow-theme')

  " 現在のカーソル位置をわかりやすくする
  autocmd MyAutoCmd ColorScheme * highlight Cursor guifg=White guibg=Red

  " 検索中のフォーカス位置をわかりやすくする
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

  function! MyModified()
    return &filetype =~  'help\|vimfiler\' ? ''          :
          \              &modified         ? "\<Space>+" :
          \              &modifiable       ? ''          : "\<Space>-"
  endfunction

  function! MyReadonly()
    return &filetype !~? 'help\|vimfiler\' && &readonly ? "\<Space>\u2B64" : ''
  endfunction

  function! MyFilename()
    " 以下の条件を満たすと処理負荷が急激に上がる。理由は不明
    " ・Vimのカレントディレクトリがネットワーク上
    " ・ネットワーク上のファイルを開いており, ファイル名をフルパス(%:p)出力
    " → GVIMウィンドウ上部にフルパスが表示されているので, そちらを参照する
    return (&filetype == 'vimfiler' ? ''          :
          \     expand('%:t') == '' ? '[No Name]' : expand('%:t'))
          \   . (MyReadonly() == '' ? ''          : MyReadonly() )
          \   . (MyModified() == '' ? ''          : MyModified() )
  endfunction

  function! MyFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
  endfunction

  function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
  endfunction

  function! MyFileencoding()
    return winwidth(0) > 70 ? (strlen(&fileencoding) ? &fileencoding : &encoding) : ''
  endfunction

  function! MyMode()
    return winwidth(0) > 30 ? lightline#mode() : ''
  endfunction

  function! MySKKMode()
    " 処理順を明確にするため, neobundle#hooks.on_post_source()を
    " 使ってプラグインの読み込み完了フラグを立てることにした
    " → 一応neobundle#is_sourced()を使っても問題無く動くことは確認した
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

    " モード切り替わり(normal⇔skk)を監視するついでにneocompleteをlock/unlock
    if b:LastMode == ''
      " normal → skk : 必要ならunlock
      if neocomplete#get_current_neocomplete().lock == 1
        NeoCompleteUnlock
      else
        let b:IsAlreadyUnlocked = 1
      endif

    else
      " skk → normal : 必要ならlock
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
    if &filetype == 'vim' || &filetype == 'markdown'
      return winwidth(0) > 100 ? s:currentFold : ''
    else
      return winwidth(0) > 70  ? s:currentFunc : ''
    endif
  endfunction

  function! MyFugitive()
    if !neobundle#is_installed('vim-fugitive') || &filetype == 'vimfiler'
      return ''
    endif
    let l:_ = fugitive#head()
    return winwidth(0) > 30 ? (strlen(l:_) ? "\u2B60 " . l:_ : '') : ''
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

  let s:fullscreenOn = 0
  function! s:ToggleScreenMode()
    if s:fullscreenOn
      execute 'ScreenMode 0'
      let s:fullscreenOn = 0
    else
      execute 'ScreenMode 6'
      let s:fullscreenOn = 1
    endif
  endfunction
  nnoremap <silent> <F11> :<C-u>call <SID>ToggleScreenMode()<CR>

endif "}}}

" incsearchをパワーアップ(incsearch.vim) {{{
if neobundle#tap('incsearch.vim')

  noremap <silent> <expr> g/ incsearch#go({'command' : '/', 'is_stay' : 1, 'pattern' : '\v<Left><Left>'})
  noremap <silent> <expr> g? incsearch#go({'command' : '?', 'is_stay' : 1, 'pattern' : '\v<Left><Left>'})

endif "}}}

" asterisk検索をパワーアップ(vim-asterisk) {{{
if neobundle#tap('vim-asterisk')

  " 検索開始時のカーソル位置を保持する
  let g:asterisk#keeppos = 1

  " star-search対象を無名レジスタに入れる
  " → クリップボードを誤って上書きすることがあったので無名レジスタに変更
  function! s:ClipCword(data) "{{{
    let     l:currentMode  = mode(1)
    if      l:currentMode == 'n'
      let @" = a:data
      return ''
    elseif  l:currentMode == 'no'
      let @" = a:data
      return "\<Esc>"
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

  " " 検索対象横にechoする。視線移動は減るが結構見づらくなるので慣れが必要
  " nmap n <Plug>(anzu-mode-n)
  " nmap N <Plug>(anzu-mode-N)

  " " 検索開始時にジャンプせず, その場でanzu-modeに移行する
  " if neobundle#is_installed('vim-asterisk')
  "   nmap *  <Plug>(_ClipCword)<Plug>(asterisk-z*)<Plug>(_ModSearchHistory)<Plug>(anzu-mode)
  "   nmap #  <Plug>(_ClipCword)<Plug>(asterisk-z#)<Plug>(_ModSearchHistory)<Plug>(anzu-mode)
  "   nmap g* <Plug>(_ClipCword)<Plug>(asterisk-gz*)<Plug>(_ModSearchHistory)<Plug>(anzu-mode)
  "   nmap g# <Plug>(_ClipCword)<Plug>(asterisk-gz#)<Plug>(_ModSearchHistory)<Plug>(anzu-mode)
  " else
  "   nmap * *<Plug>(anzu-mode)
  " endif

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
  let g:u_fbuf = '-buffer-name=file-buffer '
  let g:u_sbuf = '-buffer-name=search-buffer '
  let g:u_nins = '-no-start-insert '
  let g:u_nspl = '-no-split '
  let g:u_hopt =    '-split -horizontal -winheight=20 '
  let g:u_vopt =    '-split -vertical -winwidth=90 '

  " unite_sourcesに応じたオプション変数を定義して使ってみたけど微妙感が漂う
  let g:u_opt_bu = 'Unite '       . g:u_hopt . g:u_nins
  let g:u_opt_bo = 'Unite '       . g:u_hopt
  let g:u_opt_de = 'Unite '       . g:u_hopt
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
  let g:u_opt_ol = 'Unite '       . g:u_vopt
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
  nnoremap <expr> <Leader>fr ':<C-u>' . g:u_opt_fr . 'file_rec'         . '<CR>'
  nnoremap <expr> <Leader>g% ':<C-u>' . g:u_opt_gr . 'vimgrep:%'        . '<CR>'
  nnoremap <expr> <Leader>g* ':<C-u>' . g:u_opt_gr . 'vimgrep:*'        . '<CR>'
  nnoremap <expr> <Leader>g. ':<C-u>' . g:u_opt_gr . 'vimgrep:.*'       . '<CR>'
  nnoremap <expr> <Leader>gg ':<C-u>' . g:u_opt_gr . 'grep/git:.'       . '<CR>'
  nnoremap <expr> <Leader>gr ':<C-u>' . g:u_opt_gr . 'vimgrep:**'       . '<CR>'
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
    " <Leader>がデフォルトマッピングで使用されていた場合の対策
    nmap <buffer> <LocalLeader> <Leader>

    " grepはUniteを使うので潰しておく
    nnoremap <buffer> gr <Nop>

    " カレントディレクトリを開く
    nnoremap <buffer> ,c :<C-u>VimFilerCurrentDir<CR>
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
    delcommand ScratchInsert
    delcommand ScratchSelection

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
    nnoremap <buffer> <C-CR>     :<C-u>TweetVimSay<CR>
    nmap     <buffer> <Leader>rt <Plug>(tweetvim_action_retweet)
  endfunction
  autocmd MyAutoCmd FileType tweetvim call s:TweetVimSettings()

endif "}}}

" VimからLingrを見る(J6uil.vim) {{{
if neobundle#tap('J6uil.vim')

  let g:J6uil_config_dir = expand('~/.cache/J6uil')

  function! s:J6uilSaySetting()
    if neobundle#is_installed('eskk.vim')
      nmap     <buffer> <C-j> i<Plug>(eskk:toggle)

      " bd!が誤爆して悲しいので防ぐ(入力が記憶されてたら嬉しいのだけれど)
      nmap     <buffer> <Esc> <Nop>
    else
      nnoremap <buffer> <C-j> <Nop>
    endif
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
  " → autocmd FileTypeでfoldlevelstartを変えても意味がないぽい
  " → foldlevelをいじる
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
" TODO: operator-searchの残件
"       1. lineが条件から抜けていた件のPR
"       2. オペレータを2回連続で入力した時の行指向検索
"       3. 矩形Visualモードで指定したblock検索

