# vim-tagquery

A vim plugin that enables improved querying of tags.

Currently, this depends on [fzf.vim](https://github.com/junegunn/fzf.vim), but there are plans for a command that does not require it.

## Usage

This finds all locations with the tags `foo` and `bar`, but not `bazz`. It will put the results in a filterable `fzf` buffer with a preview of the file:

```
:FzfTagQuery foo & bar & !bazz
```

An example binding:

```viml
noremap <C-t> :FzfTagQuery
```

## Installation

Using [`vim-plug`](https://github.com/junegunn/vim-plug):

```vim
Plug 'matt-snider/vim-tagquery', { 'do': 'bash install.sh' }
```

## Configuration

Path to the vimwiki ctags file:

`let g:tagquery_ctags_file = '~/vimwiki/.vimwiki_tags'`
