# todo.vim

An **intuitive** TODO List written in **pure VimL**

![demo](https://i.ibb.co/7SWD04N/todo-vim-demo.gif) 

> Demo recorded in Neovim using **onedark.vim**

## Installation

Add **todo.vim** to your vimrc:

```
Plug 'ianding1/todo.vim'
```

## Key mappings

**todo.vim** doesn't bind any key mappings by default.

```vim
" Jump to the next TODO item (skipping DONE items).
nmap <silent> <leader>tn <Plug>(todo-next)
" Jump to the previous TODO item (skipping DONE items).
nmap <silent> <leader>tp <Plug>(todo-prev)
" List all TODO items in the location list. See `:h location-list`.
nmap <silent> <leader>tl <Plug>(todo-list)
" Use TAB to toggle the item between TODO and DONE.
nmap <silent> <expr> <tab> todo#IsTodo() ? "\<Plug>(todo-toggle)" : "\<tab>"
```

**Note: Don't use `nnoremap` to map these keys. Use double quotes instead of single quotes. And don't forget the backslashes.**

## Notes

1. **todo.vim** uses folding to collapse DONE items. The most basic commands are `zo` to open a fold and `zc` to close a fold. See `:h folding` for details. If you want to disable this feature, add `let g:todo_done_folded = 0` to your vimrc.
2. **todo.vim** uses location list to list all the TODO items in the buffer, which are sorted by the priority (the number of `!` after `[ ]`, at most 3).

## Customizations

```vim
" Set to 0 to disable folding DONE items (enabled by default).
let g:todo_done_folded = 1
```
