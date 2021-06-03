//
//  JMModel.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/1.
//

import Foundation
import ZJMKit

public class JMBookIndex {
    var chapter: Int = 0 // 章
    var page: Int = 0    // 页
    var loc: Int = 0     // 页中第几个字符
    var indexPath: IndexPath {
        return IndexPath(row: page, section: chapter)
    }
    
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


// MARK: -- 目录, ncx中读取的目录 ------- 暂时用不到 -------
public struct JMBookChapter {
    public var title: String
    public var id: String
    public let src: String
    public let fullHref: URL
    public var subTable: [JMBookChapter]?
    init(_ tableOfContents: JMEpubTOC, baseHref: URL) {
        self.id = tableOfContents.id
        self.title = tableOfContents.label
        self.src = tableOfContents.item ?? ""
        self.fullHref = baseHref.appendingPathComponent(self.src)
        self.subTable = tableOfContents.subTable?.compactMap({ $0 }).map({ JMBookChapter($0, baseHref: baseHref) })
    }
}
