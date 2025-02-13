// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/*
 * @title RebaseToken
 * @author pandit dhamdhere
 * @notice This is a cross-chain rebase token that incentivises users to deposit into a vault and gain interest in rewards.
 * @notice The interest rate in the smart contract can only decrease
 * @notice Each will user will have their own interest rate that is the global interest rate at the time of depositing.
 */

contract RebaseToken is ERC20 {
    /// ERRORS
    error RebaseToken__InterestRateCanOnlyDecrease(
        uint256 oldInterestRate,
        uint256 newInterestRate
    );

    /////////////////////
    // State Variables
    /////////////////////
    uint256 private s_interestRate = 5e10;
    mapping(address => uint256) private s_userInterestRate;

    /// events
    event InterestRateSet(uint256 newInterestRate);

    constructor() ERC20("RebaseToken", "RBT") {}

    function setInterestRate(uint256 _newInterestRate) external {
        // set interestRate
        if (_newInterestRate < s_interestRate) {
            revert RebaseToken__InterestRateCanOnlyDecrease(
                s_interestRate,
                _newInterestRate
            );
        }
        s_interestRate = _newInterestRate;
        emit InterestRateSet(_newInterestRate);
    }

    function mint(address _to, uint256 _amount) external {
        s_userInterestRate[_to] = s_interestRate;
        _mint(_to, _amount);
    }

    function getUserIntrestRate(address _user) external view returns (uint256) {
        return s_userInterestRate[_user];
    }
}
