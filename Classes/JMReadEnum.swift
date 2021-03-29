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
    case kCATransitionMoveIn = "moveIn" // 移入效果
    case kCATransitionReveal  = "reveal" // 截开效果
    case kCATransitionCube = "cube" // 方块
    
    case kCATransitionOglFlip = "oglFlip" // 上下翻转
    case kCATransitionPageCurl = "pageCurl" // 上翻页
    case kCATransitionPageUnCurl = "pageUnCurl" // 下翻页
    
    func title() -> String {
        let titleArr = ["moveIn":"滑入效果", "reveal":"滑出效果", "cube":"立方体效果", "oglFlip":"翻转效果", "pageCurl":"波纹效果", "pageUnCurl":"反翻页效果"]
        return titleArr[self.rawValue] ?? "oglFlip"
    }
}
