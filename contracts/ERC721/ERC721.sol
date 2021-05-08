pragma solidity ^0.6.0;

import './IERC721.sol';
import './IERC721TokenReceiver.sol';

contract ERC721 is IERC721, IERC721Receiver{
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    mapping (address => uint256) private _balance;
    mapping (uint256 => address) private _owner;
    mapping (uint256 => address) private _approved;
    mapping (address => mapping (address => bool)) private _approvedAll;

    bytes4 _ERC721Received = bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));

    constructor() public{}

    function onERC721Received(
        address _operator, 
        address _from, 
        uint256 _id, 
        bytes calldata _data
    ) external override returns(bytes4){
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }

    function balanceOf(address owner) external override view returns (uint256 balance){
        _isZero(owner);
        return _balance[owner];
    }

    function ownerOf(uint256 tokenId) external override view returns (address owner){
        owner = _owner[tokenId];
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) external override{
        _transfer(from,to, tokenId);
        require(_checkOnERC721Received(msg.sender,from,to,tokenId, " "));
    }

    function transferFrom(address from, address to, uint256 tokenId) external override{
        _transfer(from, to, tokenId);
    }

    function approve(address to, uint256 tokenId) external override{
        _isZero(to, _owner[tokenId]);
        require(_owner[tokenId] == msg.sender);
        _approved[tokenId] = to;
        emit Approval(msg.sender, to, tokenId);
    }

    function getApproved(uint256 tokenId) external override view returns (address operator){
        _isZero(_owner[tokenId]);
        operator = _approved[tokenId]; 
    }

    function setApprovalForAll(address operator, bool approved) external override{
        _isZero(operator);
        require(operator != msg.sender);
        _approvedAll[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator) external override view returns (bool){
        _isZero(owner, operator);
        return _approvedAll[owner][operator];
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external override{
        _transfer(from,to, tokenId);
        require(_checkOnERC721Received(msg.sender,from,to,tokenId, data));
    }

    function _isZero(address to, address from) internal {
        require(to != address(0) && from != address(0));
    }

    function _isZero(address to) internal {
        require(to != address(0));
    }

    function _transfer(address from, address to, uint256 tokenId) internal{
        _isZero(to, from);
        _isZero(_owner[tokenId]);
        require(_approv[tokenId] == msg.sender || from == msg.sender || _approvedAll[from][msg.sender]);
        require(_owner[tokenId] == from);
        _balance[from] -= 1;
        _balance[to] += 1;
        _owner[tokenId] = to;
        _approv[tokenId] = address(0);
        emit Transfer(from, to, tokenId);
    }

    function _checkOnERC721Received(
        address _operator, 
        address _from, 
        address _to, 
        uint256 _tokenId,  
        bytes memory _data
    ) internal returns (bool){
        if (!isContract(_to)) {
            return true;
        }
        bytes4 retval = IERC721Receiver(_to).onERC721Received(_operator, _from, _tokenId,_data);
        return (retval == _ERC721Received);
    }

    function isContract(address addr) internal returns (bool) {
        uint size;
        assembly{ size := extcodesize(addr)}
        return size > 0;
    }
}