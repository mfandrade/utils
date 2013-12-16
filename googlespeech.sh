#!/bin/bash

LANG='pt-br'

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <text to speech>"
  echo
  exit 1
fi

WGET=/usr/bin/wget
MPG321=/usr/bin/mpg321
PING=/bin/ping

if [[ ! -f $WGET ]] || [[ ! -f $MPG321 ]]; then
   echo "This script depends on \"wget\" and \"mpg321\" packages."
   echo
   exit 2
fi

TEXT=$(echo "$@" | tr ' ' '+')
host='translate.google.com'
API="http://$host/translate_tts?ie=UTF-8&tl=$LANG&q=$TEXT"

if [[ -f $PING ]]; then
  $PING -c1 $host &>/dev/null
  if [[ ! $? -eq 0 ]]; then
    echo "Can't convert text to speech. Please check the internet conectivity."
    echo
    exit 3
  fi
fi

$WGET -q -O- --user-agent=Mozilla $API | $MPG321 -q - 2>/dev/null
