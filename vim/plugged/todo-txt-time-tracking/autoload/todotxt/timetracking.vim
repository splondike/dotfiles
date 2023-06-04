" Track time on todo.txt files. Outputs log messages to
" g:TodoTxtTimeTrackingFile if set
function! todotxt#timetracking#toggle() abort
    let prefix = " tracking:"
    let line = getline(".")
    let timestamp = strftime("%Y%m%d%H%M%S")
    let startidx = stridx(line, prefix)

    if startidx >= 0
        let offsetidx = startidx + len(prefix)
        let spaceidx = stridx(line, " ", offsetidx)
        if spaceidx == -1
            let spaceidx = strlen(line)
        endif
        let starttime = line[offsetidx:spaceidx]
        let new_line = line[:(startidx-1)] . line[spaceidx:]
        call setline(".", new_line)

        if exists("g:TodoTxtTimeTrackingFile")
            let filename = g:TodoTxtTimeTrackingFile
            let csv_line = starttime . "," . timestamp . "," . new_line
            call writefile([csv_line], filename, "a")
        endif
    else
        let new_line = line . prefix . timestamp
        call setline(".", new_line)
    endif
endfunction
