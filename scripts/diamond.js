const FacetCutAction = { Add: 0, Replace: 1, Remove: 2 };

// get function selectors from ABI
function getSelectors(getSelectorFromName, contract) {
  const contractAbi = contract.abi;
  const abiKeys = Object.keys(contractAbi);
  let funcSelectors = [];
  abiKeys.forEach((item) => {
    if (contractAbi[item].type == "function") {
      funcSelectors.push(getSelectorFromName(contractAbi[item].name));
    }
  });
  return funcSelectors;
}
exports.getSelectors = getSelectors;
exports.FacetCutAction = FacetCutAction;
