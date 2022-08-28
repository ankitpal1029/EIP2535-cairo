# SPDX-License-Identifier: MIT

%lang starknet


from starkware.cairo.common.cairo_builtins import HashBuiltin
from src.storages.B_storage import admin, adminB
from starkware.starknet.common.syscalls import get_caller_address

# @constructor
# func constructor{
#     syscall_ptr: felt*,
#     pedersen_ptr: HashBuiltin*,
#     range_check_ptr
#     }():
#     let (caller) = get_caller_address()
#     adminB.write(caller)
#     admin.write(caller)
#     return()
# end


@external
func addAdmin{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
    }(new_admin: felt):
    let (caller) = get_caller_address()
    let (current_admin) = adminB.read()
    with_attr error_message("Not Admin: Not authorised"):
        assert caller = current_admin 
    end
    admin.write(new_admin)
    return()
end


@external
func transferAdmin{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
    }(new_admin: felt):
    let (caller) = get_caller_address()
    let (current_admin) = adminB.read()
    with_attr error_message("Not Admin: Not authorised"):
        assert caller = current_admin 
    end
    admin.write(new_admin)
    return()
end

@external
func renounceAdmin{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
    }():
    let (caller) = get_caller_address()
    let (current_admin) = adminB.read()
    with_attr error_message("Not Admin: Not authorised"):
        assert caller = current_admin 
    end
    admin.write(0)
    return()
end
