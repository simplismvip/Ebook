//
//  JMBookParse.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/7.
//

import UIKit
import ZJMKit
import EPUBKit

// MARK: -- 解析图书类，这个类允许重写覆盖
public class JMBookParse: NSObject {
    public let path: String // 图书路径
    public let pathUrl: URL // 图书URL
    public let bookType: JMBookType // 图书类型
    
    public init(_ path: String) {
        self.path = path
        self.pathUrl = URL(fileURLWithPath: path)
        self.bookType = JMBookType.bookType(pathUrl.pathExtension)
        super.init()
    }
    
    /// 开始读书
    public func startRead() {
        self.jmSendMsg(msgName: kMsgNameStartOpeningBook, info: "开始解析" as MsgObjc)
        DispatchQueue.global().async {
            if self.bookType == .Epub {
                self.parseEpubBook()
            }else if self.bookType == .Txt {
                self.parseTxtBook()
            }
        }
    }
    
    // Epub, 读取目录
    private func parseEpubBook() {
        do{
            let document = try EPUBParser().parse(documentAt: pathUrl)
            if let tocItems = document.tableOfContents.subTable {
                let ncx = tocItems.map { JMBookChapter($0,baseHref: document.contentDirectory) }
                let bookModel = JMBookModel(document: document, catalog: ncx)
                DispatchQueue.main.async {
                    self.jmSendMsg(msgName: kMsgNameOpenBookSuccess, info: bookModel as MsgObjc)
                }
            }else {
                DispatchQueue.main.async {
                    self.jmSendMsg(msgName: kMsgNameOpenBookFail, info: "🆘🆘🆘打开失败" as MsgObjc)
                }
            }
        }catch {
            DispatchQueue.main.async {
                self.jmSendMsg(msgName: kMsgNameOpenBookFail, info: "🆘🆘🆘打开 \(error.localizedDescription)失败" as MsgObjc)
            }
        }
    }
    
    // Txt
    private func parseTxtBook() {
//        do{
//            DispatchQueue.main.async {
//                self.jmSendMsg(msgName: kMsgNameOpenBookSuccess, info: "😀😀😀打开 \("document.title")成功" as MsgObjc)
//            }
//        }catch {
//            DispatchQueue.main.async {
//                self.jmSendMsg(msgName: kMsgNameOpenBookFail, info: "🆘🆘🆘打开 \(error.localizedDescription)失败" as MsgObjc)
//            }
//        }
    }
}

extension JMBookParse {
    // Pdf
    private func parsePdfBook() {
        
    }
    
    // Mobi
    private func parseMobiBook() {
        
    }
}
