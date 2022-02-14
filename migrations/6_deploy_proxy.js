const EvolveProxy = artifacts.require('EvolveProxy');
const Hero = artifacts.require('BEHero');
const Equip = artifacts.require('BEEquipment');
const Chip = artifacts.require('BEChip');

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(EvolveProxy);
  const proxyInstance = await EvolveProxy.deployed();
  if(proxyInstance) {
    console.log("EvolveProxy successfully deployed.")
  }
  try {
    let heroInstance = await Hero.deployed();
    let equipInstance = await Equip.deployed();
    let chipInstance = await Chip.deployed();
    proxyInstance.init([
      heroInstance.address,
      equipInstance.address,
      chipInstance.address
    ])
    heroInstance.setBurnProxy(proxyInstance.address);
    equipInstance.setBurnProxy(proxyInstance.address);
    chipInstance.setBurnProxy(proxyInstance.address);
    console.log(
      `Allow proxy ${proxyInstance.address} to burn contract \n hero: ${heroInstance.address}, \n equip: ${equipInstance.address}, \n chip: ${chipInstance.address}`
    );
  } catch(err) {
    console.log(err);
  }
}