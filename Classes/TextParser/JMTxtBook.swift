//
//  JMTxtBook.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/6/3.
//

import Foundation

public struct JMTxtChapter {
    var content: String?
    let title: String
    let page: String // 页数
    let count: String // 字数
    let path: String
    
    init(title: String, page: String, count: String) {
        self.title = title
        self.path = title.appendingPathExtension("txt")
        self.page = page
        self.count = count
    }
}

public struct JMTxtBook {
    public var bookId: String = ""
    public var title: String = ""
    public var author: String = ""
    public let directory: URL
    public let contentDirectory: URL
    public let chapters: [JMTxtChapter]
    
    init(title: String, bookId: String, author: String, chapters: [JMTxtChapter], path: URL) {
        self.title = title
        self.bookId = bookId
        self.author = author
        self.chapters = chapters
        self.directory = path
        self.contentDirectory = path.deletingLastPathComponent()
    }
}
