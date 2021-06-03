//
//  JMTxtBook.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/6/3.
//

import Foundation

public struct JMTxtChapter {
    let content: String
    let title: String
    let page: Int
    let pageCount: Int
}

public struct JMTxtBook {
    public var bookId: String
    public var title: String
    public var author: String
    public let directory: URL
    public let chapters: [JMTxtChapter]
    init(chapters: [JMTxtChapter], path: URL) {
        self.chapters = chapters
        self.directory = path
    }
}
