" Custom indent style for C/C++ files.
" Fixes some oddities with the default indent rules.

let b:did_indent = 1

setlocal cinoptions+=t0,j1

let s:undo_indent = "setlocal cinoptions<"

let b:undo_indent = (exists("b:undo_indent") ? b:undo_indent .. " | " : "") .. s:undo_indent
