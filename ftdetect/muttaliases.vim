" only enable auto completion in Mutt mails
autocmd BufRead,BufNewFile,BufFilePost mutt{ng,}-*-\w\+,mutt[[:alnum:]_-]\\\{6\}
      \ setlocal omnifunc=muttaliases#CompleteMuttAliases |
      \ if exists(':Alias') | exe 'Alias -buffer ea EditAliases' | endif |
      \ command! -buffer EditAliases call muttaliases#EditMuttAliasesFile()
