const Box = artifacts.require('BEBoxMall');

const config = require("../config/config");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(
    Box,
    config.admins.proposers,
    config.admins.executors
    );
  const boxInstance = await Box.deployed();
  if(boxInstance) {
    console.log("BEBoxMall successfully deployed.")
  }
  try {
    await boxInstance.setPaymentReceivedAddress(config.market.feeToAddress);
    console.log(
      `update payment received address: ${config.market.feeToAddress}`
    );
  } catch (err) {
    console.log(err);
  }
}