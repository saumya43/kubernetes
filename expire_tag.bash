#!/bin/bash
trap cleanup 2
cleanup()
{
    echo "The execution of the script was aborted due to user entering Ctrl-c"
    exit
}
git for-each-ref --sort=taggerdate --format='%(tag)___%(taggerdate:raw)' refs/tags |
grep -v '^___' |
gawk 'BEGIN {FS="___"} {t=strftime("%Y-%m-%d",$2); printf("%s %s\n", t, $1)}'|
while read -r line; do
    DATE=${line%" "*}
    if [[ $(date -jf "%Y-%m-%d %H:%M:%S" "${DATE} 00:00:00" +%s) -le $(date -jf "%Y-%m-%d %H:%M:%S" "${1} 00:00:00" +%s) ]]
    then
      echo "$(git tag -l $line)"

      #git tag -v -n -d $tag
    fi
done
