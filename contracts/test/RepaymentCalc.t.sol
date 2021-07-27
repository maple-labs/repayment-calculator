// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.6.11;

import { DSTest } from "../../modules/ds-test/src/test.sol";

import { RepaymentCalc } from "../RepaymentCalc.sol";

contract MockLoan {

    uint256 public apr;
    uint256 public paymentIntervalSeconds;
    uint256 public paymentsRemaining;
    uint256 public principalOwed;

    constructor (uint256 _apr, uint256 _paymentIntervalSeconds, uint256 _paymentsRemaining, uint256 _principalOwed) public {
        apr                    = _apr;
        paymentIntervalSeconds = _paymentIntervalSeconds;
        paymentsRemaining      = _paymentsRemaining;
        principalOwed          = _principalOwed;
    }

}

contract RepaymentCalcTest is DSTest {

    function test_calcType() external {
        assertTrue(new RepaymentCalc().calcType() == uint8(10));
    }

    function test_name() external {
        assertTrue(new RepaymentCalc().name() == "INTEREST_ONLY");
    }

    function assert_nextPayment(
        RepaymentCalc repaymentCalc,
        uint256 apr,
        uint256 paymentIntervalSeconds,
        uint256 paymentsRemaining,
        uint256 principalOwed,
        uint256 expectedTotal,
        uint256 expectedPrincipalOwed,
        uint256 expectedInterest
    ) internal {
        MockLoan loan = new MockLoan(apr, paymentIntervalSeconds, paymentsRemaining, principalOwed);
        (uint256 actualTotal, uint256 actualPrincipalOwed, uint256 actualInterest) = repaymentCalc.getNextPayment(address(loan));
        assertEq(actualTotal,         expectedTotal);
        assertEq(actualPrincipalOwed, expectedPrincipalOwed);
        assertEq(actualInterest,      expectedInterest);
    }

    function test_getNextPayment() external {
        RepaymentCalc repaymentCalc = new RepaymentCalc();
        assert_nextPayment(repaymentCalc, 1_000_000, 500, 2, 1_000_000, 1_585,     0,         1_585);
        assert_nextPayment(repaymentCalc, 1_000_000, 500, 1, 1_000_000, 1_001_585, 1_000_000, 1_585);
        assert_nextPayment(repaymentCalc, 0,         500, 2, 1_000_000, 0,         0,         0);
        assert_nextPayment(repaymentCalc, 0,         500, 1, 1_000_000, 1_000_000, 1_000_000, 0);
        assert_nextPayment(repaymentCalc, 1_000_000, 0,   2, 1_000_000, 0,         0,         0);
        assert_nextPayment(repaymentCalc, 1_000_000, 0,   1, 1_000_000, 1_000_000, 1_000_000, 0);
        assert_nextPayment(repaymentCalc, 1_000_000, 500, 2, 0,         0,         0,         0);
        assert_nextPayment(repaymentCalc, 1_000_000, 500, 1, 0,         0,         0,         0);
    }

}
