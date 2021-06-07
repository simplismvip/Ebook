//
//  JMBookConfig.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/26.
//

import UIKit
import ZJMKit

// MARK: -- 配置信息类
public class JMBookConfig {
    /// 配置
    var config = JMConfig()
    /// 底部显示广告的View，高度64
    var bottomView: UIView?
    /// 文本高度
    var height: CGFloat
    
    private var tempFont: UIFont?
    
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
        if config.fontName == .PFont {
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
    
    /// 文本颜色
    func textColor() -> UIColor {
        return UIColor(rgba: config.textColor)
    }
    
    /// 背景颜色
    func bkgColor() -> UIColor {
        return UIColor(rgba: config.bkgColor.rawValue)
    }
    
    /// 背景颜色
    var bkgColorStr: JMMenuStyle {
        return config.bkgColor
    }
    
    /// 选择文本颜色
    func selectColor() -> UIColor {
        return UIColor(rgba: config.selectColor)
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
        if let path = JMTools.jmDocuPath() {
            let fullpath = path.appendingPathComponent(".bookconfig")
            JMModelStore.share.encodeObject(config, cachePath: fullpath)
        }
    }
    
    func deCodeConfig() {
        if let path = JMTools.jmDocuPath() {
            let fullpath = path.appendingPathComponent(".bookconfig")
            JMModelStore.share.decodeObject(cachePath: fullpath) { (config: JMConfig?) in
                if let config = config {
                    self.config = config
                }
            }
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
    var brightness: CGFloat
    /// 播放状态
    var playStatus: JMMenuStyle
    /// 播放速率
    var playRate: JMMenuStyle
    
    public init() {
        self.width = UIScreen.main.bounds.size.width - 40
        self.fontSize = 17.0
        self.lineSpace = 8.0
        self.fontName = .PFont
        self.textColor = "#131313"
        self.selectColor = "#131313"
        self.bkgColor = .BkgColor
        self.flipType = .PFlipHoriCurl
        self.playStatus = .nonetype
        self.playRate = .PlayRate1
        self.brightness = UIScreen.main.brightness
    }
}
