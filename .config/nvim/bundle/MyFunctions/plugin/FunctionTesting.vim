" Function for bash script file preamble info.
  function TestFunction(...)
    while !exists(@%)
      let l:filename = input("No/Invalid filename detected.\nPlease enter a filename: ")
      if !matchstr(l:filename,'^[0-9a-zA-Z/\s]+')
        echom "The filename entered does not match the regex pattern."
      else
        let l:filename = substitute(l:filename, " ", "\ ", "g")                                                   execute "w " . l:filename
      endif
    endwhile

    :execute "norm I#!/usr/bin/env bash"
    :r! echo %:p
    :norm I#
    :w | e
    if exists(a:1)
      :execute "normal! o# " | startinsert!
    else
      :execute "normal! o# " | startinsert!
    endif
  endfunction

" Abbreviations
