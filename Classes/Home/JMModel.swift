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
    
    func sectionAdd() {
        chapter += 1
    }
    
    func rowAdd() {
        page += 1
    }
    
    func sectionJian() {
        chapter -= 1
    }
    
    func rowJian() {
        page -= 1
    }
    
    func rowZero() {
        page = 0
    }
    
    func secZero() {
        chapter = 0
    }
    
    func rowSet(_ n: Int) {
        page = n
    }
    
    func sectionSet(_ n: Int) {
        chapter = n
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
