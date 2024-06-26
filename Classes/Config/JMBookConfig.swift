//
//  JMBookConfig.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/26.
//

import UIKit

// MARK: -- 配置信息类
public class JMBookConfig {
    /// 配置
    var config = JMConfig()
    /// 底部显示广告的View，高度64
    var bottomView: UIView?
    /// 文本高度
    var height: CGFloat

    public init(_ bottomView: UIView? = nil) {
        self.bottomView = bottomView
        // let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        // 64: 底部广告，20: 底部显示电池，50: pageview底部30顶部20
        if bottomView == nil {
            self.height = UIScreen.main.bounds.height - UIDevice.headerSafeAreaHeight - UIDevice.footerSafeAreaHeight - 20 - 50
        }else{
            self.height = UIScreen.main.bounds.height - UIDevice.headerSafeAreaHeight - 20 - 50 - 64
        }
        
        deCodeConfig()
    }
    
    /// 当前字体
    func font() -> UIFont {
        let fontSize = config.fontSize
        if config.fontName == .SystemFont {
            return UIFont.jmRegular(fontSize)
        } else {
            if let bundle = Bundle.resouseBundle?.bundlePath {
                let fontPath = bundle + "/" + config.fontName.rawValue
                return fontPath.fontWith(fontSize)
            } else {
                return UIFont.systemFont(ofSize: fontSize)
            }
        }
    }
    
    /// 文本显示大小
    func bounds() -> CGRect {
        return CGRect.Rect(0, 0, config.width, height)
    }
    
    /// 宽度
    func width() -> CGFloat {
        return config.width
    }
    
    /// 字体间距
    func lineSpace() -> CGFloat {
        return config.lineSpace
    }
    
    /// 字体大小
    func fontSize() -> CGFloat {
        return config.fontSize
    }
    
    /// 字体名称
    func fontName() -> JMMenuStyle {
        return config.fontName
    }
    
    /// 翻页类型
    func flipType() -> JMMenuStyle {
        return config.flipType
    }
    
    /// 播放状态
    var playStatus: JMMenuStyle {
        return config.playStatus
    }
    
    /// 播放速率
    var playRate: JMMenuStyle {
        return config.playRate
    }
    
    /// 亮度
    func brightness() -> CGFloat {
        return config.brightness
    }
    
    func codeConfig() {
        if let path = JMFileTools.jmDocuPath() {
            let fullpath = path.appendingPathComponent(".bookconfig")
            JMBookStore.encodeObject(config, cachePath: fullpath)
        }
    }
    
    func deCodeConfig() {
        JMLogger.debug("++++++++ start Decode")
        if let path = JMFileTools.jmDocuPath() {
            let fullpath = path.appendingPathComponent(".bookconfig")
            JMBookStore.decodeMain(cachePath: fullpath) { (config: JMConfig?) in
                if let config = config {
                    JMLogger.debug("++++++++ Decoding")
                    self.config = config
                } else {
                    JMLogger.debug("++++++++ Decode Error")
                }
            }
        } else {
            JMLogger.debug("++++++++ Decode Error")
        }
    }
}

// 颜色
extension JMBookConfig {
    /// 背景颜色
    var bkgColor: JMMenuStyle {
        return config.bkgColor
    }
    
    /// 子View背景颜色
    public func subViewColor() -> UIColor {
        return UIColor(rgba: config.bkgColor.rawValue, grad: 10)
    }
    
    /// tint颜色
    public func tintColor() -> UIColor {
        return textColor()
    }

    /// 文本颜色
    public func textColor() -> UIColor {
        switch config.bkgColor {
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
    
    /// 选择文本颜色
    public func selectColor() -> UIColor {
        switch config.bkgColor {
        case .BkgWhite:
            return UIColor.menuSelColor
        case .BkgGray:
            return UIColor.menuSelColor
        case .BkgBrown:
            return UIColor.menuSelColor
        case .BkgLightGray:
            return UIColor.menuSelColor
        case .BkgBlueGray:
            return UIColor.menuSelColor
        case .BkgBlack:
            return UIColor.menuSelColor
        default:
            return UIColor.menuSelColor
        }
    }
}

class JMConfig: Codable {
    /// 文本宽度
    var width: CGFloat
    /// 字体大小
    var fontSize: CGFloat
    /// 字体名称
    var fontName: JMMenuStyle
    /// 字体行间距
    var lineSpace: CGFloat
    /// 字体颜色
    var textColor: String
    /// 选中字体颜色
    var selectColor: String
    /// 主题颜色
    var bkgColor: JMMenuStyle
    /// 翻页类型
    var flipType: JMMenuStyle
    /// 亮度
    var brightness: CGFloat {
        willSet {
            JMLogger.debug("++++++++ =======\(newValue)")
        }
    }
    /// 播放状态
    var playStatus: JMMenuStyle
    /// 播放速率
    var playRate: JMMenuStyle
    
    public init() {
        self.fontSize = 17.0
        self.lineSpace = 8.0
        self.fontName = .SystemFont
        self.selectColor = "#66B3FF"
        self.textColor = "#131313"
        self.bkgColor = .BkgWhite
        self.flipType = .PFlipHoriCurl
        self.playStatus = .nonetype
        self.playRate = .PlayRate1
        self.width = UIScreen.main.bounds.size.width - 40
        self.brightness = 1.0
    }
}
