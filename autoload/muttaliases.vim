if !exists('g:muttaliases_skip_regex')
  let g:muttaliases_skip_regex = '\v^.*([0-9]{9,}|([0-9]+[a-z]+){4,}|not?[-_.]?reply|\+).*\@'
endif

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
    " find aliases matching with a:base
    let file = muttaliases#FindMuttAliasesFile()
    if empty(file)
      echoerr 'No existing $alias_file in ~/.muttrc found!'
      return result
    endif

    let before = '\v^[^@]*'
    let base   = '\V' . escape(a:base, '\')
    let after  = '\v[^@]*($|\@)'

    let pattern_begin = '\v^' . base . after
    let pattern_delim = before . '\v<' . base . after
    let pattern = before . base . after

    let result_begin = []
    let result_delim = []
    let result = []

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
          let dict = {}
          let dict['word'] = alias
          let dict['abbr'] = words[1]
          let dict['menu'] = alias
          " add to the complete list
          if     dict.word =~? pattern_begin
            call add(result_begin, dict)
          elseif dict.word =~? pattern_delim
            call add(result_delim, dict)
          else
            call add(result, dict)
          endif
        endif
      endif
    endfor
    let result = sort(result_begin, 1) + sort(result_delim, 1) + sort(result, 1)
    return result
  endif
endfunction

function! muttaliases#EditMuttAliasesFile() abort
  let file = muttaliases#FindMuttAliasesFile()
  if empty(file)
    echoerr 'No existing $alias_file in ~/.muttrc found!'
  else
    exe 'edit ' . escape(file, ' %#|"')
  endif
endfunction

" This function, which is to be run only on a Mutt email message,
" finds all the addresses in the To, Cc, and Bcc headers. If
" no aliases exist for these addresses then they are added to the
" alias file. Needs 'set edit_headers' in ~/.muttrc !
function! muttaliases#AddMuttAliases() abort
  let aliasfile = muttaliases#FindMuttAliasesFile()

  " Find all email addresses.
  let addresses = []
  let address_pattern = '\v<[[:alnum:]._%+-]+\@([[:alnum:]-]+\.)+[[:alpha:]]{2,}>'
  let start = 1
  let end = line('$')
  let lines = getline(start, end)
  for line in lines
    if line !~# '^\v(To|Cc|Bcc):'
      continue
    endif
    let match   = matchstrpos(line, address_pattern)
    let address = match[0]
    let start   = match[1]
      " filter out common non-personal addresses
    while !empty(address) && address !~? g:muttaliases_skip_regex
      call add(addresses, address)
      let start += len(address)
      let address = matchstr(line, address_pattern, start)
    endwhile
  endfor

  " Add
  "
  "   alias address address
  "
  " to the alias file for tab-completion in mutt.
  let lines = readfile(aliasfile)
  let is_aliased = 0
  for address in addresses
    let alias_pattern = '\V\^\s\*alias\s\+' . address . '\s\+'
    for line in lines
      if line =~? alias_pattern
        let is_aliased = 1
        break
      endif
    endfor
    if !is_aliased
      let aliasline = 'alias ' . address . ' ' . address
      call writefile([aliasline], aliasfile, 'a')
    endif
  endfor
endfunction
