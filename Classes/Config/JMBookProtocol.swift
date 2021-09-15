//
//  JMProtocol.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/1.
//

import Foundation

@objc public protocol JMReadProtocol {
    /// 提供一个自定义页面展示自定义内容
    func currentReadVC(_ after: Bool) -> UIViewController?
}

@objc public protocol JMBookParserProtocol {
    /// 提供一个自定义页面展示自定义内容
    func midReadPageVC(_ after: Bool) -> UIViewController?
    /// 开始打开图书
    func startOpeningBook(_ desc: String)
    /// 打开成功
    func openBookSuccess(_ bottomView: UIView)
    /// 打开失败
    func openBookFailed(_ desc: String)
    /// 评论图书
    func commentBook(_ bookid: String)
}

@objc public protocol JMBookProtocol {
    
}

/// Menu 控制层View
public protocol JMBookControlProtocol {
    func updateProgress(curr: Float, max: Float)
    func updateItemStatus(config: JMBookConfig)
    func updateAllItemsBkg(config: JMBookConfig)
    func showWithType(type: JMMenuViewType)
    func hideWithType()
    func findItem(_ menuStyle: JMMenuStyle) -> JMMenuItem?
    func showChapter(items: [JMBookCharpter], title: String, currCharter: Int, bookId: String)
}
