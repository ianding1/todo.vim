syn match todoTodo "\v^\[ \] .*"
syn match todoImp1 "\v^\[ \]! .*"
syn match todoImp2 "\v^\[ \]!! .*"
syn match todoImp3 "\v^\[ \]!!! .*"
syn match todoDone "\v^\[X\]!{,3} .*"
syn match todoHeader "\v^# .*"

hi default todoTodo ctermfg=39 guifg=#61AfEF
hi default todoImp1 ctermfg=180 guifg=#E5C07B
hi default todoImp2 ctermfg=170 guifg=#C678DD
hi default todoImp3 cterm=bold ctermfg=204 gui=bold guifg=#E06C75
hi default todoDone ctermfg=59 guifg=#5C6370
hi default todoHeader ctermfg=204 guifg=#E06C75
hi! Folded cterm=NONE ctermfg=59 ctermbg=NONE gui=NONE guifg=#5C6370 guibg=NONE
