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

    function checkAdmin() public {

        address admin1 = TestsAccounts.getAccount(0); 
        address admin2 = TestsAccounts.getAccount(1);
        address admin3 = TestsAccounts.getAccount(2);
        address admin4 = TestsAccounts.getAccount(3);

        subject.addAdmin(admin1);
        Assert.ok(subject.isAddressAdmin(admin1) == true, 'should be true');
        Assert.ok(subject.isAddressAdmin(admin2) == false, 'should be true');
        Assert.ok(subject.isAddressAdmin(admin3) == false, 'should be true');
        Assert.ok(subject.isAddressAdmin(admin4) == false, 'should be true');

        subject.addAdmin(admin2);
        Assert.ok(subject.isAddressAdmin(admin1) == true, 'should be true');
        Assert.ok(subject.isAddressAdmin(admin2) == true, 'should be true');
        Assert.ok(subject.isAddressAdmin(admin3) == false, 'should be true');
        Assert.ok(subject.isAddressAdmin(admin4) == false, 'should be true');

        subject.addAdmin(admin3);
        Assert.ok(subject.isAddressAdmin(admin1) == true, 'should be true');
        Assert.ok(subject.isAddressAdmin(admin2) == true, 'should be true');
        Assert.ok(subject.isAddressAdmin(admin3) == true, 'should be true');
        Assert.ok(subject.isAddressAdmin(admin4) == false, 'should be true');

        subject.removeAdmin(admin3);
        Assert.ok(subject.isAddressAdmin(admin1) == true, 'should be true');
        Assert.ok(subject.isAddressAdmin(admin2) == true, 'should be true');
        Assert.ok(subject.isAddressAdmin(admin3) == false, 'should be true');
        Assert.ok(subject.isAddressAdmin(admin4) == false, 'should be true');

        subject.removeAdmin(admin1);
        Assert.ok(subject.isAddressAdmin(admin1) == false, 'should be true');
        Assert.ok(subject.isAddressAdmin(admin2) == true, 'should be true');
        Assert.ok(subject.isAddressAdmin(admin3) == false, 'should be true');
        Assert.ok(subject.isAddressAdmin(admin4) == false, 'should be true');

        subject.removeAdmin(admin2);
        Assert.ok(subject.isAddressAdmin(admin1) == false, 'should be true');
        Assert.ok(subject.isAddressAdmin(admin2) == false, 'should be true');
        Assert.ok(subject.isAddressAdmin(admin3) == false, 'should be true');
        Assert.ok(subject.isAddressAdmin(admin4) == false, 'should be true');
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

        // Register helper as admin, then the class should be able to activate / deactivate
        subject.addAdmin(address(helper));
        helper.tryToActivate();
        Assert.ok(subject.inState() == true, "Assigned admin cant activate contract.");

        helper.tryToDeactivate();
        Assert.ok(subject.inState() == false, "De activate of non admin lead to active state.");
        subject.removeAdmin(address(helper));

    }

}
    