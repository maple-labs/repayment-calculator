// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.6.11;

import { SafeMath } from "../../lib/openzeppelin-contracts/contracts/math/SafeMath.sol";
import { IERC20 }   from "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import { DSTest } from "../../lib/ds-test/contracts/test.sol";

import { RepaymentCalc } from "../RepaymentCalc.sol";

contract Loan {
    uint256 public principalOwed;
    uint256 public apr;
    uint256 public paymentIntervalSeconds;
    uint256 public paymentsRemaining;

    constructor(uint256 _principalOwed, uint256 _apr, uint256 _paymentIntervalSeconds, uint256 _paymentsRemaining) public {
        apr                    = _apr;
        principalOwed          = _principalOwed;
        paymentsRemaining      = _paymentsRemaining;
        paymentIntervalSeconds = _paymentIntervalSeconds;
    }
}

contract RepaymentCalcTest is DSTest {

    using SafeMath for uint256;

    function test_getNextPayments() public {
        Loan loan               = new Loan(1000, 30000, 5 * 1 days, 500);
        RepaymentCalc repayCalc = new RepaymentCalc();

        // Verify the state variables.
        assertEq(repayCalc.calcType(), uint256(10),     "Incorrect value of repayment calculator type");
        assertEq(repayCalc.name(),     "INTEREST_ONLY", "Incorrect value of repayment calculator name");

        uint256 interest = loan.principalOwed().mul(loan.apr()).mul(loan.paymentIntervalSeconds()).div(365 days).div(10_000);

        (uint256 r_total, uint256 r_principalOwed, uint256 r_interest) = repayCalc.getNextPayment(address(loan));
        assertEq(interest,        r_interest);
        assertEq(interest,        r_total);
        assertEq(r_principalOwed, 0);
    }

}
