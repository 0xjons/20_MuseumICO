// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract MuseumICOERC20 is ERC20, Ownable, Pausable {
    uint256 public constant MAX_SUPPLY = 336699;
    uint256 public constant ICO_SUPPLY = (MAX_SUPPLY * 20) / 100;
    uint256 public constant K = 333;
    uint256 public constant TOKEN_PRICE = 1 ether / (MAX_SUPPLY / K);
    uint256 public tokensSold = 0; // Contador de tokens vendidos

    address private authorizedCaller;

    constructor(address _goon) ERC20("MuseumToken", "MSMT") Ownable(_goon) {
        _mint(address(this), ICO_SUPPLY);
    }

    function setAuthorizedCaller(address _caller) public onlyOwner {
        authorizedCaller = _caller;
    }

    modifier onlyAuthorized() {
        require(msg.sender == authorizedCaller, "Llamada no autorizada");
        _;
    }

    function buyTokens(uint256 _amount, address _wallet)
        public
        payable
        onlyAuthorized
        whenNotPaused
    {
        require(_amount > 0, "Debe comprar al menos 1 token");
        uint256 finalAmount = _amount;

        // Doble de tokens para los primeros 30,000
        if (tokensSold + _amount <= 30000) {
            finalAmount = _amount * 2; // Duplica la cantidad si está dentro de los primeros 30,000
        } else if (tokensSold < 30000 && tokensSold + _amount > 30000) {
            uint256 bonusAmount = 30000 - tokensSold; // Cantidad que recibe el bono
            finalAmount = bonusAmount * 2 + (_amount - bonusAmount); // Aplica el bono solo a la parte que califica
        }

        uint256 cost = finalAmount * TOKEN_PRICE;
        require(msg.value >= cost, "ETH enviado no es suficiente");
        require(
            finalAmount <= balanceOf(address(this)),
            "No hay suficientes tokens disponibles para la compra"
        );

        tokensSold += finalAmount; // Actualiza el contador de tokens vendidos
        _transfer(address(this), _wallet, finalAmount); // Transfiere la cantidad final de tokens
    }

    function tokensRemainingForICO() public view returns (uint256) {
        return balanceOf(address(this));
    }

    function pauseICO() public onlyOwner {
        _pause();
    }

    function unpauseICO() public onlyOwner {
        _unpause();
    }

    function isICOPaused() public view returns (bool) {
        return paused();
    }

    receive() external payable {}

    fallback() external payable {}
}
