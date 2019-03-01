" ============================================================================
" vim-tagquery - A vim plugin that enables improved querying of tags
"
" Maintainer:  Matt Snider <https://github.com/matt-snider>
" ============================================================================
let s:root = expand('<sfile>:p:h:h')
let s:ctags_binary = 'ctags-query'
let s:local_ctags_file = getcwd() . '/.tags'


" Returns the path to the `ctags-query` binary
function! tagquery#binary_path() abort
    return s:root . '/bin/ctags-query'
endfunction


" Executes the query on the given file and returns
" a list of lines output by `ctags-query`.
function! tagquery#execute_cli(query, ctags_path) abort
    let cmd = tagquery#binary_path() . ' '
                \ . '-f' . a:ctags_path . ' '
                \ . shellescape(a:query)
    let result = system(cmd)
    return split(result, '\n')
endfunction


" Filter results with FZF given specific options
function! tagquery#fzf(query)
    let source = tagquery#execute_cli(a:query, s:local_ctags_file)
    call map(source, { _, val -> substitute(val, '\t', ':', 'g') })

    call fzf#run(fzf#vim#with_preview({
                \ 'source': source,
                \ 'options': '--delimiter : --with-nth="3.."',
                \ 'sink': function('s:fzf_sink'),
                \ 'down': 10, }),
                \ 'right:50%')
endfunction


" Handles opening a selected result
function! s:fzf_sink(result)
    let parts = split(a:result, ':')
    let filepath = parts[0]
    let location = '+' . parts[1]
    execute 'silent' 'edit' location filepath
endfunction
