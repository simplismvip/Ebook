//
//  JMBookParse.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/7.
//

import UIKit
import ZJMKit

// MARK: -- 解析图书类，这个类允许重写覆盖
public class JMBookParse: NSObject {
    public weak var delegate: JMBookParserProtocol?
    public let path: String // 图书路径
    public let pathUrl: URL // 图书URL
    public let bookType: JMBookType // 图书类型
    public let config: JMBookConfig // 配置
    private var parserCallback: ((JMBookContrller)->())?
    
    public init(_ path: String, config: JMBookConfig? = nil) {
        self.path = path
        self.pathUrl = URL(fileURLWithPath: path)
        self.bookType = JMBookType.bookType(pathUrl.pathExtension.lowercased())
        self.config = (config == nil) ? JMBookConfig() : config!
        super.init()
        let _ = JMBookDataBase.share
    }
    
    // parsent 控制器
    public func presentReader(parentVC: UIViewController) {
        startRead { (pagevc) in
            parentVC.present(pagevc)
        }
    }
    
    /// push 控制器
    public func pushReader(pushVC: UIViewController) {
        startRead { (pagevc) in
            pushVC.push(pagevc)
        }
    }
    
    /// 开始读书
    public func startRead(parser: @escaping (JMBookContrller)->()) {
        self.parserCallback = parser
        delegate?.startOpeningBook("正在打开图书loading")
        DispatchQueue.global().async {
            if self.bookType == .Epub {
                self.parseEpubBook()
            } else if self.bookType == .Txt {
                self.parseTxtBook()
            } else {
                print("❗️❗️❗️暂不支持格式")
            }
        }
    }
    
    // Epub, 读取目录
    private func parseEpubBook() {
        do{
            let epub = try JMEpubParser().parse(documentAt: pathUrl)
            let bookModel = JMBookModel(epub: epub, config: config)
            DispatchQueue.main.async {
                let pageView = JMBookContrller(bookModel)
                pageView.delegate = self
                self.parserCallback?(pageView)
            }
        }catch {
            DispatchQueue.main.async {
                self.delegate?.openBookFailed("🆘🆘🆘打开 \(error.localizedDescription)失败" )
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
                pageView.delegate = self
                self.parserCallback?(pageView)
            }
        } catch let error as NSError {
            DispatchQueue.main.async {
                self.parseTxtBook()
                // self.delegate?.openBookFailed("🆘🆘🆘打开 \(error.localizedDescription)失败" )
            }
        }
    }
}

extension JMBookParse: JMReadProtocol {
    public func currentReadVC(_ after: Bool) -> UIViewController? {
        return delegate?.midReadPageVC(after)
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
