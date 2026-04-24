import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { parseEther } from "viem";

const TokenModule = buildModule("TokenModule", (m) => {
  // Set your constructor arguments here
  const name = m.getParameter("name", "MyLabToken");
  const symbol = m.getParameter("symbol", "MLT");
  const initialSupply = m.getParameter("initialSupply", parseEther("1000"));

  // This tells Ignition to deploy the "MyToken" contract
  const token = m.contract("MyToken", [name, symbol, initialSupply]);

  return { token };
});

export default TokenModule;