" Track time on todo.txt files. Outputs log messages to
" g:TodoTxtTimeTrackingTimeLogFile if set
function! todotxt#timetracking#Toggle() abort
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
        let newLine = line[:(startidx-1)] . line[spaceidx:]
        call setline(".", newLine)

        if exists("g:TodoTxtTimeTrackingTimeLogFile")
            let filename = g:TodoTxtTimeTrackingTimeLogFile
            let csv_line = starttime . "," . timestamp . "," . newLine
            call writefile([csv_line], filename, "a")
        endif
    else
        let newLine = line . prefix . timestamp
        call setline(".", newLine)
    endif
endfunction

function! todotxt#timetracking#OpenToggleFile() abort
    if exists("g:TodoTxtTimeTrackingTimeLogFile")
        execute("e " . g:TodoTxtTimeTrackingTimeLogFile)
    endif
endfunction

" Add an estimate based on the current line
function! todotxt#timetracking#AddEstimate() abort
    if exists("g:TodoTxtTimeTrackingEstimatesFile")
        let line = getline(".")
        execute("e " . g:TodoTxtTimeTrackingEstimatesFile)
        normal! Go
        call setline(".", "," . line)
        startinsert
    endif
endfunction
