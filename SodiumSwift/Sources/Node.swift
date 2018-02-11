import Foundation

internal class INode : NSObject, Comparable
{
    static let Null = INode(rank: 0x123456789)
    
    // Fine-grained lock that protects listeners and nodes.
    internal static let ListenersLock = NSObject()

    fileprivate var _rank: Int64

    internal init(rank: Int64) {
        self._rank = rank
    }

    internal var rank: Int64 { return self._rank }

    internal static func ensureBiggerThan(_ node: INode, limit: Int64, visited: inout Set<INode>) -> Bool {
        if (node.rank > limit || visited.contains(node))
        {
            return false
        }

        visited.insert(node)
        node._rank = limit + 1
        for n in node.getListenerNodesUnsafe()
        {
            ensureBiggerThan(n, limit: node.rank, visited: &visited)
        }

        return true
    }

    func getListenerNodesUnsafe() -> [INode] { return [] }

    class Target : NSObject
    {
        let node: INode

        init(node: INode)
        {
            self.node = node
        }
    }
}

func ==(lhs: INode, rhs: INode) -> Bool {
    return lhs.rank == rhs.rank
}
func <(lhs: INode, rhs: INode) -> Bool {
    return lhs.rank < rhs.rank
}
func <=(lhs: INode, rhs: INode) -> Bool {
    return lhs.rank <= rhs.rank
}
func >=(lhs: INode, rhs: INode) -> Bool {
    return lhs.rank >= rhs.rank
}
func >(lhs: INode, rhs: INode) -> Bool {
    return lhs.rank > rhs.rank
}

internal class Node<T> : INode
{
    typealias Action = (Transaction, T) -> Void
    
    fileprivate var listeners = Array<NodeTarget<T>>()

    internal override init(rank: Int64)
    {
        super.init(rank: rank)
    }

    /**
     Link an action and a target node to this node.

     - Parameter action: The action to link to this node.
     - Parameter target: The target node to link to this node.
     - Returns: A tuple containing whether or not changes were made to the node rank and the `target` object created for this link.
     */
    internal func link(_ action: @escaping Action, target: INode) -> (Bool, NodeTarget<T>) {
        objc_sync_enter(INode.ListenersLock)
        defer { objc_sync_exit(INode.ListenersLock) }

        var v = Set<INode>()
        let changed = INode.ensureBiggerThan(target, limit: self.rank, visited: &v)
        let t = NodeTarget(action: action, node: target)
        self.listeners.append(t)
        return (changed, t)
    }

    internal func unlink(_ target: NodeTarget<T>)
    {
        self.removeListener(target)
    }


    internal func getListeners() -> [NodeTarget<T>]
    {
        objc_sync_enter(INode.ListenersLock)
        defer { objc_sync_exit(INode.ListenersLock) }
        
        return self.listeners
    }

    internal func removeListener(_ target: NodeTarget<T>) {
        objc_sync_enter(INode.ListenersLock)
        defer { objc_sync_exit(INode.ListenersLock) }

        self.listeners.remove(target)
    }

    override func getListenerNodesUnsafe() -> [INode] {
        objc_sync_enter(INode.ListenersLock)
        defer { objc_sync_exit(INode.ListenersLock) }
        
        return self.listeners.map{ $0.node }
    }
}

/// Note: Swift won't do internal classes for generic classes.
class NodeTarget<T> : INode.Target
{
    typealias Action = (Transaction, T) -> Void
    
    internal var action: Action
    
    internal init(action: @escaping Action, node: INode)
    {
        self.action = action
        super.init(node: node)
    }
}

func ==<T>(lhs: NodeTarget<T>, rhs: NodeTarget<T>) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
