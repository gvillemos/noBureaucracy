# Holacracy

The management concepts of the future, at least for companies demanding creativity, is decentralized self-organizing organizations (DSOO); organizations in which the focus is on decentralized decision making, minimal centralited power structures and a focus on ensuring that people take ownership (in a team) of their own faith. A Teal organization.
Methods such as Holacracy is one way of structuring a DSOO. Holacracy defines clear processes and clear rules for howto operate a DSOO. As such it is more than concept, it is (in its own words) the DNA of an organization. 

This repository collect smart contracts coded in Solidity.

Documentation
All documentation in https://ethereum.stackexchange.com/questions/51494/which-doxygen-tags-are-allowed-for-contracts
@title - A title that should describe the contract
@author - The name of the author of the contract
@notice - Explain to a user what a function does
@dev - Explain to a developer any extra details
@param - Documents a function parameter
@return - Documents the return type of a function

Patterns

Pattern analysis identifying more than 30 design patterns covering four categories; authorization, control, maintenance and security (https://recipp.ipp.pt/bitstream/10400.22/16441/1/DM_TiagoMoura_2020_MEI.pdf)

* Contract Registry (https://research.csiro.au/blockchainpatterns/general-patterns/contract-structural-patterns/contract-registry/) – Maintain a registry mapping a smart contract name and the address of its latest version. Before invoking a smart contract, look up the registry to find its address

* Data Contract (https://research.csiro.au/blockchainpatterns/general-patterns/contract-structural-patterns/data-contract/) – Store data in a separate smart contract

* Factory Contract (https://research.csiro.au/blockchainpatterns/general-patterns/contract-structural-patterns/factory-contract/) – Use an on-chain contract as a factory to spawn contract instances from a smart contract template

* Incentive Execution (https://research.csiro.au/blockchainpatterns/general-patterns/contract-structural-patterns/incentiveexecution/) – Offer a reward to the caller of a contract function for invoking it

* Restricting Access (https://www.linkedin.com/pulse/ethereum-solidity-smart-contract-design-patterns-wael-yousfi/) - You cannot prevent people or computer programs from reading your contract's state. The state is publicly available information for anyone with access to the blockchain. However, you can restrict other contract's access to the state by making state variables private.

* Auto Deprecation (https://www.linkedin.com/pulse/ethereum-solidity-smart-contract-design-patterns-wael-yousfi/) - The auto deprecation design pattern is a useful strategy for closing contracts that should expire after a certain amount of time. This can be useful when running alpha or beta testing for your smart contracts.

* Mortal (https://www.linkedin.com/pulse/ethereum-solidity-smart-contract-design-patterns-wael-yousfi/) - Implementing the mortal design pattern means including the ability to destroy the contract and remove it from the blockchain.

* Withdrawl (https://www.linkedin.com/pulse/ethereum-solidity-smart-contract-design-patterns-wael-yousfi/) - Pull over Push Payments (also known as the Withdrawal Pattern

* Circuit Breaker (https://www.linkedin.com/pulse/ethereum-solidity-smart-contract-design-patterns-wael-yousfi/) - Circuit Breakers are design patterns that allow contract functionality to be stopped. This would be desirable in situations where there is a live contract where a bug has been detected. Freezing the contract would be beneficial for reducing harm before a fix can be implemented.

* Speed Bump (https://www.linkedin.com/pulse/ethereum-solidity-smart-contract-design-patterns-wael-yousfi/) - Speed bumps slow down actions so that if malicious actions occur, there is time to recover.

* State Machine (https://www.linkedin.com/pulse/ethereum-solidity-smart-contract-design-patterns-wael-yousfi/) - Contracts often act as a state machine, where the contract has certain states in which it behaves differently and different functions can and should be called. A function call often ends a stage and moves the contract to the next stage (especially if the contract models interaction). It is also common that some stages are automatically reached at a certain point in time.

(Github repository; https://github.com/fravoll/solidity-patterns/blob/master/docs/index.md)
