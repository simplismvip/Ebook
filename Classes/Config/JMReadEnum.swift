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

/// 按钮显示、隐藏状态
public enum JMMenuViewType {
    case ViewType_TOP_BOTTOM // 隐藏所有
    case ViewType_LIGHT // 显示亮度
    case ViewType_PLAY // 显示播放
    case ViewType_SET // 显示设置
    case ViewType_CHAPTER // 显示目录
    case ViewType_NONE // 没有显示任何项目
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

/// 按钮类型
public enum JMMenuStyle: String, HandyJSONEnum {
    case BkgColor = "color1" // 背景色
    case BkgColor1 = "color2" // 背景色
    case BkgColor2 = "color3" // 背景色
    case BkgColor3 = "color4" // 背景色
    
    case MainBotCatalog = "bookCatalog" // 主页底部
    case MainBotDayNight = "dayornight" // 主页底部
    case MainBotBright = "brightness" // 主页底部
    case MainBotSetting = "settingMore" // 主页底部
    
    case TopLeft = "back"// 主页顶部左侧
    
    case TRightShare = "sharebook"// 主页顶部右侧
    case TRightListen = "listenBook"// 主页顶部右侧
    case TRightWifi = "sharewifi"// 主页顶部右侧
    case TRightMore = "actionmore"// 主页顶部右侧
    
    case PFlipNormal = "normal"// 翻页
    case PFlipCube = "cube"// 翻页
    case PFlipCurl = "pageCurl"// 翻页
    case PFlipOgl = "oglFlip"// 翻页
    
    case PFont = "Andada"// 字体
    case PFont1 = "Lato"// 字体
    case PFont2 = "Lora"// 字体
    case PFont3 = "Raleway"// 字体
    
    case PLightSys = "system"// 亮度
    case PLightCus = "custom"// 亮度
    
    case PlayRate = "0.5"// 播放速率
    case PlayRate1 = "1.0"// 播放速率
    case PlayRate2 = "1.5"// 播放速率
    case PlayRate3 = "2.0"// 播放速率
    
    case PlayStyle = "style1"// 播放风格
    case PlayStyle1 = "style2"// 播放风格
    case PlayStyle2 = "style3"// 播放风格
    
    case PlayOrPause = "curr"// 播放或暂停
    case PlayPrev = "prev"// 播放或暂停
    case PlayNext = "next"// 播放或暂停
    
    case nonetype = "nonetype"// 播放或暂停
}

