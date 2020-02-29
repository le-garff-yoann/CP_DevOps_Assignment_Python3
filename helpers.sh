roles_run_molecule()
{
    find roles/ -type d -mindepth 1 -maxdepth 1 | while read r
    do
        if [ -d "$r/molecule" ]
        then
            cd $r && molecule $* && cd .. || return 1
        fi
    done
}
