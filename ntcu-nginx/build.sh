#!/bin/sh

if [[ x$1 == x"clean" ]]; then
    rm -f nginx.conf
    rm -f servers/ccs.conf servers/ntcu.conf
    rm -f passwords.global
    rm -f passwords.ntcu
    rm -f passwords.ccs
	
    exit 0
fi

# Global
../support/gen-config.sh nginx.conf.in ../build.properties -h '#'
../support/gen-config.sh passwords.in ../build.properties passwords.global -h

# NTCU-Control
cat ../ccs.properties ../build.properties | ../support/gen-config.sh server.conf.in - servers/ccs.conf -h '#'
cat ../ccs.properties ../build.properties | ../support/gen-config.sh passwords.in - passwords.ccs -h

# NTCU-Control
# cat ../ntcu.properties ../build.properties | ../support/gen-config.sh server.conf.in - servers/ntcu.conf -h '#'
# cat ../ntcu.properties ../build.properties | ../support/gen-config.sh passwords.in - passwords.ntcu -h


# Server Trust chain
cat ../security/ntcu-server-trust/ntcu-server-trust-chained.cer ../security/ntcu-root-ca/ntcu-root-ca-common.cer > trust.cer

