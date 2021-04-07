//
//  JMHtmlParse.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/1.
//

import UIKit

struct JMHtmlParse {
    static func convertingHTMLToPlainText(_ htmlStr: NSString) -> String {
        return htmlStr.stringByConvertingHTMLToPlainText()
    }
}
