//
//  JMTxtParser.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/20.
//
// txt 文本解析逻辑为首次加载时根据各章节分割为小文件，以后再加载时只需加载小文件，无需加载
// 并且会生成xml格式的目录文件，再次加载时根据目录加载即可

import Foundation
import AEXML

public struct JMTxtParser {
    /// 解析txt文本文件
    public func parser(url: URL) throws -> JMTxtBook {
        let filename = url.lastPathComponent.deletingPathExtension
        if let folderPath = JMFileTools.jmDocuPath()?.appendingPathComponent(filename) {
            if FileManager.default.fileExists(atPath: folderPath) {
                // 解析
                if let book = parserOpf(folderPath: folderPath) {
                    return book
                } else {
                    throw NSError(domain: "🆘🆘🆘解析opf.xml文件错误", code: 0, userInfo: nil)
                }
            } else {
                // 第一次加载，解析生成文件
                JMFileTools.jmCreateFolder(folderPath)
                if let content = try? String(contentsOf: url, encoding: coding()) {
                    parserContent(folderPath: folderPath, content: content)
                    // 解析
                    if let book = parserOpf(folderPath: folderPath) {
                        return book
                    } else {
                        throw NSError(domain: "🆘🆘🆘解析opf.xml文件错误", code: 0, userInfo: nil)
                    }
                } else {
                    throw NSError(domain: "🆘🆘🆘解码txt文件发生错误", code: 0, userInfo: nil)
                }
            }
        } else {
            throw NSError(domain: "🆘🆘🆘创建folderpath错误", code: 0, userInfo: nil)
        }
    }
    
    // 解析opf.xml
    private func parserOpf(folderPath: String) -> JMTxtBook? {
        let xmlPath = folderPath.full(f: "opf", l: "xml")
        if let book = parserXml(xmlPath: URL(fileURLWithPath: xmlPath)) {
            return book
        } else {
            return nil
        }
    }
    
    // 解析txt全文
    func parserContent(folderPath: String, content: String) {
        var writeChapters = [JMTxtChapter]()
        let nsString = content as NSString
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
                        writeTxt(textPath: folderPath.full(f: title, l: "txt"), content: content)
                        let charpter = JMTxtChapter(title: title, page: "\(pageIndex)", count: "\(content.count)")
                        writeChapters.append(charpter)
                    }
                    if pageIndex > 0 {
                        let title = nsString.substring(with: lastRange)
                        let loc = lastRange.location + lastRange.length
                        let len = targetTange.location - loc
                        let content = nsString.substring(with: NSRange(location: loc, length: len))
                        writeTxt(textPath: folderPath.full(f: title, l: "txt"), content: content)
                        let charpter = JMTxtChapter(title: title, page: "\(pageIndex)", count: "\(content.count)")
                        writeChapters.append(charpter)
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
                writeTxt(textPath: folderPath.full(f: title, l: "txt"), content: content)
                let charpter = JMTxtChapter(title: title, page: "\(pageIndex)", count: "\(content.count)")
                writeChapters.append(charpter)
            }
        } catch {
            JMLogger.error("error")
        }
        
        // 写入xml
        writeXml(path: folderPath.full(f: "opf", l: "xml"), charpters: writeChapters)
    }
    
    // 解析txt文件的xml信息文件
    private func parserXml(xmlPath: URL) -> JMTxtBook? {
        guard let data = try? Data(contentsOf: xmlPath) else {
            return nil
        }
        
        if let xmlDoc = try? AEXMLDocument(xml: data) {
            var chapters = [JMTxtChapter]()
            let title = xmlDoc.root["metadata"]["dc:title"].string
            let creator = xmlDoc.root["metadata"]["dc:creator"].string
            let identifier = xmlDoc.root["metadata"]["dc:identifier"].string
            if let items = xmlDoc.root["manifest"]["item"].all {
                for item in items {
                    let title = item.attributes["title"] ?? ""
                    let page = item.attributes["page"] ?? ""
                    let pageCount = item.attributes["count"] ?? ""
                    let chapter = JMTxtChapter(title: title, page: page, count: pageCount)
                    chapters.append(chapter)
                }
            }
            return JMTxtBook(title: title, bookId: identifier, author: creator, chapters: chapters, path: xmlPath)
        } else {
            return nil
        }
    }
    
    // 生成txt文件目录
    private func writeXml(path: String, charpters: [JMTxtChapter]) {
        let root = AEXMLDocument()
        let attributes = ["xmlns:dc" : "https://github.com/simplismvip/Ebook", "xmlns:opf" : "opf"]
        let body = root.addChild(name: "body")
        let metadata = body.addChild(name: "metadata", attributes: attributes)
        let title = path.deletingLastPathComponent.lastPathComponent
        metadata.addChild(name: "dc:title", value: title)
        metadata.addChild(name: "dc:creator", value: "JMEpubReader")
        metadata.addChild(name: "dc:identifier", value: title)
        let manifest = body.addChild(name: "manifest")
        for charpter in charpters {
            let attributes = ["title" : charpter.title, "href" : charpter.path, "page" : charpter.page, "count" : charpter.count]
            manifest.addChild(name: "item", attributes: attributes)
        }
        writeTxt(textPath: path, content: root.xml)
    }
    
    // 写入文本信息
    private func writeTxt(textPath: String, content: String) {
        if !FileManager.default.fileExists(atPath: textPath) {
            let data = content.replacingOccurrences(of: "\r\n\r\n", with: "\r\n").data(using: .utf8)
            do {
                try data?.write(to: URL(fileURLWithPath: textPath))
            } catch {
                JMLogger.error("error")
            }
        }
    }
    
    private func coding() -> String.Encoding {
        let cfEnc = CFStringEncodings.GB_18030_2000
        let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
        return String.Encoding(rawValue: enc)
    }
}

extension JMTxtParser {
    static public func attributeStr(fullHref: URL, config: JMBookConfig) -> NSMutableAttributedString? {
        if let content = try? String(contentsOf: fullHref, encoding: .utf8) {
            let conText = NSMutableAttributedString(string: content)
            conText.yy_lineSpacing = config.lineSpace()
            conText.yy_paragraphSpacing = config.lineSpace() * 1.2
            conText.yy_font = config.font()
            conText.yy_firstLineHeadIndent = 20
            conText.yy_color = config.textColor()
            return conText
        }
        return nil
    }
}


extension String {
    func full(f: String, l: String) -> String {
        return self.appendingPathComponent(f).appendingPathExtension(l)
    }
}
