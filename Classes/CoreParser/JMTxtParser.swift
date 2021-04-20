//
//  JMTxtParser.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/20.
//

import UIKit

public struct JMTxtDocument {
    var chapters = [String]()
    init(_ chapters: [String]) {
        self.chapters = chapters
    }
}

public final class JMTxtParser {
    public func parser(url: URL) throws -> JMTxtDocument {
        let cfEnc = CFStringEncodings.GB_18030_2000
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
        do {
            let content = try String(contentsOf: url, encoding: String.Encoding(rawValue: enc))
            let chapters = separateChapter(content)
            if chapters.count > 0 {
                return JMTxtDocument(chapters)
            }else {
                throw NSError(domain: "解析错误", code: 0, userInfo: nil)
            }
        } catch {
            print("error")
        }
        
        throw NSError(domain: "解析错误", code: 0, userInfo: nil)
    }
    
    func separateChapter(_ content: String) -> [String] {
        var chapters = [String]()
        let pattern = "第[0-9一二三四五六七八九十百千]*[章回].*"
        let stringRange = NSRange(location: 0, length: content.count)
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let options = NSRegularExpression.MatchingOptions(rawValue: 0)
            regex.enumerateMatches(in: content, options: options, range: stringRange) { (result, flags, stop) in
                if let range = result?.range {
                    let local = range.location
                    
                    
                }
            }
        } catch {
            print("error")
        }
        return chapters
    }
}
