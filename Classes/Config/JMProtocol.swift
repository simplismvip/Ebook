//
//  JMProtocol.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/1.
//

import Foundation

public protocol VMProtocol {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

public protocol ModelType {
    associatedtype Item
    var items: [Item] { get }
    init(items: [Item])
}

protocol ApiProtocol {
    associatedtype ApiType
    static func currApiType(index: Int) -> ApiType
}

public struct JMWapper<T,W> {
    var t: T?
    var w: W?
    init(_ tValue: T?, _ wValue: W?) {
        self.t = tValue
        self.w = wValue
    }
}
