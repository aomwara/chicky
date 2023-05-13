import { ethers } from "hardhat";
import hre from "hardhat";
import jsonFile from "jsonfile";

async function main() {
  const name = await ethers.getContractFactory("Name");
  const nameContract = await name.deploy();
  await nameContract.deployed();
  console.log("Name deployed to:", nameContract.address);

  jsonFile.writeFileSync("config.json", {
    name: nameContract.address,
  });
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
