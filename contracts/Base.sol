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

/* @title Base class for a HolaDAO contract, implementing the patterns 'Access Restriction', 'Mortal' and 'Circuit Breaker'
*  @notice Aim of this base class is to provide the common sense functionality needed by all contracts. It is important to
* note that this functionality must be added by the users of the class, i.e. they are helper functions.
*
* The implemented patterns are 
* - Mortal. All this Conttract to 'selfdestruct'. In the process all remaining balance is transfered to the owner.
* - Access Restriction. Provide the 'modifiers' to restrict certain functions to addresses assigned as 'admins'. 
* - Circuit Breaker. Provide the 'modifiers' needed to halt execution of the contract, for example in case of misuse or emmergencies
* - Arm-Go. The critical functions (deploy, kill, etc) follows a two step process (arm-go).
*
* The class operates with 3 set of roles
* - Owner. The creator of the contract. Must be 'payable'. Is immutale, i.e. cant be changed. Always also cover the 'Admin' role.
* - Admin. A registered administrator. Must be registered by another admin. Owner is always available as an Admin. Can access all functions. 
* - Anonomous. Has restricted access, i.e. only functions not using the modifier 'isAdmin' can be accessed.
*
* Following deployment the state will be 'inactive' following the Circuit Breaker pattern. The contract must be 
* activated explicitly (arm-go principle).
*
* Selfdestruct must be done in two steps (arm-go principle); first the contract must be deactivated, then it can be killed.
*/
contract Base {

    /* @notice 
    *  @dev This could likely be immutable
    */
    address payable private owner;

    /* @notice */
    mapping(address => bool) private admins;

    /* @notice */
    bool private active;

    /* @notice
    *  @param
    *  @return
    */
    constructor() {
        owner = payable(msg.sender);
        active = false;
    }

    /* @notice
    *  @param
    *  @return
    */
    modifier isActive() {
        require(active == true, "Can only be executed when contract is active. Contract is inactive");
        _;
    }

    /* @notice
    *  @param
    *  @return
    */
    modifier isInactive() {
        require(active == false, "Can only be executed when contract is inactive. Contract is active.");
        _;
    }

    /* @notice
    *  @param
    *  @return
    */
    modifier isAdmin() {
        require(admins[msg.sender] == true || msg.sender == address(owner), "Can only be executed as admin.");
        _;
    }

    /* @notice
    *  @param
    *  @return
    */
    function addAdmin(address newAdmin) 
    isAdmin
    public
    {
        admins[newAdmin] = true;
    }

    /* @notice
    *  @param
    *  @return
    */
    function removeAdmin(address newAdmin) 
    isAdmin
    public
    {
        admins[newAdmin] = false;
    }

    /* @notice
    *  @param
    *  @return
    */
    function activate() 
    isAdmin
    public
    {
        active = true;
    }

    /* @notice
    *  @param
    *  @return
    */
    function deactivate()
    isAdmin
    public
    {
        active = false;
    }

    /* @notice
    *  @param
    *  @return
    */
    function inState()
    public
    view
    returns(bool)
    {
        return active;
    }

    /* @notice
    *  @param
    *  @return
    */
    function getOwner() 
    public
    view
    returns (address payable) 
    {
        return owner;
    }

    /* @notice
    *  @param
    *  @return
    */
    function isAddressAdmin(address admin) 
    public
    view
    returns(bool)
    {
        return admins[admin];
    }
    /* @notice
    *  @param
    *  @return
    */
    function kill() 
    isAdmin
    isInactive
    public
    {
        selfdestruct(payable(owner));
    }
}
