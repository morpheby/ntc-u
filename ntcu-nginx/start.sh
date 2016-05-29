#!/bin/sh

nginx -s quit
nginx -c `pwd`/nginx.conf
