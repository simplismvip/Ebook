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
//   第一章第一小节
//     第一章第一小节第一页
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
    
    /// 阅读百分比
    public func readRate() -> String {
        let curr = CGFloat(contents.reduce(0) { $0 + ($1.sections?.count ?? 0) })
        let total = catalogs.reduce(0) { $0 + ($1.subTable?.count ?? 0) }
        return (curr > 0) ? "\(curr / CGFloat(total))%" : ""
    }
    
    /// 当前小节标题
    public func currTitle() -> String {
        if let title = contents[indexPath.chapter].sections?[indexPath.section].title {
            return title
        }
        return title
    }
    
    subscript(indexPath: JMBookIndex) -> NSAttributedString? {
        get {
            print("😀😀😀: ------------------")
            print(indexPath.descrtion())
            print("😀😀😀: ------------------")
            if let page = contents[indexPath.chapter].sections?[indexPath.section].pages[indexPath.page] {
                return page.attribute
            }else {
                contents[indexPath.chapter].content()
                let page = contents[indexPath.chapter].sections?[indexPath.section].pages[indexPath.page]
                return page?.attribute
            }
        }
    }
    
    func currPage() -> NSAttributedString? {
        return self[indexPath]
    }
    
    /// 下一页
    // 先检查页，再检查小节，再检查章节
    func nextPage() -> NSAttributedString? {
        if indexPath.chapter == contents.count - 1
            && indexPath.section == sectionCount() - 1
            && indexPath.page == pageCount() - 1 {
            print("😀😀😀已读到最后一页")
            return nil
        }else {
            if contents[indexPath.chapter].sections == nil {
                contents[indexPath.chapter].content()
            }
            
            // 如果当前小节是本章最后，且当前页是当前小节最后一页，此时才需要更新章节
            if indexPath.section == sectionCount() - 1 && indexPath.page == pageCount() - 1 {
                indexPath.section = 0
                indexPath.page = 0
                indexPath.chapter += 1
                return self[indexPath]
            }else {
                // 当前页是本小节最后一页，更新小节
                if indexPath.page == pageCount() - 1  {
                    indexPath.page = 0
                    indexPath.section += 1
                    return self[indexPath]
                }else {
                    indexPath.page += 1
                    return self[indexPath]
                }
            }
        }
    }

    /// 上一页， 小章节还有，获取小章节
    func prevPage() -> NSAttributedString? {
        if indexPath.chapter == 0
            && indexPath.section == 0
            && indexPath.page == 0  {
            print("😀😀😀已回到第一页")
            return nil
        }else {
            if indexPath.section == 0 && indexPath.page == 0 {
                // 到这里说明更新章
                indexPath.chapter -= 1
                indexPath.section = sectionCount() - 1
                indexPath.page = pageCount() - 1
                return self[indexPath]
            }else {
                if indexPath.page == 0  {
                    // 到这里说明不需要更新下一节，判断是否允许进入下一章
                    indexPath.section -= 1
                    indexPath.page = sectionCount() - 1
                    return self[indexPath]
                }else {
                    indexPath.page -= 1
                    return self[indexPath]
                }
            }
        }
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
    /// 当前哪一小节
    public var cSection = 0
    
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
            self.sections = JMCTFrameParser.sectionContent(content: content, catalogs: catalogs, href: fullHref)
        }else {
            print("🆘🆘🆘解析失败！")
        }
    }
    
    /// 本章多少字：=小节总字数
    public func word() -> Int {
        return sections?.reduce(0, { $0 + $1.word() }) ?? 0
    }
}


// MARK: -- 小节模型
public class JMBookSection {
    /// 分解后的章节，每一个元素表示1页
    public let href: URL
    
    public var title: String

    public var idef: String

    public var item: String?
    
    /// 分解后的章节，每一个元素表示1页
    public var pages: [JMBookPage]
    /// 当前哪一小节
    public var cPage = 0
    
    init(_ content: String, _ catalog: JMBookCatalog, href: URL) {
        self.title = catalog.title
        self.idef = catalog.id
        self.item = catalog.src
        self.href = href
        let path = href.deletingLastPathComponent()
        let attributeStr = (content as NSString).parserEpub(path, spacing: JMBookConfig.share.lineSpace, font: JMBookConfig.share.font())
        self.pages = JMCTFrameParser.pageContent(content: attributeStr, bounds: JMBookConfig.share.bounds())
    }
    
    public func word() -> Int {
        return pages.reduce(0, { $0 + $1.word })
    }
}

// MARK: -- 文本数据
public struct JMBookPage {
    /// 本页字数
    public let word: Int
    /// 当前第几页
    public let page: Int
    /// 本页内容
    public let attribute: NSAttributedString
    /// 文本类型
    init(_ attribute: NSAttributedString, page: Int) {
        self.attribute = attribute
        self.word = attribute.length
        self.page = page
    }
}
