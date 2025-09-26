object "Counter" {
    code {
        // Deploy the contract
        datacopy(0, dataoffset("runtime"), datasize("runtime"))
        return(0, datasize("runtime"))
    }

    object "runtime" {
        code {
            // Protection against sending Ether
            require(iszero(callvalue()))

            // Get function selector from the calldata
            let selector := shr(224, calldataload(0))

            // Dispatch function calls
            switch selector
            // number() -> 8381f58a
            case 0x8381f58a {
                mstore(0, sload(0)) // Load value from storage slot 0
                return(0, 32)
            }
            // setNumber(uint256) -> 3fb5c1cb
            case 0x3fb5c1cb {
                // Ensure we have correct calldata length
                require(eq(calldatasize(), 36))
                
                // Get the parameter from calldata
                let newNumber := calldataload(4)
                
                // Store the new number
                sstore(0, newNumber)
                
                // Return nothing
                return(0, 0)
            }
            // increment() -> d09de08a
            case 0xd09de08a {
                // Ensure we have correct calldata length
                require(eq(calldatasize(), 4))
                
                // Load current value
                let value := sload(0)
                
                // Increment
                value := add(value, 1)
                
                // Store new value
                sstore(0, value)
                
                // Return nothing
                return(0, 0)
            }
            default {
                revert(0, 0)
            }

            function require(condition) {
                if iszero(condition) { revert(0, 0) }
            }
        }
    }
}