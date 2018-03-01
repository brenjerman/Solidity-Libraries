pragma solidity ^0.4.20;

library Memory {    
    function allocate(uint sizeSlots) internal pure returns(uint) {
        if(sizeSlots == 0) return  0;
        
        uint memptr;
        
        assembly {
            memptr := mload(0x40)
            mstore(0x40, add(memptr, mul(0x20, sizeSlots)))
        }
        
        return memptr;
    }
    
    // writes value to slot in storage.
    // @sizeBytes - size of data to be written
    // @offsetBytes - offset from left most byte to write
    // @value - values should be unformatted - this function takes care of that for you!
    function write(uint p, uint sizeBytes, uint offsetBytes, bytes32 value) internal pure {
        if(sizeBytes == 0) return;
        // inline everything ...
        assembly {
            // creates bit mask
            let mask := div(mul(sub(0,1), exp(2, mul(sub(32, sizeBytes),8))), exp(2, mul(offsetBytes, 8)))
            let oldValue := and(mload(p), not(mask)) 
            let newValue := mul(value, exp(2, mul(8, sub(32, add(sizeBytes, offsetBytes)))))
            
            mstore(p, or(oldValue, newValue))
        } 
    }
    
    // writes value to slot p
    // mem[p] := value
    function write(uint p, bytes32 value) internal pure {
        assembly {
            mstore(p, value)
        }
    }
    
    // reads n bytes (sizeBytes) from mem[p] at some offset (offsetBytes)
    function read(uint p, uint sizeBytes, uint offsetBytes) internal pure returns(bytes32 ret) {
        assembly {
            let bitsToShift := exp(2, mul(8, sub(32, add(offsetBytes, sizeBytes))))
            let mask := div(mul(sub(0,1), exp(2, mul(sub(32, sizeBytes),8))), exp(2, mul(offsetBytes, 8)))
            ret := div(and(mask, mload(p)), bitsToShift)
        }
    }
    
    function read(uint p) internal pure returns (bytes32) {
        bytes32 ret;
        
        assembly {
            ret := mload(p)
        }
        
        return ret;
    }
}
