//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IAccount} from "account-abstraction/contracts/interfaces/IAccount.sol";
import {PackedUserOperation} from "account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import { SIG_VALIDATION_FAILED, SIG_VALIDATION_SUCCESS} from "account-abstraction/contracts/core/Helpers.sol";
import {IEntryPoint} from "account-abstraction/contracts/interfaces/IEntryPoint.sol";

contract MinimalAccount is IAccount, Ownable { 

IEntryPoint private immutable i_entryPoint;
error MinimalAccount_NotForEntryPoint();

constructor(address entryPoint) Ownable(msg.sender) {
    i_entryPoint = IEntryPoint(entryPoint);
}

modifier onlyEntryPoint() {
   if(msg.sender != address(i_entryPoint)) revert MinimalAccount_NotForEntryPoint();
    _;
}
 function validateUserOp(
        PackedUserOperation calldata userOp,
        bytes32 userOpHash,
        uint256 missingAccountFunds
    ) external override onlyEntryPoint returns (uint256 validationData){
        validationData =_validateSignature(userOp, userOpHash);
        //_validateNonce(userOp.nonce);
        _payPrefund(missingAccountFunds);
    }

//EIP-181 version of the signed hash
 function _validateSignature(PackedUserOperation calldata userOp, bytes32 userOpHash) internal view returns (uint256 validationData){
   bytes32 signedMessageHash = MessageHashUtils.toEthSignedMessageHash(userOpHash);
   address signer =ECDSA.recover(signedMessageHash, userOp.signature);
   if(signer != owner()) {
    return SIG_VALIDATION_FAILED;
   }
   return SIG_VALIDATION_SUCCESS;
}

function _payPrefund(uint256 missingAccountFunds) internal {
    if(missingAccountFunds != 0) {
    (bool success,) = payable(msg.sender).call{value:missingAccountFunds, gas: type(uint256).max}("");
    (success);
    }
}

  /*//////////////////////////////////////////////////////////////
                                GETTERS
    //////////////////////////////////////////////////////////////*/

function getEntryPoint() external view returns (address){
    return address(i_entryPoint);
}

}
