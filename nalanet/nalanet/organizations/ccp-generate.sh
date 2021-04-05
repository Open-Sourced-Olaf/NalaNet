#!/bin/bash

function one_line_pem() {
    echo "$(awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1)"
}

function json_ccp() {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp() {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=ga
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/ga.nalanet.com/tlsca/tlsca.ga.nalanet.com-cert.pem
CAPEM=organizations/peerOrganizations/ga.nalanet.com/ca/ca.ga.nalanet.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" >organizations/peerOrganizations/ga.nalanet.com/connection-ga.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" >organizations/peerOrganizations/ga.nalanet.com/connection-ga.yaml

ORG=pa
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/pa.nalanet.com/tlsca/tlsca.pa.nalanet.com-cert.pem
CAPEM=organizations/peerOrganizations/pa.nalanet.com/ca/ca.pa.nalanet.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" >organizations/peerOrganizations/pa.nalanet.com/connection-pa.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" >organizations/peerOrganizations/pa.nalanet.com/connection-pa.yaml

ORG=ta
P0PORT=10051
CAPORT=10054
PEERPEM=organizations/peerOrganizations/ta.nalanet.com/tlsca/tlsca.ta.nalanet.com-cert.pem
CAPEM=organizations/peerOrganizations/ta.nalanet.com/ca/ca.ta.nalanet.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" >organizations/peerOrganizations/ta.nalanet.com/connection-ta.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" >organizations/peerOrganizations/ta.nalanet.com/connection-ta.yaml
