"let b:tex_flavor = 'pdflatex'
":compiler tex
":set makeprg=pdflatex\ \-file\-line\-error\ \-interaction=nonstopmode\ $*\\\|\ grep\ \-E\ '\\w+:[0-9]{1,4}:\\\ ' 
"setlocal errorformat=%f:%l:\ %m
:set makeprg=pdflatex\ \%
