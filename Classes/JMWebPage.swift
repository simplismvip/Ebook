//
//  JMWebPage.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/1.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift

class JMWebPage: WKWebView {
//    let config: JMReadConfig
//
//    init(frame: CGRect, config: JMReadConfig) {
//        self.config = config
//        let config = WKWebViewConfiguration()
//        super.init(frame: frame, configuration: config)
//        backgroundColor = UIColor.jmRandColor
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}

extension JMWebPage {
    // MARK: - JavaScript桥接调用
    open func js(_ script:String, handler: ((String?, Error?) -> Void)? = nil) {
        self.evaluateJavaScript(script) { (item, error) in
            handler?(item as? String, error)
        }
    }
}
