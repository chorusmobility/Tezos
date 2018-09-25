[%%version 0.3]

type parameter = 
| Bid of signature
| Reveal of nat * key
| Claim
| Withdraw

type tokenParameter = 
| Mint of nat
| Transfer of address * nat

type storage = {
  seller : address;

  token : tokenParameter contract;
  reservePrice : nat;
  endOfBidding : timestamp;
  endOfRevealing : timestamp;

  highBidder : address option;
  highBid : nat;
  secondBid : nat;

  revealed : (address, bool) map;

  balanceOf : (address, nat) map; 
  hashedBidOf : (address, signature) map;
}

let%init storage (token : tokenParameter contract) (reservePrice : nat) (biddingPeriod : nat) (revealingPeriod : nat) = {
    seller = Current.source ();

    token = token;
    reservePrice = reservePrice;
    endOfBidding = Current.time () + biddingPeriod;
    endOfRevealing = Current.time () + biddingPeriod + revealingPeriod;

    highBidder = (None : address option);
    highBid = 0p;
    secondBid = 0p;

    revealed = (Map: (address, bool) map);

    balanceOf = (Map : (address, nat) map);
    hashedBidOf = (Map : (address, signature) map);
  }

let%entry main (parameter : parameter) (storage : storage) =
  
  match parameter with
    | Bid bidSignature ->
      if Current.time () > storage.endOfBidding then Current.failwith "Bidding already ended";
      if Current.source () = storage.seller then Current.failwith "The seller can't bid";

      let storage = storage.hashedBidOf <- Map.update (Current.source ()) (Some bidSignature) storage.hashedBidOf in
      ([] : operation list), storage
    | Reveal revealParameters ->
      let amount = revealParameters.(0) in
      let storage = storage.revealed <- Map.update (Current.source ()) (Some true) storage.revealed in
      let storage = storage.balanceOf <- Map.update (Current.source ()) (Some amount) storage.balanceOf in
      ([] : operation list), storage
    | Claim ->
      if Current.time () < storage.endOfRevealing then Current.failwith "Revealing isn't finished";
      (match storage.highBidder with
        | None -> Current.failwith "No high bidder";
        | Some highBidderAddress ->
          let op = Contract.call storage.token 0tz (Transfer (highBidderAddress, storage.highBid)) in 
          [op], storage)
    | Withdraw ->
      if Current.time () < storage.endOfRevealing then Current.failwith "Revealing isn't finished";
      match Map.find (Current.source ()) storage.revealed with
        | None ->
          Current.failwith "Sender hasn't revealed";
        | Some revealed ->
          if not revealed then Current.failwith "Sender hasn't revealed"; 
          let withdrawBalance = match Map.find (Current.source ()) storage.balanceOf with
            | None -> 0p
            | Some x -> x
          in
          let op = Contract.call storage.token 0tz (Transfer ((Current.source ()), withdrawBalance)) in 
          [op], storage

