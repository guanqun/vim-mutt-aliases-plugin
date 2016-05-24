" only enable auto completion in Mutt mails
autocmd BufRead,BufNewFile,BufFilePost mutt{ng,}-*-\w\+,mutt[[:alnum:]_-]\\\{6\}
      \ setlocal omnifunc=muttaliases#CompleteMuttAliases |
      \ if !exists('g:muttaliases_do_not_add_alias_on_send') | call muttaliases#AddMuttAliases() | endif |
      \ if exists(':Alias') | exe 'Alias -buffer ea EditAliases' | endif |
      \ command! -buffer EditAliases call muttaliases#EditMuttAliasesFile()
