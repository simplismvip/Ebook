//
//  JMBookCharpter.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/9/17.
//  章节模型，一个模型代表一个章节

import UIKit

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
    
    // 获取页数
    subscript(pageIndex: Int) -> JMBookPage? {
        get {
            if pages == nil {
                countPages()
            }
            return pages?[safe: pageIndex]
        }
    }
}
