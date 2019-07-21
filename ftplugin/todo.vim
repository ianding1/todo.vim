if !exists('g:todo_fold_closed')
  let g:todo_fold_closed = 0
endif

setlocal foldexpr=todo#FoldExpr()
setlocal foldmethod=expr

if g:todo_fold_closed
  setlocal foldlevel=1
endif

setlocal errorformat=%f:%n:%r

noremap <silent> <Plug>(todo-next) :call todo#NextTodo()<cr>
noremap <silent> <Plug>(todo-prev) :call todo#PrevTodo()<cr>
noremap <silent> <Plug>(todo-list) :call todo#List()<cr>
