// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "./MuseumICOERC20.sol";

contract MuseumICONFT is ERC721, Ownable, ReentrancyGuard {
    uint256 private _nextTokenId;
    MuseumICOERC20 public immutable museumToken;
    uint256 public constant MIN_CONTRIBUTION = 0.05 ether;
    uint256 public constant MAX_NFT_PER_WALLET = 3;

    mapping(address => uint256) private _nftCountPerWallet;

    event NFTMinted(address minter, uint256 tokenId);

    constructor(MuseumICOERC20 _museumToken, address _goon)
        ERC721("CommemorativeNFT", "CNFT")
        Ownable(_goon)
    {
        museumToken = _museumToken;
    }

    function mintNFT(uint256 _tokenAmount) public payable nonReentrant {
        require(
            _tokenAmount > 0 && _tokenAmount <= MAX_NFT_PER_WALLET,
            "Cantidad de NFTs invalida"
        );
        require(
            _nftCountPerWallet[msg.sender] + _tokenAmount <= MAX_NFT_PER_WALLET,
            "Limite de NFT por wallet alcanzado"
        );

        uint256 totalCost = _tokenAmount * museumToken.TOKEN_PRICE();
        require(msg.value >= totalCost, "ETH insuficiente");

        // Llama a buyTokens en MuseumICOERC20 directamente
        museumToken.buyTokens{value: totalCost}(_tokenAmount, msg.sender);

        for (uint256 i = 0; i < _tokenAmount; i++) {
            uint256 tokenId = _nextTokenId++;
            _safeMint(msg.sender, tokenId);
            emit NFTMinted(msg.sender, tokenId);
        }

        _nftCountPerWallet[msg.sender] += _tokenAmount;

        // Reembolsa el Ether sobrante, si lo hay
        if (msg.value > totalCost) {
            payable(msg.sender).transfer(msg.value - totalCost);
        }
    }

    function nftCount(address owner) public view returns (uint256) {
        return _nftCountPerWallet[owner];
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No hay fondos disponibles para retirar");

        (bool success, ) = payable(owner()).call{value: balance}("");
        require(success, "Fallo al retirar los fondos");
    }
}
