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

router.get("/getAllAssets", async function (req, res) {
  try {
    let contract = await setUpContract(
      ccp,
      gateway,
      channelName,
      chaincodeName,
      org1UserId
    );
    let result = await contract.evaluateTransaction("GetAllAssets");

    res.status(200).json({ response: JSON.parse(result.toString()) });

    await gateway.disconnect();
  } catch (error) {
    console.error(`Failed to evaluate transaction: ${error}`);
    res.status(500).json({ error: error });
  }
});

router.get("/readAsset/:assetId", async function (req, res) {
  try {
    let contract = await setUpContract(
      ccp,
      gateway,
      channelName,
      chaincodeName,
      org1UserId
    );
    let result = await contract.evaluateTransaction(
      "ReadAsset",
      req.params.assetId
    );

    res.status(200).json({ response: JSON.parse(result.toString()) });

    await gateway.disconnect();
  } catch (error) {
    console.error(`Failed to evaluate transaction: ${error}`);
    res.status(500).json({ error: error });
  }
});

router.get("/assetExists/:assetId", async function (req, res) {
  try {
    let contract = await setUpContract(
      ccp,
      gateway,
      channelName,
      chaincodeName,
      org1UserId
    );
    let result = await contract.evaluateTransaction(
      "AssetExists",
      req.params.assetId
    );

    res.status(200).json({ response: JSON.parse(result.toString()) });

    await gateway.disconnect();
  } catch (error) {
    console.error(`Failed to evaluate transaction: ${error}`);
    res.status(500).json({ error: error });
  }
});

router.post("/createAsset", async function (req, res) {
  try {
    let contract = await setUpContract(
      ccp,
      gateway,
      channelName,
      chaincodeName,
      org1UserId
    );
    let result = await contract.submitTransaction(
      "CreateAsset",
      req.body.assetId,
      req.body.color,
      req.body.size,
      req.body.owner,
      req.body.appraisedValue
    );

    res.json({ response: JSON.parse(result.toString()) });

    await gateway.disconnect();
  } catch (error) {
    console.error(`Failed to evaluate transaction: ${error}`);
    res.json({ error: error });
  }
});

router.post("/updateAsset", async function (req, res) {
  try {
    let contract = await setUpContract(
      ccp,
      gateway,
      channelName,
      chaincodeName,
      org1UserId
    );
    let result = await contract.submitTransaction(
      "UpdateAsset",
      req.body.assetId,
      req.body.color,
      req.body.size,
      req.body.owner,
      req.body.appraisedValue
    );

    res.send('Asset updated');

    await gateway.disconnect();
  } catch (error) {
    console.error(`Failed to evaluate transaction: ${error}`);
    res.json({ error: error });
  }
});

router.post("/transferAsset", async function (req, res) {
  try {
    let contract = await setUpContract(
      ccp,
      gateway,
      channelName,
      chaincodeName,
      org1UserId
    );
    let result = await contract.submitTransaction(
      "TransferAsset",
      req.body.assetId,
      req.body.owner
    );

    res.send('Asset transferred');

    await gateway.disconnect();
  } catch (error) {
    console.error(`Failed to evaluate transaction: ${error}`);
    res.json({ error: error });
  }
});

module.exports = router;
