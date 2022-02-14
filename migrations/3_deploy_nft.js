const Hero = artifacts.require('BEHero');
const Equip = artifacts.require('BEEquipment');
const Chip = artifacts.require('BEChip');
const config = require("../config/config");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(Hero);
  const heroInstance = await Hero.deployed();
  if(heroInstance) {
    heroInstance.updateBaseURI(config.token.baseTokenURI)
    console.log("BEHero successfully deployed.")
  }


  await deployer.deploy(Equip);
  const equipInstance = await Equip.deployed();
  if(equipInstance) {
    equipInstance.updateBaseURI(config.token.baseTokenURI)
    console.log("Equip successfully deployed.")
  }

  await deployer.deploy(Chip);
  const chipInstance = await Chip.deployed();
  if(chipInstance) {
    chipInstance.updateBaseURI(config.token.baseTokenURI)
    console.log("Chip successfully deployed.")
  }
}