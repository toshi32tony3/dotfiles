source $VIMRUNTIME/delmenu.vim

" 日本語入力に関する設定
if has('multi_byte_ime') || has('xim')
  " IME ON時のカーソルの色を設定(設定例:紫)
  highlight CursorIM guibg=Purple guifg=NONE
  if has('xim') && has('GUI_GTK')
    set imactivatekey=s-space
  endif
endif

" disable load default settings.
let g:gvimrc_local_finish = 1
