// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.7.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.7.0/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts@4.7.0/token/ERC20/extensions/ERC20Votes.sol";

contract VoteToken is ERC20, Ownable, ERC20Permit, ERC20Votes {
    constructor() ERC20("Vote Token", "VOTE") ERC20Permit("Vote Token") {}

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }

    mapping(address => ClaimerDetail) public ClaimerDetails;

    struct ClaimerDetail {
        uint256 lastClaimBlockHeight; // block height of last claim
        uint256 amountClaimedTotal; // total amount claimed by this address
    }

    receive() external payable {
        // Fallback function to allow contract to recieve Ether
    }

    // Deployer Minting Ability
    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount * 1000000000000000000);
    }

    // Deployer Drain ETH from contract Ability
    function drain(uint256 value) public onlyOwner {
        payable(msg.sender).transfer(value * 1000000000000000000 * (1 wei));
    }

    // Faucet Claim
    function claimOwn() public {
        require(block.number - ClaimerDetails[msg.sender].lastClaimBlockHeight >= 4, "Please wait at least 1 minute (4 blocks) between claims");
        require(ClaimerDetails[msg.sender].amountClaimedTotal <= 2, "You can only claim from this faucet at most twice.");

        payable(msg.sender).transfer(0.05 * 1000000000000000000 * (1 wei));
        _mint(payable(msg.sender), 100 * 1000000000000000000);

        ClaimerDetails[msg.sender].lastClaimBlockHeight = block.number;
        ClaimerDetails[msg.sender].amountClaimedTotal += 1;
    }

    function claimOther(address _to) public {
        require(block.number - ClaimerDetails[_to].lastClaimBlockHeight >= 4, "Please wait at least 1 minute (4 blocks) between claims");
        require(ClaimerDetails[_to].amountClaimedTotal <= 2, "You can only claim from this faucet at most twice.");

        payable(_to).transfer(0.2 * 1000000000000000000 * (1 wei));
        _mint(payable(_to), 100 * 1000000000000000000);

        ClaimerDetails[_to].lastClaimBlockHeight = block.number;
        ClaimerDetails[_to].amountClaimedTotal += 1;
    }

    // Check Claimant Details
    function checkClaimantDetailsOwn() view public returns (ClaimerDetail memory) {
        return ClaimerDetails[msg.sender];
    }

    function checkClaimantDetailsOther(address _claimant) view public returns (ClaimerDetail memory) {
        return ClaimerDetails[_claimant];
    }
}
