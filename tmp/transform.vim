" Save this as transform.vim or add to your .vimrc
function! TransformHTMLSection()
    " Store the current position
    let save_pos = getpos(".")
    
    " Create the template
    let template = "            <div class=\"row margin-top-45\">\n"
    let template .= "               <div class=\"col-md-3\">\n"
    let template .= "                  <h2>TITLE_PLACEHOLDER</h2>\n"
    let template .= "               </div>\n"
    let template .= "               <div class=\"col-md-9\">\n"
    let template .= "                  CONTENT_PLACEHOLDER\n"
    let template .= "               </div>\n"
    let template .= "            </div>"

    " Find the boundaries of the current section
    let start_pos = search('<p><strong>', 'bc')
    let end_pos = search('</ul>', 'W')
    
    if start_pos == 0 || end_pos == 0
        echo "Couldn't find section boundaries"
        return
    endif

    " Yank the title (text between strong tags)
    normal! f>l"tyt<
    let title = @t

    " Yank the content (everything between ul tags)
    normal! /<ul>/e+1
    let ul_start = line('.')
    let ul_end = search('</ul>')
    execute ul_start . ',' . ul_end . 'y a'
    
    " Process the content
    let content = @a
    let content = substitute(content, '<ul>\n\?\s*', '', 'g')
    let content = substitute(content, '</ul>', '', 'g')
    let content = substitute(content, '<li>\(.\{-}\)</li>', '                  <p>\1</p>', 'g')
    
    " Create the final text
    let final = substitute(template, 'TITLE_PLACEHOLDER', title, '')
    let final = substitute(final, 'CONTENT_PLACEHOLDER', content, '')
    
    " Delete the original section
    execute start_pos . ',' . end_pos . 'delete'
    
    " Insert the new format
    put! =final
    
    " Clean up any extra blank lines
    normal! }k
endfunction

" Map it to a key combination (e.g., <Leader>h)
nnoremap <Leader>h :call TransformHTMLSection()<CR>
