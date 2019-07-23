let s:todo_pattern = '\v^\[[ X]\]!{,3} '
let s:pending_todo_pattern = '\v^\[ \](!{,3}) (.*)'

let s:active_job = 0
let s:timer = 0


function! todo#FoldText() abort
  return getline(v:foldstart)
endfunction


function! todo#FoldExpr(lnum) abort
  let curline = getline(a:lnum)
  if curline =~# '\v(#|(\[ \]!{,3})) '
    return '0'
  endif

  if curline =~# '\v\[X\]!{,3} '
    return '>1'
  endif

  return '='
endfunction


function! todo#PrevTodo() abort
  let todo_lnum = search(s:todo_pattern, 'bnW')

  if todo_lnum == 0
    echo 'No more previous todo'
    return
  endif

  call setpos('.', [0, todo_lnum, 1, 0])
endfunction


function! todo#NextTodo() abort
  let todo_lnum = search(s:todo_pattern, 'nW')

  if todo_lnum == 0
    echo 'No more next todo'
    return
  endif

  call setpos('.', [0, todo_lnum, 1, 0])
endfunction


function! todo#List() abort
  let todo_list = []
  let imp1_list = []
  let imp2_list = []
  let imp3_list = []

  let saved_pos = getcurpos()[:3]

  call cursor(1, 1)

  while 1
    let todo_lnum = search(s:pending_todo_pattern, 'ceWz')
    if todo_lnum == 0
      break
    endif

    let [_, imp, text; _] = matchlist(getline(todo_lnum),
          \ s:pending_todo_pattern)
    if imp ==# '!'
      call add(imp1_list, [todo_lnum, '! ' . text])
    elseif imp ==# '!!'
      call add(imp2_list, [todo_lnum, '!! ' . text])
    elseif imp ==# '!!!'
      call add(imp3_list, [todo_lnum, '!!! ' . text])
    else
      call add(todo_list, [todo_lnum, text])
    endif
  endwhile

  call setpos('.', saved_pos)

  let result = []
  let file = expand('%')

  for item in imp3_list + imp2_list + imp1_list + todo_list
    let [lnum, text] = item
    call add(result, printf('%s:%s:%s', file, lnum, text))
  endfor

  if len(result) == 0
    return
  endif

  lexpr result

  if len(result) > 10
    let loc_height = 10
  else
    let loc_height = len(result)
  endif

  execute 'lopen ' . loc_height
endfunction


function! todo#IsTodo() abort
  let [_, line; _] = getcurpos()
  let text = getline(line)
  return text =~# s:todo_pattern
endfunction


function! todo#Toggle() abort
  let [_, line; _] = getcurpos()
  let text = getline(line)


  if text =~# '\v^\[ \]'
    let newtext = substitute(text, '\V[ ]', '[X]', '')
    call setline(line, newtext)
    normal! zX
  elseif text =~# '\v^\[X\]'
    normal! zo
    let newtext = substitute(text, '\V[X]', '[ ]', '')
    call setline(line, newtext)
  endif
endfunction


function! todo#CheckUpstream(dir) abort
  if has('nvim')
    if s:active_job != 0
      return
    endif

    let cmd = 'cd ' . a:dir . ' && git fetch && git status -s -b master'

    let s:active_job = jobstart(cmd, {
          \ 'on_stdout': function('s:OnCheckUpstreamData'),
          \ 'on_exit': function('s:OnCheckUpstreamExit'),
          \ 'stdout_buffered': 1,
          \ 'action': '',
          \ 'dir': a:dir,
          \ })

    let s:timer = timer_start(30000, function('s:KillJob'))
  endif
endfunction


function! todo#Pull(dir) abort
  if has('nvim')
    if s:active_job != 0
      return
    endif

    let s:active_job = jobstart('cd ' . a:dir . ' && git pull --ff-only',
          \ {'on_exit': function('s:OnPullExit')})

    let s:timer = timer_start(30000, function('s:KillJob'))
  endif
endfunction


function! todo#CommitPush(dir) abort
  if has('nvim')
    if s:active_job != 0
      return
    endif

    let commit_msg = 'Committed by todo.vim at ' . strftime('%c')
    let cmd = 'cd ' . a:dir .
          \ ' && git add . && git commit -m "' . commit_msg . '" && git push'

    let s:active_job = jobstart(cmd,
          \ {'on_exit': function('s:OnCommitPushExit')})

    let s:timer = timer_start(10000, function('s:KillJob'))
  endif
endfunction


function! s:OnCheckUpstreamData(...) dict abort
  let data = a:2
  if match(data[0], 'behind') != -1
    " The upstream branch is ahead of the local branch.
    let self.action = 'pull'
  endif
endfunction


function! s:OnCheckUpstreamExit(...) dict abort
  let exit_code = a:2
  let s:active_job = 0

  if s:timer != 0
    call timer_stop(s:timer)
    let s:timer = 0
  endif

  if exit_code != 0
    return
  endif

  if self.action ==# 'pull'
    call todo#Pull(self.dir)
  endif
endfunction


function! s:OnPullExit(...) dict abort
  let exit_code = a:2
  let s:active_job = 0

  if s:timer != 0
    call timer_stop(s:timer)
    let s:timer = 0
  endif

  if exit_code != 0
    return
  endif

  echomsg 'todo.vim: pulled from upstream, reload file with :e'
endfunction


function! s:OnCommitPushExit(...) dict abort
  let exit_code = a:2
  let s:active_job = 0

  if s:timer != 0
    call timer_stop(s:timer)
    let s:timer = 0
  endif

  if exit_code != 0
    return
  endif

  echomsg 'todo.vim: pushed to upstream'
endfunction


function! s:KillJob(...) abort
  let s:timer = 0
  if s:active_job != 0
    call jobstop(s:active_job)
    let s:active_job = 0
  endif
endfunction
