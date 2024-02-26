// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const { ethers, upgrades } = require('hardhat');

async function main() {
  const uniswapV2RouterAddress = '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D';

  const Contract = await ethers.getContractFactory('ERC20SwapperContract');
  console.log('Deploying Contract...');
  const contract = await upgrades.deployProxy(Contract, [uniswapV2RouterAddress], { initializer: 'initialize' });
  // await contract.waitForDeployment();

  console.log(`Contract Deployed to: ${contract.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
