//
//  JMProtocol.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/1.
//

import Foundation

@objc public protocol JMBookProtocol {
    /// 打开成功
    func openSuccess(_ desc: String)
    /// 打开失败
    func openFailed(_ desc: String)
    /// 显示广告内容
    func showGADView(_ after: Bool) -> UIViewController?
    /// 文字不满一页
    func bottomGADView(_ size: CGSize) -> UIView?
    /// 评论图书
    func commentBook(_ bookid: String) -> UIViewController?
}

extension JMBookProtocol {
    func showGADView(_ after: Bool) -> UIViewController? {
        return nil
    }
    
    func bottomGADView(_ size: CGSize) -> UIView? {
        return nil
    }
    
    func commentBook(_ bookid: String) -> UIViewController? {
        return nil
    }
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
