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
    public weak var delegate: JMBookParserProtocol?
    public let path: String // 图书路径
    public let pathUrl: URL // 图书URL
    public let bookType: JMBookType // 图书类型
    private var parserCallback: ((JMReadPageContrller)->())?
    public init(_ path: String) {
        self.path = path
        self.pathUrl = URL(fileURLWithPath: path)
        self.bookType = JMBookType.bookType(pathUrl.pathExtension.lowercased())
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
    public func startRead(parser: @escaping (JMReadPageContrller)->()) {
        self.parserCallback = parser
        delegate?.startOpeningBook("正在打开图书loading")
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
            let bookModel = JMBookModel(document: document)
            DispatchQueue.main.async {
                let pageView = JMReadPageContrller(bookModel)
                pageView.delegate = self
                self.delegate?.openBookSuccess(pageView.bottomAdView)
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
            let _ = try JMTxtParser().parser(url: pathUrl)
        }catch let error as NSError {
            print(error)
        }
    }
}

extension JMBookParse: JMReadProtocol {
    public func currentReadVC(charpter: Int, page: Int) -> UIViewController? {
        return delegate?.midReadPageVC(charpter: charpter, page: page)
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

extension EPUBDocument {
    public func findTarget(target: String) -> EPUBTableOfContents? {
        guard let items = tableOfContents.subTable, items.count > 0 else {
            return nil
        }
        
        for item in items {
            if item.item == target {
                return item
            }else {
                // 第一层没找到遍历第二层
                if let subItems = item.subTable, subItems.count > 0 {
                    for subItem in subItems {
                        if subItem.item == target {
                            return subItem
                        }
                    }
                }
            }
        }
        return nil
    }
}
