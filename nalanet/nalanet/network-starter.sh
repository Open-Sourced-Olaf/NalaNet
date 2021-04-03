function _exit() {
    printf "Exiting:%s\n" "$1"
    exit -1
}

# Exit on first error, print all commands.
set -ev
set -o pipefail

# Where am I?
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set configuration path
export FABRIC_CFG_PATH="${DIR}/../config"

cd "${DIR}/../../../MLH/fabric-samples/../../MLH/fabric-samples/test-network/"

# Kill all the running docker stuff
docker kill cliGA cliPA logspout || true
./network.sh down
# Here we are using -ca flag to create crypto material using Fabric-CA
./network.sh up createChannel -ca -s couchdb

# Copy the connection profiles so they are in the correct organizations.
cp "${DIR}/../../../MLH/fabric-samples/../../MLH/fabric-samples/test-network/organizations/peerOrganizations/ga.nalanet.com/connection-ga.yaml" "${DIR}/organizations/GA/gateway/"
cp "${DIR}/../../../MLH/fabric-samples/test-network/organizations/peerOrganizations/pa.nalanet.com/connection-pa.yaml" "${DIR}/organizations/PA/gateway/"

cp ${DIR}/../../../MLH/fabric-samples/test-network/organizations/peerOrganizations/ga.nalanet.com/users/User1@ga.nalanet.com/msp/signcerts/* ${DIR}/../../../MLH/fabric-samples/test-network/organizations/peerOrganizations/ga.nalanet.com/users/User1@ga.nalanet.com/msp/signcerts/User1@ga.nalanet.com-cert.pem
cp ${DIR}/../../../MLH/fabric-samples/test-network/organizations/peerOrganizations/ga.nalanet.com/users/User1@ga.nalanet.com/msp/keystore/* ${DIR}/../../../MLH/fabric-samples/test-network/organizations/peerOrganizations/ga.nalanet.com/users/User1@ga.nalanet.com/msp/keystore/priv_sk

cp ${DIR}/../../../MLH/fabric-samples/test-network/organizations/peerOrganizations/pa.nalanet.com/users/User1@pa.nalanet.com/msp/signcerts/* ${DIR}/../../../MLH/fabric-samples/test-network/organizations/peerOrganizations/pa.nalanet.com/users/User1@pa.nalanet.com/msp/signcerts/User1@pa.nalanet.com-cert.pem
cp ${DIR}/../../../MLH/fabric-samples/test-network/organizations/peerOrganizations/pa.nalanet.com/users/User1@pa.nalanet.com/msp/keystore/* ${DIR}/../../../MLH/fabric-samples/test-network/organizations/peerOrganizations/pa.nalanet.com/users/User1@pa.nalanet.com/msp/keystore/priv_sk

echo Suggest that you monitor the docker containers by running
echo "./organizations/GA/configuration/cli/monitordocker.sh net_test"
