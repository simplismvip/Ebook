//
//  JMBase.swift
//  AEXML
//
//  Created by jh on 2024/4/9.
//

import UIKit

/// 扩展Action
public typealias JMControl = UIKit.UIControl

/// 基础对象类型
public struct JMBaseObj<Base> {
    /// 基础对象
    public let base: Base
    /// 初始化基础对象
    public init(_ base: Base) {
        self.base = base
    }
}

/// 基础协议
public protocol JMBaseCompatible {
    associatedtype CompatibleBase
    typealias CompatibleType = CompatibleBase
    static var jm: JMBaseObj<CompatibleBase>.Type { get set }
    var jm: JMBaseObj<CompatibleBase> { get set }
}

/// 基础协议扩展
extension JMBaseCompatible {
    public static var jm: JMBaseObj<Self>.Type {
        get { return JMBaseObj<Self>.self }
        set { }
    }
    
    public var jm: JMBaseObj<Self> {
        get { return JMBaseObj(self) }
        set { }
    }
}

// 让所有NSObject类都遵循基础协议，使基层自NSObject类都有jm属性
extension NSObject: JMBaseCompatible { }

/// 弱引用对象，因为数组会对元素强引用导致关联对象不释放内存
public final class JMWeakBox<T: NSObject> {
    public weak var weakObjc: T?
    public init(_ objc: T) {
        weakObjc = objc
    }
}

/// 基础 UIViewController 类
open class JMBaseController: UIViewController {
    deinit {
        print("⚠️⚠️⚠️类\(NSStringFromClass(type(of: self)))已经释放")
    }
}

/// 基础 UIView 类
open class JMBaseView: UIView {
    deinit {
        print("⚠️⚠️⚠️类\(NSStringFromClass(type(of: self)))已经释放")
    }
}

/// 基础 UITableViewCell 类
open class JMBaseTableViewCell: UITableViewCell {
    deinit {
        print("⚠️⚠️⚠️类\(NSStringFromClass(type(of: self)))已经释放")
    }
}
