function! muttaliases#SetMuttAliasesFile() abort
  if !exists('g:muttaliases_file')
    if executable('mutt')
      let g:muttaliases_file = system('mutt -Q "alias_file"')
    else
      " pedestrian's way
      let muttrc = readfile(expand('~/.muttrc'))

      for line in muttrc
        let alias_file = matchlist(line,'\v^\s*set\s+alias_file\s*\=\s*[''"]?([^''"]*)[''"]?$')
        if !empty(alias_file)
          let g:muttaliases_file = resolve(expand(alias_file[1]))
        else
          let g:muttaliases_file = ''
        endif
      endfor
    endif
  endif
  if !filereadable(g:muttaliases_file)
    echoerr 'No valid mutt aliases file found.'
    echoerr 'Please set $alias_file in ~/.muttrc or g:muttaliases_file in ~/.vimrc to a mutt aliases file!'
    let g:muttaliases_file = ''
  endif
endfunction

function! muttaliases#EditMuttAliasesFile() abort
  if !empty(g:muttaliases_file)
    exe 'edit ' . escape(file, ' %#|"')
  else
    echoerr 'No valid mutt aliases file found.'
    echoerr 'Please set $alias_file in ~/.muttrc or g:muttaliases_file in ~/.vimrc to a mutt aliases file!'
  endif
endfunction

function! muttaliases#CompleteMuttAliases(findstart, base) abort
  if a:findstart
    " locate the start of the word
    " we stop when we encounter space character
    let col = col('.')-1
    let text_before_cursor = getline('.')[0 : col - 1]
    " let start = match(text_before_cursor, '\v<([[:digit:][:lower:][:upper:]]+[._%+-@]?)+$')
    let start = match(text_before_cursor, '\v<\S+$')
    return start
  else
    let file = g:muttaliases_file

    if empty(file)
      return []
    endif

    let before = '\v^[^@]*'
    let base   = '\V' . escape(a:base, '\')
    let after  = '\v[^@]*($|\@)'

    let pattern_begin = '\v^' . base . after
    let pattern_delim = before . '\v<' . base . after
    let pattern = before . base . after

    let results_begin = []
    let results_delim = []
    let results = []

    for line in readfile(file)
      if empty(line)
        continue
      endif
      " remove optional group parameters
      let line = substitute(line, '\v(\s+-group\s+\S+)+', '','')
      let words = split(line)
      if words[0] is# 'alias' && len(words) >= 3
        if words[1] =~? pattern
          " get the alias part
          " mutt uses \ to escape ", we need to remove it!
          let alias = substitute(join(words[2:-1], ' '), '\\', '', 'g')
          let alias = substitute(alias, '\v([^\\])#.*$', '\1', '')
          let dict = {}
          let dict['word'] = alias
          let dict['abbr'] = words[1]
          let dict['menu'] = alias
          " add to the complete list
          if     dict.word =~? pattern_begin
            call add(results_begin, dict)
          elseif dict.word =~? pattern_delim
            call add(results_delim, dict)
          else
            call add(results, dict)
          endif
        endif
      endif
    endfor
    let results = sort(results_begin, 1) + sort(results_delim, 1) + sort(results, 1)
    return results
  endif
endfunction

