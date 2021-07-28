// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.6.11;

interface ILoanLike {

    function apr() external view returns (uint256);

    function paymentIntervalSeconds() external view returns (uint256);

    function paymentsRemaining() external view returns (uint256);

    function principalOwed() external view returns (uint256);

}
