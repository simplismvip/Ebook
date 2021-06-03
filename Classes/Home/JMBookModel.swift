//
//  JMBookModel.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/10.
//

import UIKit
import ZJMKit

// MARK: -- 书本📖模型
final public class JMBookModel {
    public var bookId: String
    public var title: String
    public var author: String
    public let directory: URL
    public let contentDirectory: URL
    public var coverImg: URL?
    public var desc: String?
    public let indexPath: JMBookIndex // 表示当前读到的位置
    public var contents = [JMBookCharpter]() // 所有当前章节
    public var updateTime: TimeInterval? // 更新时间
    public var lastTime: String? // 阅读的最后时间
    public var onBookshelf = false // 是否在书架上
    public var isDownload = false // 是否已下载
    public let config: JMBookConfig // 配置
    
    init(epub: JMEpubBook, config: JMBookConfig) {
        self.title = epub.title
        self.bookId = epub.bookId
        self.author = epub.author
        self.coverImg = epub.cover
        self.config = config
        self.directory = epub.directory
        self.contentDirectory = epub.contentDirectory
        self.desc = epub.metadata.description
        self.indexPath = JMBookIndex(0, 0)
        self.initCharter(epub: epub)
        
        // 初始化章节完成后转跳到相应页
        if let book = JMBookDataBase.share.fetchRate(bookid: bookId) {
            lastTime = book.timeStr.jmFormatTspString("yyyy-MM-dd HH:mm:ss")
            indexPath.chapter = book.charter
            contents[indexPath.chapter].countPages()
            if let pageindex = contents[indexPath.chapter].pages?.jmIndex({
                $0.attribute.string.contains(book.text)
            }) {
                indexPath.page = pageindex
            }
        }
    }
    
    init(txt: JMTxtBook, config: JMBookConfig) {
        self.title = txt.title
        self.bookId = txt.bookId
        self.author = txt.author
        self.config = config
        self.directory = txt.directory
        self.contentDirectory = txt.directory
        self.indexPath = JMBookIndex(0, 0)
//        self.initCharter(epub: epub)
        
        // 初始化章节完成后转跳到相应页
        if let book = JMBookDataBase.share.fetchRate(bookid: bookId) {
            lastTime = book.timeStr.jmFormatTspString("yyyy-MM-dd HH:mm:ss")
            indexPath.chapter = book.charter
            contents[indexPath.chapter].countPages()
            if let pageindex = contents[indexPath.chapter].pages?.jmIndex({
                $0.attribute.string.contains(book.text)
            }) {
                indexPath.page = pageindex
            }
        }
    }
    
    /// 本书所有文字数
    public func word() -> Int {
        return contents.reduce(0, { $0 + $1.word() })
    }
    
    /// 当前页数
    public func readRate() -> String? {
        if let page = contents[indexPath.chapter].pages?.count {
            return "第\(indexPath.page + 1)/\(page)页"
        }else {
            return "第\(indexPath.page + 1))页"
        }
    }
    
    /// 当前小节标题
    public func currTitle() -> String {
        return contents[indexPath.chapter].charpTitle ?? ""
    }
    
    /// 更新字体大小等后重新计算已读章节
    public func reCountCharpter() {
        if indexPath.chapter < contents.count {
            // 重新计算当前章页数
            contents[indexPath.chapter].countPages()
//            // 异步重新计算已读章页数
//            DispatchQueue.global().async {
//                for i in  0 ..< self.indexPath.chapter {
//                    self.contents[i].countPages()
//                }
//            }
        }
    }
    
    /// 获取重新计算分页后的目标页
    public func newPageLoc(text: String) -> JMBookPage? {
        return contents[indexPath.chapter].pages?.filter({ $0.attribute.string.contains(text) }).first
    }
    
    /// 当前页
    public func currPage() -> JMBookPage? {
        return self[indexPath]
    }
    
    /// 当前页
    public func currCharpter() -> JMBookCharpter? {
        if indexPath.chapter < contents.count {
            return contents[indexPath.chapter]
        }
        return nil
    }
    
