let s:save_cpo = &cpo
set cpo&vim

function! taskbook#utils#read_json(path) abort
  return json_decode(join(readfile(a:path), ''))
endfunction

function! taskbook#utils#input(description) abort
  let value = input(a:description)
  redraw
  return value
endfunction

function! taskbook#utils#system(cmd) abort
  if s:has_vimproc()
    let output = vimproc#system(a:cmd)
  else
    let output = system(a:cmd)
  endif
  if v:shell_error
    echohl Error | echon output | echohl None
  else
   echomsg output
  endif
endfunction

function! s:has_vimproc() abort
  if exists('s:vimproc_exists')
    return s:vimproc_exists
  endif
  try
    call vimproc#version()
    let s:vimproc_exists = 1
  catch
    let s:vimproc_exists = 0
  endtry
  return s:vimproc_exists
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
