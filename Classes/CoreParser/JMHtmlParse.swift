//
//  JMHtmlParse.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/1.
//

import UIKit
import YYText
import BSText

struct JMHtmlParse {
    
    static func parseEpub(content: String, config: JMBookConfig, href: URL) -> NSMutableAttributedString {
        let scanner = Scanner(string: content)
        let text = NSMutableAttributedString()
        while !scanner.isAtEnd {
            if scanner.scanString("<img>", into: nil) {
                let uPoint = UnsafeMutablePointer<NSString?>.allocate(capacity: 1)
                let aPointer = AutoreleasingUnsafeMutablePointer<NSString?>(uPoint)
                if scanner.scanUpTo("</img>", into: aPointer), let imaName = uPoint.pointee as String? {
                    let path = href.appendingPathComponent(imaName)
                    if let data = try? Data(contentsOf: path), let image = UIImage(data: data) {
                        if image.size.width > config.width, let cgimage = image.cgImage {
                            let rate = image.size.width / config.width
                            let tempIma = UIImage(cgImage: cgimage, scale: rate, orientation: .up)
                            let attachText = attachMent(image: tempIma, font: config.font())
                            text.append(attachText)
                            text.append(NSAttributedString(string: "\n"))
                        }else {
                            let attachText = attachMent(image: image, font: config.font())
                            text.append(attachText)
                            text.append(NSAttributedString(string: "\n"))
                        }
                    }
                    scanner.scanString("</img>", into: nil)
                }else {
                    let uPoint = UnsafeMutablePointer<NSString?>.allocate(capacity: 1)
                    let aPointer = AutoreleasingUnsafeMutablePointer<NSString?>(uPoint)
                    if scanner.scanUpTo("</img>", into: aPointer), let content = uPoint.pointee as String? {
                        let conText = NSMutableAttributedString(string: content)
                        conText.yy_lineSpacing = config.lineSpace
                        conText.yy_font = config.font()
                        conText.yy_firstLineHeadIndent = 20
                        text.append(conText)
                    }
                }
            }
        }
        
        return text
    }
    
    static func attachMent(image: UIImage, font: UIFont) -> NSMutableAttributedString {
        return NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .center, attachmentSize: image.size, alignTo: font, alignment: .center)
    }
    
    
    static func paginateWithContent(content: String, bounds: CGRect) {
        var pageArray = [Int]()
        let cfPath = CGPath(rect: bounds, transform: nil);
        let attrStr = NSMutableAttributedString(string: content)
        let ctFrameSetter = CTFramesetterCreateWithAttributedString(attrStr as CFAttributedString)
        
        // 当前偏移
        var curOffset = 0
        var curInnerOffset = 0
        // 同一位置重复获取
        var samePlaceRepeatCount = 0
        // 防止死循环，如果在同一个位置获取CTFrame超过2次，则跳出循环
        let preventDeadLoopSign = 0
        
        // 是否分页完成✅
        var hasMorePages = true
        
        while hasMorePages {
            if preventDeadLoopSign == curOffset {
                samePlaceRepeatCount += 1
            } else {
                samePlaceRepeatCount = 0;
            }
            
            if samePlaceRepeatCount > 1 {
                // 退出循环前检查一下最后一页是否已经加上
                if pageArray.count == 0 {
                    pageArray.append(curOffset)
                } else {
                    if pageArray.last != curOffset {
                        pageArray.append(curOffset)
                    }
                }
                break;
            }
            
            pageArray.append(curOffset)
            let ctFrame = CTFramesetterCreateFrame(ctFrameSetter, CFRangeMake(curInnerOffset, 0), cfPath, nil)
            let ctRange = CTFrameGetVisibleStringRange(ctFrame)
            if (ctRange.location + ctRange.length) != attrStr.length {
                curOffset += ctRange.length;
                curInnerOffset += ctRange.length;
            }else {
                // 已经分完，提示跳出循环
                hasMorePages = false
            }
        }
    }
}
