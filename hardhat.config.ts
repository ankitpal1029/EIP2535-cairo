import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@shardlabs/starknet-hardhat-plugin";

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  starknet: {
    venv: "~/cairo_venv",
  },
};

export default config;
