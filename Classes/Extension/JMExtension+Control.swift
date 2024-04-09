//
//  JMExtension+Control.swift
//  AEXML
//
//  Created by JunMing on 2020/4/13.
//  Copyright © 2022 JunMing. All rights reserved.
//

import UIKit

/// 获取对象地址指针
public func jmIdentifier(_ target: NSObject) -> UnsafeRawPointer {
    let targetIdentifier = ObjectIdentifier(target)
    let integerIdentifier = Int(bitPattern: targetIdentifier)
    return UnsafeRawPointer(bitPattern: integerIdentifier)!
}

class ControlProxy: NSObject {
    typealias Callback = (JMControl) -> Void
    
    let selector: Selector = #selector(ControlProxy.eventHandler(_:))
    var callback: Callback?
    weak var control: JMControl?
    let controlEvents: UIControl.Event
    
    init(control: JMControl, events: UIControl.Event, callback: @escaping Callback) {
        self.control = control
        self.controlEvents = events
        self.callback = callback
        super.init()
        control.addTarget(self, action: selector, for: events)
        let method = self.method(for: selector)
        if method == nil { fatalError("Can't find method") }
    }
    
    @objc func eventHandler(_ sender: JMControl!) {
        if let callback = self.callback, let control = self.control {
            callback(control)
        }
    }
    
    deinit {
        self.control?.removeTarget(self, action: self.selector, for: self.controlEvents)
        self.callback = nil
        print("⚠️⚠️⚠️ControlTarget释放掉了")
    }
}

extension JMBaseObj where Base: UIControl {
    private func addControlEvent(_ events: UIControl.Event, callback: @escaping (JMControl)->Void) -> ControlProxy {
        return ControlProxy(control: self.base, events: events) { control in
            callback(control)
        }
    }

    /// 按钮添加block响应
    public func jmControlAction(_ event: UIControl.Event, action: @escaping (JMControl)->Void) {
        let target = addControlEvent(event, callback: action)
        objc_setAssociatedObject(self.base, jmIdentifier(target), target, .OBJC_ASSOCIATION_RETAIN)
    }
}

// MARK: -- 为UIButton添加便利方法 ---
extension JMBaseObj where Base: UIButton {
    /// 按钮添加block响应
    public func addAction(event: UIControl.Event = .touchUpInside, action: @escaping (JMControl)->Void) {
        jmControlAction(event, action: action)
    }
}

extension JMBaseObj where Base: UIImageView {
    
}

// 兼容以前的版本
extension UIButton {
    /// 按钮添加block响应
    public func jmAddAction(event: UIControl.Event = .touchUpInside, action: @escaping (JMControl)->Void) {
        self.jm.jmControlAction(event, action: action)
    }
}
