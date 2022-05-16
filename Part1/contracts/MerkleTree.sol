//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { PoseidonT3 } from "./Poseidon.sol"; //an existing library to perform Poseidon hash on solidity
import "./verifier.sol"; //inherits with the MerkleTreeInclusionProof verifier contract

contract MerkleTree is Verifier {
    uint256[] public hashes; // the Merkle tree in flattened array form
    uint256 public index = 0; // the current index of the first unfilled leaf
    uint256 public root; // the current Merkle root

    constructor() {
        // [assignment] initialize a Merkle tree of 8 with blank leaves
       uint8 size=15;
       hashes=new uint256[](size);
       for (uint i =0;i<8;i++){
           hashes[i]=0;
       }
       hashes[8]=PoseidonT3.poseidon([hashes[0],hashes[1]]);
       hashes[9]=PoseidonT3.poseidon([hashes[2],hashes[3]]);
       hashes[10]=PoseidonT3.poseidon([hashes[4],hashes[5]]);
       hashes[11]=PoseidonT3.poseidon([hashes[6],hashes[7]]);
       hashes[12]=PoseidonT3.poseidon([hashes[8],hashes[9]]);
       hashes[13]=PoseidonT3.poseidon([hashes[10],hashes[11]]);
       hashes[14]=PoseidonT3.poseidon([hashes[12],hashes[13]]);
       root=hashes[14];
    }
      
    function insertLeaf(uint256 hashedLeaf) public returns ( uint256) {
         //[assignment] insert a hashed leaf into the Merkle tree
    
        for(uint i=0;i<8;i++){
           if (hashes[i]==0){
               hashes[i]=hashedLeaf;
               i=8;
               
           }
        }
        
       hashes[8]=PoseidonT3.poseidon([hashes[0],hashes[1]]);
       hashes[9]=PoseidonT3.poseidon([hashes[2],hashes[3]]);
       hashes[10]=PoseidonT3.poseidon([hashes[4],hashes[5]]);
       hashes[11]=PoseidonT3.poseidon([hashes[6],hashes[7]]);
       hashes[12]=PoseidonT3.poseidon([hashes[8],hashes[9]]);
       hashes[13]=PoseidonT3.poseidon([hashes[10],hashes[11]]);
       hashes[14]=PoseidonT3.poseidon([hashes[12],hashes[13]]);
        return  root=hashes[14];
     }

    function verify(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[1] memory input
        ) public view returns (bool) {
              
        return verifyProof(a, b, c, input)==true&&root==input[0];
            
        // [assignment] verify an inclusion proof and check that the proof root matches current root
    }
}
