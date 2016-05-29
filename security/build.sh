#!/bin/sh

if [[ x$1 == x"clean" ]]; then
    rm -rf ntcu-root-ca/ ntcu-root-ca-tmp/
    
    rm -rf ntcu-server-trust/ ntcu-server-trust-tmp/
    
    rm -rf ntcu-control-server/ ntcu-control-server-tmp/
    
    rm -rf passwords/
    
    # rm -f ntcu-client-trust.req ntcu-client-trust.cer ntcu-client-trust.key ntcu-client-trust.srl
    # rm -f ntcu-control/*
    # rm -f ntcu-gateway/*
    
    
    exit 0
fi

mkdir -p passwords

# Root CA
mkdir -p ntcu-root-ca ntcu-root-ca-tmp

cat ../build.properties | ../support/gen-config.sh sslconfig.conf.in - ntcu-root-ca-tmp/ntcu-root-ca.conf -h
cat ../build.properties | ../support/gen-config.sh passwd.in - passwords/ntcu-root-ca -h

cat passwords/ntcu-root-ca | ./build-root.sh ntcu-root-ca

# Server Trust CA
mkdir -p ntcu-server-trust ntcu-server-trust-tmp
cat ../server.properties ../build.properties | ../support/gen-config.sh sslconfig.conf.in - ntcu-server-trust-tmp/ntcu-server-trust.conf -h
cat ../server.properties ../build.properties | ../support/gen-config.sh passwd.in - passwords/ntcu-server-trust -h

cat passwords/ntcu-root-ca | ./build-sign.sh ntcu-server-trust ntcu-root-ca ca

# Control Server
mkdir -p ntcu-control-server ntcu-control-server-tmp
cat ../ccs.properties ../build.properties | ../support/gen-config.sh sslconfig.conf.in - ntcu-control-server-tmp/ntcu-control-server.conf -h
cat ../ccs.properties ../build.properties | ../support/gen-config.sh passwd.in - passwords/ntcu-control-server -h

cat passwords/ntcu-server-trust | ./build-sign.sh ntcu-control-server ntcu-server-trust server

# Gateway Server
mkdir -p ntcu-gateway-server ntcu-gateway-server-tmp
cat ../ntcu.properties ../build.properties | ../support/gen-config.sh sslconfig.conf.in - ntcu-gateway-server-tmp/ntcu-gateway-server.conf -h
cat ../ntcu.properties ../build.properties | ../support/gen-config.sh passwd.in - passwords/ntcu-gateway-server -h

cat passwords/ntcu-server-trust | ./build-sign.sh ntcu-gateway-server ntcu-server-trust serverclient
