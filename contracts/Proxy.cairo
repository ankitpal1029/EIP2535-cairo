# SPDX-License-Identifier: MIT

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import library_call
from starkware.starknet.common.syscalls import get_caller_address

from contracts.libraries.ownable import Ownable
from contracts.interfaces.ifacet_registry import (
    FacetAction, 
    FACET_FUNCTION_ADD, 
    FACET_FUNCTION_REPLACE, 
    FACET_FUNCTION_REMOVE
)

@storage_var
func selector_address_registry(selector: felt) -> (facet_address: felt):
end

@storage_var
func selector_address_registry_length() -> (res : felt):
end



# @storage_var
# func facet_registry() -> (res : felt):
# end


@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(owner: felt, facet_registry_address: felt):
    alloc_locals
    Ownable.initializer(owner)
    return()
end

@external
func manage_facet_actions{syscall_ptr : felt*, 
    pedersen_ptr : HashBuiltin*, 
    range_check_ptr
    }(actions_len: felt, actions: FacetAction*):
    alloc_locals

    Ownable.assert_only_owner()
    if actions_len == 0:
        return()
    end

    let facet_action: FacetAction = [actions]

    if facet_action.action == FACET_FUNCTION_ADD:
        add_facet_selector(selector=facet_action.selector, facet_address=facet_action.facet_address)
        tempvar syscall_ptr : felt* = syscall_ptr
        tempvar pedersen_ptr: HashBuiltin* = pedersen_ptr 
        tempvar range_check_ptr = range_check_ptr
    else:
        tempvar syscall_ptr : felt* = syscall_ptr
        tempvar pedersen_ptr: HashBuiltin* = pedersen_ptr 
        tempvar range_check_ptr = range_check_ptr
    end


    if facet_action.action == FACET_FUNCTION_REMOVE:
        remove_facet_selector(selector=facet_action.selector, facet_address=facet_action.facet_address)
        tempvar syscall_ptr : felt* = syscall_ptr
        tempvar pedersen_ptr: HashBuiltin* = pedersen_ptr 
        tempvar range_check_ptr = range_check_ptr
    else:
        tempvar syscall_ptr : felt* = syscall_ptr
        tempvar pedersen_ptr: HashBuiltin* = pedersen_ptr 
        tempvar range_check_ptr = range_check_ptr
    end


    if facet_action.action == FACET_FUNCTION_REPLACE:
        replace_facet_selector(selector=facet_action.selector, facet_address=facet_action.facet_address)
        tempvar syscall_ptr : felt* = syscall_ptr
        tempvar pedersen_ptr: HashBuiltin* = pedersen_ptr 
        tempvar range_check_ptr = range_check_ptr
    else:
        tempvar syscall_ptr : felt* = syscall_ptr
        tempvar pedersen_ptr: HashBuiltin* = pedersen_ptr 
        tempvar range_check_ptr = range_check_ptr
    end




    return manage_facet_actions(actions_len -1, actions + FacetAction.SIZE)
end

func add_facet_selector{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }(
    selector: felt,
    facet_address: felt
    ):
    let (existing_facet_address) = selector_address_registry.read(selector)
    with_attr error_message("selector already in registry"):
        assert existing_facet_address = 0
    end

    selector_address_registry.write(selector, facet_address)
    let (selector_len) = selector_address_registry_length.read()
    selector_address_registry_length.write(selector_len + 1)
    return()
end

func remove_facet_selector{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }(
    selector: felt,
    facet_address: felt
    ):
    Ownable.assert_only_owner()
    return()
    
end

func replace_facet_selector{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr
    }(
    selector: felt,
    facet_address: felt
    ):
    Ownable.assert_only_owner()
    return()
    
end


# @external
# @raw_input
# @raw_output
# func __default__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
#         selector : felt, calldata_size : felt, calldata : felt*) -> (
#         retdata_size : felt, retdata : felt*):
#     # let (address) = module_registry_get_module_address(selector)

#     with_attr error_message("selector not found"):
#         assert_not_zero(address)
#     end

#     let (retdata_size : felt, retdata : felt*) = library_call(
#         class_hash=address,
#         function_selector=selector,
#         calldata_size=calldata_size,
#         calldata=calldata)
#     return (retdata_size=retdata_size, retdata=retdata)
# end
