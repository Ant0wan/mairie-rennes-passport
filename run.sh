#!/usr/bin/env bash

export rdvlink='https://eappointment2.rennes.fr/eAppointment/element/jsp/appointment.jsp'
watch -b -n 40 -c ./crawl-mairie.sh
