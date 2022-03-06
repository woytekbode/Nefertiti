#!/bin/bash

# Use this script to start Nefertiti via PM2.
# Start with "./nefertiti_pm2.sh start" and stop with "./nefertiti_pm2.sh stop"
# You can use WOO X subaccounts by entering the API keys

# GENERAL
MODE="$1" 		#start/stop

# API keys
API_KEY_1=""
API_SECRET_1=""
API_KEY_2=""
API_SECRET_2=""
API_KEY_3=""
API_SECRET_3=""

# input 1
MARKET_1="1"		# Required, "1" or "2" or "3"
PRICE_1="25"		# Required, "X"
MULT_1="0"			# Optional, "0" if it's not used, else "1.0X"
DIP_1="0"			# Optional, "0" if it's not used, else "X"
PIP_1="0"			# Optional, "0" if it's not used, else "X"
VOLUME_1="5"		# Optional, "0" if it's not used, else "X"
TOP_1="1"			# Optional, "0" if it's not used, else "X"
REPEAT_1="1"		# Optional, "0" if it's not used, else "X"
STRICT_1="true"		# Optional, "false" if it's not used, else "true"
DCA_1="false"		# Optional, "false" if it's not used, else "true"

# input 2
MARKET_2="1"
PRICE_2="25"
MULT_2="1.04"
DIP_2="0"
PIP_2="0"
VOLUME_2="5"
TOP_2="1"
REPEAT_2="1"
STRICT_2="true"
DCA_2="false"

# input 3
MARKET_3="1"
PRICE_3="25"
MULT_3="1.03"
DIP_3="0"
PIP_3="0"
VOLUME_3="5"
TOP_3="1"
REPEAT_3="1"
STRICT_3="true"
DCA_3="false"

if [ "$MODE" == "start" ]; then
	# PM2 start
	pm2 delete all
	if [ -n "${API_KEY_1}" ]; then
		./nefertiti_woo.sh 1 ${API_KEY_1} ${API_SECRET_1} sell ${MARKET_1} ${PRICE_1} ${MULT_1} ${DIP_1} ${PIP_1} ${VOLUME_1} ${TOP_1} ${REPEAT_1} ${STRICT_1} ${DCA_1}
		./nefertiti_woo.sh 1 ${API_KEY_1} ${API_SECRET_1} buy ${MARKET_1} ${PRICE_1} ${MULT_1} ${DIP_1} ${PIP_1} ${VOLUME_1} ${TOP_1} ${REPEAT_1} ${STRICT_1} ${DCA_1}
	fi
	if [ -n "${API_KEY_2}" ]; then
		./nefertiti_woo.sh 2 ${API_KEY_2} ${API_SECRET_2} sell ${MARKET_2} ${PRICE_2} ${MULT_2} ${DIP_2} ${PIP_2} ${VOLUME_2} ${TOP_2} ${REPEAT_2} ${STRICT_2} ${DCA_2}
		./nefertiti_woo.sh 2 ${API_KEY_2} ${API_SECRET_2} buy ${MARKET_2} ${PRICE_2} ${MULT_2} ${DIP_2} ${PIP_2} ${VOLUME_2} ${TOP_2} ${REPEAT_2} ${STRICT_2} ${DCA_2}
	fi
	if [ -n "${API_KEY_3}" ]; then
		./nefertiti_woo.sh 3 ${API_KEY_3} ${API_SECRET_3} sell ${MARKET_3} ${PRICE_3} ${MULT_3} ${DIP_3} ${PIP_3} ${VOLUME_3} ${TOP_3} ${REPEAT_3} ${STRICT_3} ${DCA_3}
		./nefertiti_woo.sh 3 ${API_KEY_3} ${API_SECRET_3} buy ${MARKET_3} ${PRICE_3} ${MULT_3} ${DIP_3} ${PIP_3} ${VOLUME_3} ${TOP_3} ${REPEAT_3} ${STRICT_3} ${DCA_3}
	fi
	pm2 dash

elif [ "$MODE" == "stop" ]; then
	pm2 stop all
	if [ -n "${API_KEY_1}" ]; then
		./nefertiti_woo.sh 1 ${API_KEY_1} ${API_SECRET_1} cancel ${MARKET_1}
	fi
	if [ -n "${API_KEY_2}" ]; then
		./nefertiti_woo.sh 2 ${API_KEY_2} ${API_SECRET_2} cancel ${MARKET_2}
	fi
	if [ -n "${API_KEY_3}" ]; then
		./nefertiti_woo.sh 3 ${API_KEY_3} ${API_SECRET_3} cancel ${MARKET_3}
	fi
	
	echo "cancelling all buy orders, this may take a few minutes."
	pm2 dash
fi
