//
//  JMReadConfig.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/1.
//

import UIKit
import ZJMKit

public enum JMDirection: Int {
    case vertical
    case horizontal
    case horizontalWithVerticalContent
    case defaultVertical

    /// 当前滚动方向
    /// - Returns: 返回UICollectionView的滚动方向
    func scrollDirection() -> UICollectionView.ScrollDirection {
        switch self {
        case .vertical, .defaultVertical:
            return .vertical
        case .horizontal, .horizontalWithVerticalContent:
            return .horizontal
        }
    }
    
    func index() -> Int {
        switch self {
        case .vertical, .defaultVertical:
            return 0
        case .horizontal, .horizontalWithVerticalContent:
            return 1
        }
    }
}

// MARK: -- 配置信息类
public class JMBookConfig: Codable {
    /// 文本宽度
    var width: CGFloat
    /// 文本高度
    var height: CGFloat
    /// 字体大小
    var fontSize: CGFloat
    /// 字体名称
    var fontName: String
    /// 字体行间距
    var lineSpace: CGFloat
    /// 字体颜色
    var textColor: String
    /// 选中字体颜色
    var selectColor: String
    /// 主题颜色
    var bkgColor: String
    /// 翻页类型
    var flipType: JMFlipType
    /// 亮度
    var brightness: CGFloat
    /// 白天、夜晚模式
    var isDayMode = true
    
    
    
    public init(){
        self.width = UIScreen.main.bounds.size.width - 40
//        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        // 64: 底部广告，20: 底部显示电池，50: pageview底部30顶部20
        self.height = UIScreen.main.bounds.height - UIDevice.headerSafeAreaHeight - 20 - 50 - 64
        self.fontSize = 16.0
        self.lineSpace = 8.0
        self.fontName = "PingFangSC-Regular"
        self.textColor = "#131313"
        self.selectColor = "#131313"
        self.bkgColor = "#ffffff"
        self.flipType = .HoriCurl
        self.brightness = UIScreen.main.brightness
    }
    
    /// 当前字体
    func font() -> UIFont {
        return UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: 17)
    }
    
    /// 文本显示大小
    func bounds() -> CGRect {
        return CGRect.Rect(0, 0, width, height)
    }
}
