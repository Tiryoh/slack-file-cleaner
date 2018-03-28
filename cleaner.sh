#!/bin/sh

usage_exit() {
  echo "Usage: $0 [-s] [-o] [-d] [-h] [-D day] user_name token" 1>&2
  exit 1
}

while getopts sodD:h OPT
do
  case $OPT in
    s) show_flag=1 ;;
    o) donwload_flag=1 ;;
    d) delete_flag=1 ;;
    D) day=$OPTARG ;;
    h) usage_exit ;;
    \?) usage_exit ;;
  esac
done
shift `expr $OPTIND - 1`
if [ $# -ne 2 ]; then
  usage_exit
fi

slack_user=$1
slack_token=$2
ts_to=`date -v -${day:-0}d +%s`

# Get user id
user_id=$(curl -sS 'https://slack.com/api/users.list?token='$slack_token''\
  | jq -r '.members[] | select(.name == "'$slack_user'").id')

# Show file list
if [ "$show_flag" = 1 ]; then
  curl -sS 'https://slack.com/api/files.list?token='$slack_token'&user='$user_id'&ts_to='$ts_to''\
    | jq -r '.files[].name'
fi

# Donwload Files
if [ "$donwload_flag" = 1 ]; then
  curl -sS 'https://slack.com/api/files.list?token='$slack_token'&user='$user_id'&ts_to='$ts_to''\
    | jq -r '.files[].url_private_download'\
    | xargs -I{} curl -sS -O -H 'Authorization:Bearer '$slack_token'' {}
fi

# Delete Files
if [ "$delete_flag" = 1 ]; then
  curl -sS 'https://slack.com/api/files.list?token='$slack_token'&user='$user_id'&ts_to='$ts_to''\
    | jq -r '.files[].id' \
    | xargs -I{} curl -sS -X POST 'https://slack.com/api/files.delete?token='$slack_token'&file={}'
fi
