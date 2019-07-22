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

command! -nargs=0 TodoCheckUpstream call todo#CheckUpstream(expand('%:h'))
command! -nargs=0 TodoPull call todo#Pull(expand('%:h'))
command! -nargs=0 TodoCommitPush call todo#CommitPush(expand('%:h'))

let b:delimitMate_expand_space = 0
