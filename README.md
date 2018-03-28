# Slack File Cleaner

Download and delete files uploaded to Slack

# Requirements

* [jq](https://stedolan.github.io/jq/)

# Usage

```
./cleaner.sh [-s] [-o] [-d] [-h] [-D day] user_name token
```

* -s: Show file list
* -o: Donwload files
* -d: Delete files
* -D: Filter files created before this day
* user_name: Slack user name
* token: Authentication token (Generate tokens with [here](https://api.slack.com/custom-integrations/legacy-tokens).)

## Example

Download and delete files created by @xkumiyu before 30 days

```
./cleaner.sh -od -D 30 xkumiyu xxxx-xxxx
```
