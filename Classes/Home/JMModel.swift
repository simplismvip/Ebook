//
//  JMModel.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/1.
//

import Foundation
import EPUBKit
import ZJMKit

// MARK: -- 图书数据模型
public class JMEpubWapper<T> {
    let item: T
    init(_ item: T) {
        self.item = item
    }
}

// 第几章，第几小章
public struct JMBookIndexPath {
    var section = 0 // 第几章
    var row = 0 // 第几小章
    
    mutating func sectionAdd() {
        section += 1
    }
    
    mutating func rowAdd() {
        row += 1
    }
    
    mutating func sectionJian() {
        section -= 1
    }
    
    mutating func rowJian() {
        row -= 1
    }
    
    mutating func rowZero() {
        row = 0
    }
    
    mutating func secZero() {
        section = 0
    }
    
    mutating func rowSet(_ n: Int) {
        row = n
    }
    
    mutating func sectionSet(_ n: Int) {
        section = n
    }
}

// MARK: -- 分享
public struct JMBookShareItem {
    public var title: String?
    public var url: String?
    public var img: String?
    public var desc: String?
}

// MARK: -- 文本数据
public struct JMBookContentItem {
    /// 文本绘制区域高度
    public var attribute: NSAttributedString?
    
    /// String类型url链接地址
    public var link: String?
    /// 文字在属性文字中的范围
    public var range: NSRange?
    
    /// 图片地址
    public var imaUrl: String?
    /// 图片大小
    public var imaRect: CGRect?
    /// 图片位置
    public var postion: Int?
    
    public var pageType: JMDataType = .UnKnow
    
    /// 文本类型
    init(_ attribute: NSAttributedString) {
        self.attribute = attribute
        self.pageType = .Txt
    }
    
    /// 图片类型
    init(_ imaUrl: String, _ imaRect: CGRect, _ postion: Int) {
        self.imaUrl = imaUrl
        self.imaRect = imaRect
        self.postion = postion
        self.pageType = .Image
    }
    
    /// 链接类型
    init(_ link: String, _ range: NSRange) {
        self.link = link
        self.range = range
        self.pageType = .Link
    }
}

// MARK: -- 章节模型
public struct JMBookCharpterItem {
    public var primaryId: String?
    public var idref: String
    public var linear: Bool
    public let fullHref: URL

    public var pageCount = 0
    public var pages: [Int] = [0]
    public var mediaType: JMReadMediaType = .xHTML
    // 分解后的章节，每一个元素表示1页
    public var contentItems: [JMBookContentItem]?
    /// 文本绘制区域高度
    public var attribute: NSMutableAttributedString
    
    init(spine: EPUBSpineItem, fullHref: URL) {
        self.idref = spine.idref
        self.primaryId = spine.id
        self.linear = spine.linear
        self.fullHref = fullHref
        
        if let html = try? String(contentsOf: fullHref, encoding: .utf8),
           let content = html.convertingHTMLToPlainText() {
            print(content)
            let attrDic = JMCTFrameParser.attributes(JMCTFrameParserConfig())
            self.attribute = NSMutableAttributedString(string: content,attributes: attrDic)
            let height = UIScreen.main.bounds.height - UIDevice.footerSafeAreaHeight - UIDevice.headerSafeAreaHeight
            self.pages = JMCTFrameParser.pageWithContent(content: attribute, bounds: CGRect.Rect(0, 0, UIScreen.main.bounds.width, height))
        }else {
            self.attribute = NSMutableAttributedString(string: "🆘🆘🆘解析失败！")
            print("🆘🆘🆘解析失败！")
        }
    }
}

// MARK: -- 数据模型
final public class JMBookModel {
    public var bookId: String
    public var title: String
    public var author: String
    public var coverImg: URL?
    public var category: String?
    public var word: String?
    public var charpter: String?    //最近更新的章节
    public var desc: String?

    public var updateTime: TimeInterval? // 更新时间
    public var readTime: TimeInterval? //阅读的最后时间
    public var indexPath = JMBookIndexPath(section: 0, row: 0)
    public var end = true // 是否完结
    public var updateEnd = false // 是否更新
    public var updateCharpterId = "" // 更新章节ID
    public var onBookshelf = false // 是否在书架上
    public var isDownload = false // 是否已下载
    public var total = 0 // 总章节数
    public var currPage = 0 // 当前阅读进度
    public var share: JMBookShareItem? // 分享模型
    
//    public var currCharpter: JMBookCharpterItem // 当前章节
    public var spineChapters: [JMBookCharpterItem] // 所有当前章节
    public let chapters: [JMBookChapter] // 左侧章节目录
    public let directory: URL
    public let contentDirectory: URL
    
    init(document: EPUBDocument, chapters: [JMBookChapter]) {
        self.bookId = document.metadata.identifier ?? ""
        self.title = document.title ?? ""
        self.author = document.author ?? ""
        self.chapters = chapters
        self.coverImg = document.cover
        self.directory = document.directory
        self.contentDirectory = document.contentDirectory
        self.desc = document.metadata.description
        self.spineChapters = document.spine.items.map({
            if let href = document.manifest.items[$0.idref]?.path {
                let fullHref = document.contentDirectory.appendingPathComponent(href)
                return JMBookCharpterItem(spine: $0, fullHref: fullHref)
            }else {
                return nil
            }
        }).compactMap({ $0 })
    }
    
    subscript(indexPath: JMBookIndexPath) -> NSAttributedString? {
        get {
            if indexPath.section < spineChapters.count && indexPath.row < spineChapters[indexPath.section].pages.count {
                let content = spineChapters[indexPath.section].attribute
                let pages = spineChapters[indexPath.section].pages
                return JMCTFrameParser.currentPage(content: content, currPage: indexPath.row, pages: pages)
            }
            return nil
        }
    }
    
    /// 下一页
    func nextPage() -> NSAttributedString? {
        // 小章节还有，获取小章节
        if indexPath.row < spineChapters[indexPath.section].pages.count {
            indexPath.rowAdd()
            return self[indexPath]
        }else if indexPath.section < spineChapters.count {
            indexPath.sectionAdd()
            indexPath.rowZero()
            return self[indexPath]
        }
        return nil
    }
    
    /// 上一页
    func prevPage() -> NSAttributedString? {
        // 小章节还有，获取小章节
        if indexPath.row > 0 {
            indexPath.rowJian()
            return self[indexPath]
        }else if indexPath.section > 0 {
            indexPath.sectionJian()
            indexPath.rowSet(spineChapters[indexPath.section].pages.count-1)
            return self[indexPath]
        }
        return nil
    }
}

// MARK: -- 目录, ncx中读取的目录
public struct JMBookChapter {
    public var title: String
    public var id: String
    public let src: String
    public var subTable: [JMBookChapter]?
    init(_ tableOfContents: EPUBTableOfContents) {
        self.id = tableOfContents.id
        self.title = tableOfContents.label
        self.src = tableOfContents.item!
        self.subTable = tableOfContents.subTable?.compactMap({ $0 }).map({ JMBookChapter($0) })
    }
}
