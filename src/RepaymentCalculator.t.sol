pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "./RepaymentCalculator.sol";

contract RepaymentCalculatorTest is DSTest {
    RepaymentCalculator calculator;

    function setUp() public {
        calculator = new RepaymentCalculator();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
