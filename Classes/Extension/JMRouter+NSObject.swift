//
//  JMRouter+NSObject.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/7/16.
//  Copyright © 2022 JunMing. All rights reserved.
//
// MARK: -- ⚠️⚠️⚠️使用注意，这个分类提供关联对象相互发送消息的能力
import Foundation

public typealias MsgObjc = AnyObject
public typealias MsgBlock = (MsgObjc?) -> MsgObjc?
public typealias MsgCallBack = (MsgObjc?) -> Void
public typealias SetRouterBlock = (NSObject?, JMRouter?) -> Void
public typealias MsgPriority = NSInteger

let MsgPriorityDefault: MsgPriority = 100
let MsgPriorityHigh: MsgPriority = 1000

// MARK: 😀😀😀 -- 主要都是使用这个分类中的方法发送消息 --
open class JMRouter: NSObject {
    private let lock = NSRecursiveLock()
    private var msgNameObjsDictM = [String: [JMWeakBox]]()
     
    fileprivate func sendMsg(msgName: String, info: MsgObjc?) {
        guard let originArr = msgNameObjsDictM[msgName] else { return }
        lock.lock()
        for obj in originArr {
            if let router = obj.weakObjc?.msgRouter, router.isEqual(self) {
                if let block = obj.weakObjc?.msgDictM[msgName] {
                    let _ = block(info)
                }
            }
        }
        lock.unlock()
    }
    
    fileprivate func sendMsg(msgName: String, info: MsgObjc?, callback: @escaping MsgCallBack) {
        guard let originArr = msgNameObjsDictM[msgName] else { return }
        lock.lock()
        for obj in originArr {
            if let router = obj.weakObjc?.msgRouter, router.isEqual(self) {
                callback(obj.weakObjc?.msgDictM[msgName]?(info))
            }
        }
        lock.unlock()
    }
        
    fileprivate func registReceiver(obj: NSObject, msgName: String, priority: MsgPriority, block: @escaping MsgBlock) {
        lock.lock()
        obj.msgDictM[msgName] = block
        if msgNameObjsDictM[msgName] == nil {
            msgNameObjsDictM[msgName] = [JMWeakBox]()
        }
        
        if var arr = msgNameObjsDictM[msgName] {
            var index = 0
            for (i, value) in arr.enumerated() {
                if value.weakObjc?.msgPriority ?? 100 > priority {
                    index = i + 1
                    break
                }
            }
            obj.msgPriority = priority
            arr.insert(JMWeakBox(obj), at: index)
            msgNameObjsDictM.updateValue(arr, forKey: msgName)
        }
        lock.unlock()
    }
    
    fileprivate func removeReceiver(obj: NSObject, msgName: String) {
        lock.lock()
        if var arr = msgNameObjsDictM[msgName] {
            for index in arr.indices {
                let obj_ = arr[index]
                if obj .isEqual(obj_) {
                    arr.remove(at: index)
                    msgNameObjsDictM.updateValue(arr, forKey: msgName)
                    break
                }
            }
        }
        lock.unlock()
    }
}

// MARK: 😄😄😄 -- 主要都是使用这个分类中的方法发送消息 --
public extension NSObject {
    private struct JMStore {
        static var msgDictM = "JMStore.msgDictM"
        static var msgPriority = "JMStore.msgPriority"
        static var msgCache = "JMStore.msgCache"
        static var msgLock = "JMStore.msgLock"
        static var setAssociatedMsg = "JMStore.setAssociatedMsg"
        static var msgNameSet = "JMStore.msgNameSet"
        static var msgRouter = "JMStore.msgRouter"
        static var msgPause = "JMStore.msgPause"
    }
    
    /// 发送消息
    /// - Parameters:
    ///   - mgsName: 消息名称
    ///   - withInfo: 发送的参数
    func jmSendMsg(msgName: String, info: MsgObjc?) {
        if msgPause { return }
        msgRouter?.sendMsg(msgName: msgName, info: info)
    }
    
    /// 发送消息
    /// - Parameters:
    ///   - mgsName: 消息名称
    ///   - withInfo: 发送的参数
    ///   - callback: 回调参数
    func jmSendMsg(msgName: String, info: MsgObjc?, callback: @escaping MsgCallBack) {
        if msgPause { return }
        msgRouter?.sendMsg(msgName: msgName, info: info, callback: callback)
    }
    
    /// 注册消息
    /// - Parameters:
    ///   - msgName: 消息名称
    ///   - priority: 优先级
    ///   - callBlock: 回调
    func jmReciverMsg(msgName:String, priority: MsgPriority, callBlock: @escaping MsgBlock) {
        if let router = msgRouter {
            router.registReceiver(obj: self, msgName: msgName, priority: priority, block: callBlock)
        }else {
            msgLock.lock()
            msgCache[msgName] = callBlock
            msgLock.unlock()
        }
        msgLock.lock()
        msgNameSet.insert(msgName)
        msgLock.unlock()
    }
    
