//
//  JMHtmlParse.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/1.
//

import UIKit

struct JMHtmlParse {
    
    static func convertHTML(_ htmlStr: String, imaPath: String) -> [JMBookTextItem]? {
        let scanner = Scanner(string: htmlStr)
        
        while !scanner.isAtEnd {
            if scanner.scanString("<img>", into: nil) {
                let uPoint = UnsafeMutablePointer<NSString?>.allocate(capacity: 1)
                let aPointer = AutoreleasingUnsafeMutablePointer<NSString?>(uPoint)
                if scanner.scanUpTo("</img>", into: aPointer), let imaName = uPoint.pointee as String? {
                    if let image = UIImage(contentsOfFile: "" + imaPath + imaName) {
                        
                    }
        
                }else{
                    print("没有匹配到")
                }
            }
        }
        
        return nil
    }
    
    static func convertHTMLToText(_ htmlStr: NSString) -> [JMBookTextItem]? {
        
        return nil
    }
    
    static func convertHTMLToImage(_ htmlStr: NSString) -> [JMBookImaItem]? {
        
        return nil
    }
    
    static func convertHTMLToLink(_ htmlStr: NSString) -> [JMBookLinkItem]? {
       
        return nil
    }
}
