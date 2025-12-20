#!/bin/bash

#Get current username and directory path
TRAEFIK_CERT_DIR=$(pwd)

#Remove old certificates	
rm -rf $TRAEFIK_CERT_DIR/*.crt
rm -rf $TRAEFIK_CERT_DIR/*.key

#Generate certificate
openssl genrsa -out vas_internal.key 4096
openssl req -new -x509 -nodes -sha512 -days 3650 -key vas_internal.key -out vas_internal.crt -config openssl.cnf
