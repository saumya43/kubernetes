#!/bin/bash
help()
{
    echo "Usage: tagdelete [ -d | --date ]
               [ -r | --repo ]
               [ -h | --help  ]"
    exit 2
}

delete_older_tags(user_date){
git for-each-ref --sort=taggerdate --format='%(tag)___%(taggerdate:raw)' refs/tags |
grep -v '^___' |
gawk 'BEGIN {FS="___"} {t=strftime("%Y-%m-%d",$2); printf("%s %s\n", t, $1)}'|
while read -r line; do
    DATE=${line%" "*}
    if [[ $(date -jf "%Y-%m-%d %H:%M:%S" "${DATE} 00:00:00" +%s) -le $(date -jf "%Y-%m-%d %H:%M:%S" "${1} 00:00:00" +%s) ]]
    then
      tag = gawk '{print $2}'
      #git tag -d $tag
    fi
done
}

clone_git_repo(repo){

}

LONG=date:,repo:,help
SHORT=d:,r:,h
OPTS=$(getopt --options $SHORT --long $LONG  --name "tagdelete" -- "$@")
VALID_ARGUMENTS=$#
if [ "$VALID_ARGUMENTS" -eq 0 ]; then
  help
fi
eval set -- "$OPTS"
while :
do
  case "$1" in
    -d | --date )
      DATE="$2"
      shift 2
      ;;
    -r | --repo )
      REPO="$2"
      shift 2
      ;;
    -h | --help)
      help
      ;;
    --)
      shift;
      break
      ;;
    *)
      echo "Unexpected option: $1"
      help
      ;;
  esac
done