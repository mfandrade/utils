#!/bin/bash

usage() {
	echo "Usage: $0 (min|max|prob|rain) <city-code>"
	echo
	exit 1
}

if [[ $# -lt 2 ]]; then
	usage
fi

case $1 in
	min)  PAT=low 	;;
	max)  PAT=high	;;
	prob) PAT=prob	;;
	rain) PAT=mm		;;
	*)    usage 		;;
esac

number='^[0-9]+$'
if ! [[ $2 =~ $number ]]; then
	echo "The city code must be a number corresponding a city at www.climatempo.com.br."
	echo
	exit 2
fi

RES=curl -s "http://selos.climatempo.com.br/selos/selo.php?CODCIDADE=$2" \
#| iconv -f=iso-8859-1 -t=utf-8 \
| egrep '(low|high|prob|mm)="[0-9]{2}" ' -o \
| head -n4 \
| tr -d \" )


OUT=$( echo $RES | egrep -o "$PAT=[0-9]{2}" | cut -f2 -d'=' )

echo $OUT
