" The todo.txt-vim syntax highlighting only allows certain match groups
" within it. So I just piggy back on one of those.
syntax match OverDueDate 'tracking:\d\+'
highlight default link OverDueDate Character
