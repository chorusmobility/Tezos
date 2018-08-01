[%%version 0.32]

type parameter = 
| UpdateCurrentLocation of string
| UpdateDestinationLocation of string
| VerifyPositionChange
| Kill
| UpdateLimit of nat
| UpdateTokenAddress of address

type vickreyParameter = 
| Bid of signature
| Reveal of nat * key
| Claim
| Withdraw

type storage = {
  owner : key_hash;
  tokenAddress : address;
  auctionAddress : address;

  endOfBidding : timestamp;
  endOfRevealing : timestamp;
  limit : nat;

  positionOrigin : string;
  positionDestination : string;
}

let%init storage : storage = { 
  owner = (tz1MhhPP2QKZ8As9T5DHWH4WQNtvDoWgzhyF : key_hash);
  tokenAddress = (tz1MhhPP2QKZ8As9T5DHWH4WQNtvDoWgzhyF : address);
  auctionAddress = (tz1MhhPP2QKZ8As9T5DHWH4WQNtvDoWgzhyF : address);

  endOfBidding = 1970-01-01T00:00:00Z;
  endOfRevealing = 1970-01-01T00:00:00Z;
  limit = 100p;

  positionOrigin = "position1";
  positionDestination = "position2";
}

let%entry main (parameter : parameter) (storage : storage)  =
  
  match parameter with
  | UpdateCurrentLocation location ->
    let storage = storage.positionOrigin <- location in
    ([] : operation list), storage

  | UpdateDestinationLocation location ->
    let storage = storage.positionDestination <- location in
    ([] : operation list), storage

  | VerifyPositionChange ->
    let auctionOption = (Contract.at storage.auctionAddress : vickreyParameter contract option) in
    (match auctionOption with
        | None -> Current.failwith "Auction not found"
        | Some auction ->
          let op = Contract.call auction 0tz Withdraw in 
          [op], storage)

  | Kill ->
    let amount = Current.balance () in
    let refundTo = Account.default storage.owner in
    let op = Contract.call refundTo amount () in
    [op], storage

  | UpdateLimit newLimit ->
    let storage = storage.limit <- newLimit in
    ([] : operation list), storage

  | UpdateTokenAddress newAddress ->
    let storage = storage.tokenAddress <- newAddress in
    ([] : operation list), storage
