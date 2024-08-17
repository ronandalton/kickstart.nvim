" Custom indent style for text files.
" Lines which end with a colon cause the following line to be indented.

if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal indentexpr=GetTextIndent(v:lnum)
setlocal indentkeys=!^F,o,O
setlocal nosmartindent

let b:undo_indent = "setlocal indentexpr< indentkeys< smartindent<"

if exists("*GetTextIndent")
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

function GetTextIndent(lnum)
    if !prevnonblank(a:lnum-1)
        return 0
    endif

    let prevlnum = prevnonblank(a:lnum-1)

    if getline(prevlnum) =~# '^.*:\s*$'
        return indent(prevlnum)+shiftwidth()
    endif

    return indent(prevlnum)
endfunction

let &cpo = s:save_cpo
