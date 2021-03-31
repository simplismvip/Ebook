//
//  JMReadEnum.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/3.
//

import Foundation
import HandyJSON

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

/// 按钮类型
public enum JMMenuType: String, HandyJSONEnum {
    case BkgColor = "color" // 背景色
    case MainBottom = "bottom" // 主页底部
    case TopLeft = "topleft"// 主页顶部左侧
    case TopRight = "topright"// 主页顶部右侧
    case PageFlip = "pageflip"// 翻页
    case PageFont = "pagefont"// 字体
    case PageLight = "pagelight"// 亮度
    case PlayRate = "playrate"// 播放速率
    case PlayStyle = "playstyle"// 播放风格
    case PlayOrPause = "playpause"// 播放或暂停
    case nonetype = "nonetype"// 播放或暂停
}
