#!/usr/bin/env bash

function dispo() {
	slots="$(echo $2)"
	if $3; then
		printf "%-37s\e[5m\e[1m\e[92m%s\e[0m\n" "$1" "$2"
	else
		printf "%-37s\e[90m%s\e[0m\n" "$1" "$2"
	fi
}

echo '[]' | jq '[range(0;42)| now + . * 86400 | strftime("%Y-%m-%d")]' | grep -oE '[0-9]{4}-0(3|4)-[0-9]{2}' > date
curl -L -c rennes.txt 'https://eappointment2.rennes.fr/eAppointment/appointment.do?preselectservice=RDV' 2> /dev/null > /dev/null

# Mairie Centre - Victor Hugo: site7
function async_curl() {
	curl -L -b rennes.txt 'https://eappointment2.rennes.fr/eAppointment/dwr/call/plaincall/AjaxSelectionFormFeeder.getClosedDaysList.dwr' --data-raw $'callCount=1\nnextReverseAjaxIndex=0\nc0-scriptName=AjaxSelectionFormFeeder\nc0-methodName=getClosedDaysList\nc0-id=0\nc0-param0=string:site7\nc0-param1=string:20012\nbatchId=5\ninstanceId=0\npage=%2FeAppointment%2Felement%2Fjsp%2Fappointment.jsp\nscriptSessionId=\n' 2> /dev/null | grep 'handleCallback' | grep -oE '[0-9]{4}-0(3|4)-[0-9]{2}' > "$2"
	if ! site=$(diff $2 date); then
		dispo "$1: " "$site" true
		notify-send "$1" "$rdvlink $site"
	else
		dispo "$1: " "Pas de RDV" false
	fi
}
async_curl "Mairie Centre - Victor Hugo" "site7" &

# Mairie de quartier Blosne: site3
function async_blosne() {
	curl -L -b rennes.txt 'https://eappointment2.rennes.fr/eAppointment/dwr/call/plaincall/AjaxSelectionFormFeeder.getClosedDaysList.dwr' --data-raw $'callCount=1\nnextReverseAjaxIndex=0\nc0-scriptName=AjaxSelectionFormFeeder\nc0-methodName=getClosedDaysList\nc0-id=0\nc0-param0=string:site3\nc0-param1=string:20012\nbatchId=5\ninstanceId=0\npage=%2FeAppointment%2Felement%2Fjsp%2Fappointment.jsp\nscriptSessionId=\n' 2> /dev/null | grep 'handleCallback' | grep -oE '[0-9]{4}-0(3|4)-[0-9]{2}' > site3
	if ! site3=$(diff site3 date); then
		dispo "Mairie de quartier Blosne: " "$site3" true
		notify-send 'Mairie de quartier Blosne' "$rdvlink $site3"
	else
		dispo "Mairie de quartier Blosne: " "Pas de RDV" false
	fi
}
async_blosne &

# Mairie de quartier Bréquigny: site8
#curl -L -b rennes.txt 'https://eappointment2.rennes.fr/eAppointment/dwr/call/plaincall/AjaxSelectionFormFeeder.getClosedDaysList.dwr' --data-raw $'callCount=1\nnextReverseAjaxIndex=0\nc0-scriptName=AjaxSelectionFormFeeder\nc0-methodName=getClosedDaysList\nc0-id=0\nc0-param0=string:site8\nc0-param1=string:20012\nbatchId=5\ninstanceId=0\npage=%2FeAppointment%2Felement%2Fjsp%2Fappointment.jsp\nscriptSessionId=\n' 2> /dev/null | grep 'handleCallback' | grep -oE '[0-9]{4}-0(3|4)-[0-9]{2}' > site8
#if ! site8=$(diff site8 date); then
#	dispo "Mairie de quartier Bréquigny: " "$site8" true
#	notify-send 'Mairie de quartier Bréquigny' "$rdvlink $site8"
#else
#	dispo "Mairie de quartier Bréquigny: " " Pas de RDV" false
#fi
#
## Mairie de quartier Maurepas Europe: site2
#curl -L -b rennes.txt 'https://eappointment2.rennes.fr/eAppointment/dwr/call/plaincall/AjaxSelectionFormFeeder.getClosedDaysList.dwr' --data-raw $'callCount=1\nnextReverseAjaxIndex=0\nc0-scriptName=AjaxSelectionFormFeeder\nc0-methodName=getClosedDaysList\nc0-id=0\nc0-param0=string:site2\nc0-param1=string:20012\nbatchId=5\ninstanceId=0\npage=%2FeAppointment%2Felement%2Fjsp%2Fappointment.jsp\nscriptSessionId=\n' 2> /dev/null | grep 'handleCallback' | grep -oE '[0-9]{4}-0(3|4)-[0-9]{2}' > site2
#if ! site2=$(diff site2 date); then
#	dispo "Mairie de quartier Maurepas Europe: " "$site2" true
#	notify-send 'Mairie de quartier Maurepas Europe' "$rdvlink $site2"
#else
#	dispo "Mairie de quartier Maurepas Europe: " "Pas de RDV" false
#fi
#
## Mairie de quartier Villejean: site4
#curl -L -b rennes.txt 'https://eappointment2.rennes.fr/eAppointment/dwr/call/plaincall/AjaxSelectionFormFeeder.getClosedDaysList.dwr' --data-raw $'callCount=1\nnextReverseAjaxIndex=0\nc0-scriptName=AjaxSelectionFormFeeder\nc0-methodName=getClosedDaysList\nc0-id=0\nc0-param0=string:site4\nc0-param1=string:20012\nbatchId=5\ninstanceId=0\npage=%2FeAppointment%2Felement%2Fjsp%2Fappointment.jsp\nscriptSessionId=\n' 2> /dev/null | grep 'handleCallback' | grep -oE '[0-9]{4}-0(3|4)-[0-9]{2}' > site4
#if ! site4=$(diff site4 date); then
#	dispo "Mairie de quartier Villejean: " "$site4" true
#	notify-send 'Mairie de quartier Villejean' "$rdvlink $site4"
#else
#	dispo "Mairie de quartier Villejean: " "Pas de RDV" false
#fi
