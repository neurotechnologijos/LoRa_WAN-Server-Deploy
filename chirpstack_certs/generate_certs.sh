#!/bin/bash

#Get current username and directory path
USERNAME=$(id -u -n)
MAIN_CERT_DIR=$(pwd)

#Set variables	
CHIRPSTACK_CERT_DIR=$MAIN_CERT_DIR/../configuration/chirpstack/certs
MOSQUITTO_CERT_DIR=$MAIN_CERT_DIR/../configuration/mosquitto/certs

#Remove old certificates

rm -rf $MAIN_CERT_DIR/*.pem
rm -rf $MAIN_CERT_DIR/*.csr

#Generate the CA certificate and key:
cd $MAIN_CERT_DIR
cfssl gencert -initca ca-csr.json | cfssljson -bare ca

#Generate MQTT server-certificate and certificates for chirpstack clients
cd $MAIN_CERT_DIR
cfssl gencert -ca ca.pem -ca-key ca-key.pem -config ca-config.json -profile server mqtt-server.json | cfssljson -bare mqtt-server

cfssl gencert -ca ca.pem -ca-key ca-key.pem -config ca-config.json -profile client chirpstack.json | cfssljson -bare chirpstack

cfssl gencert -ca ca.pem -ca-key ca-key.pem -config ca-config.json -profile client chirpstack_client_EU868.json | cfssljson -bare chirpstack_client_EU868

cfssl gencert -ca ca.pem -ca-key ca-key.pem -config ca-config.json -profile client chirpstack_client_EU433.json | cfssljson -bare chirpstack_client_EU433

cfssl gencert -ca ca.pem -ca-key ca-key.pem -config ca-config.json -profile client chirpstack_client_IN865.json | cfssljson -bare chirpstack_client_IN865

#cfssl gencert -ca ca.pem -ca-key ca-key.pem -config ca-config.json -profile client chirpstack_client_KZ865.json | cfssljson -bare chirpstack_client_KZ865

chown $USERNAME:$USERNAME $MAIN_CERT_DIR/*

#Remove old ChirpStack certificates:
rm -rf $CHIRPSTACK_CERT_DIR/*

#Copy ChirpStack client certificates
cd $MAIN_CERT_DIR
cp ca.pem ca-key.pem chirpstack-key.pem chirpstack.pem chirpstack_client_EU433-key.pem chirpstack_client_EU433.pem chirpstack_client_EU868-key.pem chirpstack_client_EU868.pem chirpstack_client_IN865-key.pem chirpstack_client_IN865.pem $CHIRPSTACK_CERT_DIR/
#cp ca.pem ca-key.pem chirpstack-key.pem chirpstack.pem chirpstack_client_EU433-key.pem chirpstack_client_EU433.pem chirpstack_client_EU868-key.pem chirpstack_client_EU868.pem chirpstack_client_IN865-key.pem chirpstack_client_IN865.pem chirpstack_client_KZ865-key.pem chirpstack_client_KZ865.pem $CHIRPSTACK_CERT_DIR/
chown -R $USERNAME:$USERNAME $CHIRPSTACK_CERT_DIR
chmod 664 $CHIRPSTACK_CERT_DIR/*

#Remove old mosquitto certificates:
rm -rf $MOSQUITTO_CERT_DIR/*

#Copy ChirpStack client certificates
cd $MAIN_CERT_DIR
cp ca.pem mqtt-server.pem mqtt-server-key.pem $MOSQUITTO_CERT_DIR/
chown -R $USERNAME:$USERNAME $MOSQUITTO_CERT_DIR
chmod 664 $MOSQUITTO_CERT_DIR/*
