%lang starknet
from tests.constants import owner_public_key, new_admin_A
from starkware.cairo.common.cairo_builtins import HashBuiltin
from src.interfaces.ifacet_registry import FacetAction

@contract_interface
namespace IA:
    func getter() -> (counter_val: felt):
    end
    func setter(addVal: felt):
    end
end

@contract_interface
namespace IB:
    func addAdmin(new_admin: felt):
    end
    func transferAdmin(new_admin: felt):
    end
    func renounceAdmin():
    end
end
@external
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
):
    alloc_locals
    local deployer_address: felt
    local diamond_address: felt
    let (_owner_public_key) = owner_public_key()
    let (_new_admin_A_public_key) = new_admin_A()
    %{
        print("setting up environemt...")
        deployer_address = deploy_contract('./lib/cairo_contracts/src/openzeppelin/account/presets/Account.cairo', [ids._owner_public_key]).contract_address
        print(f"deployer address: {deployer_address}")
        context.deployer_address = deployer_address

        context.new_admin_A_address = deploy_contract('./lib/cairo_contracts/src/openzeppelin/account/presets/Account.cairo', [ids._new_admin_A_public_key]).contract_address

        # deploying proxy and declaring facet hashes
        stop_prank_callable = start_prank(deployer_address)
        facet_A_class_hash = declare('./src/A.cairo').class_hash
        proxy_address = deploy_contract('./src/Proxy.cairo', [deployer_address]).contract_address
        context.proxy_address = proxy_address
        print(f"proxy address: {proxy_address}")

        from starkware.starknet.public.abi import get_selector_from_name
        import json

        cut_params = []
        actions = []
        facets = ["A", "B"]

        FACET_FUNCTION_ADD = 0
        selectors_count = 0

        print("registring facets...")
        for facet in facets:
            facet_hash = declare(f"./src/{facet}.cairo").class_hash
            with open(f"./build/{facet}_abi.json", 'r') as f:
                abi = json.load(f)
                for item in abi:
                    if item['type'] == 'function':
                        selector = get_selector_from_name(item['name'])
                        store(proxy_address, "selector_address_registry", [facet_hash], key=[selector])
                        store(proxy_address, "selector_address_registry_len", [selectors_count + 1])
                        selectors_count += 1
        
        print("facets registered.")
        stop_prank_callable()
    %}
    return()
end



@external
func test_A{syscall_ptr : felt*, range_check_ptr}(
):
    %{ 
        print(f"--------------------------------------------")
        print(f"starting test_A")
    %}
    alloc_locals
    tempvar proxy_address
    %{ stop_prank_callable = start_prank(context.deployer_address, target_contract_address=context.proxy_address)%}
    %{ 
        ids.proxy_address = context.proxy_address
        print(f"proxy address from context: {ids.proxy_address}")
    %}

    # increment counter on A
    %{ print("A should return 0 upon getter") %}
    let (res) = IA.getter(proxy_address)
    assert res = 0
    tempvar adminA
    %{ 
        print("A should return 10") 
    %}
    IA.setter(proxy_address, addVal=10)
    let (res2) = IA.getter(proxy_address)
    assert res2 = 10
    %{ 
        stop_prank_callable()
        print(f"--------------------------------------------")
    %}
    return()
end

@external
func test_upgrade_persistance{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
):
    %{ 
        print(f"--------------------------------------------")
        print(f"starting test_upgrade_persistance")
    %}
    %{ 
        stop_prank_callable = start_prank(context.deployer_address, target_contract_address=context.proxy_address)
    %}
    %{ print("fetching admin of A")%}
    alloc_locals
    local adminA: felt
    local proxy_address: felt
    local new_admin_A_address: felt
    tempvar deployer_address
    %{ 
        ids.deployer_address = context.deployer_address
        print(f"{context.proxy_address}")
        ids.adminA = load(context.proxy_address, "admin", "felt")[0]
        ids.proxy_address = context.proxy_address
        print(f"deployer address: {ids.deployer_address}")
    %}
    IA.setter(proxy_address, addVal=10)
    assert adminA = deployer_address

    %{ 
        print(f"change admin of A and upgrade to A_new")
        ids.new_admin_A_address = context.new_admin_A_address
    %}
    
    IB.transferAdmin(proxy_address, new_admin_A_address)

    %{expect_revert(error_message="Not Admin: Not authorised")%}
    IA.setter(proxy_address, 10)


    # upgrading A with A_new
    %{ 
        from starkware.starknet.public.abi import get_selector_from_name
        import json

        cut_params = []
        actions = []
        facets = ["A_new"]
        FACET_FUNCTION_ADD = 0

        print("registring facet A_new...")
        for facet in facets:
            facet_hash = declare(f"./src/{facet}.cairo").class_hash
            with open(f"./build/{facet}_abi.json", 'r') as f:
                abi = json.load(f)
                for item in abi:
                    if item['type'] == 'function':
                        selector = get_selector_from_name(item['name'])
                        store(proxy_address, "selector_address_registry", [facet_hash], key=[selector])
                        store(proxy_address, "selector_address_registry_len", [selectors_count + 1])
                        selectors_count += 1
        
        print("facets registered.")


    %}
    

    %{ 
        stop_prank_callable()
    %}



    return()
    
end
