" Custom ftplugin settings for C/C++ files.
" Fixes the default commentstring.

let b:did_ftplugin = 1

setlocal commentstring=//\ %s

let s:undo_ftplugin = "setlocal commentstring<"

let b:undo_ftplugin = (exists("b:undo_ftplugin") ? b:undo_ftplugin .. " | " : "") .. s:undo_ftplugin
