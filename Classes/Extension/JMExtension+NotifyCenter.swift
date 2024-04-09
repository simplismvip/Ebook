//
//  JMExtension+NotifyCenter.swift
//  ZJMKit
//
//  Created by JunMing on 2021/1/18.
//  Copyright © 2022 JunMing. All rights reserved.
//

import UIKit

class JMStaticNotify: NSObject {
    private var notifyDic = [String: JMWeakBox]()
    private static let share = JMStaticNotify()
    
    @objc public static func getObserverTarget(_ name: String) -> NSObject? {
        return JMStaticNotify.share.notifyDic[name]?.weakObjc
    }
    
    @objc public static func setObserverTarget(_ name: String, target: NSObject) {
        if let _ = getObserverTarget(name) {
            print("⚠️⚠️⚠️已经存在了，不需要再次添加")
        }else {
            JMStaticNotify.share.notifyDic[name] = JMWeakBox(target)
        }
    }
    
    @objc public static func removeTarget(_ name: String) {
        JMStaticNotify.share.notifyDic.removeValue(forKey: name)
    }
}

class NotifyProxy: NSObject {
    typealias Callback = (Notification) -> Void
    var callback: Callback?
    let name: String
    
    init(name: String, object: Any?, callback: @escaping Callback) {
        self.callback = callback
        self.name = name
        super.init()
        
        let notifyName = NSNotification.Name(rawValue: name)
        let selector: Selector = #selector(eventHandler(_:))
        NotificationCenter.default.addObserver(self, selector: selector, name: notifyName, object: object)
        let method = self.method(for: selector)
        if method == nil { fatalError("Can't find method") }
    }
    
    @objc func eventHandler(_ notify: Notification!) {
        callback?(notify)
    }
    
    func removeObserver() {
        let notifyName = NSNotification.Name(rawValue: name)
        NotificationCenter.default.removeObserver(self, name: notifyName, object: nil)
        self.callback = nil
    }
    
    deinit {
        removeObserver()
        print("⚠️⚠️⚠️NotifyProxy释放掉了")
    }
}

extension JMBaseObj where Base: NotificationCenter {
    private func observer(name: String, object: Any? = nil, callback: @escaping (Notification)->Void) -> NotifyProxy {
        return NotifyProxy(name: name, object: object, callback: callback)
    }
    
    
    /// 添加通知
    /// - Parameters:
    ///   - target: 添加通知的对象
    ///   - name: 通知名称
    ///   - object: 发送对象
    ///   - callback: 回调
    public func addObserver(target: NSObject, name: String, object: Any? = nil, callback: @escaping (Notification)->Void) {
        let targ = observer(name: name, object: object, callback: callback)
        JMStaticNotify.setObserverTarget(name, target: targ)
        objc_setAssociatedObject(target, jmIdentifier(targ), targ, .OBJC_ASSOCIATION_RETAIN)
    }
    
    
    /// 发送通知
    /// - Parameters:
    ///   - name: 通知名称
    ///   - object: 发送对象，默认为空
    public func post(name: String, object: Any? = nil) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: object)
    }
    
    
    /// 移除通知
    /// - Parameters:
    ///   - target: 添加通知的对象
    ///   - name: 通知名称
    public func removeObserver(target: NSObject, _ name: String) {
        (JMStaticNotify.getObserverTarget(name) as? NotifyProxy)?.removeObserver()
        JMStaticNotify.removeTarget(name)
    }
}
