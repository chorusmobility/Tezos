extern crate rust_tezos;

fn main() {
    println!("Initializing a Chorus Network Node");

    let client = rust_tezos::Client::new();
    let balance = client
        .get_balance("tz1WaWmQgkkcgTxico7gSfcoGZwkDTM6MN1p")
        .unwrap();
    println!("The balance is {:?} ", balance);

    let storage = client
        .get_storage("tz1WaWmQgkkcgTxico7gSfcoGZwkDTM6MN1p")
        .unwrap();
    println!("The storage is {:?} ", storage);

    println!("<Node is Terminated>");
}
