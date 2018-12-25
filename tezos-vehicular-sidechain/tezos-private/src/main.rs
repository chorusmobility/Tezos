extern crate run_script;
extern crate log;
extern crate reqwest;

use log::info;
use run_script::ScriptOptions;

fn check_docker() {
    let (code, output, error) = run_script::run(
        r#" which docker > /dev/null 2>&1 "#,
        &vec![],
        &ScriptOptions::new(),
    ).unwrap();

    if code != 0 {
        panic!("The Docker daemon has to be installed to run Tezos nodes");
    }
}

fn download_tezos_script() -> String {
    let mut res =
        reqwest::get("https://gitlab.com/tezos/tezos/raw/master/scripts/alphanet.sh").unwrap();

    if res.status().as_u16() != 200 {
        panic!("Error downloading the Tezos container init script");
    }

    return res.text().unwrap();
}

fn run_tezos_container(script: String) {
    let (code, output, error) = run_script::run(
        script.as_str(),
        &vec!["start".to_string()],
        &ScriptOptions::new(),
    ).unwrap();

    println!("{}", output);
}

fn main() {
    env_logger::init();
    info!("Starting a private Tezos node");
    check_docker();
    let script = download_tezos_script();
    run_tezos_container(script);
}
