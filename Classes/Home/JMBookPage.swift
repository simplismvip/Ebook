//
//  JMBookPage.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/9/17.
//  文本页模型，一个模型代表一页书

import UIKit

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
    }
}
