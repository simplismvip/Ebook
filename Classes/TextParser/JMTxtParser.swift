//
//  JMTxtParser.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/20.
//
// txt 文本解析逻辑为首次加载时根据各章节分割为小文件，以后再加载时只需加载小文件，无需加载
// 并且会生成xml格式的目录文件，再次加载时根据目录加载即可

import UIKit
import AEXML

public struct JMTxtParser {
    
    public func parser(url: URL) throws -> JMTxtBook {
        do {
            let content = try String(contentsOf: url, encoding: coding())
            let chapters = separateChapter(content)
            if chapters.count > 0 {
                return JMTxtBook(chapters: chapters, path: url)
            }else {
                throw NSError(domain: "解析错误", code: 0, userInfo: nil)
            }
        } catch {
            print("error")
        }
        
        throw NSError(domain: "解析错误", code: 0, userInfo: nil)
    }
    
    func separateChapter(_ content: String) -> [JMTxtChapter] {
        let nsString = content as NSString
        var chapters = [JMTxtChapter]()
        let pattern = "第[0-9一二三四五六七八九十百千]*[章回].*"
        let stringRange = NSRange(location: 0, length: content.count)
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let options = NSRegularExpression.MatchingOptions(rawValue: 0)
            
            // 记录上一个位置
            var pageIndex: Int = 0
            var lastRange = NSRange(location: 0, length: 0)
            regex.enumerateMatches(in: content, options: options, range: stringRange) { (result, flags, stop) in
                if let targetTange = result?.range {
                    if pageIndex == 0 {
                        let title = "开始"
                        let content = nsString.substring(with: NSRange(location: 0, length: targetTange.location))
                        let chapter = JMTxtChapter(content: content, title: title, page: pageIndex, pageCount: content.count)
                        chapters.append(chapter)
                    }
                    if pageIndex > 0 {
                        let title = nsString.substring(with: lastRange)
                        let loc = lastRange.location + lastRange.length
                        let len = targetTange.location - loc
                        let content = nsString.substring(with: NSRange(location: loc, length: len))
                        let chapter = JMTxtChapter(content: content, title: title, page: pageIndex, pageCount: content.count)
                        chapters.append(chapter)
                    }
                    
                    lastRange = targetTange
                    pageIndex += 1
                }
            }
            
            // 这是为了如果读取最后一段
            let location = lastRange.location + lastRange.length
            if location < nsString.length {
                let title = nsString.substring(with: lastRange)
                let content = nsString.substring(with: NSRange(location: location, length: nsString.length - location))
                let chapter = JMTxtChapter(content: content, title: title, page: pageIndex, pageCount: content.count)
                chapters.append(chapter)
            }
            
        } catch {
            print("error")
        }
        return chapters
    }
    
    func write(path: String, content: String) {
        if !FileManager.default.fileExists(atPath: path) {
            let data = content.data(using: coding())
            do {
                try data?.write(to: URL(fileURLWithPath: path))
            } catch {
                print("error")
            }
        }
    }
    
    func coding() -> String.Encoding {
        let cfEnc = CFStringEncodings.GB_18030_2000
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
        return String.Encoding(rawValue: enc)
    }
}
