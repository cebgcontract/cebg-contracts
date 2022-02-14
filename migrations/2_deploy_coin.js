const Coin = artifacts.require('BECoin');

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(Coin);
  const coinInstance = await Coin.deployed();
  if(coinInstance) {
    console.log("BECoin successfully deployed.")
  }
};