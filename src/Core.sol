// SPDX-License-Identifier: WTFPL.ETH
pragma solidity >0.8.0 <0.9.0;
import "./Interface.sol";
import "./Metadata.sol";

abstract contract Core is iERC165, iERC173, iERC2981 {

    /// @dev : Deployer/Multisig controller of UBI.ETH
    address payable public Gov;
    
    /// @dev : Namehash of "ubi.eth"
    // keccak256(abi.encodePacked(keccak256(abi.encodePacked(bytes32(0), keccak256("eth"))), keccak256("ubi")))
	bytes32 public immutable ubi_eth = 0xf8c6748a21154202c6a840d4524d65aa6bceff9cc915d3282ce51fe9d3aaa41a;
	
    struct NFT {
        uint32 len;
        uint64 expiry;
        address approved;

        uint16 counter;
        bytes10 prefix; // contenthash prefix
        address owner;

        uint64 created;
        uint64 ubiFees;
        uint128 ethFees;

        bytes32 content;
        string label;
    }

    mapping(uint => NFT) public nfts;

    //mapping(uint256 => address) public ownerOf;

    uint public totalSupply; // total supply of NFT
    uint public totalETH; // total ETH paid to mint & renew
    uint public totalUBI; // total UBI paid to mint & renew

    mapping(uint => string) public id2Name;
    mapping(bytes32 => bytes) public contenthash;
    mapping(uint => uint) public ethFeesById;
    mapping(bytes32 => uint) public namehash2ID;

    /// eth per name by length
    uint256[7] public perNameETH;

    modifier onlyGov() {
        require(msg.sender == Gov, "ONLY_GOV");
        _;
    }

    // @dev : onchain svg & json generator, managed by Gov
    Metadata public metadata; // Metadata contract

    /// @dev : Royalty percent, (100 = 1%), managed by Gov
    uint public royalty = 1000; // 10%

    /// @dev : membership expiry timestamp 
    mapping(uint256 => uint256) public expiry;


    /// @dev : ENS registry contract 
    // iENS public immutable ENS = iENS(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e);

    /**
     * @dev : transfer contract ownership to new Gov
     * @param newGov : new Gov
     */
    function transferOwnership(address newGov) external onlyGov {
        emit OwnershipTransferred(Gov, newGov);
        Gov = payable(newGov);
    }

    /**
     * @dev : get owner of contract
     * @return : address of controlling dev or multi-sig wallet
     */
    function owner() external view returns(address) {
        return Gov;
    }

    /**
     * @dev EIP2981 royalty standard
     * @param _royalty : royalty (100 = 1 %)
     */
    function setRoyalty(uint256 _royalty) external onlyGov {
        //require(_royalty >= 100, "MIN_1_PERCENT");
        royalty = _royalty;
    }

    /**
     * @dev : get royalty info
     * @param id : token id
     * @param _price : price of nft
     */
    function royaltyInfo(uint256 id, uint256 _price) external view returns(address receiver, uint256 royaltyAmount) {
        require(expiry[id] > block.timestamp, "NOT_REGD/EXPIRED");
        return (Gov, (_price / 10000) * royalty);
    }


    function strlen(bytes memory str) public pure returns(uint256 len) {
        uint256 i;
        uint256 bytelength = str.length;
        bytes1 _d;
        while (i < bytelength) {
            unchecked {
                ++len;
                _d = str[i];
                if (_d < 0x80) {
                    i += 1;
                } else if (_d < 0xE0) {
                    i += 2;
                } else if (_d < 0xF0) {
                    i += 3;
                } else if (_d < 0xF8) {
                    i += 4;
                } else if (_d < 0xFC) {
                    i += 5;
                } else {
                    i += 6;
                }
            }
        }
    }
}