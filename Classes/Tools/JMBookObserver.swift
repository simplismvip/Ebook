//
//  JMBookObserver.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/6/9.
//

import Foundation

func bindingError(_ error: Swift.Error) {
    fatalError("")
}

public enum Event<Element> {
    case next(Element)
    case error(Swift.Error)
    case completed
}

// 任何观察者都遵循可观察协议，均可调用on方法，扩展了onNext，onCompleted，onError方法可调用
public protocol ObserverType {
    associatedtype Element
    typealias E = Element
    func on(_ event: Event<Element>)
}

extension ObserverType {
    public func onNext(_ element: Element) {
        self.on(.next(element))
    }
    
    public func onCompleted() {
        self.on(.completed)
    }
    
    public func onError(_ error: Swift.Error) {
        self.on(.error(error))
    }
}

public struct Binder<Value>: ObserverType {
    public typealias Element = Value
    private let _binding: (Event<Value>) -> Void
    
    public init<Target: AnyObject>(_ target: Target, binding: @escaping (Target, Value) -> Void) {
        weak var weaktarget = target
        self._binding = { event in
            switch event {
            case .next(let element):
                if let target = weaktarget {
                    binding(target, element)
                }
            case .error(let error):
                bindingError(error)
            case .completed:
                break
            }
        }
    }
    
    public func on(_ event: Event<Value>) {
        self._binding(event)
    }
}
