# General code for the stow-* scripts

do_stow() {
    for package in "${@}";do
        fold_arg=""
        if [ -e "home-private/$package" -a "home-public/$package" ];then
            fold_arg="--no-folding"
        fi

        if [ -e home-private/$package ];then
            stow -v $fold_arg --dotfiles --dir=home-private --target=$HOME $package
        fi
        if [ -e home-public/$package ];then
            stow -v $fold_arg --dotfiles --dir=home-public --target=$HOME $package
        fi
    done
}
