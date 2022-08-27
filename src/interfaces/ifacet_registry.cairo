%lang starknet

const FACET_FUNCTION_ADD = 0
const FACET_FUNCTION_REPLACE = 1
const FACET_FUNCTION_REMOVE = 2

struct FacetAction:
    member facet_address : felt
    member action : felt
    member selector : felt
end

@contract_interface
namespace IFacetRegistry:
    func changeModules(
            actions_len : felt, actions : FacetAction*, address : felt,
            calldata_len : felt, calldata : felt*):
    end
end
