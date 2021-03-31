//
//  JMReadEnum.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/3.
//

import Foundation

public enum JMEpubStatus {
    case Opening(_ text: String) // 正在打开
    case OpenSuccess(_ text: String) // 打开成功
    case OpenFail(_ text: String) // 打开失败
    case OpenInit // 初始状态
}

public enum JMTransitionType: String {
    case kCATransitionPageNormal = "normal" // 正常
    case kCATransitionCube = "cube" // 覆盖
    case kCATransitionOglFlip = "oglFlip" // 翻转
    case kCATransitionPageCurl = "pageCurl" // 仿真
    
    func title() -> String {
        let titleArr = ["normal":"正常", "cube":"覆盖", "oglFlip":"翻转", "pageCurl":"仿真"]
        return titleArr[self.rawValue] ?? "normal"
    }
}

/// 按钮显示、隐藏状态
public enum JMMenuStatus {
    case HideOrShowAll(_ isHide: Bool) // 上下
    case ShowSet(_ isHide: Bool) // 设置
    case ShowLight(_ isHide: Bool) // 亮度
    case ShowPlay(_ isHide: Bool) // 播放
}
