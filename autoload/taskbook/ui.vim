let s:save_cpo = &cpo
set cpo&vim

function! taskbook#ui#init() abort
  let screen = s:make_screen()
  call screen.show()
endfunction

function! s:make_screen() abort
  let screen = vui#screen#new()
  
  function! screen.load_items() abort
    let self._items = taskbook#items#load_from_storage()
    let self._boards = s:collect_boards(values(self._items))
  endfunction

  function! screen.on_before_render(screen) abort
    call s:on_before_render(a:screen)
  endfunction

  function! screen.active_board() abort
    return self._active_board
  endfunction

  function! screen.active_board_items() abort
    let items = []
    let active_board = self.active_board()
    for item in values(self._items)
      if taskbook#item#belongs_to_board(item, active_board)
        call add(items, item)
      endif
    endfor
    return items
  endfunction

  function! screen.has_active_board() abort
    return has_key(self, '_active_board')
  endfunction

  function! screen.activate_board(board) abort
    let self._active_board = a:board
  endfunction

  function! screen.deactivate_board() abort
    unlet self._active_board
  endfunction

  function! screen.render_board() abort
    call s:render_board(self)
  endfunction

  function! screen.render_board_selector() abort
    call s:render_board_selector(self) 
  endfunction

  function! screen.star_item() abort
    call s:star_item(self)
  endfunction

  function! screen.set_normal_priority() abort
    call s:set_normal_priority(self)
  endfunction

  function! screen.set_medium_priority() abort
    call s:set_medium_priority(self)
  endfunction

  function! screen.set_high_priority() abort
    call s:set_high_priority(self)
  endfunction

  function! screen.begin_task() abort
    call s:begin_task(self)
  endfunction

  function! screen.delete_item() abort
    call s:delete_item(self)
  endfunction

  function! screen.add_task() abort
    call s:add_task(self)
  endfunction

  function! screen.add_note() abort
    call s:add_note(self)
  endfunction

  function! screen.edit_item() abort
    call s:edit_item(self)
  endfunction

  call screen.map('s', 'star_item')
  call screen.map('l', 'set_normal_priority')
  call screen.map('m', 'set_medium_priority')
  call screen.map('h', 'set_high_priority')
  call screen.map('p', 'begin_task')
  call screen.map('t', 'add_task')
  call screen.map('n', 'add_note')
  call screen.map('e', 'edit_item')
  call screen.map('dd', 'delete_item')
  call screen.map('<BS>', 'deactivate_board')

  call screen.load_items()
  
  return screen
endfunction

function! s:on_before_render(screen) abort
  if a:screen.has_active_board()
    call a:screen.render_board()
  else
    call a:screen.render_board_selector()
  endif
endfunction

function! s:render_board(screen) abort
  let board = s:make_board(a:screen)
  call a:screen.set_root_component(board)
endfunction

function! s:make_board(screen) abort
  let active_board = a:screen.active_board()
  let items = a:screen.active_board_items()
  let panel = vui#component#panel#new(active_board, winwidth(0), winheight(0))
  let container = vui#component#vcontainer#new()

  for item in items
    call container.add_child(s:make_board_item(item))
  endfor

  call panel.get_content_component().add_child(container)
  return panel
endfunction

function! s:make_board_item(item) abort
  if taskbook#item#is_task(a:item)
    return s:make_task(a:item)
  else
    return s:make_note(a:item)
  endif
endfunction

