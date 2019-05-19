if exists('g:loaded_taskbook')
  finish
endif
let g:loaded_taskbook = 1

let s:cpo_save = &cpo
set cpo&vim

command! -nargs=* TaskbookCreateTask :call taskbook#command#create_task([<f-args>])
command! -nargs=* TaskbookCreateNote :call taskbook#command#create_note([<f-args>])

command! -nargs=* TaskbookCheck :call taskbook#command#check([<f-args>])
command! -nargs=* TaskbookBegin :call taskbook#command#begin([<f-args>])
command! -nargs=* TaskbookStar :call taskbook#command#star([<f-args>])
command! -nargs=* TaskbookDelete :call taskbook#command#delete([<f-args>])
command! -nargs=* TaskbookRestore :call taskbook#command#restore([<f-args>])
command! -nargs=* TaskbookCopy :call taskbook#command#copy([<f-args>])

command! -nargs=* TaskbookMove :call taskbook#command#move([<f-args>])
command! -nargs=* TaskbookEdit :call taskbook#command#edit([<f-args>])

command! -nargs=? TaskbookSetNormalPriority :call taskbook#command#set_normal_priority(<f-args>)
command! -nargs=? TaskbookSetMediumPriority :call taskbook#command#set_medium_priority(<f-args>)
command! -nargs=? TaskbookSetHighPriority :call taskbook#command#set_high_priority(<f-args>)

command! -nargs=0 TaskbookClear :call taskbook#command#clear()

command! -nargs=0 TaskbookUI :call taskbook#ui#init()

let &cpo = s:cpo_save
