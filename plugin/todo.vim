if !exists('g:todo_done_folded')
  let g:todo_done_folded = 1
endif

if !exists('g:todo_sync_git')
  let g:todo_sync_git = 0
endif

if g:todo_sync_git
  augroup todo_vim
    autocmd!
    au BufReadPost *.todo TodoCheckUpstream
    au BufWritePost *.todo TodoCommitPush
  augroup END
endif
