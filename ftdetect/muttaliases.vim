" only enable auto completion in Mutt mails
autocmd BufRead,BufNewFile,BufFilePost mutt{ng,}-*-\w\+,mutt[[:alnum:]_-]\\\{6\}
      \ setlocal omnifunc=muttaliases#CompleteMuttAliases |
      \ command! -buffer EditAliases call muttaliases#EditMuttAliasesFile()

