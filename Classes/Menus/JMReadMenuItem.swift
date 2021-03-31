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
    
    
    var border = false // 选中是否显示border
    var event = kReadMenuEventNameNone
    var type = JMMenuType.nonetype
    
    /// 是否是设置背景模型
    var bkgColor: String?
    
    var borderWidth: CGFloat?
    var cornerRadius: CGFloat?
    var borderColor: UIColor?
    var titleColor: UIColor?
    var identify: String? // id
    var isSelect = BehaviorSubject<Bool>(value: false)
    required init () { }
}
