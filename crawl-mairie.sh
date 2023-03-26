#!/usr/bin/env bash
echo '[]' | jq '[range(0;42)| now + . * 86400 | strftime("%Y-%m-%d")]' | grep -oE '[0-9]{4}-0(3|4)-[0-9]{2}' > date
curl -L -c rennes.txt 'https://eappointment2.rennes.fr/eAppointment/appointment.do?preselectservice=RDV' 2> /dev/null > /dev/null
function dispo() {
	slots="$(echo $2)"
	if $3; then
		printf "%-37s\e[5m\e[1m\e[92m%s\e[0m\n" "$1" "$2"
	else
		printf "%-37s\e[90m%s\e[0m\n" "$1" "$2"
	fi
}
function async_curl() {
	endpoint='https://eappointment2.rennes.fr/eAppointment/dwr/call/plaincall/AjaxSelectionFormFeeder.getClosedDaysList.dwr'
	data="callCount=1\nnextReverseAjaxIndex=0\nc0-scriptName=AjaxSelectionFormFeeder\nc0-methodName=getClosedDaysList\nc0-id=0\nc0-param0=string:$2\nc0-param1=string:20012\nbatchId=5\ninstanceId=0\npage=%%2FeAppointment%%2Felement%%2Fjsp%%2Fappointment.jsp\nscriptSessionId=\n"
	curl -L -b rennes.txt "$endpoint" --data-raw "$(printf $data)" 2> /dev/null | grep 'handleCallback' | grep -oE '[0-9]{4}-0(3|4)-[0-9]{2}' > "$2"
	if ! site=$(diff $2 date); then
		dispo "$1: " "$site" true
		notify-send "$1" "$rdvlink $site"
	else
		dispo "$1: " "Pas de RDV" false
	fi
}
async_curl "Mairie Centre - Victor Hugo" "site7" &
async_curl "Mairie de quartier Blosne" "site3" &
async_curl "Mairie de quartier Brequigny" "site8" &
async_curl "Mairie de quartier Maurepas Europe" "site2" &
async_curl "Mairie de quartier Villejean" "site4" &

