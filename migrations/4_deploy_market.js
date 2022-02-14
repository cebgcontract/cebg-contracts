const MarketPlace = artifacts.require('MarketPlace');
const Hero = artifacts.require('BEHero');
const Equip = artifacts.require('BEEquipment');
const Chip = artifacts.require('BEChip');
const config = require("../config/config");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(MarketPlace);
  const marketInstance = await MarketPlace.deployed();
  if(marketInstance) {
    console.log("MarketPlace successfully deployed.")
  }
  try {
    marketInstance.setFeeToAddress(config.market.feeToAddress);
    marketInstance.setPaymentTokens(config.market.paymentTokens);
  } catch(err) {
    console.log("MarketPlace setFeeToAddress or setPaymentTokens with error", err);
  }

  // add marketplace to whitelist
  try {
    let heroInstance = await Hero.deployed();
    await heroInstance.addApprovalWhitelist(marketInstance.address);
    let equipInstance = await Equip.deployed();
    await equipInstance.addApprovalWhitelist(marketInstance.address);
    let chipInstance = await Chip.deployed();
    await chipInstance.addApprovalWhitelist(marketInstance.address);
    console.log(
      `Allow operation ${marketInstance.address} to reduce gas fee`
    );
  } catch (err) {
    console.log(err);
  }
}