let s:todo_pattern = '\v^\[[ X]\]!{,3} '
let s:header_pattern = '\v^# '
let s:pending_todo_pattern = '\v^\[ \](!{,3}) (.*)'
let s:toplevel_pattern = '\v^(#|(\[[ X]\]!{,3}) )'


function! todo#FoldExpr() abort
  let curline = getline(v:lnum)
  if match(curline, s:toplevel_pattern) == 0
    return '0'
  endif

  let saved_pos = getcurpos()[:3]
  call cursor(v:lnum, 1)

  let todo_lnum = search(s:todo_pattern, 'bnW')
  let header_lnum = search(s:header_pattern, 'bnW')
  call setpos('.', saved_pos)

  if todo_lnum != 0 && (header_lnum == 0 || header_lnum < todo_lnum)
    return '1'
  endif

  return '0'
endfunction


function! todo#FoldText() abort
  let startline = getline(v:foldstart)
  if strchars(startline) > 70
    return startline . ' ...'
  endif

  return startline
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
      call add(imp1_list, [todo_lnum, '!' . text])
    elseif imp ==# '!!'
      call add(imp2_list, [todo_lnum, '!!' . text])
    elseif imp ==# '!!!'
      call add(imp3_list, [todo_lnum, '!!!' . text])
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
