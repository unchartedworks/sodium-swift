internal class CoalesceHandler<T>
{
    typealias Action = (Transaction, T) -> Void
    var accum: T?
    
    func create(_ f: @escaping (T,T) -> T, out: Stream<T>) -> Action {
        return { /*[weak out]*/ (trans1, a) in
    
            if let acc = self.accum {
                self.accum = f(acc, a)
            }
            else {
                trans1.prioritized(out.node) { trans2 in
                    out.send(trans2, a: self.accum!)
                    self.accum = nil
                }
                self.accum = a
            }
        }
    }
}
