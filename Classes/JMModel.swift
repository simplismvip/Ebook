//
//  JMModel.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/1.
//

import Foundation
import EPUBKit
import ZJMKit

// MARK: -- 图书数据模型
public class JMEpubWapper<T> {
    let item: T
    init(_ item: T) {
        self.item = item
    }
}

// MARK: -- 按钮显示、隐藏状态
public enum JMBookType {
    case Epub // 上下
    case Txt // 设置
    case Pdf // 亮度
    case Mobi // 播放
    case NoneType // 播放
    
    /// 返回图书的类型
    static func bookSuffix(_ type: JMBookType) -> String {
        switch type {
        case .Epub:
            return "epub"
        case .Txt:
            return "txt"
        case .Pdf:
            return "pad"
        case .Mobi:
            return "mobi"
        case .NoneType:
            return "none"
        }
    }
    
    /// 返回图书的类型
    static func bookType(_ suffix: String) -> JMBookType {
        if suffix == "epub" {
            return .Epub
        }else if suffix == "txt" {
            return .Txt
        }else if suffix == "pdf" {
            return .Pdf
        }else if suffix == "mobi" {
            return .Mobi
        }else {
            return NoneType
        }
    }
}

// MARK: -- 分享
public struct JMBookShareItem {
    public var title: String?
    public var url: String?
    public var img: String?
    public var desc: String?
}

// MARK: -- 章节模型
public struct JMBookCharpterItem {
    public var primaryId: String?
    public var name: String?
    public var content: String?
    public var charpterId: String?
    public var pageCount: Int?
    
    public var html: String?
    public var chapterpath: String?
    public var epubImagePath: String?
    
    var bookName: String?
    var author: String?
    var bookId: String?
}

// MARK: -- 数据模型
final public class JMBookModel {
    public var bookId: String
    public var title: String
    public var author: String
    public var coverImg: String?
    public var category: String?
    public var word: String?
    public var charpter: String?    //最近更新的章节
    public var desc: String?

    public var updateTime: TimeInterval? // 更新时间
    public var readTime: TimeInterval? //阅读的最后时间
    
    public var end = false // 是否完结
    public var updateEnd = false // 是否更新
    public var updateCharpterId = "" // 更新章节ID
    public var onBookshelf = false // 是否在书架上
    public var isDownload = false // 是否已下载
    public var total = 0 // 总章节数
    public var currPage = 0 // 当前阅读进度
    public var currCharpter: JMBookCharpterItem? // 当前章节
    public var share: JMBookShareItem? // 分享模型
    
    init(bookId: String, title: String, author: String) {
        self.bookId = bookId
        self.title = title
        self.author = author
    }
}
