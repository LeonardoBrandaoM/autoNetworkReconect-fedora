#!/bin/bash
INTERFACE="$1"
EVENT="$2"

if [[ "$EVENT" == "connectivity-change" ]]; then
	CONNECTIVITY=$(nmcli -t -f CONNECTIVITY general status 2>/dev/null | head -1)
	if [[ "$CONNECTIVITY" == "none" || "$CONNECTIVITY" == "limited" ]]; then
		sleep 5
		CONNECTIVITY2=$(nmcli -t -f CONNECTIVITY general status 2>/dev/null | head -1)
		if [[ "$CONNECTIVITY2" == "none" || "$CONNECTIVITY2" == "limited" ]]; then
                logger -t nm-auto-reconnect "Reconectando por perda de conectividade..."
                nmcli device disconnect enp5s0
                sleep 2
                nmcli connection up "Conexão cabeada 1"
		fi
	fi
fi
