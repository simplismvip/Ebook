//
//  JMBookModel.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/10.
//

import UIKit
import EPUBKit
import ZJMKit

// 层次结构：总共N章节
// 第一章
//   第一章第二小节
//     第一章第二小节第二页
// MARK: -- 书本📖模型
final public class JMBookModel {
    public var bookId: String
    public var title: String
    public var author: String
    public let directory: URL
    public let contentDirectory: URL
    public var coverImg: URL?
    public var desc: String?
    
    // 第N章-N小节-N页，表示当前读到的位置
    public let indexPath: JMBookIndex
    // 所有当前章节
    public var contents: [JMBookCharpter]
    // 左侧章节目录，这个相比上面的更详细
    public let catalogs: [JMBookCatalog]
    
    public var updateTime: TimeInterval? // 更新时间
    public var readTime: TimeInterval? //阅读的最后时间
    public var onBookshelf = false // 是否在书架上
    public var isDownload = false // 是否已下载
    
    init(document: EPUBDocument, catalog: [JMBookCatalog]) {
        self.bookId = document.metadata.identifier ?? ""
        self.title = document.title ?? ""
        self.author = document.author ?? ""
        self.catalogs = catalog
        self.coverImg = document.cover
        self.directory = document.directory
        self.contentDirectory = document.contentDirectory
        self.desc = document.metadata.description
        self.indexPath = JMBookIndex(0,0,0)
        self.contents = document.spine.items.map({
            if let href = document.manifest.items[$0.idref]?.path {
                let fullHref = document.contentDirectory.appendingPathComponent(href)
                return JMBookCharpter(spine: $0, catalogs: catalog, fullHref: fullHref)
            }else {
                return nil
            }
        }).compactMap({ $0 })
    }
    
    /// 本书所有文字数
    public func word() -> Int {
        return contents.reduce(0, { $0 + $1.word() })
    }
    
    subscript(indexPath: JMBookIndex) -> NSAttributedString? {
        get {
            if indexPath.chapter < contents.count
                && indexPath.section < sectionCount()
                && indexPath.page < pageCount() {
                return contents[indexPath.chapter].sections?[indexPath.section].pages[indexPath.page].attribute
            }
            return nil
        }
    }

    /// 下一页
    // 先检查页，再检查小节，再检查章节
    func nextPage() -> NSAttributedString? {
        // 小章节还有，获取小章节
        if indexPath.chapter < contents.count && indexPath.section < sectionCount() && indexPath.page < pageCount() {
            indexPath.page += 1
            return self[indexPath]
            
        }else if indexPath.chapter < contents.count && indexPath.section < sectionCount() && indexPath.page >= pageCount() {
            indexPath.section += 1
            indexPath.page = 0
            return self[indexPath]
            
        }else if indexPath.chapter < contents.count && indexPath.section >= sectionCount() {
            indexPath.chapter += 1
            indexPath.section = 0
            indexPath.page = 0
            return self[indexPath]
            
        }else if indexPath.chapter >= contents.count {
            return self[indexPath]
            
        }
        return nil
    }

    /// 上一页， 小章节还有，获取小章节
    func prevPage() -> NSAttributedString? {
        if indexPath.chapter > 0 && indexPath.section > 0 && indexPath.page > 0 {
            indexPath.page -= 1
            return self[indexPath]
            
        }else if indexPath.chapter > 0 && indexPath.section > 0 && indexPath.page == 0 {
            indexPath.section -= 1
            let pageC = pageCount()
            if pageC > 0  {
                indexPath.page = pageC - 1
            }else {
                indexPath.page = 0
            }
            return self[indexPath]
            
        }else if indexPath.chapter > 0 && indexPath.section == 0 {
            indexPath.chapter -= 1
            
            let secC = sectionCount()
            if secC > 0 {
                indexPath.section = secC - 1
            }else {
                indexPath.section = 0
            }
            
            let pageC = pageCount()
            if pageC > 0 {
                indexPath.page = pageC - 1
            }else {
                indexPath.page = 0
            }
            return self[indexPath]
            
        }else if indexPath.chapter == 0 {
            return self[indexPath]
            
        }
        return nil
    }
    
