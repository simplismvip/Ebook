//
//  JMModel.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/1.
//

import Foundation
import EPUBKit
import ZJMKit

public class JMBookIndex {
    var chapter: Int = 0 // 章
    var page: Int = 0    // 页
    var loc: Int = 0     // 页中第几个字符
    
    init(_ chapter: Int, _ page: Int) {
        self.chapter = chapter
        self.page = page
    }
    
    func descrtion() {
        print("chapter:\(chapter) page:\(page)")
    }
}

// MARK: -- 分享
public struct JMBookShareItem {
    public var title: String?
    public var url: String?
    public var img: String?
    public var desc: String?
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
    
    init(_ content: NSMutableAttributedString, _ catalog: JMBookChapter, href: URL) {
        self.title = catalog.title
        self.idef = catalog.id
        self.item = catalog.src
        self.href = href
//        let path = href.deletingLastPathComponent()
//        let attributeStr = (content as NSString).parserEpub(path, spacing: JMBookConfig.share.lineSpace, font: JMBookConfig.share.font())
        self.pages = JMPageParse.pageContent(content: content, title:"", bounds: JMBookConfig.share.bounds())
    }
    
    public func word() -> Int {
        return pages.reduce(0, { $0 + $1.word })
    }
}

// MARK: -- 目录, ncx中读取的目录 ------- 暂时用不到 -------
public struct JMBookChapter {
    public var title: String
    public var id: String
    public let src: String
    public let fullHref: URL
    public var subTable: [JMBookChapter]?
    init(_ tableOfContents: EPUBTableOfContents, baseHref: URL) {
        self.id = tableOfContents.id
        self.title = tableOfContents.label
        self.src = tableOfContents.item ?? ""
        self.fullHref = baseHref.appendingPathComponent(self.src)
        self.subTable = tableOfContents.subTable?.compactMap({ $0 }).map({ JMBookChapter($0, baseHref: baseHref) })
    }
}
