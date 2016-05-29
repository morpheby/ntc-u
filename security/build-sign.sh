#!/bin/sh

if [ -e $1/$1.key -a -e $1-tmp/$1.req -a -e $1/$1.cer \
  -a $1/$1.cer -nt $2/$2.cer \
  -a $1/$1.key -nt $1-tmp/$1.conf \
  -a $1-tmp/$1.req -nt $1-tmp/$1.conf \
  -a $1/$1.cer -nt $1-tmp/$1.conf \
  -a $1/$1.cer -nt $0 ]; then
  exit 0
fi

rm -f $1/$1.key $1-tmp/$1.req $1/$1.cer $1/$1.srl

case $3 in
    "ca") trust_conf="-trustout -extensions v3_ca";;
    "client") trust_conf="-addtrust clientAuth";;
    "server") trust_conf="-addtrust serverAuth";;
    "serverclient") trust_conf="-addtrust serverAuth -addtrust clientAuth";;
    *) trust_conf=;;
esac

openssl req -batch -new -config $1-tmp/$1.conf -out $1-tmp/$1.req -newkey rsa:4096 -keyout $1/$1.key
openssl x509 -days 365 -in $1-tmp/$1.req -req -out $1/$1.cer -CA $2/$2.cer -CAkey $2/$2.key -CAserial $2/$2.srl -CAcreateserial $trust_conf -extfile $1-tmp/$1.conf -passin stdin
openssl x509 -in $1/$1.cer -clrtrust -out $1/$1-common.cer


if [[ -e $2/$2-chained.cer ]]; then
    append="$2/$2-chained.cer"
else
    append="$2/$2-common.cer"
fi
cat $1/$1-common.cer $append > $1/$1-chained.cer
