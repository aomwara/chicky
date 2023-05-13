pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ChickyChicPoints is ERC1155, Ownable {
    using Strings for uint256;
    // Initial Token ID = 1
    uint256 private _tokenId = 1;

    // Membership
    // mapping studentId to address
    mapping(address => uint256) private studentId;
    mapping(uint256 => address) private studentIdAddress;
    mapping(uint256 => bool) private _isMember;

    // Point system
    mapping(address => uint256) private _pointsBalance;

    // Token URI
    string public baseURI;
    string internal baseExtension = ".json";

    // Events
    event PointsEarned(address indexed account, uint256 amount);
    event PointsSpent(address indexed account, uint256 amount);

    constructor() ERC1155("ChickyChicPoints") {}

    // Modifier to check if studentId is already registered
    modifier isStudentIdNotRegistered (uint256 _studentId) {
        require(studentId[msg.sender] == 0, "ChickyChicPoints: Student ID already registered");
        _;
    }

    //Get Student Address
    function getStudentAddress (uint256 _studentId) public view returns (address) {
        return studentIdAddress[_studentId];
    }
    // Register membership and map studentId to address
    function registerMember ( uint256 _studentId) public isStudentIdNotRegistered(_studentId) {
        studentId[msg.sender] = _studentId;
        studentIdAddress[_studentId] = msg.sender;
    }

    //Mint point to member (By ChickyChic Owner)
    function mintPoints(uint256 _studentId, uint256 amount) external onlyOwner {
        require(studentIdAddress[_studentId] != address(0), "ChickyChicPoints: Student ID not registered");
        address account = studentIdAddress[_studentId];
        _pointsBalance[account] += amount;
        _mint(account, _tokenId, amount, "");
    }

    //Spend point (By member)
    function spendPoints(uint256 amount) external {
        require(_pointsBalance[msg.sender] >= amount, "ChickyChicPoints: Insufficient balance");
        _pointsBalance[msg.sender] -= amount;
        _burn(msg.sender, _tokenId, amount);
        emit PointsSpent(msg.sender, amount);
    }

    //Check point balance ()
    function pointsBalance(address account) external view returns (uint256) {
        return _pointsBalance[account];
    }

    // Change ChickyChic owner address
    function changeOwner (address _newOwner) public onlyOwner {
        transferOwnership(_newOwner);
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

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC1155)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }


    //Token URI
    function tokenURI(
        uint256 tokenId
    ) public view returns (string memory) {
        string memory currentBaseURI = _baseURI();
        return (
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        baseExtension
                    )
                )
                : ""
        );
    }

    function _baseURI() internal view returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }

}