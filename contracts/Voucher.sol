//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.15;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Voucher is ERC721, Ownable {
    constructor() ERC721("NFT Voucher", "VOUCHER") {}

    function mint(address to, uint256 tokenId) public onlyOwner {
        _mint(to, tokenId);
    }
}
