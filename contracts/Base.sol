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

    /* @notice The single owner. The creator of the contract is automatically the owner and cannot be
    *  changed.
    *  @dev This could likely be immutable
    */
    address payable private owner;

    /* @notice Lits of all admins. */
    mapping(address => bool) private admins;

    /* @notice State of the conttract. Possible states are true (active) or false (inactive) */
    bool private active;

    /* @notice Create the contract and assign the caller as owner
    */
    constructor() {
        owner = payable(msg.sender);
        active = false;
    }

    /* @notice Modifier to check whether the contract is active. Implements the circuit break pattern.
    *  All functions who should only be possible in an 'active' state should use this modifier.
    */
    modifier isActive() {
        require(active == true, "Can only be executed when contract is active. Contract is inactive");
        _;
    }

    /* @notice Modifier to check whether the contract is inactive. Implements the circuit break pattern.
    *  All functions who should only be possible in an 'inactive' state should use this modifier.
    */
    modifier isInactive() {
        require(active == false, "Can only be executed when contract is inactive. Contract is active.");
        _;
    }

    /* @notice Modifier to check whether the caller is an administrator. Implements the circuit restricted access pattern.
    *  All functions which can only be executed by admins should use this modifier.
    */
    modifier isAdmin() {
        require(admins[msg.sender] == true || msg.sender == address(owner), "Can only be executed as admin.");
        _;
    }

    /* @notice Adds an address as administrator. Can only be called by an existing admin. Notice that the owner is always admin.
    *  @param address to be added as an admin
    */
    function addAdmin(address newAdmin) 
    isAdmin
    public
    {
        admins[newAdmin] = true;
    }

    /* @notice Remove an adress as administrator.
    *  @param address to be removed
    */
    function removeAdmin(address oldAdmin) 
    isAdmin
    public
    {
        admins[oldAdmin] = false;
    }

    /* @notice function to activate this contract. Can only be called by an admin. Implement the 'Circuit Break' pattern.
    */
    function activate() 
    isAdmin
    public
    {
        active = true;
    }

    /* @notice function to deactive this contract. Can only be called by an admin. Implement the 'Circuit Break' pattern.
    */
    function deactivate()
    isAdmin
    public
    {
        active = false;
    }

    /* @notice function to check the current runtime state of this contract.
    *  @return bool indicating state. true = active, false = inactive
    */
    function inState()
    public
    view
    returns(bool)
    {
        return active;
    }

    /* @notice function to get the address of the owner of the contract
    *  @return payable address of the owner
    */
    function getOwner() 
    public
    view
    returns (address payable) 
    {
        return owner;
    }

    /* @notice function to check whether a specific address is an admin
    *  @param address to be checked whether admin or not
    *  @return bool whether the provided address is admin (true) or not (false)
    */
    function isAddressAdmin(address admin) 
    public
    view
    returns(bool)
    {
        return admins[admin];
    }

    /* @notice Function to permanently kill this contract, i.e. irreversiably remove the contracts from the
    *  chain. In the case of termination the remaining balance of the contract is transfered to the owner.
    * 
    *  Can only be called by an admin. Can only be called in an inactive state, i.e. first the contract must be 
    *  deactivated, then it can be killed (arm-go principle).
    */
    function kill() 
    isAdmin
    isInactive
    public
    {
        selfdestruct(payable(owner));
    }
}
