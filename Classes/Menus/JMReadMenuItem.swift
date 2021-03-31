//
//  JMReadMenuItem.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/3/29.
//

import UIKit
import RxSwift
import HandyJSON

class JMReadMenuItem: HandyJSON {
    var title: String?
    var image: String?
    var showTitie = false
    var event = kReadMenuEventNameNone
    
    /// 字体类型
    var font: UIFont?
    /// 是否是设置背景模型
    var bkgColor: String?
    
    /// slider使用
    var value:Float?
    
    var borderWidth: CGFloat?
    var cornerRadius: CGFloat?
    var borderColor: UIColor?
    var titleColor: UIColor?

    /// 是否允许带状态
    var isStatus = false
    var isSelect = BehaviorSubject<Bool>(value: false)
    required init () { }
}
