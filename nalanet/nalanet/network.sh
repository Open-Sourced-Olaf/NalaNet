#!/bin/bash
#
# prepending $PWD/../bin to PATH to ensure we are picking up the correct binaries
# this may be commented out to resolve installed version of tools if desired
export PATH=${PWD}/../bin:$PATH

#TODO: there are two locatiosn for configtx
export FABRIC_CFG_PATH=${PWD}/configtx
export VERBOSE=false

. scripts/utils.sh

# Obtain CONTAINER_IDS and remove them
# TODO Might want to make this optional - could clear other containers
# This function is called when you bring a network down
function clearContainers() {
  CONTAINER_IDS=$(docker ps -a | awk '($2 ~ /dev-peer.*/) {print $1}')
  if [ -z "$CONTAINER_IDS" -o "$CONTAINER_IDS" == " " ]; then
    infoln "No containers available for deletion"
  else
    docker rm -f $CONTAINER_IDS
  fi
}

# Delete any images that were generated as a part of this setup
# specifically the following images are often left behind:
# This function is called when you bring the network down
function removeUnwantedImages() {
  DOCKER_IMAGE_IDS=$(docker images | awk '($1 ~ /dev-peer.*/) {print $3}')
  if [ -z "$DOCKER_IMAGE_IDS" -o "$DOCKER_IMAGE_IDS" == " " ]; then
    infoln "No images available for deletion"
  else
    docker rmi -f $DOCKER_IMAGE_IDS
  fi
}

# Versions of fabric known not to work with the test network
NONWORKING_VERSIONS="^1\.0\. ^1\.1\. ^1\.2\. ^1\.3\. ^1\.4\."

# Do some basic sanity checking to make sure that the appropriate versions of fabric
# binaries/images are available. In the future, additional checking for the presence
# of go or other items could be added.
function checkPrereqs() {
  ## Check if your have cloned the peer binaries and configuration files.
  peer version >/dev/null 2>&1

  if [[ $? -ne 0 || ! -d "../config" ]]; then
    errorln "Peer binary and configuration files not found.."
    errorln
    errorln "Follow the instructions in the Fabric docs to install the Fabric Binaries:"
    errorln "https://hyperledger-fabric.readthedocs.io/en/latest/install.html"
    exit 1
  fi
  # use the fabric tools container to see if the samples and binaries match your
  # docker images
  LOCAL_VERSION=$(peer version | sed -ne 's/ Version: //p')
  DOCKER_IMAGE_VERSION=$(docker run --rm hyperledger/fabric-tools:$IMAGETAG peer version | sed -ne 's/ Version: //p' | head -1)

  infoln "LOCAL_VERSION=$LOCAL_VERSION"
  infoln "DOCKER_IMAGE_VERSION=$DOCKER_IMAGE_VERSION"

  if [ "$LOCAL_VERSION" != "$DOCKER_IMAGE_VERSION" ]; then
    warnln "Local fabric binaries and docker images are out of  sync. This may cause problems."
  fi

  for UNSUPPORTED_VERSION in $NONWORKING_VERSIONS; do
    infoln "$LOCAL_VERSION" | grep -q $UNSUPPORTED_VERSION
    if [ $? -eq 0 ]; then
      fatalln "Local Fabric binary version of $LOCAL_VERSION does not match the versions supported by the test network."
    fi

    infoln "$DOCKER_IMAGE_VERSION" | grep -q $UNSUPPORTED_VERSION
    if [ $? -eq 0 ]; then
      fatalln "Fabric Docker image version of $DOCKER_IMAGE_VERSION does not match the versions supported by the test network."
    fi
  done

  ## Check for fabric-ca
  if [ "$CRYPTO" == "Certificate Authorities" ]; then

    fabric-ca-client version >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
      errorln "fabric-ca-client binary not found.."
      errorln
      errorln "Follow the instructions in the Fabric docs to install the Fabric Binaries:"
      errorln "https://hyperledger-fabric.readthedocs.io/en/latest/install.html"
      exit 1
    fi
    CA_LOCAL_VERSION=$(fabric-ca-client version | sed -ne 's/ Version: //p')
    CA_DOCKER_IMAGE_VERSION=$(docker run --rm hyperledger/fabric-ca:$CA_IMAGETAG fabric-ca-client version | sed -ne 's/ Version: //p' | head -1)
    infoln "CA_LOCAL_VERSION=$CA_LOCAL_VERSION"
    infoln "CA_DOCKER_IMAGE_VERSION=$CA_DOCKER_IMAGE_VERSION"

    if [ "$CA_LOCAL_VERSION" != "$CA_DOCKER_IMAGE_VERSION" ]; then
      warnln "Local fabric-ca binaries and docker images are out of sync. This may cause problems."
    fi
  fi
}

