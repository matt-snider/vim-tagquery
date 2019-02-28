" ============================================================================
" vim-tagquery - A vim plugin that enables improved querying of tags
"
" Maintainer:  Matt Snider <https://github.com/matt-snider>
" ============================================================================

if exists('g:loaded_tagquery')
    finish
endif
let g:loaded_tagquery = 1


" The location of the `ctags-query` executable.
" TODO: this needs to be properly found in install dir
let s:executable = 'ctags-query'


" Executes the tagquery in a filterable fzf buffer.
function! s:fzf_query(query)
    let ctags = getcwd() . '/.tags'
    let cmd = s:executable . ' -f ' .  ctags . " '" . a:query . "'"
    call fzf#run({'source': cmd,
                \ 'sink': function('s:fzf_sink'),
                \ 'down': 10,
                \ })
endfunction


" Handles opening a selected result
function! s:fzf_sink(result)
    let parts = split(a:result)
    let filepath = parts[0]
    let location = '+' . parts[1]
    execute 'silent' 'edit' location filepath
endfunction


" Filter through tag query results in Ffz
command! -narg=1 -complete=tag FzfTagQuery
            \ call <sid>fzf_query(<q-args>)

