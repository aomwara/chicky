pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ChickyChicPoints is ERC1155, Ownable {
    mapping(address => uint256) private _pointsBalance;
    uint256 private _tokenId;

    event PointsEarned(address indexed account, uint256 amount);
    event PointsSpent(address indexed account, uint256 amount);

    constructor() ERC1155("ChickyChicPoints") {
        _tokenId = 1;
    }

    function mintPoints(address account, uint256 amount) external onlyOwner {
        _pointsBalance[account] += amount;
        _mint(account, _tokenId, amount, "");
    }

    function spendPoints(uint256 amount) external {
        require(_pointsBalance[msg.sender] >= amount, "ChickyChicPoints: Insufficient balance");

        _pointsBalance[msg.sender] -= amount;
        _burn(msg.sender, _tokenId, amount);
        emit PointsSpent(msg.sender, amount);
    }

    function pointsBalance(address account) external view returns (uint256) {
        return _pointsBalance[account];
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override {
        require(
            from == address(0) || to == address(0),
            "ChickyChicPoints: tokens are not transferable"
        );
    }
    
    function changeOwner (address _newOwner) public onlyOwner {
        transferOwnership(_newOwner);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC1155)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}