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
        self.charterFromEpub(epub: epub)
        
        // 初始化章节完成后转跳到相应页
        if let bookTag = JMBookDataBase.share.fetchRate(bookid: bookId) {
            lastTime = bookTag.timeStr.jmFormatTspString("yyyy-MM-dd HH:mm:ss")
            indexPath.chapter = bookTag.charter
            contents[indexPath.chapter].countPages()
            // 查找阅读到的Page
            if let targetPage = newPageLoc(location: bookTag.location, text: bookTag.text) {
                indexPath.page = targetPage.page
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
        self.charterFromTxt(txt: txt)
        
        // 初始化章节完成后转跳到相应页
        if let bookTag = JMBookDataBase.share.fetchRate(bookid: bookId) {
            lastTime = bookTag.timeStr.jmFormatTspString("yyyy-MM-dd HH:mm:ss")
            indexPath.chapter = bookTag.charter
            contents[indexPath.chapter].countPages()
            // 查找阅读到的Page
            if let targetPage = newPageLoc(location: bookTag.location, text: bookTag.text) {
                indexPath.page = targetPage.page
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
        return contents[indexPath.chapter].charpTitle ?? title
    }
    
    /// 更新字体大小等后重新计算已读章节
    public func reCountCharpter() {
        if indexPath.chapter < contents.count {
            // 重新计算当前章页数
            contents[indexPath.chapter].countPages()
        }
    }
    
    /// 获取重新计算分页后的目标页
    public func newPageLoc(location: Int, text: String) -> JMBookPage? {
        reCountCharpter() // 重新修改字体，计算页数
        if let pages = contents[indexPath.chapter].pages {
            if let page = pages.filter({ $0.attribute.string.contains(text) }).first {
                return page
            } else {
                var loc = 0
                for page in pages {
                    loc += page.word
                    if location <= loc {
                        return page
                    } else {
                        return nil
                    }
                }
            }
        }
        return nil
    }
    
    /// 当前页
    public func currPage() -> JMBookPage? {
        if let page = self[indexPath] {
            return page
        }
        return nil
    }
    
    /// 当前章节
    public func currCharpter() -> JMBookCharpter? {
        if indexPath.chapter < contents.count {
            return contents[indexPath.chapter]
        }
        return nil
    }
    
    /// 当前位置
    public func currLocation(target: String) -> Int {
        var location = 0
        if let cCharptre = currCharpter()?.pages, let cPage = currPage() {
            for page in cCharptre {
                location += page.word
                if page.page == cPage.page
                    && page.word == cPage.word
                    && page.title == cPage.title
                    && page.attribute == cPage.attribute {
                    break
                }
            }
        }
        return location
    }
    
    /// 本章节未读页
    public func unreadPage() -> [JMBookPage] {
        var unreadPages = [JMBookPage]()
        if let cCharptre = currCharpter()?.pages {
            for (index, page) in cCharptre.enumerated() where index >= indexPath.page {
                unreadPages.append(page)
            }
        }
        return unreadPages
    }
    
    // 当前章节页数
    private func pageCount() -> Int {
        if let pages = contents[indexPath.chapter].pages {
            return pages.count
        }else {
            contents[indexPath.chapter].countPages()
            return contents[indexPath.chapter].pages?.count ?? 0
        }
    }
    
    // 初始化章节
    private func charterFromEpub(epub: JMEpubBook) {
        for (index, spine) in epub.spine.items.enumerated() {
            if spine.linear, let href = epub.manifest.items[spine.idref]?.path {
                let fullHref = epub.contentDirectory.appendingPathComponent(href)
                let charpter = JMBookCharpter(spine: spine, fullHref: fullHref, loc: JMBookIndex(index, 0), config: config)
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
    
    // 初始化章节
    private func charterFromTxt(txt: JMTxtBook) {
        for (index, txtChapter) in txt.chapters.enumerated() {
            let fullHref = txt.contentDirectory.appendingPathComponent(txtChapter.path)
            let charpter = JMBookCharpter(charpter: txtChapter, fullHref: fullHref, loc: JMBookIndex(index, 0), config: config)
            charpter.charpTitle = txtChapter.title
            self.contents.append(charpter)
        }
    }
}

// MARK: -- 处理章节、页数 --
extension JMBookModel {
    /// 下一章节
    func nextCharpter() -> JMBookPage? {
        if indexPath.chapter < contents.count - 1 {
            indexPath.chapter += 1
            indexPath.page = 0
            return currPage()
        } else {
            Logger.debug("😀😀😀已读到最后一章节")
            return nil
        }
        
    }
    
    /// 上一章节
    func prevCharpter() -> JMBookPage? {
        if indexPath.chapter > 0 {
            indexPath.chapter -= 1
            indexPath.page = 0
            return currPage()
        } else {
            Logger.debug("😀😀😀已回到第一章节")
            return nil
        }
    }
    
    /// 下一页
    func nextPage() -> JMBookPage? {
        if indexPath.chapter == contents.count - 1
            && indexPath.page == pageCount() - 1 {
            Logger.debug("😀😀😀已读到最后一页")
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
            } else {
                indexPath.page += 1
                return self[indexPath]
            }
        }
    }

    /// 上一页
    func prevPage() -> JMBookPage? {
        if indexPath.chapter == 0
            && indexPath.page == 0  {
            Logger.debug("😀😀😀已回到第一页")
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
            Logger.debug("😀😀😀: ------------------")
            Logger.debug(indexPath.descrtion())
            Logger.debug("😀😀😀: ------------------")
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
    public let parser = JMXmlParser()
    /// 当前章节
    public let location: JMBookIndex
    /// 配置文件
    public let config: JMBookConfig
    /// 文件类型
    public let booktype: JMBookType
    
    /// Epub格式初始化
    init(spine: JMEpubSpineItem, fullHref: URL, loc: JMBookIndex, config: JMBookConfig) {
        self.idref = spine.idref
        self.linear = spine.linear
        self.fullHref = fullHref
        self.location = loc
        self.config = config
        self.booktype = .Epub
    }
    
    /// Txt格式初始化
    init(charpter: JMTxtChapter, fullHref: URL, loc: JMBookIndex, config: JMBookConfig) {
        self.idref = charpter.path
        self.linear = false
        self.fullHref = fullHref
        self.location = loc
        self.config = config
        self.booktype = .Txt
    }
        
    /// 读取本章节，计算页数
    public func countPages() {
        if booktype == .Epub {
            if parser.xmlNodes.isEmpty {
                parser.content(fullHref)
            }
            let attr = parser.attributeStr(config)
            pages = JMPageParse.pageContent(content: attr, title: charpTitle ?? "", bounds: config.bounds())
        } else if booktype == .Txt {
            if let attr = JMTxtParser.attributeStr(fullHref: fullHref, config: config) {
                pages = JMPageParse.pageContent(content: attr, title: charpTitle ?? "", bounds: config.bounds())
            }
        }
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
    /// 本页内容
    public var string: String {
        return attribute.string
    }
    /// 文本类型
    init(_ attribute: NSAttributedString, title: String, page: Int) {
        self.attribute = attribute
        self.word = attribute.string.count
        self.page = page
        self.title = title
        
//        var uth_string = attribute.string
//        uth_string = uth_string.trimmingCharacters(in: NSCharacterSet.whitespaces);
//        uth_string = uth_string.trimmingCharacters(in: NSCharacterSet.newlines);
//        self.word = uth_string.count
    }
}

// MARK: -- 索引模型 ---
public class JMBookIndex {
    // 章
    var chapter: Int = 0
    // 页
    var page: Int = 0
    // 页中第几个字符
    var loc: Int = 0
    var indexPath: IndexPath {
        return IndexPath(row: page, section: chapter)
    }
    
    init(_ chapter: Int, _ page: Int) {
        self.chapter = chapter
        self.page = page
    }
    
    func descrtion() {
        Logger.debug("chapter:\(chapter) page:\(page)")
    }
}

// MARK: -- 分享模型 --
public struct JMBookShareItem {
    public var title: String?
    public var url: String?
    public var img: String?
    public var desc: String?
}