    // 当前页数
    private func pageCount() -> Int {
        if let pages = contents[indexPath.chapter].pages {
            return pages.count
        }else {
            contents[indexPath.chapter].countPages()
            return contents[indexPath.chapter].pages?.count ?? 0
        }
    }
    
    // 初始化章节
    private func initCharter(epub: JMEpubBook) {
        for (index, spine) in epub.spine.items.enumerated() {
            if spine.linear, let href = epub.manifest.items[spine.idref]?.path {
                let fullHref = epub.contentDirectory.appendingPathComponent(href)
                let charpter = JMBookCharpter(spine: spine, fullHref: fullHref, loc: JMBookIndex(index,0), config: config)
                // 先使用spine的ID去mainfrist查找path，再用path去toc中查找title
                if let path = epub.manifest.items[spine.idref]?.path {
                    charpter.charpTitle = epub.findTarget(target: path)?.label
                }else {
                    charpter.charpTitle = title
                }
                self.contents.append(charpter)
            }
        }
    }
}

// MARK: -- 处理章节、页数 --
extension JMBookModel {
    
    /// 下一章节
    func nextCharpter() -> JMBookPage? {
        if indexPath.chapter < contents.count {
            indexPath.chapter += 1
            indexPath.page = 0
            return currPage()
        }
        return nil
    }
    
    /// 上一章节
    func prevCharpter() -> JMBookPage? {
        if indexPath.chapter > 0 {
            indexPath.chapter -= 1
            indexPath.page = 0
            return currPage()
        }
        return nil
    }
    
    /// 下一页
    func nextPage() -> JMBookPage? {
        if indexPath.chapter == contents.count - 1
            && indexPath.page == pageCount() - 1 {
            print("😀😀😀已读到最后一页")
            return nil
        }else {
            if contents[indexPath.chapter].pages == nil {
                contents[indexPath.chapter].countPages()
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

    /// 上一页
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
    
    subscript(indexPath: JMBookIndex) -> JMBookPage? {
        get {
            print("😀😀😀: ------------------")
            print(indexPath.descrtion())
            print("😀😀😀: ------------------")
            if contents[indexPath.chapter].pages == nil {
                contents[indexPath.chapter].countPages()
            }
            
            if let page = contents[indexPath.chapter].pages?[indexPath.page] {
                return page
            }
            
            return nil
        }
    }
}

// MARK: -- 章节模型 --
public class JMBookCharpter {
    /// 章节标题
    public var charpTitle: String?
    /// 地址
    public let idref: String
    /// 是否隐藏
    public let linear: Bool
    /// 章节地址URL
    public let fullHref: URL
    /// 当前章节分页
    public var pages: [JMBookPage]?
    /// 解析器
    public let parser = JMXMLParser()
    /// 当前章节
    public let location: JMBookIndex
    /// 配置文件
    public let config: JMBookConfig
    
    init(spine: JMEpubSpineItem, fullHref: URL, loc: JMBookIndex, config: JMBookConfig) {
        self.idref = spine.idref
        self.linear = spine.linear
        self.fullHref = fullHref
        self.location = loc
        self.config = config
    }
        
    /// 读取本章节，计算页数
    public func countPages() {
        if parser.xmlNodes.isEmpty {
            parser.content(fullHref)
        }
        let attr = parser.attributeStr(config)
        pages = JMPageParse.pageContent(content: attr, title: charpTitle ?? "", bounds: config.bounds())
    }
    
    /// 本章多少字：=小节总字数
    public func word() -> Int {
        return pages?.reduce(0, { $0 + $1.word }) ?? 0
    }
}

// MARK: -- 文本页模型 ---
public struct JMBookPage {
    /// 本页标题
    public let title: String
    /// 本页字数
    public let word: Int
    /// 当前第几页
    public let page: Int
    /// 本页内容
    public let attribute: NSAttributedString
    /// 文本类型
    init(_ attribute: NSAttributedString, title: String, page: Int) {
        self.attribute = attribute
        self.word = attribute.length
        self.page = page
        self.title = title
    }
}
