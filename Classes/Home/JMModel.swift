//
//  JMModel.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/1.
//

import Foundation
import EPUBKit
import ZJMKit

// 第几章，第几小章
// 层次结构：总共N章节
// 第一章
//   第一章第二小节
//     第一章第二小节第二页
public class JMBookIndex {
    var chapter: Int = 0 // 章
    var section: Int = 0 // 小节
    var page: Int = 0    // 页
    var loc: Int = 0     // 页中第几个字符
    
    init(_ chapter: Int, _ section: Int, _ page: Int) {
        self.chapter = chapter
        self.section = section
        self.page = page
    }
    
    func descrtion() {
        print("chapter:\(chapter) section:\(section) page:\(page)")
    }
}

// MARK: -- 分享
public struct JMBookShareItem {
    public var title: String?
    public var url: String?
    public var img: String?
    public var desc: String?
}

// MARK: -- 目录, ncx中读取的目录
public struct JMBookCatalog {
    public var title: String
    public var id: String
    public let src: String
    public var subTable: [JMBookCatalog]?
    init(_ tableOfContents: EPUBTableOfContents) {
        self.id = tableOfContents.id
        self.title = tableOfContents.label
        self.src = tableOfContents.item!
        self.subTable = tableOfContents.subTable?.compactMap({ $0 }).map({ JMBookCatalog($0) })
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
    /// 选中字体颜色
    var bkgColor: String
    /// 翻页类型
    var flipType: JMFlipType
    /// 亮度
    var brightness: CGFloat
    /// 白天、夜晚模式
    var isDayMode = true
    
    static let share: JMBookConfig = {
        return JMBookConfig()
    }()
    
    public init(){
        self.width = UIScreen.main.bounds.size.width - 40
//        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        self.height = UIScreen.main.bounds.height - UIDevice.footerSafeAreaHeight - UIDevice.headerSafeAreaHeight - 20
        self.fontSize = 17.0
        self.lineSpace = 4.0
        self.fontName = "PingFangSC-Regular"
        self.textColor = "#131313"
        self.selectColor = "#131313"
        self.bkgColor = "#131313"
        self.flipType = .VertScroll
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


