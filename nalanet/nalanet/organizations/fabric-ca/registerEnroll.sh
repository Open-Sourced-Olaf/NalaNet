#!/bin/bash

function createGA() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/ga.nalanet.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/ga.nalanet.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-ga --tls.certfiles ${PWD}/organizations/fabric-ca/ga/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-ga.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-ga.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-ga.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-ga.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/ga.nalanet.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-ga --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ga/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-ga --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/ga/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-ga --id.name gaadmin --id.secret gaadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ga/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-ga -M ${PWD}/organizations/peerOrganizations/ga.nalanet.com/peers/peer0.ga.nalanet.com/msp --csr.hosts peer0.ga.nalanet.com --tls.certfiles ${PWD}/organizations/fabric-ca/ga/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ga.nalanet.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ga.nalanet.com/peers/peer0.ga.nalanet.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-ga -M ${PWD}/organizations/peerOrganizations/ga.nalanet.com/peers/peer0.ga.nalanet.com/tls --enrollment.profile tls --csr.hosts peer0.ga.nalanet.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ga/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ga.nalanet.com/peers/peer0.ga.nalanet.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ga.nalanet.com/peers/peer0.ga.nalanet.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ga.nalanet.com/peers/peer0.ga.nalanet.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ga.nalanet.com/peers/peer0.ga.nalanet.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ga.nalanet.com/peers/peer0.ga.nalanet.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ga.nalanet.com/peers/peer0.ga.nalanet.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ga.nalanet.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ga.nalanet.com/peers/peer0.ga.nalanet.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ga.nalanet.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ga.nalanet.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ga.nalanet.com/peers/peer0.ga.nalanet.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ga.nalanet.com/tlsca/tlsca.ga.nalanet.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ga.nalanet.com/ca
  cp ${PWD}/organizations/peerOrganizations/ga.nalanet.com/peers/peer0.ga.nalanet.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ga.nalanet.com/ca/ca.ga.nalanet.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-ga -M ${PWD}/organizations/peerOrganizations/ga.nalanet.com/users/User1@ga.nalanet.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ga/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ga.nalanet.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ga.nalanet.com/users/User1@ga.nalanet.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://gaadmin:gaadminpw@localhost:7054 --caname ca-ga -M ${PWD}/organizations/peerOrganizations/ga.nalanet.com/users/Admin@ga.nalanet.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ga/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ga.nalanet.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ga.nalanet.com/users/Admin@ga.nalanet.com/msp/config.yaml
}

function createPA() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/pa.nalanet.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/pa.nalanet.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-pa --tls.certfiles ${PWD}/organizations/fabric-ca/pa/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-pa.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-pa.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-pa.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-pa.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/pa.nalanet.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-pa --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/pa/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-pa --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/pa/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-pa --id.name paadmin --id.secret paadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/pa/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-pa -M ${PWD}/organizations/peerOrganizations/pa.nalanet.com/peers/peer0.pa.nalanet.com/msp --csr.hosts peer0.pa.nalanet.com --tls.certfiles ${PWD}/organizations/fabric-ca/pa/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/pa.nalanet.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/pa.nalanet.com/peers/peer0.pa.nalanet.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-pa -M ${PWD}/organizations/peerOrganizations/pa.nalanet.com/peers/peer0.pa.nalanet.com/tls --enrollment.profile tls --csr.hosts peer0.pa.nalanet.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/pa/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/pa.nalanet.com/peers/peer0.pa.nalanet.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/pa.nalanet.com/peers/peer0.pa.nalanet.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/pa.nalanet.com/peers/peer0.pa.nalanet.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/pa.nalanet.com/peers/peer0.pa.nalanet.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/pa.nalanet.com/peers/peer0.pa.nalanet.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/pa.nalanet.com/peers/peer0.pa.nalanet.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/pa.nalanet.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/pa.nalanet.com/peers/peer0.pa.nalanet.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/pa.nalanet.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/pa.nalanet.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/pa.nalanet.com/peers/peer0.pa.nalanet.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/pa.nalanet.com/tlsca/tlsca.pa.nalanet.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/pa.nalanet.com/ca
  cp ${PWD}/organizations/peerOrganizations/pa.nalanet.com/peers/peer0.pa.nalanet.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/pa.nalanet.com/ca/ca.pa.nalanet.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-pa -M ${PWD}/organizations/peerOrganizations/pa.nalanet.com/users/User1@pa.nalanet.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/pa/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/pa.nalanet.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/pa.nalanet.com/users/User1@pa.nalanet.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://paadmin:paadminpw@localhost:8054 --caname ca-pa -M ${PWD}/organizations/peerOrganizations/pa.nalanet.com/users/Admin@pa.nalanet.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/pa/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/pa.nalanet.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/pa.nalanet.com/users/Admin@pa.nalanet.com/msp/config.yaml
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/nalanet.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/nalanet.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/nalanet.com/msp/config.yaml

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/nalanet.com/orderers/orderer.nalanet.com/msp --csr.hosts orderer.nalanet.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/nalanet.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/nalanet.com/orderers/orderer.nalanet.com/msp/config.yaml

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/nalanet.com/orderers/orderer.nalanet.com/tls --enrollment.profile tls --csr.hosts orderer.nalanet.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/nalanet.com/orderers/orderer.nalanet.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/nalanet.com/orderers/orderer.nalanet.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/nalanet.com/orderers/orderer.nalanet.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/nalanet.com/orderers/orderer.nalanet.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/nalanet.com/orderers/orderer.nalanet.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/nalanet.com/orderers/orderer.nalanet.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/nalanet.com/orderers/orderer.nalanet.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/nalanet.com/orderers/orderer.nalanet.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/nalanet.com/orderers/orderer.nalanet.com/msp/tlscacerts/tlsca.nalanet.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/nalanet.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/nalanet.com/orderers/orderer.nalanet.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/nalanet.com/msp/tlscacerts/tlsca.nalanet.com-cert.pem

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/nalanet.com/users/Admin@nalanet.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/nalanet.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/nalanet.com/users/Admin@nalanet.com/msp/config.yaml
}

