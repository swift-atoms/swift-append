@frozen
public struct Append<
    Accumulated: ~Copyable & ~Escapable,
    Next: ~Copyable & ~Escapable,
    Output: ~Copyable & ~Escapable,
    Failure: Swift.Error
> {

    public let appending: @_lifetime(captures, copy accumulated, copy next)
        (_ accumulated: consuming Accumulated, _ next: consuming Next) throws(Failure) -> Output

    @inlinable
    public init(
        appending: @escaping @_lifetime(captures, copy accumulated, copy next)
        (_ accumulated: consuming Accumulated, _ next: consuming Next) throws(Failure) -> Output
    ) {
        self.appending = appending
    }

    @inlinable
    @_lifetime(borrow self, copy accumulated, copy next)
    public borrowing func callAsFunction(
        _ accumulated: consuming Accumulated,
        _ next: consuming Next
    ) throws(Failure) -> Output {
        try appending(accumulated, next)
    }
}

extension Append where Failure == Never {

    @inlinable
    public init<each Element>()
    where
        Accumulated == (repeat each Element),
        Output == (repeat each Element, Next),
        Next: Copyable & Escapable
    {
        self.init { accumulated, next in
            (repeat each accumulated, next)
        }
    }
}
