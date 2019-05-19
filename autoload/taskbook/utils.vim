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

let &cpo = s:save_cpo
unlet s:save_cpo
