[%%version 0.3]

type parameter = 
| Mint of nat
| Transfer of address * nat

type storage = {
  owner: address;
  balance : (address, nat) map;
}

let%init storage =
  {
    owner = (tz1MhhPP2QKZ8As9T5DHWH4WQNtvDoWgzhyF : address);
    balance = (Map : (address, nat) map);
  }

let%entry main (parameter : parameter) (storage : storage) =

  match parameter with
    | Mint amount ->
      if (Current.source ()) <> storage.owner then Current.failwith "Only the owner can mint";
      let oldBalance = match Map.find (Current.source ()) storage.balance with
        | None -> 0p
        | Some x -> x
      in
      let newBalance = oldBalance + amount in
      let storage = storage.balance <- Map.update (Current.source ()) (Some newBalance) storage.balance in
      ([] : operation list), storage


    | Transfer arg -> 
      let source = Current.source () in
      let sourceBalance = match Map.find source storage.balance with
        | None -> 0p
        | Some x -> x
      in
      let target = arg.(0) in
      let amount = arg.(1) in
      match%nat (sourceBalance - amount) with
      | Minus _ ->
        Current.failwith "Insufficient balance"
      | Plus diff ->
        let newSourceBalance = diff in
        let newTargetBalance = amount + (match Map.find target storage.balance with
          | None -> 0p
          | Some x -> x)
        in
        let storage = storage.balance <- Map.update source (Some newSourceBalance) storage.balance in
        let storage = storage.balance <- Map.update target (Some newTargetBalance) storage.balance in
        ([] : operation list), storage
