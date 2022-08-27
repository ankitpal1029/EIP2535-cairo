# SPDX-License-Identifier: MIT

%lang starknet


from starkware.cairo.common.cairo_builtins import HashBuiltin
from contracts.storages.A_storage import counter
from contracts.storages.B_storage import admin
from starkware.starknet.common.syscalls import get_caller_address

@external
func getter{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
    }() -> (counter_val: felt):
    let (counter_val) = counter.read()
    return(counter_val=counter_val)
end


@external
func setter{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
    }(addVal: felt):
    let (caller) = get_caller_address()
    let (current_admin) = admin.read()
    with_attr error_message("Not Admin: Not authorised"):
        assert caller = current_admin 
    end
    let (counter_val) = counter.read()
    counter.write(counter_val + addVal)
    return()
end