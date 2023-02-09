" vim source for zettel
function! coc#source#zettel#init() abort
  return {
        \ 'priority': 0,
        \ 'shortcut': 'Zettel',
        \ 'filetypes': ['markdown'],
        \ 'triggerCharacters': ['](']
        \}
endfunction

function! Strip_start(key, val) abort
    return a:val[2:]
endfunction

function! coc#source#zettel#complete(opt, cb) abort
    let items = split(globpath(".", "*.md"), "\n")
    call map(items, function("Strip_start"))
    call a:cb(items)
endfunction