function createTA() {
  infoln "Enrolling the TA admin"
  mkdir -p organizations/peerOrganizations/ta.nalanet.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/ta.nalanet.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca-ta --tls.certfiles ${PWD}/organizations/fabric-ca/ta/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-ta.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate:cacerts/localhost-10084-ca-ta.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-ta.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-ta.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/ta.nalanet.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-ta --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/ta/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-ta --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/ta/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-ta --id.name taadmin --id.secret taadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ta/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca-ta -M ${PWD}/organizations/peerOrganizations/ta.nalanet.com/peers/peer0.ta.nalanet.com/msp --csr.hosts peer0.ta.nalanet.com --tls.certfiles ${PWD}/organizations/fabric-ca/ta/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ta.nalanet.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ta.nalanet.com/peers/peer0.ta.nalanet.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca-ta -M ${PWD}/organizations/peerOrganizations/ta.nalanet.com/peers/peer0.ta.nalanet.com/tls --enrollment.profile tls --csr.hosts peer0.ta.nalanet.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ta/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ta.nalanet.com/peers/peer0.ta.nalanet.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ta.nalanet.com/peers/peer0.ta.nalanet.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/ta.nalanet.com/peers/peer0.ta.nalanet.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/ta.nalanet.com/peers/peer0.ta.nalanet.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/ta.nalanet.com/peers/peer0.ta.nalanet.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/ta.nalanet.com/peers/peer0.ta.nalanet.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/ta.nalanet.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/ta.nalanet.com/peers/peer0.ta.nalanet.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ta.nalanet.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/ta.nalanet.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/ta.nalanet.com/peers/peer0.ta.nalanet.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/ta.nalanet.com/tlsca/tlsca.ta.nalanet.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/ta.nalanet.com/ca
  cp ${PWD}/organizations/peerOrganizations/ta.nalanet.com/peers/peer0.ta.nalanet.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/ta.nalanet.com/ca/ca.ta.nalanet.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca-ta -M ${PWD}/organizations/peerOrganizations/ta.nalanet.com/users/User1@ta.nalanet.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ta/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ta.nalanet.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ta.nalanet.com/users/User1@ta.nalanet.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://taadmin:taadminpw@localhost:10054 --caname ca-ta -M ${PWD}/organizations/peerOrganizations/ta.nalanet.com/users/Admin@ta.nalanet.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ta/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/ta.nalanet.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/ta.nalanet.com/users/Admin@ta.nalanet.com/msp/config.yaml

}
