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

// MARK: -- 翻页类型
public enum JMFlipType: String, Codable {
    case VertScroll = "竖直滚动" // 竖直滚动
    case VertCurl = "竖直翻页" // 竖直翻页
    case HoriScroll = "横向滚动" // 横向滚动
    case HoriCurl = "横向翻页" // 横向翻页
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

// MARK: -- epub资源类型
public enum JMReadMediaType: String {
    case gif = "image/gif"
    case jpeg = "image/jpeg"
    case png = "image/png"
    case svg = "image/svg+xml"
    case xHTML = "application/xhtml+xml"
    case rfc4329 = "application/javascript"
    case opf2 = "application/x-dtbncx+xml"
    case openType = "application/font-sfnt"
    case woff = "application/font-woff"
    case mediaOverlays = "application/smil+xml"
    case pls = "application/pls+xml"
    case mp3 = "audio/mpeg"
    case mp4 = "audio/mp4"
    case css = "text/css"
    case woff2 = "font/woff2"
    case unknown
}
