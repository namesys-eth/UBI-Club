// SPDX-License-Identifier: WTFPL.ETH
pragma solidity > 0.8 .0 < 0.9 .0;
/**
 * @title : UBI Club NFT
 * 
 * @author : 0xc0de4c0ffee.eth, sshmatrix.eth
 */

interface iOverloadResolver {
    function addr(bytes32 node, uint256 coinType) external view returns(bytes memory);
}
interface iResolver {
    function contenthash(bytes32 node) external view returns(bytes memory);
    function addr(bytes32 node) external view returns(address payable);
    function pubkey(bytes32 node) external view returns(bytes32 x, bytes32 y);
    function text(bytes32 node, string calldata key) external view returns(string memory);
    function name(bytes32 node) external view returns(string memory);
}
interface iCCIP {
    function resolve(bytes memory name, bytes memory data) external view returns(bytes memory);
    function contenthash(bytes32 node) external view returns(bytes memory);
    function setContenthash(bytes32 node, bytes memory _contenthash) external;
}
interface iERC20 {
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    function name() external view returns(string memory);
    function symbol() external view returns(string memory);
    function decimals() external view returns(uint8);
    function totalSupply() external view returns(uint256);
    function balanceOf(address _owner) external view returns(uint256 balance);
    function transfer(address to, uint256 amount) external returns(bool success);
    function transferFrom(address from, address to, uint256 amount) external returns(bool success);
    function approve(address _spender, uint256 amount) external returns(bool success);
    function allowance(address _owner, address _spender) external view returns(uint256 remaining);
}
interface iENS {
    event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
    event Transfer(bytes32 indexed node, address owner);
    event NewResolver(bytes32 indexed node, address resolver);
    event NewTTL(bytes32 indexed node, uint64 ttl);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    function setRecord(bytes32 node, address owner, address resolver, uint64 ttl) external;
    function setSubnodeRecord(bytes32 node, bytes32 label, address owner, address resolver, uint64 ttl) external;
    function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external returns(bytes32);
    function setResolver(bytes32 node, address resolver) external;
    function setOwner(bytes32 node, address owner) external;
    function setTTL(bytes32 node, uint64 ttl) external;
    function setApprovalForAll(address operator, bool approved) external;
    function owner(bytes32 node) external view returns(address);
    function resolver(bytes32 node) external view returns(address);
    function ttl(bytes32 node) external view returns(uint64);
    function recordExists(bytes32 node) external view returns(bool);
    function isApprovedForAll(address owner, address operator) external view returns(bool);
}
interface iERC2981 {
    function royaltyInfo(uint256 id, uint256 _salePrice) external view returns(address receiver, uint256 royaltyAmount);
}
interface iERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns(bool);
}
interface iERC173 {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    function owner() external view returns(address);
    function transferOwnership(address _newOwner) external;
}
interface iERC721 {
    event Transfer(address indexed from, address indexed to, uint256 indexed id);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed id);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    function balanceOf(address _owner) external view returns(uint256);
    function ownerOf(uint256 id) external view returns(address);
    function safeTransferFrom(address from, address to, uint256 id, bytes memory data) external;
    function safeTransferFrom(address from, address to, uint256 id) external;
    function transferFrom(address from, address to, uint256 id) external;
    function approve(address _approved, uint256 id) external;
    function setApprovalForAll(address _operator, bool _approved) external;
    function getApproved(uint256 id) external view returns(address);
    function isApprovedForAll(address _owner, address _operator) external view returns(bool);
}
interface iERC721Receiver {
    function onERC721Received( address _operator, address from, uint256 id, bytes memory _data) external returns(bytes4);
}

interface iERC721Metadata {
    function name() external view returns(string memory);
    function symbol() external view returns(string memory);
    function tokenURI(uint256 id) external view returns(string memory);
}