//
//  JMMenuItem.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/3/29.
//

import UIKit

public class JMMenuItem: Codable {
    var title: String?
    var image: String?
    
    var border = false // 选中是否显示border
    var event: String = kReadMenuEventNameNone
    var type: JMMenuType = JMMenuType.nonetype
    var identify: JMMenuStyle = .nonetype
    var isSelect: Bool = false
    
    /// 是否是设置背景模型
    var borderWidth: CGFloat?
    var cornerRadius: CGFloat?
    
//    var borderColor: UIColor?
//    var titleColor: UIColor?
//    {
//        willSet { didSelectAction?(newValue) }
//    }
//    var didSelectAction: ((Bool)->())?
}

@propertyWrapper
struct JMMenuSelect {
    private var status: Bool = false
    private var projectValue: Bool = false
    
    var wrappedValue: Bool {
        set {
            projectValue = newValue
            status = newValue
        }
        get { return status }
    }
}
