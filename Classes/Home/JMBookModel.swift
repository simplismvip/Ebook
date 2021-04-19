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
        self.indexPath = JMBookIndex(0,0)
        self.contents = document.spine.items.map({
            if let href = document.manifest.items[$0.idref]?.path {
                let fullHref = document.contentDirectory.appendingPathComponent(href)
                return JMBookCharpter(spine: $0, fullHref: fullHref)
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
        let curr = CGFloat(contents.reduce(0) { $0 + ($1.pages?.count ?? 0) })
        let total = catalogs.reduce(0) { $0 + ($1.subTable?.count ?? 0) }
        return (curr > 0) ? "\(curr / CGFloat(total))%" : ""
    }
    
    /// 当前小节标题
    public func currTitle() -> String {
        return contents[indexPath.chapter].charpTitle
    }
    
    subscript(indexPath: JMBookIndex) -> JMBookPage? {
        get {
            print("😀😀😀: ------------------")
            print(indexPath.descrtion())
            print("😀😀😀: ------------------")
            if let page = contents[indexPath.chapter].pages?[indexPath.page] {
                return page
            }else {
                contents[indexPath.chapter].pagesContent()
                let page = contents[indexPath.chapter].pages?[indexPath.page]
                return page
            }
        }
    }
    
    /// 当前页
    func currPage() -> JMBookPage? {
        return self[indexPath]
    }
    
    /// 下一页
    // 先检查页，再检查小节，再检查章节
    func nextPage() -> JMBookPage? {
        if indexPath.chapter == contents.count - 1
            && indexPath.page == pageCount() - 1 {
            print("😀😀😀已读到最后一页")
            return nil
        }else {
            if contents[indexPath.chapter].pages == nil {
                contents[indexPath.chapter].pagesContent()
            }
            
            // 如果当前小节是本章最后，且当前页是当前小节最后一页，此时才需要更新章节
            if indexPath.page == pageCount() - 1 {
                indexPath.page = 0
                indexPath.chapter += 1
                return self[indexPath]
            }else {
                indexPath.page += 1
                return self[indexPath]
            }
        }
    }

    /// 上一页， 小章节还有，获取小章节
    func prevPage() -> JMBookPage? {
        if indexPath.chapter == 0
            && indexPath.page == 0  {
            print("😀😀😀已回到第一页")
            return nil
        }else {
            if indexPath.page == 0 {
                // 到这里说明更新章
                indexPath.chapter -= 1
                indexPath.page = pageCount() - 1
                return self[indexPath]
            }else {
                indexPath.page -= 1
                return self[indexPath]
            }
        }
    }
    
    private func pageCount() -> Int {
        if let pages = contents[indexPath.chapter].pages {
            return pages.count
        }else {
            contents[indexPath.chapter].pagesContent()
            return contents[indexPath.chapter].pages?.count ?? 0
        }
    }
}

// MARK: -- 章节模型
public class JMBookCharpter {
    /// 章节标题
    public var charpTitle: String
    /// 地址
    public var idref: String
    /// 是否隐藏
    public var linear: Bool
    /// 章节地址URL
    public let fullHref: URL
    /// 当前章节分页
    public var pages: [JMBookPage]?
    /// 解析器
    public let parser = JMXMLParser()
    
    init(spine: EPUBSpineItem, fullHref: URL) {
        self.idref = spine.idref
        self.linear = spine.linear
        self.fullHref = fullHref
        self.charpTitle = spine.idref
    }
        
    // 读取本章节，
    func pagesContent() {
        parser.content(fullHref)
        let attr = parser.attributeStr(JMBookConfig.share)
        self.pages = JMPageParse.pageContent(content: attr, bounds: JMBookConfig.share.bounds())
//        DispatchQueue.global().async {
//            self.parser.content(self.fullHref)
//            DispatchQueue.main.async {
//                let attr = self.parser.attributeStr(JMBookConfig.share)
//                self.sections = [JMBookSection(attr, self.catalogs.first!, href: self.fullHref)]
//            }
//        }
    }
    
    /// 本章多少字：=小节总字数
    public func word() -> Int {
        return pages?.reduce(0, { $0 + $1.word }) ?? 0
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


// MARK: -- 小节模型 ------- 暂时用不到 -------
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
    
    init(_ content: NSMutableAttributedString, _ catalog: JMBookCatalog, href: URL) {
        self.title = catalog.title
        self.idef = catalog.id
        self.item = catalog.src
        self.href = href
//        let path = href.deletingLastPathComponent()
//        let attributeStr = (content as NSString).parserEpub(path, spacing: JMBookConfig.share.lineSpace, font: JMBookConfig.share.font())
        self.pages = JMPageParse.pageContent(content: content, bounds: JMBookConfig.share.bounds())
    }
    
    public func word() -> Int {
        return pages.reduce(0, { $0 + $1.word })
    }
}
