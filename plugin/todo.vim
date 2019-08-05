if !exists('g:todo_done_folded')
  let g:todo_done_folded = 1
endif

augroup todo_vim
  autocmd!
  au BufReadPost *.todo
        \ if todo#HasAutoGitSync() | execute 'TodoCheckUpstream' | endif
  au BufWritePost *.todo 
        \ if todo#HasAutoGitSync() | execute 'TodoCommitPush' | endif
augroup END
