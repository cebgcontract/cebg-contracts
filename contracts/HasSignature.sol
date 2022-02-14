// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract HasSignature {

    function checkSigner(
        address signer,
        bytes32 hash,
        bytes memory signature 
    ) public pure {
        require(signature.length == 65, "[BE] invalid signature length");
        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(
            hash
        );
        
        address recovered = ECDSA.recover(ethSignedMessageHash, signature);
        require(recovered == signer, "[BE] invalid signature");
    }
}