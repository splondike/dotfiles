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
    return fnamemodify(a:val, ":t")
endfunction

function! coc#source#zettel#complete(opt, cb) abort
    if !exists("g:ZettelAutocompletePaths")
        call a:cb([])
        return
    endif

    # The g:ZettelAutocompletePaths should be a CSV of absolute file
    # paths.
    let items = split(globpath(g:ZettelAutocompletePaths, "*.md"), "\n")
    call map(items, function("Strip_start"))
    call a:cb(items)
endfunction
