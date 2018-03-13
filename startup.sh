#!/bin/sh -e

if [ -z "${WALLET_ADDRESS}" ]; then
	echo "!!! WALLET_ADDRESS must be set to an ERC20 wallet address";
	exit 1;
fi;

# If our hostname has a hyphen-delimited suffix with a unique identifier, e.g. the ordinal if
#    we're in a Kubernetes statefulset, use that suffix as a subdirectry in the main DATADIR
if [ "$(echo "${USE_HOSTNAME_SUFFIX}" | tr /a-z/ /A-Z/)" == 'TRUE' ]; then
	DATADIR="${DATADIR}/$(hostname | rev | cut -d- -f1 | rev)";
fi;

storjshare daemon -F &
sleep 1;

mkdir -pv "${DATADIR}/share" "${DATADIR}/log";
if [ ! -f "${DATADIR}/config.json" ]; then
	storjshare create --storj "${WALLET_ADDRESS}" --storage "${DATADIR}/share" --size "${SHARE_SIZE}" --rpcport 4000 --rpcaddress "${RPCADDRESS}" --tunnelportmin 4001 --tunnelportmax 4003 --logdir "${DATADIR}/log" --outfile "${DATADIR}/config.json" --noedit;
fi;

storjshare start --config "${DATADIR}/config.json";
wait;

