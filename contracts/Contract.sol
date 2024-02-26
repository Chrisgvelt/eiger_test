// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ERC20Swapper {
    /// @dev swaps the `msg.value` Ether to at least `minAmount` of tokens in `address`, or reverts
    /// @param token The address of ERC-20 token to swap
    /// @param minAmount The minimum amount of tokens transferred to msg.sender
    /// @return The actual amount of transferred tokens
    function swapEtherToToken(address token, uint minAmount) external payable returns (uint);
}

contract ERC20SwapperContract is ERC20Swapper, Initializable {
    IUniswapV2Router02 public uniswapRouter;

    function initialize(address _uniswapRouter) public initializer {
        uniswapRouter = IUniswapV2Router02(_uniswapRouter);
    }

    function swapEtherToToken(address token, uint minAmount) public payable override returns (uint) {
        require(msg.value > 0, "No Ether sent");
        require(minAmount > 0, "Minimum amount must be greater than 0");

        address[] memory path = new address[](2);
        path[0] = uniswapRouter.WETH();
        path[1] = token;

        uint[] memory amounts = uniswapRouter.swapExactETHForTokens{value: msg.value}(minAmount, path, msg.sender, block.timestamp + 15 minutes);

        // Transfer tokens to the sender
        // IERC20(token).transfer(msg.sender, amounts[1]);

        return amounts[1];
    }

    // Helper function to get token price
    function getTokenPrice(address token) public view returns (uint) {
        address[] memory path = new address[](2);
        path[0] = uniswapRouter.WETH();
        path[1] = token;

        uint[] memory amounts = uniswapRouter.getAmountsOut(1e18, path); // 1 ETH in wei

        return amounts[1];
    }
}