function! muttaliases#FindMuttAliasesFile() abort
    let file = readfile(expand('~/.muttrc'))
    for line in file
        let alias_file = matchlist(line,'\v^\s*set\s+alias_file\s*\=\s*[''"]?([^''"]*)[''"]?$')
        if !empty(alias_file)
            return resolve(expand(alias_file[1]))
        endif
    endfor
    return ''
endfunction

function! muttaliases#EditMuttAliasesFile() abort
    let file = muttaliases#FindMuttAliasesFile()
    if empty(file)
        echoerr 'No existing $alias_file in ~/.muttrc found!'
    else
        exe 'edit ' . escape(file, ' \%#|"')
    endif
endfunction

function! muttaliases#CompleteMuttAliases(findstart, base) abort
    if a:findstart
        " locate the start of the word
        " we stop when we encounter space character
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~# '\a'
            let start -= 1
        endwhile
        return start
    else
        " find aliases matching with "a:base"
        let result = []
        let file = muttaliases#FindMuttAliasesFile()
        if empty(file)
            echoerr 'No existing $alias_file in ~/.muttrc found!'
            return result
        endif
        for line_alias in readfile(file)
            let words = split(line_alias, '\s')
            if words[0] is# 'alias' && len(words) >= 3
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

