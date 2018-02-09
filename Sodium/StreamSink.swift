/**
 A stream that allows values to be pushed into it, acting as an interface between the world of I/O and the world of FRP.  Code that exports StreamSinks for read-only use should downcast to `Stream<T>`.

 - Parameter T: The type of values fired by the stream.
 */
open class StreamSink<T> : Stream<T>
{
    typealias Action = (Transaction, T) -> Void
    
    fileprivate var coalescer: Action = { _,_ in }
    fileprivate let fold: (T,T)->T
   
    /// Construct a StreamSink that uses the last value if `Send` is called more than once per transaction.
    public convenience override init(refs: MemReferences? = nil)
    {
        self.init(fold: { (left, right) in fatalError("Send was called more than once in a transaction, which isn't allowed.  To combine the streams, pass a coalescing function to the StreamSink constructor.")
            return right
        }, refs: refs)
    }

    /**
     Construct a StreamSink that uses
     - Parameter fold: to combine values if `send` is called more than once per transaction.
     */
    public init(fold: @escaping (T,T) -> T, refs: MemReferences? = nil)
    {
        self.fold = fold
        super.init(refs: refs)
        let h = CoalesceHandler<T>()
        self.coalescer = h.create(fold, out: self)
    }

    /**
     Send a value.  This method may not be called from inside handlers registered with `Stream<T>.listen(Action<T>)` or `Cell<T>.listen(Action<T>)`.  An exception will be thrown, because sinks are for interfacing I/O to FRP only.  They are not meant to be used to define new primitives.

     - Parameter a: The value to send.
    */
    open func send(_ a: T) {
        Transaction.run(
        {
            trans in
            if (Transaction.inCallback > 0) {
                fatalError("Send() may not be called inside a Sodium callback.")
            }
            self.coalescer(trans, a)
        })
    }
}
