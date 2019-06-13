" only enable auto completion in Mutt mails
autocmd BufRead,BufNewFile,BufFilePost mutt{ng,}-*-\w\+,mutt[[:alnum:]_-]\\\{6\}
      \ setlocal completefunc=muttaliases#CompleteMuttAliases |
      \ call muttaliases#SetMuttAliasesFile() |
      \ command! -buffer EditAliases call muttaliases#EditMuttAliasesFile()

