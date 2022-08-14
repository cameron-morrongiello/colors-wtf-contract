require('@nomiclabs/hardhat-ethers');
require("@nomiclabs/hardhat-ganache");

const { alchemyApiKey, mnemonic } = require('./secrets.json');

module.exports = {
  solidity: "0.8.9",
  networks: {
         rinkeby: {
           url: `https://eth-rinkeby.alchemyapi.io/v2/${alchemyApiKey}`,
           accounts: { mnemonic: mnemonic },
         },
      },
};