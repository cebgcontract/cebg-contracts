const TimelockController = artifacts.require('BETimelockController');
const Box = artifacts.require('BEBoxMall');
const Coin = artifacts.require('BECoin');
const Hero = artifacts.require('BEHero');
const Equip = artifacts.require('BEEquipment');
const Chip = artifacts.require('BEChip');
const MarketPlace = artifacts.require('MarketPlace');
const Factory = artifacts.require('MinterFactory');
const EvolveProxy = artifacts.require('EvolveProxy');
const config = require("../config/config");


module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(
    TimelockController,
    config.admins.proposers,
    config.admins.executors
    );
  const timelockInstance = await TimelockController.deployed();
  if(timelockInstance) {
    console.log("TimelockController successfully deployed.")
  }
  try {
    const marketInstance = await MarketPlace.deployed();
    await marketInstance.transferOwnership(timelockInstance.address);
    console.log('MarketPlace onwer has change to: ', timelockInstance.address);
    const heroInstance = await Hero.deployed();
    await heroInstance.transferOwnership(timelockInstance.address);
    console.log('Hero onwer has change to: ', timelockInstance.address);
    const equipInstance = await Equip.deployed();
    await equipInstance.transferOwnership(timelockInstance.address);
    console.log('Equip onwer has change to: ', timelockInstance.address);
    const chipInstance = await Chip.deployed();
    await chipInstance.transferOwnership(timelockInstance.address);
    console.log('Chip onwer has change to: ', timelockInstance.address);
  } catch(err) {
    console.log('generate config with error: ', err);
  }
}