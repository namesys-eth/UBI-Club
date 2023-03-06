// SPDX-License-Identifier: WTFPL.ETH
pragma solidity >0.8.0 <0.9.0;
import "./Interface.sol";
import "./Core.sol";

abstract contract ERC721 is Core, iERC721, iERC721Metadata {


    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => bool)) public isApprovedForAll;

    function tokenURI(uint256 Id) external view returns(string memory) {
        NFT memory nft = nfts[Id];
        bytes memory _name = bytes(nft.label);
        require(_name.length > 0, "NOT_REGD");
        return metadata.generate(Id);
    }

    function mint(string calldata _name, bytes32 _ipnx, uint8 _years) public payable {
        require(_years > 0, "ZERO_YEARS");
        uint id = uint256(keccak256(bytes(_name)));
        require(nfts[id].expiry < block.timestamp, "ALREADY_MINTED");
        uint len = strlen(bytes(_name));
        unchecked {
            require(perNameETH[len > 5 ? 6 : len] * _years >= msg.value, "NOT_ENOUGH_ETH");
            nfts[id] = NFT(
                uint8(len), uint64(block.timestamp + 365 * _years + 30 days), address(0),
                1, bytes10(0xe5010172002408011220), msg.sender,
                uint64(block.timestamp), 0, uint128(msg.value),
                _ipnx,
                _name
            );
            ++balanceOf[msg.sender];
            ++totalSupply;
        }
        //ENS.setSubnodeRecord(ubi_eth, bytes32(id), msg.sender, address(this), 0);
        bytes32 _namehash = keccak256(abi.encodePacked(ubi_eth, bytes32(id)));
        namehash2ID[_namehash] = id;
        emit Transfer(address(0), msg.sender, id);
    }

    function approve(address spender, uint256 id) public {
        address owner = nfts[id].owner;
        require(msg.sender == owner, "NOT_AUTHORIZED");
        nfts[id].approved = spender;
        emit Approval(owner, spender, id);
    }

    function setApprovalForAll(address operator, bool approved) public {
        isApprovedForAll[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function transferFrom(address from, address to, uint256 id) public {
        NFT storage nft = nfts[id];
        require(from == nft.owner, "NOT_OWNER");
        require(expiry[id] > block.timestamp, "NAME_EXPIRED");
        require(
            msg.sender == from ||
            isApprovedForAll[from][msg.sender] ||
            msg.sender == nft.approved,
            "NOT_AUTHORIZED"
        );
        unchecked {
            --balanceOf[from];
            ++balanceOf[to];
            ++nft.counter;
        }
        nft.owner = to;
        delete nft.approved;
        //ENS.setSubnodeOwner(ubi_eth, bytes32(id), to);
        emit Transfer(from, to, id);
    }

    function safeTransferFrom(address from, address to, uint256 id) public {
        transferFrom(from, to, id);
        require(
            to.code.length == 0 ||
            iERC721Receiver(to).onERC721Received(msg.sender, from, id, "") ==
            iERC721Receiver.onERC721Received.selector,
            "UNSAFE_RECIPIENT"
        );
    }

    function safeTransferFrom(address from, address to, uint256 id, bytes calldata data) public {
        transferFrom(from, to, id);
        require(
            to.code.length == 0 ||
            iERC721Receiver(to).onERC721Received(msg.sender, from, id, data) ==
            iERC721Receiver.onERC721Received.selector,
            "UNSAFE_RECIPIENT"
        );
    }

    function getApproved(uint256 id) external view returns(address) {
        NFT memory nft = nfts[id];
        require(nft.expiry > block.timestamp, "NAME_EXPIRED/NOT_REGD");
        return nft.approved;
    }

    function ownerOf(uint256 id) external view returns(address) {
        NFT memory nft = nfts[id];
        require(nft.expiry > block.timestamp, "NAME_EXPIRED/NOT_REGD");
        return nft.owner;
    }
}