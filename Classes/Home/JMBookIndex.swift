//
//  JMBookIndex.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/9/17.
//  -- 索引模型，用章节、页、某个字描述当前索引

import UIKit

public class JMBookIndex {
    /// 章
    var chapter: Int = 0
    /// 页
    var page: Int = 0
    /// 页中第几个字符
    var loc: Int = 0
    /// 当前索引
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
