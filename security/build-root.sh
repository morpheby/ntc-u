#!/bin/sh

if [ -e $1/$1.key -a -e $1-tmp/$1.req -a -e $1/$1.cer \
  -a $1/$1.key -nt $1-tmp/$1.conf \
  -a $1-tmp/$1.req -nt $1-tmp/$1.conf \
  -a $1/$1.cer -nt $1-tmp/$1.conf \
  -a $1/$1.cer -nt $0 ]; then
  exit 0
fi

rm -f $1/$1.key $1-tmp/$1.req $1/$1.cer $1/$1.srl

openssl req -batch -new -config $1-tmp/$1.conf -out $1-tmp/$1.req -newkey rsa:4096 -keyout $1/$1.key
openssl x509 -days 365 -in $1-tmp/$1.req -req -trustout -out $1/$1.cer -signkey $1/$1.key -extensions v3_ca -extfile $1-tmp/$1.conf -passin stdin
openssl x509 -in $1/$1.cer -clrtrust -out $1/$1-common.cer


# openssl pkcs12 -export -inkey ntcu-gateway-key.pem -in ntcu-gateway.pem -out ntcu-gateway.p12 -CAfile ca-root.pem
# keytool -keystore ntcu-trust.jks -import -file ca-root.pem -alias ca-root -storepass ""
# keytool -keystore ntcu-trust.jks -importcert ca-root.pem
# openssl pkcs12 -export -inkey ntcu-central-key.pem -in ntcu-central.pem -out ntcu-central.p12 -CAfile ca-root.pem
# openssl x509 -in ntcu-central.req -req -CA ca-root.pem -addtrust serverAuth -CAkey ca-root-key.pem -out ntcu-central.pem
# openssl req -in ntcu-central.req -out ntcu-central.req -newkey rsa:4096 -keyout ntcu-central-key.pem
# openssl pkcs12 -export -inkey ntcu-central-key.pem -in ntcu-central.pem -out ntcu-central.p12
# openssl x509 -in ntcu-gateway.req -req -CA ca-root.pem -addtrust serverAuth -addtrust clientAuth -CAkey ca-root-key.pem -out ntcu-gateway.pem
# openssl x509 -in ntcu-gateway.req -req -CA ca-root.pem -addtrust serverAuth,clientAuth -CAkey ca-root-key.pem -out ntcu-gateway.pem
# openssl x509 -in ntcu-central.req -req -CA ca-root.pem -CAkey ca-root-key.pem
# openssl x509 -in ca-root.req -req -trustout -out ca-root.pem -signkey ca-root-key.pem -extensions v3_ca