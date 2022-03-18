// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
import "../contracts/Base.sol";


contract Helper {

    Base subject;

    constructor(Base theSubject) {
        subject = theSubject;
    }

    function tryToActivate() public {
        subject.activate();
    }

    function tryToDeactivate() public {
        subject.deactivate();
    }

}

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {

    Base subject;
    Helper helper;

    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        subject = new Base();
        helper = new Helper(subject);

        // Must be inactive per default
        Assert.ok(subject.inState() == false, "Contract should be in state inactive when deployed");

        // Owner should be the creator (this)
        Assert.ok(subject.getOwner() == address(this), "'this' i.e. the initiator should be owner.");
    }

    function checkActivation() public {
        subject.activate();
        Assert.ok(subject.inState() == true, "Failed to activate contract.");

        subject.deactivate();
        Assert.ok(subject.inState() == false, "Failed to deactivate contract.");

        helper.tryToActivate();
        Assert.ok(subject.inState() == false, "Non admin managed to activate contract.");

        helper.tryToDeactivate();
        Assert.ok(subject.inState() == false, "De activate of non admin lead to active state.");


        subject.addAdmin(address(helper));
        helper.tryToActivate();
        Assert.ok(subject.inState() == true, "Assigned admin cant activate contract.");

        helper.tryToDeactivate();
        Assert.ok(subject.inState() == false, "De activate of non admin lead to active state.");
        subject.removeAdmin(address(helper));

    }

    function checkAdmin() public {

        // Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
        // Assert.ok(2 == 2, 'should be true');
    }
}
    