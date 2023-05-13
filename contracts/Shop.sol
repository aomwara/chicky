//SPDX-License-Identifier: Unlicense

pragma solidity 0.8.15;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Shop , Ownable{
    IERC721 public voucher;
    mapping(uint256 => bool) public redeemed;

    constructor(address _voucher) {
        voucher = IERC721(_voucher);
    }

    function mint(address to, uint256 tokenId) public {
        voucher.mint(to, tokenId);
    }

    function redeem(uint256 tokenId) public {
        require(voucher.ownerOf(tokenId) == msg.sender, "Not the owner of this voucher");
        require(redeemed[tokenId] == false, "Already redeemed");
        redeemed[tokenId] = true;
    }

    function changeOwner (address _newOwner) public onlyOwner {
        transferOwnership(_newOwner);
        voucher.transferOwnership(_newOwner);
    }
}
