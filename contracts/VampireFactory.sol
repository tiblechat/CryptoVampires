pragma solidity >=0.5.0 <0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./safemath.sol";


contract VampireFactory is Ownable{


using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;
     event NewVampire(uint vampireId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;
    // inside a struct uint32 takes less size than uint (256)
    // but they have to be packed together
    struct Vampire {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    // vampire list
    Vampire[] public vampires;
    // maps a vampire to its owner
    mapping (uint => address) public vampireToOwner;
    // how many vampires an address has
    mapping (address => uint) ownerVampireCount;


    function _createVampire(string memory _name, uint _dna) internal {
        uint id = vampires.push(Zombie(_name, _dna,1,uint32(now + cooldownTime),0,0)) - 1;
        vampireToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
        emit NewVampire(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    // random vampire creation (name based)
    // only possible if user has no vampire
    function createRandomVampire(string memory _name) public 
    {
         require(ownerVampireCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createVampire(_name, randDna);
    }

}