    /// 注册消息
    /// - Parameters:
    ///   - msgName: 消息名称
    ///   - withCallBack: 回调
    func jmReciverMsg(msgName: String, withCallBack block: @escaping MsgBlock) {
        jmReciverMsg(msgName: msgName, priority: MsgPriorityDefault, callBlock: block)
    }
    
    // 一个对象只能关联一个router
    // 不同对象可以关联同一个router，这样不同对象可以发送消息
    func jmSetAssociatedMsgRouter(router: JMRouter) {
        if self is NSString {
            assert(false, "🚫🚫🚫NSString不允许关联Router")
            return
        }
        self.msgRouter = router
        self.setAssociatedMsgRouterBlock?(self, router)
    }
    /// 暂时不用
    func jmDidSetAssociatedMsgRouterBlock(block: @escaping SetRouterBlock) {
        self.setAssociatedMsgRouterBlock = block
    }
    /// 移除注册的消息
    func jmRemoveMsg(msgName: String) {
        msgLock.lock()
        msgNameSet.remove(msgName)
        msgLock.unlock()
        if let router = msgRouter {
            router.removeReceiver(obj: self, msgName: msgName)
        }else {
            msgCache.removeValue(forKey: msgName)
        }
    }
    /// 移除所有注册的消息
    func jmRemoveAllMsg() {
        for msgname in msgNameSet {
            jmRemoveMsg(msgName: msgname)
        }
    }
    
    // MARK: -- 解决发送消息时未绑定router问题。
    fileprivate func updateMsgcache() {
        msgLock.lock()
        for (key, value) in msgCache {
            jmReciverMsg(msgName: key, withCallBack: value)
        }
        msgCache.removeAll()
        msgLock.unlock()
    }
    
    // MARK: 😌😌😌 -- NSObject 的 _MsgDict 分类实现 --
    fileprivate var msgDictM:[String: MsgBlock] {
        get {
            guard let dicInfo = objc_getAssociatedObject(self, &JMStore.msgDictM) as? [String: MsgBlock] else {
                self.msgDictM = [String: MsgBlock]()
                return self.msgDictM
            }
            return dicInfo
        }
        set { objc_setAssociatedObject(self, &JMStore.msgDictM, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    // TODO: -- 关联基本类型，可能有问题
    fileprivate var msgPriority:MsgPriority {
        get {
            guard let priorty = objc_getAssociatedObject(self, &JMStore.msgPriority) as? MsgPriority else { return 100 }
            return priorty
        }
        set { objc_setAssociatedObject(self, &JMStore.msgPriority, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    // MARK: 😌😌😌 -- NSObject的MsgRouter分类实现 --
    // ⚠️⚠️⚠️ 给NSObject的MsgRouter分类添加私有属性
    fileprivate var msgCache:[String: MsgBlock] {
        get {
            guard let cache = objc_getAssociatedObject(self, &JMStore.msgCache) as? [String: MsgBlock] else {
                self.msgCache = [String: MsgBlock]()
                return self.msgCache
            }
            return cache
        }
        set { objc_setAssociatedObject(self, &JMStore.msgCache, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    fileprivate var msgLock:NSRecursiveLock {
        get {
            guard let lock = objc_getAssociatedObject(self, &JMStore.msgLock) as? NSRecursiveLock else {
                self.msgLock = NSRecursiveLock()
                return self.msgLock
            }
            return lock
        }
        set { objc_setAssociatedObject(self, &JMStore.msgLock, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    fileprivate var setAssociatedMsgRouterBlock:SetRouterBlock? {
        get { return objc_getAssociatedObject(self, &JMStore.setAssociatedMsg) as? SetRouterBlock }
        set { objc_setAssociatedObject(self, &JMStore.setAssociatedMsg, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    fileprivate var msgNameSet:Set<String> {
        get {
            guard let nameSet = objc_getAssociatedObject(self, &JMStore.msgNameSet) as? Set<String> else {
                self.msgNameSet = Set()
                return self.msgNameSet
            }
            return nameSet
        }
        set { objc_setAssociatedObject(self, &JMStore.msgNameSet, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    // TODO: -- 关联基本类型，可能有问题
    var msgPause:Bool {
        get {
            guard let pau = objc_getAssociatedObject(self, &JMStore.msgPause) as? Bool else { return false }
            return pau
        }
        set { objc_setAssociatedObject(self, &JMStore.msgPause, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    var msgRouter:JMRouter? {
        get { return objc_getAssociatedObject(self, &JMStore.msgRouter) as? JMRouter }
        set {
            updateMsgcache()
            objc_setAssociatedObject(self, &JMStore.msgRouter, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}


