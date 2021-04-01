//
//  JMReadPageView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/1.
//

import UIKit
import ZJMKit
import EPUBKit
import WebKit

public class JMReadPageView: JMBaseCollectionCell {
    lazy var webPage: JMWebPage = {
        let webView = JMWebPage(frame: .zero , config: JMReadConfig())
        webView.navigationDelegate = self
        return webView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(webPage)
        if let htmlPath = Bundle.path(resource: "test", ofType: "html") {
            let hemlContent = JMHtmlParse.html(htmlPath)
            loadHTMLString(hemlContent, baseURL: URL(fileURLWithPath: htmlPath))
        }
    }
    
    func refash(_ model: EPUBSpineItem) {
        
    }
    
    func loadHTMLString(_ htmlContent: String, baseURL: URL) {
        webPage.loadHTMLString(htmlContent, baseURL: nil)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        webPage.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JMReadPageView: WKNavigationDelegate {
    /**
     网页加载完成，获取内容的高度。
     - 1、想要拿到高度，webView的高度先要设置小一点，也可设置为0。
     假如，一开始设置了webView的高度为700，但是内容的高度没有达到700，
     此时获取到的高度肯定是700。所以要先设置小一点。
     
     - 2、以下代码，也可以放在KVO的监听方法里面，但是KVO可能会执行多次。
     didFinish这里只执行一次。具体放那里看个人需求了。
     */
    private func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let jsScrollHeight = "document.body.scrollHeight"
        webView.evaluateJavaScript(jsScrollHeight, completionHandler: { (result, error) in
            if result == nil { return }
            if result is CGFloat {
                /** 这里拿到的 result 就是高度 */
                let height = result as! CGFloat
                var rect = webView.frame
                rect.size.height = height
                webView.frame = rect
            }
        })
    }
    
    private func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}
