" ============================================================================
" vim-tagquery - A vim plugin that enables improved querying of tags
"
" Maintainer:  Matt Snider <https://github.com/matt-snider>
" ============================================================================

" TODO: this needs to be properly found in install dir 
let s:executable = 'ctags-query'


function! s:fzf_sink(result) 
    let parts = split(a:result)
    let filepath = parts[0]
    let location = '+' . parts[1]
    execute 'silent' 'edit' location filepath
endfunction


function! s:fzf_query(query) 
    let ctags = getcwd() . '/.tags'
    let cmd = s:executable . ' -f ' .  ctags . " '" . a:query . "'"
    echom cmd
    call fzf#run({'source': cmd,
                \ 'sink': function('s:fzf_sink'), 
                \ 'down': 10,
                \ })
endfunction


command! -narg=* FzfTagQuery 
            \ call <sid>fzf_query(<args>)

