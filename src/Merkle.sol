// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

contract Merkle {
	bytes32[] leaves;
	function create_tree(bytes[] memory data) public returns(bytes32) {
		if (data.length == 0)
			return 0x00;
		else if (data.length == 1)
			return keccak256(data[0]);
		else {
			// base layer
			for (uint i = 0; i < data.length; i++) {
				leaves.push(keccak256(data[i]));
			}

			uint n = data.length;
			while (n != 1) {
				if (n % 2 == 0) {
					uint x = leaves.length;
					uint offset = x - n;
					for (uint i = 0; i < n; i += 2) {
						if (leaves[offset + i] <= leaves[offset + i + 1])
							leaves.push(_efficientHash(leaves[offset + i], leaves[offset + i + 1]));
						else
							leaves.push(_efficientHash(leaves[offset + i + 1], leaves[offset + i]));
					}
					n /= 2;
				}
				else {
					uint x = leaves.length;
					uint offset = x - n;
					for (uint i = 0; i < n - 1; i += 2) {
						if (leaves[offset + i] <= leaves[offset + i + 1])
							leaves.push(_efficientHash(leaves[offset + i], leaves[offset + i + 1]));
						else
							leaves.push(_efficientHash(leaves[offset + i + 1], leaves[offset + i]));
					}
					leaves.push(leaves[offset + n - 1]);
					n = n / 2 + 1;
				}
			}
			return (leaves[leaves.length - 1]);
		}
	}

	function _efficientHash(bytes32 a, bytes32 b) public pure returns (bytes32 value) {
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            value := keccak256(0x00, 0x40)
        }
    }
}