function! s:make_task(item) abort
  let toggle = vui#component#toggle#new(taskbook#item#to_string(a:item))
  let toggle._item = a:item
  call toggle.set_checked(taskbook#item#is_complete(a:item))

  function! toggle.on_change(toggle) abort
    call taskbook#command#check([taskbook#item#id(a:toggle._item)])
    call taskbook#item#toggle_complete(a:toggle._item)
    call a:toggle.set_checked(taskbook#item#is_complete(a:toggle._item))
  endfunction

  return toggle
endfunction

function! s:make_note(item) abort
  let button = vui#component#button#new(taskbook#item#to_string(a:item))
  let button._item = a:item
  return button
endfunction

function! s:is_board_item(element) abort
  return has_key(a:element, '_item')
endfunction

function! s:render_board_selector(screen) abort
  let board_selector = s:make_board_selector(a:screen)
  call a:screen.set_root_component(board_selector)
endfunction

function! s:make_board_selector(screen) abort
  let boards = a:screen._boards
  let panel = vui#component#panel#new('Boards', winwidth(0), winheight(0))
  let container = vui#component#vcontainer#new() 

  for board in boards
    let board_button = vui#component#button#new(board)

    function! board_button.on_action(board_button) abort
      let board_to_activate = a:board_button.get_text()
      call b:screen.activate_board(board_to_activate)
    endfunction

    call container.add_child(board_button)
  endfor

  call panel.get_content_component().add_child(container)
  return panel
endfunction

function! s:star_item(screen) abort
  let element = a:screen.get_focused_element()
  if s:is_board_item(element)
    call taskbook#command#star([taskbook#item#id(element._item)])
    call taskbook#item#toggle_star(element._item)
  endif
endfunction

function! s:set_normal_priority(screen) abort
  let element = a:screen.get_focused_element()
  if s:is_board_item(element)
    call taskbook#command#set_normal_priority(taskbook#item#id(element._item))
    call taskbook#item#set_normal_priority(element._item)
  endif
endfunction

function! s:set_medium_priority(screen) abort
  let element = a:screen.get_focused_element()
  if s:is_board_item(element)
    call taskbook#command#set_medium_priority(taskbook#item#id(element._item))
    call taskbook#item#set_medium_priority(element._item)
  endif
endfunction

function! s:set_high_priority(screen) abort
  let element = a:screen.get_focused_element()
  if s:is_board_item(element)
    call taskbook#command#set_high_priority(taskbook#item#id(element._item))
    call taskbook#item#set_high_priority(element._item)
  endif
endfunction

function! s:begin_task(screen) abort
  let element = a:screen.get_focused_element()
  if s:is_board_item(element)
    call taskbook#command#begin([taskbook#item#id(element._item)])
    call taskbook#item#toggle_progress(element._item)
  endif
endfunction

function! s:delete_item(screen) abort
  let element = a:screen.get_focused_element()
  if s:is_board_item(element)
    call taskbook#command#delete([taskbook#item#id(element._item)])
    call remove(a:screen._items, taskbook#item#id(element._item))
  endif
endfunction

function! s:edit_item(screen) abort
  let element = a:screen.get_focused_element()
  if s:is_board_item(element)
    let id = '@' . taskbook#item#id(element._item)
    let description = taskbook#utils#input('New Description: ')
    let board = s:format_board_name(a:screen.active_board())

    if len(description) == 0
      return
    endif

    call taskbook#command#edit([id, description, board])
    call taskbook#item#change_description(element._item, description)
  endif
endfunction

function! s:add_task(screen) abort
  let description = taskbook#utils#input('New Task: ')
  if len(description) == 0
    return
  endif
  let board = s:format_board_name(a:screen.active_board())
  call taskbook#command#create_task([description, board])
  call a:screen.load_items()
endfunction

function! s:add_note(screen) abort
  let description = taskbook#utils#input('New Note: ')
  if len(description) == 0
    return
  endif
  let board = s:format_board_name(a:screen.active_board())
  call taskbook#command#create_note([description, board])
  call a:screen.load_items()
endfunction

function! s:format_board_name(board) abort
  if a:board ==# 'My Board'
    return ''
  else
    return a:board
  endif
endfunction

function! s:collect_boards(items) abort
  let boards = {}
  for item in a:items
    for board in taskbook#item#boards(item)
      let boards[board] = 1
    endfor
  endfor
  return keys(boards)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
