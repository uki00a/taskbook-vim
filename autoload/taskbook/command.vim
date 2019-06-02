let s:save_cpo = &cpo
set cpo&vim

function! taskbook#command#create_task(args) abort
  call taskbook#utils#system('tb -t ' . s:prepare_description(a:args))
endfunction

function! taskbook#command#create_note(args) abort
  call taskbook#utils#system('tb -n ' . s:prepare_description(a:args))
endfunction

function! taskbook#command#begin(ids) abort
  call taskbook#utils#system('tb -b ' . s:prepare_ids(a:ids))
endfunction

function! taskbook#command#star(ids) abort
  call taskbook#utils#system('tb -s ' . s:prepare_ids(a:ids))
endfunction

function! taskbook#command#check(ids) abort
  call taskbook#utils#system('tb -c ' . s:prepare_ids(a:ids))
endfunction

function! taskbook#command#delete(ids) abort
  call taskbook#utils#system('tb -d ' . s:prepare_ids(a:ids))
endfunction

function! taskbook#command#restore(ids) abort
  call taskbook#utils#system('tb -r ' . s:prepare_ids(a:ids))
endfunction

function! taskbook#command#copy(ids) abort
  call taskbook#utils#system('tb -y ' . s:prepare_ids(a:ids))
endfunction

function! taskbook#command#move(args) abort
  if empty(a:args)
    let id = '@' . taskbook#utils#input('id: ')
    let boards = taskbook#utils#input('destination boards: ')
    let args = s:build_cmd_args([id, boards])
  else
    let args = s:build_cmd_args(a:args)
  endif
  call taskbook#utils#system('tb -m ' . args)
endfunction

function! taskbook#command#edit(args) abort
  if empty(a:args)
    let id = '@' . taskbook#utils#input('id: ')
    let boards = taskbook#utils#input('description: ')
    let args = s:build_cmd_args([id, boards])
  else
    let args = s:build_cmd_args(a:args)
  endif
  call taskbook#utils#system('tb -e ' . args)
endfunction

function! taskbook#command#clear() abort
  call taskbook#utils#system('tb --clear')
endfunction

function! taskbook#command#set_normal_priority(...) abort
  call s:set_priority(1, a:000)
endfunction

function! taskbook#command#set_medium_priority(...) abort
  call s:set_priority(2, a:000)
endfunction

function! taskbook#command#set_high_priority(...) abort
  call s:set_priority(3, a:000)
endfunction

function! s:set_priority(priority, args) abort
  if empty(a:args)
    let id = taskbook#utils#input('id: ')
  else
    let id = a:args[0]
  endif
  let args = s:build_cmd_args(['@' . id, a:priority])
  call taskbook#utils#system('tb -p ' . args)
endfunction

function! s:prepare_ids(ids) abort
  return s:prepare_cmd_args(a:ids, 'ids: ')
endfunction

function! s:prepare_description(args) abort
  return s:prepare_cmd_args(a:args, 'description: ')
endfunction

function! s:prepare_cmd_args(args, prompt) abort
  let args = s:ensure_cmd_args(a:args, a:prompt)
  return s:build_cmd_args(args)
endfunction

function! s:ensure_cmd_args(args, prompt) abort
  if empty(a:args)
    return split(taskbook#utils#input(a:prompt))
  else
    return a:args
  endif
endfunction

function! s:build_cmd_args(args) abort
  return join(s:escape_cmd_args(a:args))
endfunction

function! s:escape_cmd_args(args) abort
  return map(a:args, 'shellescape(v:val)')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