    /// 读取需求页
    func pageText() -> NSAttributedString? {
        if indexPath.chapter < contents.count {
            return contents[indexPath.chapter].pageText(indexPath.section, page: indexPath.page)
        }
        return nil
    }
    
    private func sectionCount() -> Int {
        if let sections = contents[indexPath.chapter].sections {
            return sections.count
        }else {
            contents[indexPath.chapter].content()
            return contents[indexPath.chapter].sections?.count ?? 0
        }
    }
    
    private func pageCount() -> Int {
        if let sections = contents[indexPath.chapter].sections {
            return sections[indexPath.section].pages.count
        }else {
            contents[indexPath.chapter].content()
            return contents[indexPath.chapter].sections?[indexPath.section].pages.count ?? 0
        }
    }
}

// MARK: -- 章节模型
public class JMBookCharpter {
    public var idref: String
    public var linear: Bool
    public let fullHref: URL
    /// 分解后的小节
    public var sections: [JMBookSection]?
    /// catalogs：每章的小节
    public let catalogs: [JMBookCatalog]
    /// 当前第几小节
    public var section = 0
    /// 文本类型
    public var mediaType: JMReadMediaType = .xHTML
    /// 文本绘制区域高度
    public var attribute: NSMutableAttributedString?
    
    init(spine: EPUBSpineItem, catalogs: [JMBookCatalog], fullHref: URL) {
        self.idref = spine.idref
        self.linear = spine.linear
        self.fullHref = fullHref
        self.catalogs = catalogs
    }
    
    // 读取本章节，
    func content() {
        if let html = try? String(contentsOf: fullHref, encoding: .utf8),
           let content = html.convertingHTMLToPlainText() {
            self.sections = JMCTFrameParser.sectionContent(content: content, catalogs: catalogs)
        }else {
            print("🆘🆘🆘解析失败！")
        }
    }
    
    /// 本章多少字：=小节总字数
    public func word() -> Int {
        return sections?.reduce(0, { $0 + $1.word() }) ?? 0
    }
    
    // 读取需求页
    func pageText(_ section: Int, page: Int) -> NSAttributedString? {
        if section < sections?.count ?? 0 {
            return sections?[section].page(page)
        }
        return nil
    }
}


// MARK: -- 小节模型
public class JMBookSection {
    /// 分解后的章节，每一个元素表示1页
//    public let href: URL
    
    public var title: String

    public var idef: String

    public var item: String?
    
    /// 分解后的章节，每一个元素表示1页
    public var pages: [JMBookPage]
    
    /// 文本绘制区域高度
    public var attribute: NSMutableAttributedString?
    
    init(_ content: String, _ catalog: JMBookCatalog) {
        self.title = catalog.title
        self.idef = catalog.id
        self.item = catalog.src
        let attrDic = JMCTFrameParser.attributes(JMCTFrameParserConfig())
        let attributeStr = NSMutableAttributedString(string: content, attributes: attrDic)
        let height = UIScreen.main.bounds.height - UIDevice.footerSafeAreaHeight - UIDevice.headerSafeAreaHeight
        self.pages = JMCTFrameParser.pageContent(content: attributeStr, bounds: CGRect.Rect(0, 0, UIScreen.main.bounds.width-40, height))
    }
    
    // 读取需求页
    public func page(_ page: Int) -> NSAttributedString? {
        if page < pages.count {
            return attribute
        }
        return nil
    }
    
    public func word() -> Int {
        return pages.reduce(0, { $0 + $1.word })
    }
}

// MARK: -- 文本数据
public struct JMBookPage {
    /// 本页多少字
    public let word: Int
    /// 当前第几页
    public var page = 0
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
        self.word = attribute.length
    }
    
    /// 图片类型
    init(_ imaUrl: String, _ imaRect: CGRect, _ postion: Int) {
        self.imaUrl = imaUrl
        self.imaRect = imaRect
        self.postion = postion
        self.pageType = .Image
        self.word = 0
    }
    
    /// 链接类型
    init(_ link: String, _ range: NSRange) {
        self.link = link
        self.range = range
        self.pageType = .Link
        self.word = 0
    }
}
