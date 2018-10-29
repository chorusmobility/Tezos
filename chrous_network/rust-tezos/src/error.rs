#[derive(Debug)]
pub(crate) enum Kind {
    ServerError(String),
}

#[derive(Debug)]
pub struct Error {
    inner: Box<Inner>,
}

#[derive(Debug)]
struct Inner {
    kind: Kind
}


/// A `Result` alias where the `Err` case is `rust_tezos::Error`.
pub type Result<T> = ::std::result::Result<T, Error>;

impl Error {
    fn new(kind: Kind) -> Error {
        Error {
            inner: Box::new(Inner {
                kind,
            }),
        }
    }
}
