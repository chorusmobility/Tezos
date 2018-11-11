extern crate reqwest;

mod error;

pub use self::error::{Error, Result};


pub struct Client {
    provider: String
}

impl Client {
    /// Constructs a new `Client`.
    pub fn new() -> Client {
        Client {
            provider: "https://rpc.tezrpc.me".to_string()
        }
    }

    fn call_rpc(&self, url: String) -> reqwest::Result<String> {
        let full_url = self.provider.clone() + &url;
        let mut result = reqwest::get(&full_url)?;
//        let body = result.text()?;
//        println!("Got an RPC response. Body = {:?}", body);
        return result.json();
    }

    pub fn get_balance(&self, address: &str) -> ::Result<String> {
        let result = self.call_rpc(
            "/chains/main/blocks/head/context/contracts/".to_owned() + address + "/balance");
        return Ok(result.unwrap());
    }

    pub fn get_storage(&self, address: &str) -> ::Result<String> {
        let result = self.call_rpc(
            "/chains/main/blocks/head/context/contracts/".to_owned() + address + "/storage");
        return Ok(result.unwrap());
    }
}
