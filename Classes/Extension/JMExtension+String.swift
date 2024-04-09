//
//  JMExtension+String.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/9.
//

import Foundation
import UIKit

// MARK: - NSString helpers
public extension String {
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    var abbreviatingWithTildeInPath: String {
        return (self as NSString).abbreviatingWithTildeInPath
    }
    
    func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
    
    func appendingPathExtension(_ str: String) -> String {
        return (self as NSString).appendingPathExtension(str) ?? self+"."+str
    }
    
    func rangeOf(_ targrt: String) -> NSRange {
        return (self as NSString).range(of: targrt)
    }
    
    func fontWith(_ fontSize: CGFloat) -> UIFont {
        return (self as NSString).font(withSize: fontSize)
    }
    
    /// 中文转英文
    func jmTransformChinese() -> String {
        let mutabString = self.mutableCopy() as! CFMutableString
        CFStringTransform(mutabString, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(mutabString, nil, kCFStringTransformStripCombiningMarks, false)
        return mutabString as String
    }

    /// 时间戳字符串格式化
    func jmFormatTspString(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String? {
        // 1578039791.520024
        if let time = Double(self) {
            let date = Date(timeIntervalSince1970: time)
            let dfmatter = DateFormatter()
            dfmatter.dateFormat = format
            return dfmatter.string(from: date)
        }
        return nil
    }
}