# Before you can bring up a network, each organization needs to generate the crypto
# material that will define that organization on the network. Because Hyperledger
# Fabric is a permissioned blockchain, each node and user on the network needs to
# use certificates and keys to sign and verify its actions. In addition, each user
# needs to belong to an organization that is recognized as a member of the network.
# You can use the Cryptogen tool or Fabric CAs to generate the organization crypto
# material.

# By default, the sample network uses cryptogen. Cryptogen is a tool that is
# meant for development and testing that can quickly create the certificates and keys
# that can be consumed by a Fabric network. The cryptogen tool consumes a series
# of configuration files for each organization in the "organizations/cryptogen"
# directory. Cryptogen uses the files to generate the crypto  material for each
# org in the "organizations" directory.

# You can also Fabric CAs to generate the crypto material. CAs sign the certificates
# and keys that they generate to create a valid root of trust for each organization.
# The script uses Docker Compose to bring up three CAs, one for each peer organization
# and the ordering organization. The configuration file for creating the Fabric CA
# servers are in the "organizations/fabric-ca" directory. Within the same directory,
# the "registerEnroll.sh" script uses the Fabric CA client to create the identities,
# certificates, and MSP folders that are needed to create the test network in the
# "organizations/ordererOrganizations" directory.

# Create Organization crypto material using cryptogen or CAs
function createOrgs() {
  if [ -d "organizations/peerOrganizations" ]; then
    rm -Rf organizations/peerOrganizations && rm -Rf organizations/ordererOrganizations
  fi

  # Create crypto material using cryptogen
  if [ "$CRYPTO" == "cryptogen" ]; then
    which cryptogen
    if [ "$?" -ne 0 ]; then
      fatalln "cryptogen tool not found. exiting"
    fi
    infoln "Generating certificates using cryptogen tool"

    infoln "Creating GA Identities"

    set -x
    cryptogen generate --config=./organizations/cryptogen/crypto-config-ga.yaml --output="organizations"
    res=$?
    { set +x; } 2>/dev/null
    if [ $res -ne 0 ]; then
      fatalln "Failed to generate certificates..."
    fi

    infoln "Creating PA Identities"

    set -x
    cryptogen generate --config=./organizations/cryptogen/crypto-config-pa.yaml
    --output="organizations"
    res=$?
    { set +x; } 2>/dev/null
    if [ $res -ne 0 ]; then
      fatalln "Failed to generate certificates..."
    fi

    infoln "Creating TaxAgent Identities"

    set -x
    cryptogen generate --config=./organizations/cryptogen/crypto-confgi-taxagent.yaml
    --output="organizations"
    res=$?
    { set +x; } 2>/dev/null
    if [ $res -ne 0 ]; then
      fatalln "Failed to generate certificates..."
    fi

    infoln "Creating Orderer Org Identities"

    set -x
    cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml
    --output="organizations"
    res=$?
    { set +x; } 2>/dev/null
    if [ $res -ne 0 ]; then
      fatalln "Failed to generate certificates..."
    fi

  fi
}
