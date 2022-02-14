const Factory = artifacts.require('MinterFactory');
const Hero = artifacts.require('BEHero');
const Equip = artifacts.require('BEEquipment');
const Chip = artifacts.require('BEChip');

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(Factory);
  const factoryInstance = await Factory.deployed();
  if(factoryInstance) {
    console.log("Mint Factory successfully deployed.")
  }
  try {
    let heroInstance = await Hero.deployed();
    let equipInstance = await Equip.deployed();
    let chipInstance = await Chip.deployed();
    factoryInstance.init([
      heroInstance.address,
      equipInstance.address,
      chipInstance.address
    ])
    heroInstance.setMintFactory(factoryInstance.address);
    equipInstance.setMintFactory(factoryInstance.address);
    chipInstance.setMintFactory(factoryInstance.address);
    console.log(
      `Allow factory ${factoryInstance.address} to mint contract \n hero: ${heroInstance.address}, \n equip: ${equipInstance.address}, \n chip: ${chipInstance.address}`
    );
  } catch(err) {
    console.log(err);
  }
}