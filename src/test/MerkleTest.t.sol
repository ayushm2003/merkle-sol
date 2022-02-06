// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "./console.sol";
import "../Merkle.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleTest is DSTest {
	Merkle merkle;
	function setUp() public {
		merkle = new Merkle();
	}

    // function testExample() public {
    //     assertTrue(true);
    // }

	bytes[] data;

	
	function testCreateMerkleEven() public {
		delete data;
		data.push(bytes("hello"));
		data.push(bytes("world"));
		data.push(bytes("!"));
		data.push(bytes("lol"));
		data.push(bytes("phew"));
		data.push(bytes("yay"));

		bytes32 root = merkle.createTree(data);
		console.logBytes32(root);
		assertEq(root, bytes32(hex'c0446242ea010423de07ec20577c70620c01f75dcb782beb97302b116e1be662'));
	}
	
	function testCreateMerkleOdd() public {
		delete data;
		data.push("vires");
		data.push("in");
		data.push("numeris");

		bytes32 root = merkle.createTree(data);
		console.logBytes32(root);
		assertEq(root, bytes32(hex'2d8c657706f2404938dc80afbe73284de45e2b6aa5129e721f876f8fb5eb28f3'));
	}
	

	function testProof() public {
		data.push("vires");
		data.push("in");
		data.push("numeris");
		data.push(bytes("hello"));
		data.push(bytes("world"));
		data.push(bytes("!"));

		merkle.createTree(data);
		bytes32[] memory proof = merkle.createProof("vires");
		for (uint i=0; i < proof.length; i++) {
			console.logBytes32(proof[i]);
		}
		bool res = MerkleProof.verify(proof, bytes32(hex'9836b7a95d837e8d9ab44b68fc91a3cbeb0e6ffbc860bc210c37705ba9370272'), keccak256('vires'));
		// console.log(res);
		assert(res);
	}

	/*
	function testComparison() public view {
		bytes32 res = checkComparison(bytes32(hex"817f9cf412e48771da9077a54e99b92c920c5a08b06477d97fcc2b64ad9eea8f"), hex'12cd219a566fb979c5bef6c77c034fbb3650d845a95dc012a9c07be75c3d8fa2');
		console.logBytes32(res);
	}

	function checkComparison(bytes32 a, bytes32 b) public pure returns(bytes32) {
		if (a >= b)
			return a;
		else
			return 0x00;
	}
	
	function testHash() public view {
		bytes32 _hash = merkle._efficientHash(0x12cd219a566fb979c5bef6c77c034fbb3650d845a95dc012a9c07be75c3d8fa2, 0x817f9cf412e48771da9077a54e99b92c920c5a08b06477d97fcc2b64ad9eea8f);
		console.logBytes32(_hash);
	}
	*/

}
