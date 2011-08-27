function! FindMuttAliasesFile()
    let file = readfile(expand('~/.muttrc'))
    for line in file
        let words = split(line, '\s')
        if len(words) >= 3 && words[0] == "set" && words[1] == "alias_file"
            return words[2]
        endif
    endfor
    return ""
endfunction

function! CompleteMuttAliases(findstart, base)
    if a:findstart
        " locate the start of the word
        " we stop when we encounter space character
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '\a'
            let start -= 1
        endwhile
        return start
    else
        " find aliases matching with "a:base"
        let result = []
        let file = FindMuttAliasesFile()
        if file == ""
            return result
        endif
        if file[0] == '"'
            let expanded_file = expand(file[1:-2])
        endif
        for line_alias in readfile(expanded_file)
            let words = split(line_alias, '\s')
            if words[0] == "alias" && len(words) >= 3
                if words[1] =~ '^' . a:base
                    " get the alias part
                    " mutt uses '\' to escape '"', we need to remove it!
                    let alias = substitute(join(words[2:-1], ' '), '\\', '', 'g')
                    let dict = {}
                    let dict['word'] = alias
                    let dict['abbr'] = words[1]
                    let dict['menu'] = alias
                    " add to the complete list
                    call add(result, dict)
                endif
            endif
        endfor
        return result
    endif
endfunction

" we only enable this auto complete function when editting Mutt mails
autocmd BufRead,BufNewFile /tmp/mutt-* setlocal completefunc=CompleteMuttAliases
