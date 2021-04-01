function _exit(){
    printf "Exiting:%s\n" "$1"
    exit -1
}

# Exit on first error, print all commands.
set -ev
set -o pipefail

# Where am I?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Set configuration path
export FABRIC_CFG_PATH="${DIR}/../config"


cd "${DIR}/../../../MLH/fabric-samples/../../MLH/fabric-samples/test-network/"

# Kill all the running docker stuff
docker kill cliGA cliPA logspout || true
./network.sh down
# Here we are using -ca flag to create crypto material using Fabric-CA
./network.sh up createChannel -ca -s couchdb

# Copy the connection profiles so they are in the correct organizations.
cp "${DIR}/../../../MLH/fabric-samples/../../MLH/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/connection-org1.yaml" "${DIR}/organizations/GA/gateway/"
cp "${DIR}/../../../MLH/fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/connection-org2.yaml" "${DIR}/organizations/PA/gateway/"

cp ${DIR}/../../../MLH/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/signcerts/* ${DIR}/../../../MLH/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/signcerts/User1@org1.example.com-cert.pem
cp ${DIR}/../../../MLH/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/keystore/* ${DIR}/../../../MLH/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/keystore/priv_sk

cp ${DIR}/../../../MLH/fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp/signcerts/* ${DIR}/../../../MLH/fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp/signcerts/User1@org2.example.com-cert.pem
cp ${DIR}/../../../MLH/fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp/keystore/* ${DIR}/../../../MLH/fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp/keystore/priv_sk

echo Suggest that you monitor the docker containers by running
echo "./organizations/GA/configuration/cli/monitordocker.sh net_test"