# Tezos Vehicular Network Project Status: 
## Phase 1 (Implemented):

* Choose technologies for Tezos Vehicular Ad Hoc Network implementation:
  1. Rust as the sidechain implementation language
  2. Honey Badger BFT as the sidechain consensus algorithm
  3. POA Network HBBFT as the upstream Honey Badger implementation in Rust
  4. Reqwest as the HTTP RPC library for interaction with Tezos Nodes

* Set up Cargo Workspace-based project to manage internal dependencies between project. This also allows us to later publish sub-projects as separate crates once they become mature

* Set up a project for Tezos-Rust RPC bindings on top of the Reqwest HTTP library

* Implement a minimal test of Test-Rust RPC connectivity

* Set up a project for the Vehicular Sidechain node

## Phase 2 (In progress):

* Implement a minimal test of the Vehicular Sidechain node connectivity on top of the POA Network HBBFT library

* Implement parts of the Tezos JSON/RPC API surface in our Tezos-Rust bindings crate

* Implement a minimal example of Vehicular Sidechain node <-> Test-Rust bindings connectivity

## Phase 3 (To be implemented next):

* Continue covering more of Tezos JSON/RPC API surface in our Tezos-Rust bindings

* Cover the Tezos-Rust bindings with tests

* Cover the Vehicular Sidechain node with tests

* Implement more PoC vehicular interaction scenarios on top of our code base

## Phase 4 (to be scheduled and implemented later):

* Establish load testing and performance/timing standards and regression tracking

* Iterate on algorithmic optimizations and trade-offs to meet real-world performance requirements

* Establish contribution standards and help the open-source community join the project


------------------------------------------------------------------------------------------------------------------

# Liquidity Smart Contracts compiled to Michelson

## Proof-of-Yield


Liquidity smart contract for the road space negotiation using Vickrey auctions. The contract is triggered in case two vehicles conduct a road-space negotiation auction that results either in a change of positions or is aborted. The contracts implements a prototype of a standard protocol for autonomous vehicle communication and processing of P2P micro payments within Vehicular Ad-Hoc Networks (VANETs).

## Vickrey Auction

A further important core concept of the Chorus V2X system is to support the exchange and provision of goods on services between entities. When trading goods and services, the buying and the selling party usually have contrary goals in terms of pricing. The seller's goal is to maximize his/her profits while the buyer tries to minimize the costs. Auctions are a common approach to reach a consensus on a certain price between buyer and seller. We designed two auction algorithms based on the concept of so called Vickrey Auction. An algorithm for the scenario with exactly one buyer and one seller, as well as an algorithm that can be used in scenarios with multiple buyers and multiple sellers.  During a Vickrey auction, participants exchange sealed bids. Each bidder submits a written and signed bid without having any knowledge of the bids of the other participants. After submitting all bids, the sealed bids are opened and the highest bidder wins. But instead of paying the price of this highest offer, the price paid is the second-highest bid. 

An example of a Vickrey auction with multiple buyers and sellers is illustrated below. We assume a scenario where buyer one is willing to pay a price of $1.80, buyer two offers a price of $3.20 and buyer three offering $3.50. The seller is not selling for less than $2.0. Again, we only conduct a single auction round and the buyers as well as the seller all submit their bid in an encrypted and signed envelope that is distributed and send to all registered participants. As soon as all participants received the bids, the encryption keys are exchanged as well and the sealed bids are decrypted. Buyer three wins the auction and pays the seller the price of buyer two that offered $3.20.

In case we have multiple sellers, the sequence diagram is almost identical and the bidding process follows the same procedure. Except in the end, the highest bidder is paying the second highest price to  the seller with the highest minimum price, and so on - as long as the paid price is higher than the matched seller's minimum price.


