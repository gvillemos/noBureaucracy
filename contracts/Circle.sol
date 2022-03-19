// SPDX-License-Identifier: Apache-2.0

/**
* Copyright 2022 
* @author: Gert Villemos (gvillemos@gmail.com)
*
* THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING 
* BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
* OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*
*/

pragma solidity ^0.8.0;

import "./Base.sol";

/* @title 
*  @notice (from https://www.holaspirit.com/blog/holacracy)
* Circles in Holacracy are basically the equivalent of teams in traditional organizations.
* With a few key differences
* 1/ In Holacracy, each circle has a clear purpose whereas traditional teams are often functional, focused on delivering tasks. 
* 2/ In part because a new role doesn’t necessarily mean new hire, Holacratic circles evolve constantly whereas traditional teams tend to be fixed.
* 3/ Holacratic circles naturally include people with different sets of expertise whereas traditional teams are often one-dimensional.
* 4/ Circle lead links distribute their authority whereas traditional managers tend to call the shots and tell their team what to do and how to do it.
* 
* Circle Lead Links
* In a Holacracy circle, the Circle Lead Link is “the role responsible for assigning other roles and allocating resources”. 
* If we take traditional organizations as a frame of reference, the lead link is similar to a department or team manager, it:
* 1/ allocates people to roles in the circle,
* 2/ can define an overall strategy and priorities for the circle,
* 3/ is responsible for all unassigned accountabilities in that circle.
* However, Lead Link’s and traditional managers are different in two key aspects:
* 1/ Lead Links can’t tell people how to do their jobs,
* 2/ team members have a say in the Lead Link’s role, domain and accountabilities.
*/
contract Circle is Base {
    /** A link to an external tool is expected, i.e. for example to HolaSpirit or Glassfrog. In that
    tool the roles, accountabilities and tensions will be recorded. These are not here. This contract 
    reflects the circles balance, i.e. its bank account
    1/ Who can access it?
    2/ What can they do?
    3/ Do it! */

    /* @notice Map of all members of this circle. Only members of the circle can perform functions on the circle.
    *  @dev Linkely need a link to an external DB in the future, i.e. to HolaSpirit or Glassfrog*/
    mapping(address => bool) members private;

    /* @notice the maximal amount that can be automatically reimbursed. */
    uint limit public;
    
    public function addMember(address member) 
    isAdmin
    isActive
    {
        members[member] = true;
    }

    public function removeMember(address member) 
    isAdmin
    isActive
    {
        members[member] = false;
    }

    modifier isMember(address requester) {
        require(members[requester] > 0);
        _;
    }

    modifier hasBalance(uint amount) {
        require(address(this).balance > amount)
        _;
    }

    function requestReimbursement(uint amount) 
    isMember(msg.sender)
    isActive
    isWithinLimit(amount)
    {


    }

   /* @notice Map of all members of this circle. Only members of the circle can perform functions on the circle.
    * @dev This should likely use the 'withdraw' pattern. */
    function confirmReimbursement(address requester, uint timestamp) 
    isMember(msg.sender)
    isMember(requester)
    requestExist(requester, timestamp)
    isActive
    {

    }
}
