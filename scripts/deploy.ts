import hardhat from "hardhat";
import {
  StarknetContract,
  StarknetContractFactory,
  Account,
} from "hardhat/types/runtime";
import { hash } from "starknet";
const { getSelectors } = require("./diamond.js");

type CutParams = {
  facet_address: string;
  action: number;
  selector: string;
};

const FACET_FUNCTION_ADD = 0;
const FACET_FUNCTION_REPLACE = 1;
const FACET_FUNCTION_REMOVE = 2;

export const deployDiamond = async () => {
  console.log("Deploying account:");
  const account: Account = await hardhat.starknet.deployAccount("OpenZeppelin");
  console.log("yo");

  // deploying Proxy
  const proxy: StarknetContractFactory =
    await hardhat.starknet.getContractFactory("Proxy");
  const proxyContract: StarknetContract = await proxy.deploy({
    owner: account.address,
  });
  console.log(`Proxy deployed to: ${proxyContract.address}`);
  console.log(`Current admin address: ${account.address}`);

  const facetNames = ["A", "B"];

  const cutParams: CutParams[] = [];
  for (let i = 0; i < facetNames.length; i++) {
    let facet: StarknetContractFactory =
      await hardhat.starknet.getContractFactory(facetNames[i]);
    let facetContractClassHash: string = await facet.declare();

    const funcSelectors = getSelectors(hash.getSelectorFromName, facet);
    funcSelectors.forEach((sel: string) => {
      cutParams.push({
        facet_address: facetContractClassHash,
        action: FACET_FUNCTION_ADD,
        selector: sel,
      });
    });
  }

  const contractFactory = await hardhat.starknet.getContractFactory("Proxy");
  const contract = await contractFactory.getContractAt(proxyContract.address);
  let tx = await account.invoke(contract, "manage_facet_actions", {
    actions: cutParams,
    address: 0,
    calldata: [],
  });
  console.log("proxy tx", tx);
  return [proxyContract.address, account] as const;
};

if (require.main === module) {
  deployDiamond()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
}
