//
//  JMBookModel.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/10.
//  书本📖模型，一个模型代表一本书

import UIKit
import ZJMKit

final public class JMBookModel {
    public var bookId: String // 目前使用文件名作为唯一ID，因为发现有的电子书没有唯一ID
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
        self.bookId = epub.directory.lastPathComponent // epub.bookId
        self.author = epub.author
        self.coverImg = epub.cover
        self.config = config
        self.directory = epub.directory
        self.contentDirectory = epub.contentDirectory
        self.desc = epub.metadata.description
        self.indexPath = JMBookIndex(0, 0)
        self.charterFromEpub(epub: epub)
        
        // 初始化章节完成后转跳到相应页
        if let bookTag = JMBookDataBase.fetchRate(bookid: bookId) {
            lastTime = bookTag.timeStr.jmFormatTspString("yyyy-MM-dd HH:mm:ss")
            indexPath.chapter = bookTag.charter
            contents[safe: indexPath.chapter]?.countPages()
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
        if let bookTag = JMBookDataBase.fetchRate(bookid: bookId) {
            lastTime = bookTag.timeStr.jmFormatTspString("yyyy-MM-dd HH:mm:ss")
            indexPath.chapter = bookTag.charter
            contents[safe: indexPath.chapter]?.countPages()
            // 查找阅读到的Page
            if let targetPage = newPageLoc(location: bookTag.location, text: bookTag.text) {
                indexPath.page = targetPage.page
            }
        }
    }
    
    // 失败的情况调用
    init(_ desc: String) {
        self.title = desc
        self.bookId = ""
        self.author = ""
        self.config = JMBookConfig()
        self.directory = URL(fileURLWithPath: "")
        self.contentDirectory = URL(fileURLWithPath: "")
        self.indexPath = JMBookIndex(0, 0)
    }
    
    /// 本书所有文字数
    public func word() -> Int {
        return contents.reduce(0, { $0 + $1.word() })
    }
    
    /// 当前页数
    public func readRate() -> String? {
        if let page = contents[safe: indexPath.chapter]?.pages?.count {
            return "第\(indexPath.page + 1)/\(page)页"
        } else {
            return "第\(indexPath.page + 1))页"
        }
    }
    
    /// 当前小节标题
    public func currTitle() -> String {
        return contents[safe: indexPath.chapter]?.charpTitle ?? title
    }
    
    /// 更新字体大小等后重新计算已读章节
    public func reCountCharpter() {
        if indexPath.chapter < contents.count {
            // 重新计算当前章页数
            contents[safe: indexPath.chapter]?.countPages()
        }
    }
    
    /// 获取重新计算分页后的目标页
    public func newPageLoc(location: Int, text: String) -> JMBookPage? {
        reCountCharpter() // 重新修改字体，计算页数
        if let pages = contents[safe: indexPath.chapter]?.pages {
            if let pageIndex = pages.jmIndex({ $0.attribute.string.contains(text) }) {
                indexPath.page = pageIndex // 重新计算后页数可能会改变，所以重新赋值页数
                return pages[safe: pageIndex]
            } else {
                var loc = 0
                for (pageIndex, page) in pages.enumerated() {
                    loc += page.word
                    if location <= loc {
                        indexPath.page = pageIndex
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
    
    /// 当前章节
    public func currCharpter() -> JMBookCharpter? {
        if indexPath.chapter < contents.count {
            return contents[safe: indexPath.chapter]
        }
        return nil
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
        if let pages = contents[safe: indexPath.chapter]?.pages {
            return pages.count
        } else {
            contents[safe: indexPath.chapter]?.countPages()
            return contents[safe: indexPath.chapter]?.pages?.count ?? 0
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
                } else {
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
        } else {
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
        } else {
            if indexPath.page == 0 {
                // 到这里说明更新章
                indexPath.chapter -= 1
                indexPath.page = pageCount() - 1
                return self[indexPath]
            } else {
                indexPath.page -= 1
                return self[indexPath]
            }
        }
    }
    
    subscript(indexPath: JMBookIndex) -> JMBookPage? {
        get {
            indexPath.descrtion()
            return contents[safe: indexPath.chapter]?[indexPath.page]
        }
    }
}
