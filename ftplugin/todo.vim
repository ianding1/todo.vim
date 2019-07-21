if !exists('g:todo_done_folded')
  let g:todo_done_folded = 1
endif

setlocal autoindent
setlocal nocindent
setlocal nosmartindent

setlocal shiftwidth=2
setlocal softtabstop=2

setlocal foldtext=todo#FoldText()
setlocal foldexpr=todo#FoldExpr(v:lnum)
setlocal foldmethod=expr

if g:todo_done_folded
  setlocal foldlevel=0
else
  setlocal foldlevel=1
endif

setlocal errorformat=%f:%n:%r

noremap <silent> <Plug>(todo-next) :call todo#NextTodo()<cr>
noremap <silent> <Plug>(todo-prev) :call todo#PrevTodo()<cr>
noremap <silent> <Plug>(todo-list) :call todo#List()<cr>
noremap <silent> <Plug>(todo-toggle) :call todo#Toggle()<cr>

let b:delimitMate_expand_space = 0
