//
//  JMReadEnum.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/3.
//

import Foundation
import HandyJSON

@objc public enum JMBookActionType: Int {
    case Comment // 评论
    case Reward // 打赏
    case Share // 分享
}

public enum JMEpubStatus {
    case Opening(_ text: String) // 正在打开
    case OpenSuccess(_ text: String) // 打开成功
    case OpenFail(_ text: String) // 打开失败
    case OpenInit // 初始状态
}

// MARK: -- 系统亮度
public enum JMBrightness {
    case System // 系统亮度
    case Custom // 自定义
    case CaseEye // 护眼模式
}

// MARK: -- 章节分解图书后每一页内容类型
public enum JMDataType {
    case Image // 图片
    case Txt // 文本
    case Link // 链接
    case UnKnow // 未知累
}

// MARK: -- 按钮显示、隐藏状态
public enum JMBookType {
    case Epub // 上下
    case Txt // 设置
    case Pdf // 亮度
    case Mobi // 播放
    case NoneType // 播放
    
    /// 返回图书的类型
    static func bookSuffix(_ type: JMBookType) -> String {
        switch type {
        case .Epub:
            return "epub"
        case .Txt:
            return "txt"
        case .Pdf:
            return "pad"
        case .Mobi:
            return "mobi"
        case .NoneType:
            return "none"
        }
    }
    
    /// 返回图书的类型
    static func bookType(_ suffix: String) -> JMBookType {
        if suffix == "epub" {
            return .Epub
        }else if suffix == "txt" {
            return .Txt
        }else if suffix == "pdf" {
            return .Pdf
        }else if suffix == "mobi" {
            return .Mobi
        }else {
            return NoneType
        }
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
    case ViewType_PROGRESS // 进度
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
    case CharterTag = "charterTag"// 播放或暂停
    case nonetype = "nonetype"// 播放或暂停
}

/// 按钮类型
public enum JMMenuStyle: String, Codable, HandyJSONEnum {
    case BkgBlack = "#000000" // 黑色
    case BkgGray = "#696969" // 灰色
    case BkgBrown = "#A0522D" // 棕色🏾
    case BkgLightGray = "#979797" // 浅灰色
    case BkgBlueGray = "#708090" // 蓝灰色
    case BkgWhite = "#FFFFFF" // 白色
    
    case MainBotCatalog = "bookCatalog" // 主页底部
    case MainBotDayNight = "dayornight" // 主页底部
    case MainBotBright = "brightness" // 主页底部
    case MainBotSetting = "settingMore" // 主页底部
    
    case TopLeft = "back"// 主页顶部左侧
    
    case TRightShare = "sharebook"// 主页顶部右侧
    case TRightListen = "listenBook"// 主页顶部右侧
    case TRightWifi = "sharewifi"// 主页顶部右侧
    case TRightMore = "actionmore"// 主页顶部右侧
    case TRightTag = "tagbook" // 添加书签🔖
    
    case PFlipVertScroll = "vertScroll" // 竖直滚动
    case PFlipVertCurl = "vertCurl" // 竖直翻页
    case PFlipHoriScroll = "horiScroll" // 横向滚动
    case PFlipHoriCurl = "horiCurl" // 横向翻页
    
    case SystemFont = "PingFangSC-Regular" // 系统
    case PFont1 = "kaitiGB2312.ttf"// 字体
    case PFont2 = "HYChenMeiZiJ.ttf"// 字体
    case PFont3 = "HYYouRanTiJ.ttf"// 字体
    
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
    case PlayPrev = "prev"// 播放上一页
    case PlayNext = "next"// 播放下一页
    
    case Charter = "charter"// 章节
    case CharterTag = "charterTag"// 书签
    
    case nonetype = "nonetype"// 未发现
    
    /// 文本颜色
    public func textColor() -> UIColor {
        switch self {
        case .BkgWhite:
            return UIColor(rgba: "#131313")
        case .BkgGray:
            return UIColor(rgba: "#F0F0F0")
        case .BkgBrown:
            return UIColor(rgba: "#F0F0F0")
        case .BkgLightGray:
            return UIColor(rgba: "#FFFFFF")
        case .BkgBlueGray:
            return UIColor(rgba: "#F0F0F0")
        case .BkgBlack:
            return UIColor(rgba: "#666666")
        default:
            return UIColor(rgba: "#B2B0B0")
        }
    }
    
    /// 子View背景颜色
    public func subViewColor() -> UIColor {
        return UIColor(rgba: self.rawValue, grad: 10)
    }
    
    /// 选择文本颜色
    public func selectColor() -> UIColor {
        switch self {
        case .BkgWhite:
            return UIColor.menuBkg
        case .BkgGray:
            return UIColor(rgba: "#666666")
        case .BkgBrown:
            return UIColor(rgba: "")
        case .BkgLightGray:
            return UIColor(rgba: "#666666")
        case .BkgBlueGray:
            return UIColor(rgba: "")
        case .BkgBlack:
            return UIColor(rgba: "#18181A")
        default:
            return UIColor(rgba: "#B2B0B0")
        }
    }
    
    /// tint颜色
    public func tintColor() -> UIColor {
        switch self {
        case .BkgWhite:
            return UIColor(rgba: "#979797")
        case .BkgGray:
            return UIColor(rgba: "#F0F0F0")
        case .BkgBrown:
            return UIColor(rgba: "#F0F0F0")
        case .BkgLightGray:
            return UIColor(rgba: "#FFFFFF")
        case .BkgBlueGray:
            return UIColor(rgba: "#F0F0F0")
        case .BkgBlack:
            return UIColor(rgba: "#979797")
        default:
            return UIColor(rgba: "#B2B0B0")
        }
    }
}
