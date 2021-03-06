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

augroup MyAutoCmd " vimrc内全体で使うaugroupを定義
  autocmd!
augroup END

" setglobalがVim起動直後に生成されるバッファに適用されない件の対策
function! s:regenerateFirstBuffer(path)
  if argc() >= 1 | bdelete | execute 'edit ' . a:path
  else           | new     | execute 'wincmd w'       | bdelete | endif
endfunction
autocmd MyAutoCmd VimEnter * call s:regenerateFirstBuffer(expand('%:p'))

" " 書き込み時の文字エンコーディング(encodingと同じ値にしたい場合は設定不要)
" setglobal fileencoding=utf-8

" 読み込み時の文字エンコーディング候補
if has('kaoriya') | setglobal fileencodings=guess
else              | setglobal fileencodings=cp932,euc-jp,utf-8 | endif

" 文字エンコーディング/改行コードを指定してファイルを開き直す
nnoremap <Leader>en :<C-u>e ++bad=keep ++encoding=
nnoremap <Leader>ff :<C-u>e ++fileformat=

" ネットワーク上ファイルの書き込みが遅くなるので, いろいろ作らない
setglobal nobackup nowritebackup noswapfile

" Vim生成物の生成先ディレクトリ指定
let s:saveUndoDir = expand('~/vimfiles/undo')
if !isdirectory(s:saveUndoDir) | call mkdir(s:saveUndoDir) | endif
if has('persistent_undo') |
  let &g:undodir = s:saveUndoDir
  setglobal undofile
endif

" デフォルトではスペルチェックしない
setglobal nospell spelllang=en,cjk spellfile=~/dotfiles/en.utf-8.add
setglobal history=1000       " コマンドと検索の履歴は多めに保持できるようにする
setglobal autoread           " ファイルが外部で変更された時, 自動的に読み直す
setglobal shortmess=aoOotTWI " メッセージ省略設定

" カーソル上下に表示する最小の行数(大きい値:カーソル移動時に必ず画面再描画)
if !exists('s:scrolloffOn') | set scrolloff=100 | let s:scrolloffOn = 1 | endif
function! s:ToggleScrollOffSet()
  let s:scrolloffOn = (s:scrolloffOn + 1) % 2
  if  s:scrolloffOn | set scrolloff=100 | set scrolloff?
  else              | set scrolloff=0   | set scrolloff? | endif
endfunction
nnoremap <silent> <F2> :<C-u>call <SID>ToggleScrollOffSet()<CR>

" vimdiff用オプション(filler : 埋め合わせ行を表示する / vertical : 縦分割する)
setglobal diffopt=filler,vertical

" ターミナルを指定
if !has('gui_running')
  setglobal ttytype=builtin_xterm
endif

"}}}
"-----------------------------------------------------------------------------
" Plugin List {{{

" filetype関連のファイルはruntimepathの登録が終わってから読み込むため, 一旦オフ
filetype plugin indent off

" 実は必要のないset nocompatible
" http://rbtnn.hateblo.jp/entry/2014/11/30/174749
if has('vim_starting')
  if &compatible | setglobal nocompatible | endif
  " neobundle.vimでプラグインを管理する(NeoBundleCleanを使うために小細工)
  if   isdirectory(expand('~/.vim/bundle/neobundle.vim_673be4e'))
    setglobal runtimepath+=~/.vim/bundle/neobundle.vim_673be4e
  else
    setglobal runtimepath+=~/.vim/bundle/neobundle.vim
  endif
endif
call neobundle#begin(expand('~/.vim/bundle'))

" NeoBundleCleanを使うために小細工
NeoBundleFetch 'Shougo/neobundle.vim', {'rev' : '673be4e'}

" 日本語ヘルプを卒業したいが, なかなかできない
NeoBundleLazy 'vim-jp/vimdoc-ja'
setglobal helplang=ja

NeoBundle 'thinca/vim-scouter'

" ヴィむぷろしー
NeoBundle 'Shougo/vimproc.vim', {
      \   'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'linux'   : 'make',
      \   },
      \   'rev' : 'ver.9.3',
      \ }

"-------------------------------------------------------------------
" VCS {{{

NeoBundle 'mhinz/vim-signify'

NeoBundleLazy 'cohama/agit.vim', {
     \   'on_cmd'    : ['Agit', 'AgitFile']
     \ }

NeoBundleLazy 'lambdalisue/vim-gita', {
      \   'rev'       : '0.1.5',
      \   'on_source' : 'agit.vim',
      \   'on_cmd'    : 'Gita',
      \ }
command! -nargs=* -range -bang -bar -complete=customlist,gita#command#complete
      \ GitaBar call gita#command#command(<q-bang>, [<line1>, <line2>], <q-args>)
NeoBundle 'tpope/vim-fugitive'

"}}}
"-------------------------------------------------------------------
" input {{{

NeoBundleLazy 'tyru/eskk.vim',    {'on_map' : [['nic', '<Plug>']]}
NeoBundleLazy 'tyru/skkdict.vim', {'on_ft' : 'skkdict'}

NeoBundleLazy 'thinca/vim-ambicmd'

"}}}
"-------------------------------------------------------------------
" view {{{

" 本家 : 'sjl/badwolf'
NeoBundle 'toshi32tony3/badwolf'

" 本家 : 'vim-scripts/EditPlus'
NeoBundle 'toshi32tony3/EditPlus'

NeoBundle 'cocopon/lightline-hybrid.vim'
NeoBundle 'itchyny/lightline.vim'

let g:loaded_matchparen = 1
NeoBundle 'itchyny/vim-parenmatch'

NeoBundleLazy 'thinca/vim-fontzoom', {
      \   'on_map' : '<Plug>',
      \   'on_cmd' : 'Fontzoom',
      \ }

"}}}
"-------------------------------------------------------------------
" move {{{

NeoBundleLazy 'osyo-manga/vim-anzu',     {'on_map' : '<Plug>'}
NeoBundleLazy 'haya14busa/vim-asterisk', {'on_map' : '<Plug>'}

NeoBundleLazy 'deris/vim-shot-f',        {'on_map' : '<Plug>'}

" NeoBundle 'kshenoy/vim-signature'

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
NeoBundleLazy 'osyo-manga/vim-operator-search', {
      \   'depends' : ['kana/vim-operator-user', 'kana/vim-textobj-function'],
      \   'on_map'  : [['nx', '<Plug>']],
      \ }
NeoBundleLazy 'tyru/caw.vim', {
      \   'depends' : ['kana/vim-operator-user'],
      \   'on_map'  : [['nx', '<Plug>']],
      \ }

NeoBundleLazy 't9md/vim-quickhl', {
      \   'on_map'  : [['nx', '<Plug>(', '<Plug>(operator-quickhl-']],
      \ }

NeoBundle 'tpope/vim-surround'
NeoBundle 'toshi32tony3/vim-repeat'

