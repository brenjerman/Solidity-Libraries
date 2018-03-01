pragma solidity ^0.4.20;

library Memory {
    bytes32 constant bitMask = 2 ** 256 - 1;
    
    // 
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
        
        // only writes a single slot
        assert(sizeBytes + offsetBytes <= 32);
        
        bytes32 mask = getMask(sizeBytes, offsetBytes);
        
        bytes32 oldValue = read(p) & ~mask;
        bytes32 newValue = value << numBitsRight(sizeBytes, offsetBytes);
        bytes32 writeValue = oldValue | newValue;
        
        write(p, writeValue);
    }
    
    // writes value to slot p
    // mem[p] := value
    function write(uint p, bytes32 value) internal pure {
        assembly {
            mstore(p, value)
        }
    }
    
    // reads n bytes (sizeBytes) from mem[p] at some offset (offsetBytes)
    function read(uint p, uint sizeBytes, uint offsetBytes) internal pure returns(bytes32) {
        assert(offsetBytes + sizeBytes <= 32);
        
        bytes32 value = read(p);
        bytes32 mask = getMask(sizeBytes, offsetBytes);
        
        return (value & mask) >> numBitsRight(sizeBytes, offsetBytes);
    }
    
    function read(uint p) internal pure returns (bytes32) {
        bytes32 ret;
        
        assembly {
            ret := mload(p)
        }
        
        return ret;
    }
    
    // shift left to the correct size, then move right to the offset position
    function getMask(uint sizeBytes, uint offsetBytes) private pure returns(bytes32) {
        return bitMask << ((32 - sizeBytes) * 8) >> numBitsLeft(offsetBytes);
    }
    
    function numBitsLeft(uint offsetBytes) private pure returns(uint) {
        return offsetBytes * 8;
    }
    
    function numBitsRight(uint sizeBytes, uint offsetBytes) private pure returns(uint) {
        return (32 - offsetBytes - sizeBytes) * 8;
    }
}

contract UnitTest {

    // breaks up slot into 4, 8 byte sized chunks.
    function test1() public pure returns(bool) {
        uint sizeBytes = 8; // in bytes
        uint slot = Memory.allocate(1);
        uint value = 10;

        for(uint i = 0; i < 4; ++ i) {
            Memory.write(slot, sizeBytes, i * sizeBytes, bytes32(value + i));
        }
        
        for(uint j = 0; j < 4; ++ j) {
            assert(Memory.read(slot, sizeBytes, j * sizeBytes) == bytes32(value + j));
        }
        
        return true;
    }
}
