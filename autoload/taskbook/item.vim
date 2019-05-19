let s:save_cpo = &cpo
set cpo&vim

function! taskbook#item#id(item) abort
  return a:item._id
endfunction

function! taskbook#item#boards(item) abort
  return a:item.boards
endfunction

function! taskbook#item#belongs_to_board(item, board) abort
  return index(a:item.boards, a:board) > -1
endfunction

function! taskbook#item#to_string(item) abort
  let s = a:item.description

  if taskbook#item#is_note(a:item)
    let s = " ●  " . s
  endif

  if has_key(a:item, 'priority') && a:item.priority > 1
    let s .= (" (" . repeat("!", a:item.priority - 1) . ")")
  endif

  if a:item.isStarred
    let s .= " ★"
  endif

  if get(a:item, 'inProgress', 0)
    let s .= " ⛏"
  endif

  return s
endfunction

function! taskbook#item#is_complete(item) abort
  return a:item.isComplete
endfunction

function! taskbook#item#toggle_complete(item) abort
  let a:item.isComplete = !a:item.isComplete
endfunction

function! taskbook#item#toggle_star(item) abort
  let a:item.isStarred = !a:item.isStarred
endfunction

function! taskbook#item#toggle_progress(item) abort
  if taskbook#item#is_task(a:item)
    let a:item.inProgress = !a:item.inProgress
  endif
endfunction

function! taskbook#item#change_description(item, description) abort
  let a:item.description = a:description
endfunction

function! taskbook#item#set_normal_priority(item) abort
  let a:item.priority = 1
endfunction

function! taskbook#item#set_medium_priority(item) abort
  let a:item.priority = 2
endfunction

function! taskbook#item#set_high_priority(item) abort
  let a:item.priority = 3
endfunction

function! taskbook#item#is_task(item) abort
  return a:item._isTask
endfunction

function! taskbook#item#is_note(item) abort
  return !taskbook#item#is_task(a:item)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
