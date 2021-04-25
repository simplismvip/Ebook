//
//  JMProtocol.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/1.
//

import Foundation

@objc public protocol JMReadProtocol {
    /// 提供一个自定义页面展示自定义内容
    func currentReadVC(charpter: Int, page: Int) -> UIViewController?
}

@objc public protocol JMBookParserProtocol {
    /// 提供一个自定义页面展示自定义内容
    func midReadPageVC(charpter: Int, page: Int) -> UIViewController?
    /// 开始打开图书
    func startOpeningBook(_ desc: String)
    /// 打开成功
    func openBookSuccess(_ bottomView: UIView)
    /// 打开失败
    func openBookFailed(_ desc: String)
}

// MARK: -- 图书数据模型
public class JMEpubWapper<T> {
    let item: T
    init(_ item: T) {
        self.item = item
    }
}


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
