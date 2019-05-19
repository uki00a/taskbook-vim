let s:save_cpo = &cpo
set cpo&vim

let s:source = {
  \ 'name': 'taskbook',
  \ 'description': 'candidates from taskbook',
  \ 'default_action': 'check',
  \ 'action_table': {
  \   'check': {
  \    'description': 'check an item',
  \    'is_selectable': 0,
  \    'is_invalidate_cache': 1,
  \    'is_quit': 0
  \  },
  \  'delete': {
  \     'description': 'delete an item',
  \     'is_selectable': 0,
  \     'is_invalidate_cache': 1,
  \     'is_quit': 0
  \  }
  \ }
  \ }

function! unite#sources#taskbook#define() abort
  return s:source
endfunction

function! s:source.gather_candidates(args, context) abort
  let items = taskbook#items#load_from_storage()
  return s:make_candidates(values(items))
endfunction

function! s:source.action_table.delete.func(candidate) abort
  call taskbook#command#delete([a:candidate.action__id])
endfunction

function! s:source.action_table.check.func(candidate) abort
  call taskbook#command#check([a:candidate.action__id])
endfunction

function! s:make_candidates(items) abort
  return map(a:items,
    \ "{
    \   'word': s:item_to_word(v:val),
    \   'action__id': taskbook#item#id(v:val)
    \ }")
endfunction

function! s:item_to_word(item) abort
  return (taskbook#item#is_complete(a:item) ? '[x]' : '[ ]')
    \ .taskbook#item#to_string(a:item)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
