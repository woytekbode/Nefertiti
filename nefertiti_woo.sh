#!/bin/bash

# This script is called by "nefertiti_pm2.sh"
# Arguments:
# nefertiti_all.sh	subaccount	api_key		api_secret	mode	market	price	mult	dip		pip		volume	top		repeat	strict	dca
# nefertiti_all.sh	$1			$2			$3			$4		$5		$6		$7		$8		$9		$10		$11		$12		$13		$14
#
# Exchange, markets and ignore error are set in this script

# API
SUBACCOUNT="${1}"
API_KEY="${2}"
API_SECRET="${3}"
PUSHOVER_APP_KEY="none"
PUSHOVER_USER_KEY="none"
TELEGRAM_APP_KEY="none"
TELEGRAM_CHAT_ID="none"
API="--api-key=${API_KEY} --api-secret=${API_SECRET} --pushover-app-key=${PUSHOVER_APP_KEY} --pushover-user-key=${PUSHOVER_USER_KEY} --telegram-app-key=${TELEGRAM_APP_KEY} --telegram-chat-id=${TELEGRAM_CHAT_ID}"

# GENERAL
MODE="${4}"
EXCHANGE="Woo"			# exchange

# BUY/SELL
MARKET="${5}"
MARKET_1=("all")		# ("all") OR ("COIN1" "COIN2")
MARKET_2=("WOO")		# ("all") OR ("COIN1" "COIN2")
MARKET_3=("")		# ("all") OR ("COIN1" "COIN2")
MARKET_LIST=""
PRICE="${6}"
QUOTE="USDT"
IGNORE=""
IGNORE_1=("BTC" "ETH" "DOGE" "SHIB" "USDC" "BUSD" "DAI" "BTTC")	# ("COIN1" "COIN2") OR ("")
IGNORE_2=("")			# ("COIN1" "COIN2")
IGNORE_3=("")			# ("COIN1" "COIN2")
IGNORE_ERROR="true"		# "true" or "false"
IGNORE_LIST=""
MULT="${7}"
DIP="${8}"
PIP="${9}"
VOLUME="${10}"
TOP="${11}"
REPEAT="${12}"
STRICT="${13}"
DCA="${14}"

if [ "${MARKET}" == "1" ]; then
	MARKET=(${MARKET_1[@]})
	IGNORE=(${IGNORE_1[@]})
elif [ "${MARKET}" == "2" ]; then
	MARKET=(${MARKET_2[@]})
	IGNORE=(${IGNORE_2[@]})
elif [ "${MARKET}" == "3" ]; then
	MARKET=(${MARKET_3[@]})
	IGNORE=(${IGNORE_3[@]})
fi

if [ "${MARKET}" == "all" ]; then
	MARKET_LIST="${MARKET}"
	QUOTE_ARG="--quote=${QUOTE} "
else
	for i in "${MARKET[@]}"
	do
		MARKET_LIST="${MARKET_LIST}SPOT_${i}_${QUOTE},"
	done
	MARKET_LIST="${MARKET_LIST%,}"
	QUOTE_ARG=""
fi

if [ -n "${IGNORE}" ]; then
	for i in "${IGNORE[@]}"
	do
		IGNORE_LIST="${IGNORE_LIST}SPOT_${i}_${QUOTE},"
	done
fi

if [ "${IGNORE_ERROR}" == "true" ]; then
	IGNORE_LIST="error,${IGNORE_LIST}"
fi

if [ -n "${IGNORE_LIST}" ]; then
	IGNORE_ARG="--ignore=${IGNORE_LIST%,} "
else
	IGNORE_ARG=""
fi

if [ "${MULT}" != "0" ]; then
	MULT_ARG="--mult=${MULT} "
else
	MULT="1.05"
    MULT_ARG=""
fi

if [ "${VOLUME}" != "0" ]; then
	VOLUME_ARG="--volume=${VOLUME} "
else
    VOLUME_ARG=""
fi

if [ "${DIP}" != "0" ]; then
	DIP_ARG="--dip=${DIP} "
else
    DIP_ARG=""
fi

if [ "${PIP}" != "0" ]; then
	PIP_ARG="--pip=${PIP} "
else
    PIP_ARG=""
fi

if [ "${TOP}" != "0" ]; then
	TOP_ARG="--top=${TOP} "
else
    TOP_ARG=""
fi

if [ "${REPEAT}" != "0" ]; then
	REPEAT_ARG="--repeat=${REPEAT} "
else
    REPEAT_ARG=""
fi

if [ "${STRICT}" == "true" ]; then
	STRICT_ARG="--strict "
else
    STRICT_ARG=""
fi

if [ "${DCA}" == "true" ]; then
	DCA_ARG="--dca "
else
    DCA_ARG=""
fi


# BUY
if [ "$MODE" == "buy" ]; then
	pm2 start nefertiti \
	--name "nefertiti_${SUBACCOUNT}_${MODE}_${MULT}" \
	-- \
	buy \
	${API} \
	--exchange=${EXCHANGE} \
	--market=${MARKET_LIST} \
	--price=${PRICE} \
	${IGNORE_ARG}\
	${QUOTE_ARG}\
	${MULT_ARG}\
	${VOLUME_ARG}\
	${DIP_ARG}\
	${PIP_ARG}\
	${TOP_ARG}\
	${REPEAT_ARG}\
	${STRICT_ARG}\
	${DCA_ARG}

# SELL
elif [ "$MODE" == "sell" ]; then
	pm2 start nefertiti \
	--name "nefertiti_${SUBACCOUNT}_${MODE}_${MULT}" \
	-- \
	sell \
	${API} \
	--exchange=${EXCHANGE} \
	${MULT_ARG}

# CANCEL
elif [ "$MODE" == "cancel" ]; then
	pm2 start nefertiti \
	--name "nefertiti_${SUBACCOUNT}_${MODE}" \
	--no-autorestart \
	-- \
	cancel \
	${API} \
	--exchange=${EXCHANGE} \
	--market=${MARKET_LIST} \
	--side="buy"
fi
