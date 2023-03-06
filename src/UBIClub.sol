// SPDX-License-Identifier: WTFPL.ETH
pragma solidity >0.8.0 <0.9.0;
import "./Interface.sol";
import "./Metadata.sol";
import "./ERC721.sol";

contract UBIClub is ERC721 {

	string public constant name = "Universal Basic Income Supporters";
	string public constant symbol = "UBIGANG";

	constructor() {
		Gov = payable(msg.sender);
		metadata = new Metadata();
		perNameETH[1] = 0.06 ether;
		perNameETH[2] = 0.05 ether;
		perNameETH[3] = 0.04 ether;
		perNameETH[4] = 0.03 ether;
		perNameETH[5] = 0.02 ether;
		perNameETH[6] = 0.01 ether; //>=6 length
	}

	/**
	 * @dev iERC165 supportsInterface 
	 * @param id : interface id
	 */
	function supportsInterface(bytes4 id) external pure returns(bool) {
		return type(iERC2981).interfaceId == id || // royalty interface
			type(iERC721).interfaceId == id || // Nft interfasce
			type(iERC721Metadata).interfaceId == id || // NFT metadata interfacde
			type(iERC165).interfaceId == id || // erc165, suppports interface
			type(iERC173).interfaceId == id; // conteact ownership interface
	}

	/// @dev : revert on fallback
	fallback() external payable {
		revert();
	}

	// log eth donations
	event ThankYou(address indexed sender, uint indexed donation);

	/// @dev : receive domations in ETH
	receive() external payable {
		unchecked {
			uint donated = ethFeesById[uint160(msg.sender)] + msg.value;
			emit ThankYou(msg.sender, donated);
			ethFeesById[uint160(msg.sender)] = donated;
		}
	}
}