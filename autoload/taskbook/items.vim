let s:save_cpo = &cpo
set cpo&vim

let s:config_directory = expand('~/.taskbook.json')

function! taskbook#items#load_from_storage() abort
  let taskbook_directory = s:determine_taskbook_directory()
  let path_to_storage = s:join_paths(taskbook_directory, 'storage/storage.json')
  let items = taskbook#utils#read_json(path_to_storage)
  return items
endfunction

function! s:determine_taskbook_directory() abort
  let default_base_directory = expand('~')
  let base_directory = s:get_config('taskbookDirectory', default_base_directory)
  return s:join_paths(expand(base_directory), '.taskbook')
endfunction

function! s:read_config() abort
  return taskbook#utils#read_json(s:config_directory)
endfunction

function! s:get_config(key, default) abort
  let config = s:read_config()  
  return get(config, a:key, a:default)
endfunction

" FIXME
function! s:join_paths(p1, p2) abort
  return a:p1 . '/' .  a:p2
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
