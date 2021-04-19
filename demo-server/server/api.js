var express = require("express");
var router = express.Router();

const { Gateway } = require("fabric-network");
const {
  buildCCPOrg1,
} = require("utils/AppUtil.js");

const { setUpContract } = require("../utils/ServerUtils.js");

const channelName = "mychannel";
const chaincodeName = "basic";
const org1UserId = "appUser";

const ccp = buildCCPOrg1();
const gateway = new Gateway();

router.get("/getAllLand", async function (req, res) {
  try {
    let contract = await setUpContract(
      ccp,
      gateway,
      channelName,
      chaincodeName,
      org1UserId
    );
    let result = await contract.evaluateTransaction("GetAllLand");

    res.status(200).json({ response: JSON.parse(result.toString()) });

    await gateway.disconnect();
  } catch (error) {
    console.error(`Failed to evaluate transaction: ${error}`);
    res.status(500).json({ error: error });
  }
});

router.get("/readAsset/:landNumber", async function (req, res) {
  try {
    let contract = await setUpContract(
      ccp,
      gateway,
      channelName,
      chaincodeName,
      org1UserId
    );
    let result = await contract.evaluateTransaction(
      "ReadLand",
      req.params.owner,
      req.params.landNumber
    );

    res.status(200).json({ response: JSON.parse(result.toString()) });

    await gateway.disconnect();
  } catch (error) {
    console.error(`Failed to evaluate transaction: ${error}`);
    res.status(500).json({ error: error });
  }
});

router.get("/landExists/:landNumber", async function (req, res) {
  try {
    let contract = await setUpContract(
      ccp,
      gateway,
      channelName,
      chaincodeName,
      org1UserId
    );
    let result = await contract.evaluateTransaction(
      "landExists",
      req.params.owner,
      req.params.landNumber
    );

    res.status(200).json({ response: JSON.parse(result.toString()) });

    await gateway.disconnect();
  } catch (error) {
    console.error(`Failed to evaluate transaction: ${error}`);
    res.status(500).json({ error: error });
  }
});

router.post("/registerLand", async function (req, res) {
  try {
    let contract = await setUpContract(
      ccp,
      gateway,
      channelName,
      chaincodeName,
      org1UserId
    );
    let result = await contract.submitTransaction(
      "Register",
      req.body.owner,
      req.body.landNumber,
      req.body.registerDateTime,
      req.body.faceValue,
    );

    res.json({ response: JSON.parse(result.toString()) });

    await gateway.disconnect();
  } catch (error) {
    console.error(`Failed to evaluate transaction: ${error}`);
    res.json({ error: error });
  }
});

router.post("/transferLand", async function (req, res) {
  try {
    let contract = await setUpContract(
      ccp,
      gateway,
      channelName,
      chaincodeName,
      org1UserId
    );
    let result = await contract.submitTransaction(
      "TransferLand",
      req.body.currentOwner,
      req.body.landID,
      req.body.newOner
    );

    res.send('Land transferred');

    await gateway.disconnect();
  } catch (error) {
    console.error(`Failed to evaluate transaction: ${error}`);
    res.json({ error: error });
  }
});

module.exports = router;
