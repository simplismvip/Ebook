//
//  JMBookParse.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/7.
//

import UIKit

public class JMBookParse {
    public let path: String // 图书路径
    public let pathUrl: URL // 图书URL
    public let bookType: JMBookType // 图书类型
    public let config: JMBookConfig // 配置
    private var parserCallback: ((JMBookContrller, Bool) -> ())?
    
    public init(_ path: String, config: JMBookConfig? = nil) {
        self.path = path
        self.pathUrl = URL(fileURLWithPath: path)
        self.bookType = JMBookType.bookType(pathUrl.pathExtension.lowercased())
        self.config = (config == nil) ? JMBookConfig() : config!
        JMBookCache.setObjc(key: "jmBookConfig", obj: self.config)
//        let _ = JMBookDataBase.share
    }
    
    // parsent 控制器
    public func presentReader(parentVC: UIViewController) {
        startRead { (pagevc, status) in
            if status {
                pagevc.delegate = parentVC as? JMBookProtocol
                pagevc.delegate?.openSuccess("打开图书成功")
                parentVC.present(pagevc)
            } else {
                pagevc.delegate = parentVC as? JMBookProtocol
                pagevc.delegate?.openFailed("🆘🆘🆘打开失败\(pagevc.bookModel.title)" )
            }
        }
    }
    
    /// push 控制器
    public func pushReader(pushVC: UIViewController) {
        startRead { (pagevc, status) in
            if status {
                pagevc.delegate = pushVC as? JMBookProtocol
                pagevc.delegate?.openSuccess("打开图书成功")
                pushVC.push(pagevc)
            } else {
                pagevc.delegate = pushVC as? JMBookProtocol
                pagevc.delegate?.openFailed("🆘🆘🆘打开失败:\(pagevc.bookModel.title)" )
            }
        }
    }
    
    /// 开始读书
    private func startRead(parser: @escaping (JMBookContrller, Bool) -> ()) {
        self.parserCallback = parser
        DispatchQueue.global().async {
            switch self.bookType {
            case .Epub:
                self.parseEpubBook()
            case .Txt:
                self.parseTxtBook()
            case .Mobi:
                JMLogger.error("❗️❗️❗️暂不支持格式")
            case .Pdf:
                JMLogger.error("❗️❗️❗️暂不支持格式")
            case .NoneType:
                JMLogger.error("❗️❗️❗️暂不支持格式")
            }
        }
    }
    
    // Epub, 读取目录
    private func parseEpubBook() {
        do {
            let epub = try JMEpubParser().parse(documentAt: pathUrl)
            let bookModel = JMBookModel(epub: epub, config: config)
            DispatchQueue.main.async {
                let pageView = JMBookContrller(bookModel)
                self.parserCallback?(pageView, true)
            }
        } catch let error as NSError {
            DispatchQueue.main.async {
                let bookModel = JMBookModel(error.description)
                let pageView = JMBookContrller(bookModel)
                self.parserCallback?(pageView, false)
            }
        }
    }
    
    // Txt
    private func parseTxtBook() {
        do {
            let txt = try JMTxtParser().parser(url: pathUrl)
            let bookModel = JMBookModel(txt: txt, config: config)
            DispatchQueue.main.async {
                let pageView = JMBookContrller(bookModel)
                self.parserCallback?(pageView, true)
            }
        } catch let error as NSError {
            DispatchQueue.main.async {
                let bookModel = JMBookModel(error.description)
                let pageView = JMBookContrller(bookModel)
                self.parserCallback?(pageView, false)
            }
        }
    }
    
    // Pdf
    private func parsePdfBook() {
        
    }
    
    // Mobi
    private func parseMobiBook() {
        
    }
    
    deinit {
        print("⚠️⚠️⚠️类 JMBookParse 已经释放")
    }
}