"}}}
"-------------------------------------------------------------------
" vimdiff {{{

NeoBundleLazy 'AndrewRadev/linediff.vim', {'on_cmd' : 'Linediff'}

"}}}
"-------------------------------------------------------------------
" interface {{{

NeoBundle 'mhinz/vim-startify', {'rev' : 'v1.1'}

NeoBundleLazy 'Shougo/unite.vim',     {'on_cmd'    : 'Unite'}
NeoBundleLazy 'hewes/unite-gtags',    {'on_source' : 'unite.vim'}
NeoBundleLazy 'Shougo/unite-outline', {'on_source' : 'unite.vim'}
NeoBundle 'Shougo/vimfiler.vim',      {'rev'       : 'b5a8b54' }

"}}}
"-------------------------------------------------------------------
" special buffer {{{

NeoBundleLazy 'thinca/vim-qfreplace', {'on_cmd' : 'Qfreplace'}

NeoBundleLazy 'mtth/scratch.vim', {
      \   'on_map' : '<Plug>',
      \   'on_cmd' : ['Scratch', 'ScratchPreview'],
      \ }

" 本家 : 'koron/dicwin-vim'
NeoBundleLazy 'toshi32tony3/dicwin-vim', {'on_map' : [['ni', '<Plug>']]}

"}}}
"-------------------------------------------------------------------
" web {{{

NeoBundleLazy 'tyru/open-browser.vim', {
      \   'on_map' : '<Plug>(open',
      \   'on_cmd' : ['OpenBrowserSearch'],
      \ }
"}}}
"-------------------------------------------------------------------
" formatter {{{

" 本家 : 'bronson/vim-trailing-whitespace'
NeoBundle 'toshi32tony3/vim-trailing-whitespace'

"}}}
"-------------------------------------------------------------------

call neobundle#end()

" Call on_source hook when reloading .vimrc.
" https://github.com/machakann/vimrc/blob/master/.vimrc
if !has('vim_starting')
  call neobundle#call_hook('on_source')
endif

" filetype関連のファイルを読み込む
filetype plugin indent on

" シンタックスハイライトを有効化(on:現在の設定を破棄する, enable:破棄しない)
syntax enable

" vimrcに書いてあるプラグインがインストールされているかチェックする
NeoBundleCheck

" ローカル設定を読み込む
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
autocmd MyAutoCmd FileType       make setlocal noexpandtab

setglobal nrformats=hex              " <C-a>や<C-x>の対象を10進数,16進数に絞る
setglobal virtualedit=all            " テキストが存在しない場所でも動きたい
setglobal nostartofline              " カーソルが勝手に行の先頭へ行くのは嫌
setglobal hidden                     " quit時はバッファを削除せず, 隠す
setglobal confirm                    " 変更されたバッファを閉じる時に確認する
setglobal switchbuf=useopen,usetab   " 既に開かれていたら, そっちを使う
setglobal showmatch matchtime=3      " 対応する括弧などの入力時にハイライト表示
setglobal backspace=indent,eol,start " <BS>でなんでも消せるようにする
setglobal iminsert=0 imsearch=0      " 勝手にIME ONさせない

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
setglobal completeopt=menuone noinfercase pumheight=10

" コマンドライン補完設定
setglobal wildmenu wildmode=full

" <C-p>や<C-n>でもコマンド履歴のフィルタリングを使えるようにする
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" 自動整形設定(formatoptions)
" Default: formatoptions=tcq
" c : textwidthを使ってコメントを自動折返 + コメント行を継続
" j : 行連結時にコメントリーダーを削除
" m : 整形時, 255よりも大きいマルチバイト文字間でも改行する
" q : gqでコメント行を整形
" t : textwidthを使ってテキストを自動折返
" B : 行連結時に, マルチバイト文字の前後に空白を挿入しない
" M : 行連結時に, マルチバイト文字同士の間に空白を挿入しない
setglobal formatoptions=cjmqBM
setglobal textwidth=78
setglobal noautoindent

" インデントを入れるキーのリストを調整(コロン, 行頭の#でインデントしない)
setglobal indentkeys-=:,0# cinkeys-=:,0#

" Dはd$なのにYはyyと同じというのは納得がいかない
nnoremap Y y$

" クリップボードレジスタを使う
setglobal clipboard=unnamed

" クリップボード関連のコマンドを定義
command! ClipFilePath    let @* = expand('%:p')   | echo 'clipped: ' . @*
command! ClipFileName    let @* = expand('%:t')   | echo 'clipped: ' . @*
function! s:ClipFileDir()
  let l:dirPathList = split(expand('%:p:h'), '\\')
  call reverse(l:dirPathList)
  let @* = l:dirPathList[0]
  echo 'clipped: ' . @*
endfunction
command! ClipFileDir call s:ClipFileDir()
command! ClipFileDirPath let @* = expand('%:p:h') | echo 'clipped: ' . @*
function! s:ClipCommandOutput(cmd)
  redir @*> | silent execute a:cmd | redir END
  if len(@*) != 0 | let @* = @*[1 :] | endif " 先頭の改行文字を取り除く
endfunction
command! -nargs=1 -complete=command ClipCommandOutput call s:ClipCommandOutput(<f-args>)

"}}}
"-----------------------------------------------------------------------------
" View {{{

if has('gui_running')
  if has('vim_starting')
    let &g:guifont = 'Ricty for Powerline:h12:cSHIFTJIS'
  endif

  setglobal linespace=0          " 行間隔[pixel]の設定(default 1 for Win32 GUI)
  setglobal guioptions=Mc!       " M : メニュー削除 / c : ポップアップを使わない
                                 " ! : :shで:terminalする
  setglobal guicursor=a:blinkon0 " カーソルを点滅させない
  setglobal nomousefocus         " マウス移動でフォーカスを自動的に切り替えない
  setglobal mousehide            " 入力時にマウスポインタを隠す
endif

if has('kaoriya') && has('win32')
  setglobal ambiwidth=auto
endif

setglobal mouse=a               " マウス機能有効
setglobal showcmd               " 入力中のキーを画面右下に表示
setglobal cmdheight=2           " コマンド行は2行がちょうど良い
setglobal showtabline=2         " 常にタブ行を表示する
setglobal laststatus=2          " 常にステータス行を表示する
setglobal wrap                  " 長いテキストを折り返す
setglobal display=lastline      " 長いテキストを省略しない
" setglobal colorcolumn=81        " 81列目に線を表示
setglobal noequalalways         " ウィンドウの自動リサイズをしない
setglobal number relativenumber " 行番号を相対表示
nnoremap <silent> <F10> :<C-u>set relativenumber! relativenumber?<CR>

" 不可視文字の設定
setglobal list listchars=tab:>-,trail:-,eol:\

