const { Wallets } = require("fabric-network");
const path = require("path");
const fs = require("fs");
const { buildWallet } = require("./AppUtil.js");

exports.setUpContract = async (
  ccp,
  gateway,
  channelName,
  chaincodeName,
  org1UserId
) => {
  const walletPath = '../wallet';
  const wallet = await buildWallet(Wallets, walletPath);

  await gateway.connect(ccp, {
    wallet,
    identity: org1UserId,
    discovery: { enabled: true, asLocalhost: true },
  });

  const network = await gateway.getNetwork(channelName);
  const contract = network.getContract(chaincodeName);
  return contract;
};
