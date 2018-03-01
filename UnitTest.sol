import "./Memory.sol";

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