" 透明度をスイッチ
if has('kaoriya')
  if !exists('s:transparencyOn') | let s:transparencyOn = 0 | endif
  function! s:ToggleTransParency()
    let s:transparencyOn = (s:transparencyOn + 1) % 2
    if  s:transparencyOn | set transparency=220 transparency?
    else                 | set transparency=255 transparency? | endif
  endfunction
  nnoremap <silent> <F12> :<C-u>call <SID>ToggleTransParency()<CR>
endif

setglobal foldcolumn=1      " 折り畳みレベルを表示する列を1列設ける
setglobal foldmethod=marker " foldmarkerを使って折り畳みを作成する
setglobal foldlevelstart=0  " 折り畳みを全て閉じた状態でファイルを開く
setglobal foldnestmax=2     " 折り畳みを自動生成する時の折り畳み深さの最大値
setglobal commentstring=%s  " 基本的にはfoldmarkerに余計なものを付けない
setglobal fillchars=vert:\| " 区切りを埋める文字の設定
nnoremap <silent> <F9> :<C-u>setlocal foldenable! foldenable?<CR>

" filetypeがvimの時はvimのコメント行markerを前置してfoldmarkerを付ける
autocmd MyAutoCmd FileType vim setlocal commentstring=\ \"%s

" filetypeがc/markdownの時は折り畳み機能を自動生成する。ただし, デフォルトは無効
autocmd MyAutoCmd FileType c,cpp,markdown
      \ setlocal foldmethod=syntax foldnestmax=1 nofoldenable

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
setglobal hlsearch   " 検索結果をハイライト

if has('kaoriya') && has('migemo')
  setglobal migemo " backward-migemo検索g?を有効化
  noremap m/ g/
  noremap m? g?
endif

"}}}
"-----------------------------------------------------------------------------
" Simplify operation {{{

setglobal notimeout " キー入力タイムアウトは無くて良い気がする

" :make実行後, 自動でQuickfixウィンドウを開く
autocmd MyAutoCmd QuickfixCmdPost make if len(getqflist()) != 0 | copen | endif

" 最後のウィンドウのbuftypeがquickfixであれば, 自動で閉じる
autocmd MyAutoCmd WinEnter * if winnr('$') == 1 && &buftype == 'quickfix' | quit | endif

" 検索テキストハイライトを消す
nnoremap <silent> <Esc> :<C-u>nohlsearch<CR>

" バッファ選択を簡易化
nnoremap <A-b> :<C-u>ls<CR>:buffer<Space>

" タブ複製を簡易化
nnoremap ,t :<C-u>tab split<CR>

" 新規タブでgf
nnoremap ,gf :<C-u>execute 'tabfind ' . expand('<cfile>')<CR>

" 新規タブでvimdiff
" 引数が1つ     : カレントバッファと引数指定ファイルの比較
" 引数が2つ以上 : 引数指定ファイル同士の比較
" http://koturn.hatenablog.com/entry/2013/08/10/034242
function! s:TabDiff(...) "{{{
  if a:0 == 1
    tabnew %:p
    execute 'rightbelow vertical diffsplit ' . a:1
    return
  endif
  execute 'tabedit ' a:1
  for l:file in a:000[1 :]
    execute 'rightbelow vertical diffsplit ' . l:file
  endfor
endfunction "}}}
command! -nargs=+ -complete=file Diff call s:TabDiff(<f-args>)

"}}}
"-----------------------------------------------------------------------------
" tags, path {{{

" 新規タブでタグジャンプ
nnoremap <silent> <expr> <Leader>] ':<C-u>tab cstag ' . expand('<cword>') . "\<CR>"

" ソースディレクトリの設定はローカル設定ファイルに記述する
" see: ~/localfiles/template/local.rc.vim
if filereadable(expand('~/localfiles/template/local.rc.vim'))

  function! s:SetSrcDir() "{{{
    let g:local_rc_src_dir         = g:local_rc_src_list[g:local_rc_src_index]
    let g:local_rc_current_src_dir = g:local_rc_base_dir . '\' . g:local_rc_src_dir
    let g:local_rc_ctags_dir       = g:local_rc_current_src_dir . '\TAGS'
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
    let $GTAGSROOT = g:local_rc_current_src_dir
    if filereadable($GTAGSROOT . '\GTAGS')
      setglobal cscopeprg=gtags-cscope
      setglobal cscopetag
      setglobal cscoperelative
      setglobal cscopequickfix=s-,c-,d-,i-,t-,e-
      setglobal nocscopeverbose
      setglobal cscopetagorder=1
      execute 'cscope kill -1'
      execute 'cscope add ' . $GTAGSROOT . '\GTAGS'
      setglobal cscopeverbose
    endif
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

  " プロジェクトをスイッチ
  function! s:SwitchProject() "{{{
    let g:local_rc_src_index += 1
    if  g:local_rc_src_index >= len(g:local_rc_src_list)
      let g:local_rc_src_index = 0
    endif
    call s:SetSrcDir()
    call s:SetTags()
    call s:SetPathList()
    call s:SetCDPathList()
    call SetEnvironmentVariables()
    if isdirectory(g:local_rc_current_src_dir)
      execute 'cd ' . g:local_rc_current_src_dir
    endif
    if exists('s:IsFirstLoad') | echo 'switch to: ' . g:local_rc_src_dir | endif
  endfunction "}}}
  nnoremap <silent> ,s :<C-u>call <SID>SwitchProject()<CR>

  " 初回のtags, path設定/ディレクトリ移動
  autocmd MyAutoCmd VimEnter * call s:SwitchProject() | let s:IsFirstLoad = 1

  " ctagsで生成するタグファイルをアップデート
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

" アンドゥ単位を区切りつつ, <C-w>, <C-u>を使う
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

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

"   Alt + カーソルキーでUnitePrevious/UniteNext
if neobundle#is_installed('unite.vim')
  nnoremap <silent> <A-Left>  :UnitePrevious<CR>
  nnoremap <silent> <A-Right> :UniteNext<CR>
endif

"}}}
"-----------------------------------------------------------------------------
" Scripts {{{

" タイムスタンプの挿入
function! s:PutDateTime() "{{{
  execute "normal! i\<C-r>=strftime('%Y/%m/%d(%a) %H:%M')\<CR>"
endfunction "}}}
command! PutDateTime call s:PutDateTime()

" 区切り線&タイムスタンプの挿入
function! s:PutMemoFormat() "{{{
  execute "normal! 80gI=\<Esc>o"
  execute "normal! i\<C-r>=strftime('%Y/%m/%d(%a) %H:%M')\<CR>"
  execute "normal! $l3a{\<Esc>o\<CR>\<Esc>3i}\<Esc>k0"
endfunction "}}}
command! PutMemoFormat call s:PutMemoFormat()

" :messageで表示される履歴を削除
" → 空文字で埋めているだけ。:ClipCommandOutput messageすると202行になる
" http://d.hatena.ne.jp/osyo-manga/20130502/1367499610
command! ClearMessage  for s:n in range(250) | echomsg '' | endfor

