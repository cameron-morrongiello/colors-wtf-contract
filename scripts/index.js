// const url = "http://127.0.0.1:8545";
// const provider = new ethers.providers.JsonRpcProvider(url);
// provider.pollingInterval = 100;

const { mnemonic,  alchemyApiKey} = require('./../secrets.json');


const provider = new ethers.providers.AlchemyProvider("rinkeby", alchemyApiKey);

async function main () {
  


  const address = '0xCD8cB95E5bE5ef3107188bc76dA0f41DA2938967';
  const ColorsWtf = await ethers.getContractFactory('ColorsWtf');
  const colors = await ColorsWtf.attach(address);

  var wallet = ethers.Wallet.fromMnemonic(mnemonic);

  var signer = wallet.connect(provider);

  console.log(await provider.getBalance(await (await signer.getAddress())));


  // console.log(addr1);
  // console.log(addr2);

  const tx = await colors.connect(signer).blend(255, 255, 255, 127, 127, 127, "give me money", {value: ethers.utils.parseEther("0.002")});

  // const value = await colors.getNameFromId(2);
  // console.log(`Color index ${2} name is ${value.toString()}`);

  const rec = await tx.wait();

  console.log(rec);


}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });