extern crate rust_tezos;
extern crate env_logger;
extern crate log;
extern crate docopt;
extern crate serde;
extern crate serde_derive;
extern crate hbbft;
extern crate rand;
extern crate rand_derive;

use rand_derive::Rand;
use std::net::SocketAddr;
use std::collections::HashSet;
use log::{debug, info};
use docopt::Docopt;
use serde_derive::{Deserialize, Serialize};
use hbbft::dynamic_honey_badger::DynamicHoneyBadger;
use hbbft::NetworkInfo;
use hbbft::dynamic_honey_badger::Message;
use hbbft::honey_badger::Message as HbMessage;
use hbbft::honey_badger::MessageContent;
use hbbft::subset;
use hbbft::broadcast;

const VERSION: &str = env!("CARGO_PKG_VERSION");
const USAGE: &str = "
Tezos Vehicular Ad Hoc Sidechain Node

Usage:
  tvahs-node --bind-address=<host:port> [--value=VALUE] [--remote-address=<host:port>]...
  tvahs-node (--help | -h)
  tvahs-node --version
";

#[derive(Debug, Deserialize)]
struct Args {
    bind_address: SocketAddr,
    remote_addresses: HashSet<SocketAddr>,
}

fn parse_args() -> Result<Args, docopt::Error> {
    Docopt::new(USAGE)?
        .version(Some(VERSION.to_string()))
        .parse()?
        .deserialize()
}

fn get_balance() {
    let client = rust_tezos::Client::new();
    let balance = client
        .get_balance("tz1WaWmQgkkcgTxico7gSfcoGZwkDTM6MN1p")
        .unwrap();
    info!("Smart contract balance is {:?} ", balance);
}

#[derive(Serialize, Deserialize, Eq, PartialEq, Ord, PartialOrd, Hash, Debug, Rand, Clone)]
pub struct NodeId(pub usize);

#[derive(Serialize, Deserialize, Eq, PartialEq, Hash, Ord, PartialOrd, Debug, Clone)]
pub struct Transaction(pub Vec<u8>);

fn init_bft(args: Args) {
    let node_ids = (0..2).map(NodeId);
    let netinfos =
        NetworkInfo::generate_map(node_ids, &mut rand::thread_rng()).unwrap();
    let my_netinfo = netinfos.get(&NodeId(0)).unwrap().clone();
    let mut dhb: DynamicHoneyBadger<Vec<Transaction>, NodeId> = DynamicHoneyBadger::builder()
        .build(my_netinfo);
}

fn main() {
    env_logger::init();
    let args: Args = parse_args().unwrap_or_else(|e| e.exit());
    info!("Initializing a Tezos Vehicular Ad Hoc Sidechain Node");
    init_bft(args);
    get_balance();
    info!("<Node is Terminated>");
}