" :jumplistを空にする
command! ClearJumpList for s:n in range(250) | mark '     | endfor

" 指定時間毎に発火するCursorMoved / LineChangedを追加
" http://d.hatena.ne.jp/gnarl/20080130/1201624546
let s:throttleTimeSpan = 250
function! s:OnCursorMove() "{{{
  " normalかvisualの時のみ判定
  let     l:mode  = mode(1)
  if      l:mode !=  'n' && l:mode !=  'no' &&
        \ l:mode !=# 'v' && l:mode !=# 'V'  && l:mode != "\<C-v>"
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
    let l:foldName = split(a:line)
    return empty(l:foldName) ? '' : join(l:foldName[1 :], "\<Space>")
  endif
  return ''
endfunction "}}}

" foldlevel('.')はnofoldenableの時に必ず0を返すので, foldlevelを自分で数える
" NOTE: 1行, 1Foldまでとする
" NOTE: 対応ファイルタイプ : vim/markdown
function! s:GetFoldLevel() "{{{
  " foldlevelに大きめの値をセットして[z, ]zを使えるようにする
  if &foldenable == 'nofoldenable' | setlocal foldlevel=10 | endif

  let l:savedView = winsaveview() " Viewを保存
  let l:belloffTmp = &l:belloff   " motionの失敗を前提にするのでbelloffを使う
  let &l:belloff   = 'error'

  let l:foldLevel         = 0
  let l:currentLineNumber = line('.')
  let l:lastLineNumber    = l:currentLineNumber

  if &filetype == 'markdown'
    let l:pattern = '^#'
  else
    let l:pattern = '{{{$' " for match }}}
  endif

  " markdownの場合, (現在の行 - 1)にfoldmarkerが含まれていれば, foldLevel+=1
  if &filetype == 'markdown' && getline((line('.') - 1)) =~# l:pattern
    let l:foldLevel += 1
  endif

  " 現在の行にfoldmarkerが含まれていれば, foldLevel+=1
  let l:foldLevel += getline('.') =~# l:pattern ? 1 : 0

  " [zを使ってカーソルが移動していればfoldLevelをインクリメント
  while 1
    keepjumps normal! [z
    let l:currentLineNumber = line('.')
    if  l:currentLineNumber == l:lastLineNumber | break | endif
    let l:foldLevel += 1
    let l:lastLineNumber = l:currentLineNumber
  endwhile

  " 退避していたbelloff / Viewを戻す
  let &l:belloff = l:belloffTmp
  call winrestview(l:savedView)

  return l:foldLevel
endfunction "}}}
command! EchoFoldLevel echo s:GetFoldLevel()

" カーソル位置の親Fold名を取得
" NOTE: 対応ファイルタイプ : vim/markdown
let s:currentFold = ''
function! s:GetCurrentFold() "{{{
  if &filetype != 'vim' && &filetype != 'markdown' | return '' | endif

  " foldlevel('.')はnofoldenable時にあてにならないので自作関数で求める
  let l:foldLevel = s:GetFoldLevel()
  if  l:foldLevel <= 0 | return '' | endif

  let l:firstCurPos = getcurpos() " カーソル位置を保存
  let l:savedView = winsaveview() " Viewを保存
  let l:belloffTmp = &l:belloff   " motionの失敗を前提にするのでbelloffを使う
  let &l:belloff   = 'error'

  " カーソル位置のfoldListを取得
  let l:foldList = []
  let l:lastLineNumber = line('.')
  let l:searchCounter = l:foldLevel
  while 1 | if l:searchCounter <= 0 | break | endif
    keepjumps normal! [z
    let l:currentLineNumber = line('.')
    if  l:currentLineNumber == l:lastLineNumber
      " カーソルを戻して子FoldをfoldListに追加
      call setpos('.', l:firstCurPos)
      let l:currentLine = ((&filetype == 'markdown') && (getline('.') =~# '^#'))
            \ ? getline((line('.') - 1))
            \ : getline('.')
      let l:foldName = s:GetFoldName(l:currentLine)
      if  l:foldName != '' | call add(l:foldList, l:foldName) | endif
    else
      let l:currentLine = (&filetype == 'markdown')
            \ ? getline((line('.') - 1))
            \ : getline('.')
      " 親FoldをfoldListに追加
      let l:foldName = s:GetFoldName(l:currentLine)
      if  l:foldName != '' | call insert(l:foldList, l:foldName, 0) | endif
    endif
    let l:lastLineNumber = l:currentLineNumber
    let l:searchCounter -= 1
  endwhile

  " 退避していたbelloff / Viewを戻す
  let &l:belloff = l:belloffTmp
  call winrestview(l:savedView)

  " ウィンドウ幅が十分ある場合, foldListを繋いで返す
  if winwidth(0) > 120 | return join(l:foldList, " \u2B81 ") | endif

  " ウィンドウ幅が広くない場合, 直近のFold名を返す
  return get(l:foldList, -1, '')
endfunction "}}}
command! EchoCurrentFold echo s:GetCurrentFold()
autocmd MyAutoCmd User MyLineChanged let s:currentFold = s:GetCurrentFold()
autocmd MyAutoCmd BufEnter *         let s:currentFold = s:GetCurrentFold()

" Cの関数名取得
let s:currentFunc = ''
function! s:GetCurrentFuncC() "{{{
  if &filetype != 'c' | return '' | endif

  let l:savedView = winsaveview() " Viewを保存
  if getline('.')[0] != '{' " [[が必要か判定
    keepjumps normal! []
    let l:endLine = line('.')
    call winrestview(l:savedView)
    keepjumps normal! [[
    " 以下のいずれかなら[[は不要
    " ・関数定義の間(セクション開始 '{' よりも前方にセクション末尾 '}' がある)
    " ・検索対象が居ない
    if line('.') < l:endLine | call winrestview(l:savedView) | return '' | endif
    if line('.') == 1        | call winrestview(l:savedView) | return '' | endif
  endif
  " call search('(', 'b')
  " keepjumps normal! b
  call search(g:cFuncDefPattern, 'b')
  let l:funcName = expand('<cword>') " 関数名を取得
  call winrestview(l:savedView)      " Viewを戻す

  return l:funcName
endfunction " }}}
autocmd MyAutoCmd User MyLineChanged
      \ if &filetype == 'c' | let s:currentFunc = s:GetCurrentFuncC() | endif
autocmd MyAutoCmd BufEnter *  let s:currentFunc = s:GetCurrentFuncC()

function! s:ClipCurrentFunc(funcName) "{{{
  if strlen(a:funcName) == 0 | echo 'function is not found.' | return | endif
  let @* = a:funcName | echo 'clipped: ' . a:funcName
endfunction "}}}
command! ClipCurrentFunc call s:ClipCurrentFunc(s:currentFunc)

function! s:PutCurrentFunc(funcName) "{{{
  if strlen(a:funcName) == 0 | echo 'function is not found.' | return | endif
  execute 'normal! i' . a:funcName
endfunction "}}}
command! PutCurrentFunc call s:PutCurrentFunc(s:currentFunc)

" cd.で現在開いているファイルのディレクトリに移動
cnoreabbrev <expr> cd. 'cd ' . expand('%:p:h')

" vim-ambicmdでは補完できないパターンを補うため, リストを使った補完を併用する
let s:MyCMapEntries = []
function! s:AddMyCMap(originalPattern, alternateName) "{{{
  " let l:separator = stridx(a:alternateName, '!') == -1 ? "\<Space>" : '!'
  " if !exists(':' . split(a:alternateName, l:separator)[0]) | return | endif
  " let g:abbrev = 'cnoreabbrev ' . a:originalPattern . ' ' . a:alternateName
  " execute substitute(g:abbrev, '|', '<bar>', 'g')
  call add(s:MyCMapEntries, ['^' . a:originalPattern . '$', a:alternateName])
endfunction "}}}

" リストに登録されている   : 登録されたコマンド名を返す
" リストに登録されていない : vim-ambicmdで変換を試みる
function! s:MyCMap(cmdLine) "{{{
  for [originalPattern, alternateName] in s:MyCMapEntries
    if a:cmdLine =~# originalPattern
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
call s:AddMyCMap(  'cm', 'ClearMessage')
call s:AddMyCMap(  'pd', 'PutDateTime')
call s:AddMyCMap(  'uc', 'UpdateCtags')
call s:AddMyCMap(  'ug', 'UpdateGtags')
call s:AddMyCMap( 'cfd', 'ClipFileDir')

" リストへの変換候補登録(Plugin's command)
call s:AddMyCMap( 'sc', 'Scratch')
call s:AddMyCMap('scp', 'ScratchPreview')
call s:AddMyCMap( 'gi', 'Gita')
call s:AddMyCMap( 'ga', 'Gita add % -f')
call s:AddMyCMap( 'gc', 'Gita commit')
call s:AddMyCMap( 'gg', 'Gita grep')
call s:AddMyCMap('gac', 'GitaBar add % -f | Gita commit')
call s:AddMyCMap('gbl', 'Gita blame')
call s:AddMyCMap('gbr', 'Gita branch')
call s:AddMyCMap('gca', 'Gita commit --amend')
call s:AddMyCMap('gch', 'Gita chaperone')
call s:AddMyCMap('gco', 'Gita checkout')
call s:AddMyCMap('gdi', 'Gita diff')
call s:AddMyCMap('gdl', 'Gita diff-ls')
call s:AddMyCMap('gfe', 'Gita fetch')
call s:AddMyCMap('glf', 'Gita ls-files')
call s:AddMyCMap('gme', 'Gita merge')
call s:AddMyCMap('gp2', 'Gita patch -2')
call s:AddMyCMap('gp3', 'Gita patch -3')
call s:AddMyCMap('gpl', '!git pull')
call s:AddMyCMap('gps', '!git push')
call s:AddMyCMap('gre', 'Gita reset')
call s:AddMyCMap('gst', 'Gita status')

" 最後のカーソル位置にジャンプ
autocmd MyAutoCmd BufRead * silent! execute 'normal! `"zv'

"}}}
"-----------------------------------------------------------------------------
" Plugin Settings {{{

" VCSの差分をVimのsignで表示(vim-signify) {{{
if neobundle#tap('vim-signify')

  " use git only
  let g:signify_vcs_list = ['git']
  let g:signify_skip_filetype = {'vimfiler' : 1}

  " switch signify_vcs_cmds
  let g:diff_target = 'master'
  if !exists('s:signifyDiffSwitch') | let s:signifyDiffSwitch = 0 | endif
  function! s:SwitchSignifyDiff() "{{{
    let s:signifyDiffSwitch = (s:signifyDiffSwitch + 1) % 2
    if  s:signifyDiffSwitch
      let g:signify_vcs_cmds.git = printf(
            \ 'git diff %s --no-color --no-ext-diff -U0 -- %%f', g:diff_target)
      echo 'Show diff between HEAD and ' . g:diff_target
    else
      let g:signify_vcs_cmds.git =
            \ 'git diff --no-color --no-ext-diff -U0 -- %f'
      echo 'Show diff between HEAD and WORKTREE'
    endif
  endfunction "}}}
  nnoremap <silent> ,d :<C-u>call <SID>SwitchSignifyDiff()<CR>
  nnoremap ,m :let g:diff_target =<Space>''<Left>

  " Hunk text object
  omap ic <Plug>(signify-motion-inner-pending)
  xmap ic <Plug>(signify-motion-inner-visual)
  omap ac <Plug>(signify-motion-outer-pending)
  xmap ac <Plug>(signify-motion-outer-visual)

  function! neobundle#hooks.on_post_source(bundle)
    " 使わないコマンドを削除する
    if exists(':SignifyEnable')       | delcommand SignifyEnable       | endif
    if exists(':SignifyDisable')      | delcommand SignifyDisable      | endif
    if exists(':SignifyDebug')        | delcommand SignifyDebug        | endif
    if exists(':SignifyDebugDiff')    | delcommand SignifyDebugDiff    | endif
    if exists(':SignifyDebugUnknown') | delcommand SignifyDebugUnknown | endif
    if exists(':SignifyFold')         | delcommand SignifyFold         | endif
  endfunction

endif "}}}

" VimからGitを使う(編集, コマンド実行, vim-gita) {{{
if neobundle#tap('vim-gita')

  let g:gita#suppress_warning = 1
  autocmd MyAutoCmd BufWinEnter gita:* setlocal nofoldenable

endif "}}}

" VimからGitを使う(コミットツリー表示, 管理, agit.vim) {{{
if neobundle#tap('agit.vim')

  let g:agit_enable_auto_show_commit = 0
  let g:agit_max_log_lines = 10000

  function! s:AgitSettings()
    nmap <buffer> ch <Plug>(agit-git-cherry-pick)
    nmap <buffer> Rv <Plug>(agit-git-revert)
  endfunction
  autocmd MyAutoCmd FileType agit          call s:AgitSettings()
  autocmd MyAutoCmd FileType agit_diff setlocal nofoldenable

endif "}}}

" Vimでskkする(eskk.vim) {{{
if neobundle#tap('eskk.vim')

  if has('kaoriya')
    setglobal imdisable
  endif

  let g:eskk#directory = '~/.cache/eskk'
  let g:eskk#dictionary = {
        \   'path'     : '~/dotfiles/.skk-jisyo',
        \   'sorted'   : 0,
        \   'encoding' : 'utf-8',
        \ }
  let g:eskk#large_dictionary = {
        \   'path'     : '~/vimfiles/dict/SKK-JISYO.L',
        \   'sorted'   : 1,
        \   'encoding' : 'euc-jp',
        \ }

  " " neocompleteを使わない場合, 以下の設定は不要
  " let g:eskk#show_annotation = 1
  " let g:eskk#tab_select_completion = 1
  " let g:eskk#start_completion_length = 2

  " http://tyru.hatenablog.com/entry/20101214/vim_de_skk
  let g:eskk#egg_like_newline = 1
  let g:eskk#egg_like_newline_completion = 1
  let g:eskk#rom_input_style = 'msime'

  imap <C-j>  <Plug>(eskk:toggle)
  nmap <C-j> i<Plug>(eskk:enable)
  nmap <A-i> I<Plug>(eskk:enable)
  nmap <A-a> A<Plug>(eskk:enable)
  nmap <A-o> O<Plug>(eskk:enable)
  cmap <C-j>  <Plug>(eskk:toggle)

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

endif "}}}

" コマンド名補完(vim-ambicmd) {{{
if neobundle#tap('vim-ambicmd')

  " " 下手にマッピングするよりもambicmdで補完する方が捗る
  " " リスト補完を併用することにした。→s:MyCMap()を参照のこと
  " cnoremap <expr> <Space> ambicmd#expand("\<Space>")

endif "}}}

" My favorite colorscheme(badwolf) {{{
if neobundle#tap('badwolf')

  colorscheme badwolf

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
    if !neobundle#is_sourced('eskk.vim') | return '' | endif
    return winwidth(0) < 30 ? '' : eskk#statusline()
  endfunction

  function! MyGit()
    if !neobundle#is_sourced('vim-gita') | return '' | endif
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

" 対応する括弧をハイライト(vim-parenmatch) "{{{
if neobundle#tap('vim-parenmatch')

endif "}}}

" フォントサイズ変更を簡易化(vim-fontzoom) {{{
if neobundle#tap('vim-fontzoom')

  nnoremap ,f :<C-u>Fontzoom!<CR>
  nmap <A-+> <Plug>(fontzoom-larger)
  nmap <A--> <Plug>(fontzoom-smaller)

  " 残念だが, Vimの既知のバグでWindows環境ではC-Scrollを使えないらしい
  " → https://github.com/vim-jp/issues/issues/73
  nmap <C-ScrollWheelUp>   <Plug>(fontzoom-larger)
  nmap <C-ScrollWheelDown> <Plug>(fontzoom-smaller)

endif "}}}

" フルスクリーンモード(scrnmode.vim) {{{
if has('kaoriya')
  if !exists('s:fullscreenOn') | let s:fullscreenOn = 0 | endif
  function! s:ToggleScreenMode()
    let s:fullscreenOn = (s:fullscreenOn + 1) % 2
    if  s:fullscreenOn | execute 'ScreenMode 6'
    else               | execute 'ScreenMode 0' | endif
  endfunction
  nnoremap <silent> <F11> :<C-u>call <SID>ToggleScreenMode()<CR>
endif "}}}

" asterisk検索をパワーアップ(vim-asterisk) {{{
if neobundle#tap('vim-asterisk')

  " 検索開始時のカーソル位置を保持する
  let g:asterisk#keeppos = 1

  " <cword>を選択レジスタに入れる
  function! s:ClipCword(data) "{{{
    let     l:mode  = mode(1)
    if      l:mode == 'n' || l:mode == 'no'
      let @* = a:data
      return ''
    elseif  l:mode ==# 'v' || l:mode ==# 'V' || l:mode == "\<C-v>"
      return "\<Esc>gvygv"
    endif
    return ''
  endfunction "}}}
  noremap <silent> <expr> <Plug>(_ClipCword) <SID>ClipCword(expand('<cword>'))

  map *                      <Plug>(asterisk-z*)<Plug>(anzu-update-search-status-with-echo)
  map #                      <Plug>(asterisk-z#)<Plug>(anzu-update-search-status-with-echo)
  map g*                     <Plug>(asterisk-gz*)<Plug>(anzu-update-search-status-with-echo)
  map g#                     <Plug>(asterisk-gz#)<Plug>(anzu-update-search-status-with-echo)
  nmap y*  <Plug>(_ClipCword)<Plug>(asterisk-z*)<Plug>(anzu-update-search-status-with-echo)
  nmap y#  <Plug>(_ClipCword)<Plug>(asterisk-z#)<Plug>(anzu-update-search-status-with-echo)
  nmap yg* <Plug>(_ClipCword)<Plug>(asterisk-gz*)<Plug>(anzu-update-search-status-with-echo)
  nmap yg# <Plug>(_ClipCword)<Plug>(asterisk-gz#)<Plug>(anzu-update-search-status-with-echo)

endif "}}}

" 何番目の検索対象か／検索対象の総数を表示(vim-anzu) {{{
if neobundle#tap('vim-anzu')

  " コマンド結果出力画面にecho, 飛び先がfoldされてたら見えるところまで開く
  nmap n <Plug>(anzu-n-with-echo)zv
  nmap N <Plug>(anzu-N-with-echo)zv

endif "}}}

" f検索を便利に(vim-shot-f) {{{
if neobundle#tap('vim-shot-f')

  map f <Plug>(shot-f-f)
  map F <Plug>(shot-f-F)
  map t <Plug>(shot-f-t)
  map T <Plug>(shot-f-T)

endif "}}}

" Vimのマーク機能を使いやすくする(vim-signature) {{{
if neobundle#tap('vim-signature')

  " viminfoからグローバルマークを削除
  let g:SignatureForceRemoveGlobal = 1

  " これだけあれば十分
  " mm       : ToggleMarkAtLine
  " m<Space> : PurgeMarks
  nmap mm m.

  function! neobundle#hooks.on_post_source(bundle)
    " 使わないコマンドを削除する
    if exists(':SignatureToggleSigns')     | delcommand SignatureToggleSigns     | endif
    if exists(':SignatureRefresh')         | delcommand SignatureRefresh         | endif
    if exists(':SignatureListBufferMarks') | delcommand SignatureListBufferMarks | endif
    if exists(':SignatureListGlobalMarks') | delcommand SignatureListGlobalMarks | endif
    if exists(':SignatureListMarkers')     | delcommand SignatureListMarkers     | endif
  endfunction

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

  " <cword>を検索レジスタに入れる
  function! s:SearchCword(data) "{{{
    let     l:mode  = mode(1)
    if      l:mode == 'n' || l:mode == 'no'
      let @/ = '\<' . a:data . '\>'
      return ''
    elseif  l:mode ==# 'v' || l:mode ==# 'V' || l:mode == "\<C-v>"
      echo 'function SearchCword() not supported in visual mode.'
      return ''
    endif
    return ''
  endfunction "}}}
  noremap <silent> <expr> <Plug>(_SearchCword) <SID>SearchCword(expand('<cword>'))

  map <A-s> <Plug>(operator-search)

  if neobundle#is_installed('vim-textobj-function')
    nmap <A-s>* <Plug>(_SearchCword)<Plug>(operator-search)<Plug>(textobj-function-i)<C-r>/<CR>
  endif

endif "}}}

" コメントアウト/コメントアウト解除(caw.vim) {{{
if neobundle#tap('caw.vim')

  map gc    <Plug>(caw:prefix)

  " 旧来のC用(/* comment */)
  " map <A-c> <Plug>(caw:wrap:toggle:operator)

  " C++用(// comment)
  map <A-c> <Plug>(caw:hatpos:toggle:operator)

endif "}}}

" 自由にテキストハイライト(vim-quickhl) {{{
if neobundle#tap('vim-quickhl')

  map <A-h> <Plug>(operator-quickhl-manual-this-motion)

  if neobundle#is_installed('vim-repeat')
    nnoremap <silent> <A-h><A-h> :<C-u>Repeatable silent! execute "normal \<Plug>(quickhl-manual-this)"<CR>
  else
    nmap <A-h><A-h> <Plug>(quickhl-manual-this)
  endif

endif "}}}

" 囲む / 囲まなくする / 別の何かで囲む(vim-surround) {{{
if neobundle#tap('vim-surround')

endif "}}}

" もっと繰り返し可能にする(vim-repeat) {{{
if neobundle#tap('vim-repeat')

  " Quickly make a macro and use it with "."
  " https://github.com/AndrewRadev/Vimfiles/blob/master/startup/mappings.vim
  let s:simple_macro_active = 0
  function! s:SimpleMacro(id, op)
    if a:id !~# "\[a-z]" | echo 'you cannot use : ' . a:id | return | endif
    if a:op !~# "\[0-2]" | echo 'invalid option : ' . a:op | return | endif
    let s:simple_macro_active = (s:simple_macro_active + 1) % 2
    if  s:simple_macro_active
      echo 'call SimpleMacro()'
      call feedkeys('q' . a:id, 'n')
    else
      normal! q
      " remove trailing mapping key and <C-o>
      let l:reg = '@' . a:id

      " やってることは以下
      " let @m = @m[0 : (-1 * (a:op + 1))]
      execute 'let ' . l:reg
        \    . ' = ' . l:reg . '[0 : (-1 * (' . a:op . ' + 1))]'

      " やってることは以下
      " let @m = stridx(@m, "\<C-o>") == (len(@m) - 1) ? @m[0 : -2] : @m
      execute 'let '     . l:reg
        \ . ' = stridx(' . l:reg . ', "\<C-o>") == (len(' . l:reg . ') - 1) ? '
        \                . l:reg . '[0 : -2] : ' . l:reg

      call repeat#set('@' . a:id, 1)
      echo '@' . a:id . ':'
      execute 'echo @' . a:id
    endif
  endfunction
  nnoremap <silent> <A-m> :call <SID>SimpleMacro('m', 2)<CR>

  " Make the given command repeatable using repeat.vim
  " https://github.com/AndrewRadev/Vimfiles/blob/master/startup/commands.vim
  function! s:Repeatable(cmd)
    for i in range(v:count1)
      execute a:cmd
    endfor
    call repeat#set(':Repeatable ' . a:cmd . "\<CR>", 1)
  endfunction
  command! -nargs=+ -count Repeatable call s:Repeatable(<q-args>)

  " 変更リストを辿る
  nnoremap <silent> g; :<C-u>Repeatable silent! execute 'normal! g;zvzz'<CR>
  nnoremap <silent> g, :<C-u>Repeatable silent! execute 'normal! g,zvzz'<CR>

  " ]c, [cをdotrepeat可能にする
  if neobundle#is_installed('vim-signify')
    nnoremap <silent> [c :<C-u>Repeatable silent! execute "normal \<Plug>(signify-prev-hunk)"<CR>
    nnoremap <silent> ]c :<C-u>Repeatable silent! execute "normal \<Plug>(signify-next-hunk)"<CR>
  endif

  " scrollbind無しで全ウィンドウ同時スクロール
  nnoremap <silent> <A-e> :Repeatable
        \ for i in range(winnr('$')) <bar>
        \ execute "normal! \<C-e\><Left><C-h><C-e>" <bar> silent! wincmd w <bar>
        \ endfor<CR>
  nnoremap <silent> <A-y> :Repeatable
        \ for i in range(winnr('$')) <bar>
        \ execute "normal! \<C-y\><Left><C-h><C-e>" <bar> silent! wincmd w <bar>
        \ endfor<CR>

  " Cの関数名にジャンプ
  let g:cFuncUsePattern = '\v\zs<\a+\u+\l+\w+>\ze\('
  let g:cFuncDefPattern = '\v(static\s+)?\a\s+\zs<\a+\u+\l+\w+>\ze\('
  nnoremap <silent> ]f :<C-u>Repeatable call search(g:cFuncUsePattern,  's')<CR>
  nnoremap <silent> [f :<C-u>Repeatable call search(g:cFuncUsePattern, 'bs')<CR>
  nnoremap <silent> ]F :<C-u>Repeatable call search(g:cFuncDefPattern,  's')<CR>
  nnoremap <silent> [F :<C-u>Repeatable call search(g:cFuncDefPattern, 'bs')<CR>

  " ブラケットの前の単語にジャンプ
  let g:bracketPattern = '\v\zs<\w+>\ze(\s)?\('
  nnoremap <silent> ]b :<C-u>Repeatable call search(g:bracketPattern,  's')<CR>
  nnoremap <silent> [b :<C-u>Repeatable call search(g:bracketPattern, 'bs')<CR>

endif "}}}

" 指定した行をVimDiff(linediff.vim) {{{
if neobundle#tap('linediff.vim')

endif "}}}

" Vimにスタート画面を用意(vim-startify) {{{
if neobundle#tap('vim-startify')

  let g:startify_files_number = 3
  let g:startify_change_to_dir = 1
  let g:startify_session_dir = '~/vimfiles/session'
  let g:startify_session_delete_buffers = 1
  let g:startify_enable_unsafe = 1

  " ブックマークの設定はローカル設定ファイルに記述する
  " see: ~/localfiles/template/local.rc.vim
  " let g:startify_bookmarks = ['.', '~\.vimrc']

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
  let g:u_opt_de = 'Unite '       . g:u_hopt            . g:u_imme
  let g:u_opt_dr = 'Unite '       . g:u_hopt
  let g:u_opt_fb = 'UniteResume ' . g:u_hopt                       . g:u_fbuf
  let g:u_opt_fg = 'Unite '       . g:u_hopt
  let g:u_opt_fr = 'Unite '       . g:u_hopt                       . g:u_fbuf
  let g:u_opt_gr = 'Unite '       . g:u_hopt                       . g:u_sbuf
  let g:u_opt_gp = 'Unite '       . g:u_hopt
  let g:u_opt_li = 'Unite '       . g:u_nspl                       . g:u_sbuf
  let g:u_opt_mf = 'Unite '       . g:u_hopt
  let g:u_opt_mg = 'Unite '       . g:u_hopt                       . g:u_sbuf
  let g:u_opt_mp = 'Unite '       . g:u_nspl
  let g:u_opt_nl = 'Unite '       . g:u_nspl
  let g:u_opt_nu = 'Unite '       . g:u_nspl . g:u_nins . g:u_nsyn
  let g:u_opt_ol = 'Unite '       . g:u_vopt
  let g:u_opt_op = 'Unite '       . g:u_nspl
  let g:u_opt_re = 'Unite '       . g:u_hopt            . g:u_nqui . g:u_sbuf
  let g:u_opt_sb = 'UniteResume ' . g:u_hopt                       . g:u_sbuf

  nnoremap <expr> <Leader>bu ':<C-u>' . g:u_opt_bu . 'buffer'           . '<CR>'
  nnoremap <expr> <Leader>de ':<C-u>' . g:u_opt_de . 'gtags/def:'
  nnoremap <expr> <Leader>dr ':<C-u>' . g:u_opt_dr . 'directory_rec'
  nnoremap <expr> <Leader>fb ':<C-u>' . g:u_opt_fb                      . '<CR>'
  nnoremap <expr> <Leader>fg ':<C-u>' . g:u_opt_fg . 'file_rec/git'     . '<CR>'
  nnoremap <expr> <Leader>fr ':<C-u>' . g:u_opt_fr . 'file_rec'
  nnoremap <expr> <Leader>g% ':<C-u>' . g:u_opt_gr . 'grep:%'           . '<CR>'
  nnoremap <expr> <Leader>g. ':<C-u>' . g:u_opt_gr . 'grep:.*'          . '<CR>'
  nnoremap <expr> <Leader>gg ':<C-u>' . g:u_opt_gr . 'grep/git:/'       . '<CR>'
  nnoremap <expr> <Leader>gp ':<C-u>' . g:u_opt_gp . 'gtags/path'       . '<CR>'
  nnoremap <expr> <Leader>gr ':<C-u>' . g:u_opt_gr . 'grep:**'
  nnoremap <expr> <Leader>li ':<C-u>' . g:u_opt_li . 'line:'
  nnoremap <expr> <Leader>mf ':<C-u>' . g:u_opt_mf . 'file:~/memo'      . '<CR>'
  nnoremap <expr> <Leader>mg ':<C-u>' . g:u_opt_mg . 'vimgrep:~/memo/*' . '<CR>'
  nnoremap <expr> <Leader>mp ':<C-u>' . g:u_opt_mp . 'mapping'          . '<CR>'
  nnoremap <expr> <Leader>nl ':<C-u>' . g:u_opt_nl . 'neobundle/lazy'   . '<CR>'
  nnoremap <expr> <Leader>nu ':<C-u>' . g:u_opt_nu . 'neobundle/update'
  nnoremap <expr> <Leader>ol ':<C-u>' . g:u_opt_ol . 'outline:!'        . '<CR>'
  nnoremap <expr> <Leader>op ':<C-u>' . g:u_opt_op . 'output'           . '<CR>'
  nnoremap <expr> <Leader>re ':<C-u>' . g:u_opt_re . 'gtags/ref:'
  nnoremap <expr> <Leader>sb ':<C-u>' . g:u_opt_sb                      . '<CR>'
  nnoremap <expr> <Leader>v% ':<C-u>' . g:u_opt_gr . 'vimgrep:%'        . '<CR>'
  nnoremap <expr> <Leader>v* ':<C-u>' . g:u_opt_gr . 'vimgrep:*'        . '<CR>'
  nnoremap <expr> <Leader>v. ':<C-u>' . g:u_opt_gr . 'vimgrep:.*'       . '<CR>'
  nnoremap <expr> <Leader>vg ':<C-u>' . g:u_opt_gr . 'vimgrep:**'

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

    " Unite line/directory_rec/file_rec/grep/vimgrepの結果候補数を制限しない
    call unite#custom#source('line',          'max_candidates', 0)
    call unite#custom#source('directory_rec', 'max_candidates', 0)
    call unite#custom#source('file_rec',      'max_candidates', 0)
    call unite#custom#source('grep',          'max_candidates', 0)
    call unite#custom#source('vimgrep',       'max_candidates', 0)

    " ディレクトリが選択されたらvimfilerで開く
    call unite#custom_default_action('source/bookmark/directory', 'vimfiler')
    call unite#custom_default_action('directory_mru',             'vimfiler')
  endfunction

endif "}}}

" for unite-gtags {{{
if neobundle#tap('unite-gtags')

endif "}}}

" for unite-outline {{{
if neobundle#tap('unite-outline')

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

  nnoremap ,, :<C-u>VimFilerTab<CR>

  " vimfilerのマッピングを一部変更
  function! s:VimfilerSettings()
    " <Leader>がデフォルトマッピングで使用されていた場合の対策
    nmap <buffer> <LocalLeader> <Leader>

    " uniteを使うのでgrepは潰しておく
    nnoremap <buffer> gr <Nop>
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
  nnoremap <A-k>  <Nop>
  inoremap <A-k>  <Nop>
  nmap <A-k><A-k> <Plug>(dicwin-cword)
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

  nmap <A-l><A-l> <Plug>(openbrowser-smart-search)
  vmap <A-l><A-l> <Plug>(openbrowser-smart-search)

endif "}}}

" 文末の空白削除を簡易化(vim-trailing-whitespace) {{{
if neobundle#tap('vim-trailing-whitespace')

endif "}}}

" バッファをHTML形式に変換(2html.vim) {{{

let g:tohtml_font_family = "'MS Gothic'"
let g:tohtml_font_size = "10pt"

" 選択範囲をHTML変換してヤンクする
command! -range=% -bar ClipHTML
      \ :<line1>,<line2>TOhtml | execute "normal! ggyG" | silent execute "bd!"
      \ | let @* = substitute(@*, 'font-family: \zs\w*\ze;', g:tohtml_font_family, 'g')
      \ | let @* = substitute(@*, 'font-size: \zs\w*\ze;', g:tohtml_font_size, 'g')
cnoreabbrev ch ClipHTML

"}}}

" Vim上でGDBを動かす(termdebug) {{{

packadd termdebug

autocmd MyAutoCmd WinEnter *
      \ if &buftype == 'prompt' | call s:TermDebugSettings() | endif

function! s:TermDebugSettings()
  imap <buffer> <A-s> <Esc>:Step<CR>
  imap <buffer> <A-n> <Esc>:Over<CR>
  imap <buffer> <A-f> <Esc>:Finish<CR>
  imap <buffer> <A-c> <Esc>:Continue<CR>
endfunction

"}}}

"}}}
"-----------------------------------------------------------------------------

