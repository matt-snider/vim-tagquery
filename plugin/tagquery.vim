" ============================================================================
" vim-tagquery - A vim plugin that enables improved querying of tags
"
" Maintainer:  Matt Snider <https://github.com/matt-snider>
" ============================================================================

if exists('g:loaded_tagquery')
    finish
endif
let g:loaded_tagquery = 1

" Filter through tag query results in Ffz
command! -narg=1 -complete=tag FzfTagQuery call tagquery#fzf(<q-args>)

