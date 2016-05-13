//
//  LRUCache.swift
//  A1
//
//  Created by CY Wu on 2016/5/11.
//  Reference from https://gist.github.com/AquaGeek
//
// Implementation of LRUCache

private class LRUCacheNode<Key: Hashable, Value> {
    let key: Key
    var value: Value
    var previous: LRUCacheNode?
    var next: LRUCacheNode?
    
    init(key: Key, value: Value) {
        self.key = key
        self.value = value
    }
}

class LRUCache<Key: Hashable, Value> {
    private typealias Node = LRUCacheNode<Key, Value>
    
    private var capacity: Int
    
    private var storage: Dictionary<Key, Value>
    private var head: Node?
    private var tail: Node?
    
    init(capacity: Int) {
        self.capacity = capacity
        self.storage = Dictionary<Key, Value>(minimumCapacity: capacity)
    }
    
    subscript (key: Key) -> Value? {
        get {
            if let node = findNode(key) {
                // Move the node to the front of the list
                moveNodeToFront(node)
            }
            
            return storage[key]
        }
        set(newValue) {
            storage[key] = newValue
            
            if let value = newValue {
                // Value was provided. Find the corresponding node, update its value, and move
                // it to the front of the list. If it's not found, create it at the front.
                if let node = findNode(key) {
                    node.value = value
                    moveNodeToFront(node)
                } else {
                    var newNode = Node(key: key, value: value)
                    addNodeToFront(newNode)
                    
                    // Truncate from the tail
                    if count > capacity {
                        for _ in capacity..<count {
                            storage[tail!.key] = nil
                            tail = tail?.previous
                        }
                    }
                }
            } else {
                // Value was removed. Find the corresponding node and remove it as well.
                if let node = findNode(key) {
                    removeNode(node)
                }
            }
        }
    }
    
    var count: Int {
        return storage.count
    }
    
    
    // MARK: -
    
    private func addNodeToFront(node: Node) {
        if let headNode = head {
            head = node
            node.next = headNode
            headNode.previous = node
        } else {
            head = node
            tail = node
        }
    }
    
    private func moveNodeToFront(node: Node) {
        // Link the previous node to the next
        removeNode(node)
        
        // Then prepend this node at the front of the list
        node.next = head
        head = node
    }
    
    private func findNode(key: Key) -> Node? {
        var node = head
        var found = false
        
        while node != nil {
            if node?.key == key {
                found = true
                break
            } else {
                node = node?.next
            }
        }
        
        if !found {
            node = nil
        }
        
        return node
    }
    
    private func removeNode(node: Node) {
        // Remove the given node by linking the previous node to the next
        let previous = node.previous
        let next = node.next
        
        previous?.next = next
        next?.previous = previous
        
        // Update the tail, if necessary
        if tail?.key == node.key {
            tail = previous
        }
    }
}