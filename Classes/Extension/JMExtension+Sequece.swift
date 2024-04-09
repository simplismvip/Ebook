//
//  JMExtension+Sequece.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/7/2.
//  Copyright © 2022 JunMing. All rights reserved.
//

import UIKit

extension Array where Element: Equatable {
    /// 查找某个元素的位置，这个方法是下面index的特殊情况
    public func index(of element: Element) -> Int? {
        for idx in self.indices where self[idx] == element {
            return idx
        }
        return nil
    }
    
    /// 移除元素
    public mutating func jmRemoveObject(_ element: Element) -> [Element] {
        if let index = self.index(of: element) {
            self.remove(at: index)
        }
        return self
    }
    
    /// 删除元素
    public mutating func jmDeleteObject(_ model: Element, inArray: inout [Element]) {
        var findIndex: Int?
        for (index,item) in inArray.enumerated() {
            if item == model {
                findIndex = index
                break
            }
        }
        
        if let index = findIndex {
            inArray.remove(at: index)
        }
    }
}

extension Array {
    /// 使用小数组中元素移除大数组中元素
    /// - Parameters:
    ///   - items: 小数组，被移除的元素
    ///   - transFrom: 操作
    /// - Returns: 移除后的新数组
    public func jmRemove(by items: [Element], _ transFrom: (Element, Element)-> Bool) -> [Element] {
        return filter { (model) -> Bool in
            return !items.contains { (item) -> Bool in
                return transFrom(model, item)
            }
        }
    }
    
    /// 查找首个符合条件元素的位置，返回索引位置
    public func jmIndex(_ transfrom:(Element) -> Bool) -> Int?  {
        var result: Int?
        for (index,x) in enumerated() where transfrom(x) {
            result = index
            break
        }
        return result
    }
    
    /// 查找序列中一组满足某个条件的元素个数，并未构建数组，比使用Filter高效
    public func jmCount(where predicate:(Element) ->Bool) -> Int? {
        var result = 0
        for element in self where predicate(element) {
            result += 1
        }
        return result
    }
    
    /// 类似reduce
    public func jmAccumulate<Result>(_ initialResult:Result, _ nextPartialResult:(Result,Element) ->Result) -> [Result] {
        var running = initialResult
        return map { (next) -> Result in
            running = nextPartialResult(running,next)
            return running
        }
    }
    
    /// 安全索引
    public subscript (safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Sequence where Element: Hashable {
    /// 去掉重复元素，并按照顺序返回。正常使用Set返回的元素是无序的
    public func jmUnique() -> [Element] {
        var seen:Set<Element> = []
        return filter { (element) -> Bool in
            if seen.contains(element) {
                return false
            }else {
                seen.insert(element)
                return true
            }
        }
    }
    
    /// 将相同元素放到同一数组中，不保证顺序，只需要遍历一次
    public func jmSubSequence() -> [[Element]] {
        var seen:Dictionary<Element,[Element]> = [:]
        for element in self {
            if var items = seen[element] {
                items.append(element)
                seen.updateValue(items, forKey: element)
            }else {
                var items = [Element]()
                items.append(element)
                seen[element] = items
            }
        }
        return seen.compactMap { $0.value }
    }
    
    /// 某一组元素是否包含在另一个数组中(O(m+n))
    public func isSubSet<S: Sequence>(of other: S) -> Bool where S.Element == Element {
        // Set必须是可哈希的，遵循Hashable协议
        let otherSet = Set(other)
        for element in self {
            guard otherSet.contains(element) else {
                return false
            }
        }
        return true
    }
}

extension Sequence {
    /// 某一组元素是否包含在另一个数组中.这是限制更少的版本
    public func isSubSet<S: Sequence>(of other: S, by areEquivalent: (Element, S.Element) -> Bool) ->Bool {
        for element in self {
            guard other.contains(where: { areEquivalent(element, $0) }) else {
                return false
            }
        }
        return true

    }
}
