/*
 * This application has 6 basic steps:
 * 1. Select an identity from a wallet
 * 2. Connect to network gateway
 * 3. Access PaperNet network
 * 4. Construct request to buy commercial paper
 * 5. Submit transaction
 * 6. Process response
 */

'use strict'

// Bring key classes into scope, most importantly Fabric SDK network class 

const fs = require('fs')
const yaml = require('js-yaml')
const { Wallets, Gateway } = require('fabric-network')
// Calling Go from js. this is is bluing trouble
const land = require('../contract/nalanet')

async function main() {

    // A wallet stores a collection of identities for use
    const wallet = await Wallets.newFileSystemWallet('../identity/user/isabella/wallet');

    // A gateway defines the peers used to access Fabric networks
    const gateway = new Gateway();

    try {
        const username = 'Bushra'

        // Load connection profile; will be used to locate a gateway
        let connectionProfile = yaml.safeLoad(fs.readFileSync('../gateway/connection-or'))
    }


}