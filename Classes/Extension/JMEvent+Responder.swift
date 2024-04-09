//
//  JMEvent+Responder.swift
//  ZJMKit
//
//  Created by JunMing on 2020/3/28.
//  Copyright © 2022 JunMing. All rights reserved.
//

import UIKit

private let kEventBlockKey = "kEventBlockKey"
private let kNextRespKey = "kNextRespKey"
extension UIResponder {
    public typealias EventBlock = (_ info: AnyObject?) -> Void
    private struct Store { static var key = "storeKey" }
    
    // 添加计算属性，用来绑定 AssociatedKeys
    private var eventDic: Dictionary<String, AnyObject> {
        get {
            guard let dic = objc_getAssociatedObject(self, &Store.key) as? Dictionary<String, AnyObject> else {
                self.eventDic = Dictionary<String, AnyObject>()
                return self.eventDic
            }
            return dic
        }
        set { objc_setAssociatedObject(self, &Store.key, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    /// 向 父视图/父控制器 发送消息
    open func jmRouterEvent(eventName: String, info: AnyObject?) {
        if let blockDic = eventDic[eventName] {
            if let block = blockDic[kEventBlockKey] as? EventBlock {
                block(info)
            }
            
            if let next = blockDic[kNextRespKey] {
                if let nextStatus = next as? Bool, !nextStatus {
                    return
                }
            }
        }
        next?.jmRouterEvent(eventName: eventName, info: info)
    }
    
    /// 向 父视图/父控制器 注册消息
    open func jmRegisterEvent(eventName: String,block: @escaping EventBlock, next: Bool) {
        eventDic[eventName] = [kEventBlockKey: block, kNextRespKey: next] as AnyObject
    }
}
