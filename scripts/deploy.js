async function main () {
  // We get the contract to deploy
  const Box = await ethers.getContractFactory('ColorsWtf');
  console.log('Deploying ColorsWtf...');
  const box = await Box.deploy();
  await box.deployed();
  console.log('ColorsWtf deployed to:', box.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });