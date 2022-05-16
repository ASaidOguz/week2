pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";


template TreeLayer(n) {
 var nItems = 1 << n;
 signal input ins[nItems * 2];
 signal output outs[nItems];

 component hash[nItems];
 for(var i = 0; i < nItems; i++) {
 hash[i] = Poseidon(2);
 hash[i].inputs[0] <== ins[i * 2];
 hash[i].inputs[1] <== ins[i * 2 + 1];
 hash[i].out ==> outs[i];
 log(hash[i].out);
 }
}

template CheckRoot(n) {
 signal input leaves[2**n];
 signal output root;

 component layers[n];
 for(var level = n - 1; level >= 0; level--) {
  layers[level] = TreeLayer(level);
  for(var i = 0; i < (1 << (level + 1)); i++) {
   layers[level].ins[i] <== level == n - 1 ? leaves[i] : layers[level + 1].outs[i];
  }
 }

 root <== n > 0 ? layers[0].outs[0] : leaves[0];
}    
    //[assignment] insert your code here to calculate the Merkle root from 2^n leaves








template MerkleTreeInclusionProof(n) {
    signal input leaf;
    signal input path_elements[n];
    signal input path_index[n]; // path index are 0's and 1's indicating whether the current element is on the left or right
    signal output root; // note that this is an OUTPUT signal

    // hash of first two entries in tx Merkle proof
    component merkle_root[n];
    merkle_root[0] = Poseidon(2);
    merkle_root[0].inputs[0] <== leaf - path_index[0]* (leaf - path_elements[0]);
    merkle_root[0].inputs[1] <== path_elements[0] - path_index[0]* (path_elements[0] - leaf);
    // hash of all other entries in tx Merkle proof
    for (var v = 1; v < n; v++){
        merkle_root[v] = Poseidon(2);
        merkle_root[v].inputs[0] <== merkle_root[v-1].out - path_index[v]* (merkle_root[v-1].out 
        - path_elements[v]);
        merkle_root[v].inputs[1] <==path_elements[v] - path_index[v]* (path_elements[v] 
        - merkle_root[v-1].out);
    }

    // output computed Merkle root
    root <== merkle_root[n-1].out;
    log(root);
    //[assignment] insert your code here to compute the root from a leaf and elements along the path
}