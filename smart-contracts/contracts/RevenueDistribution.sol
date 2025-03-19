// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract RevenueDistribution is AccessControl {
    bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");
    bytes32 public constant EDITOR_ROLE = keccak256("EDITOR_ROLE");
    bytes32 public constant INVESTOR_ROLE = keccak256("INVESTOR_ROLE");

    IERC20 public usdcToken;

    constructor(address _usdcToken) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        usdcToken = IERC20(_usdcToken);
    }

    function distributeRevenue(
        address creator,
        address editor,
        address investor,
        uint256 creatorShare,
        uint256 editorShare,
        uint256 investorShare
    ) external {
        require(hasRole(CREATOR_ROLE, creator), "Caller is not a creator");
        require(hasRole(EDITOR_ROLE, editor), "Caller is not an editor");
        require(hasRole(INVESTOR_ROLE, investor), "Caller is not an investor");

        uint256 totalAmount = creatorShare + editorShare + investorShare;
        require(usdcToken.transferFrom(msg.sender, address(this), totalAmount), "Transfer failed");

        usdcToken.transfer(creator, creatorShare);
        usdcToken.transfer(editor, editorShare);
        usdcToken.transfer(investor, investorShare);
    }
}
