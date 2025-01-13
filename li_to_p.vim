" Function to convert next N lines
function! ConvertLiToPLines(num_lines)
    let start_line = line('.')
    let end_line = start_line + a:num_lines - 1
    execute start_line.','.end_line.'s/<li>\(.\{-}\)<\/li>/<p>\1<\/p>/g'
endfunction

" Map for converting next N lines (usage: \n5 to convert next 5 lines)
nnoremap <Leader>n :call ConvertLiToPLines(

