import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@shardlabs/starknet-hardhat-plugin";

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  starknet: {
    // venv: "~/cairo_venv",
  },
  networks: {
    integratedDevnet: {
      url: "http://127.0.0.1:5050",
      // venv: "active",
      dockerizedVersion: "0.2.2",
    },
  },
};

export default config;
