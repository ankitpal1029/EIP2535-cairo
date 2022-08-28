%lang starknet
from tests.constants import owner_public_key

@external
func test_deploy_diamond{syscall_ptr : felt*, range_check_ptr}(
    arguments
):
    alloc_locals
    local deployer_address: felt
    local diamond_address: felt

    let (_owner_public_key) = owner_public_key()

    %{
        print("setting up environemt...")
        deployer = deploy_contract('./lib/cairo_contracts/src/openzeppelin/account/presets/Account.cairo', [ids._owner_public_key])

        print("deployer address: ", deployer.contract_address)
        deployer_address = deployer.contract_address
    %}


    return()
    
end
