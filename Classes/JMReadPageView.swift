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
        let webView = JMWebPage(frame: .zero)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.backgroundColor = UIColor.white
        webView.scrollView.bounces = true
        webView.scrollView.isPagingEnabled = true
        webView.isOpaque = false
        webView.navigationDelegate = self
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        return webView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(webPage)
        
        if let htmlPath = Bundle.path(resource: "test", ofType: "html") {
            let hemlContent = html(htmlPath)
            loadHTMLString(hemlContent, baseURL: URL(fileURLWithPath: htmlPath))
        }
    }
    
    func refash(_ model: EPUBSpineItem) {
        
    }
    
    func loadHTMLString(_ htmlContent: String, baseURL: URL) {
        let tempHtmlContent = htmlContent
        webPage.alpha = 0
        webPage.loadHTMLString(tempHtmlContent, baseURL: nil)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        webPage.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: HTML 解析
extension JMReadPageView {
    func html(_ fullHref: String) -> String {
        guard var html = try? String(contentsOfFile: fullHref, encoding: .utf8) else {
            return ""
        }
        
        let ovColor = JMReadConfig.share.mediaOverlayColor
        let mediaOverlayStyleColors = "\"\(ovColor.hexString(false))\", \"\(ovColor.highlightColor().hexString(false))\""
        
        // Inject CSS
        let jsPath = Bundle.path(resource: "Bridge", ofType: "js")
        let cssPath = Bundle.path(resource: "Style", ofType: "css")
        let cssTag = "<link rel=\"stylesheet\" type=\"text/css\" href=\"\(cssPath!)\">"
        let jsTag = "<script type=\"text/javascript\" src=\"\(jsPath!)\"></script>" +
        "<script type=\"text/javascript\">setMediaOverlayStyleColors(\(mediaOverlayStyleColors))</script>"
        
        let toInject = "\n\(cssTag)\n\(jsTag)\n</head>"
        html = html.replacingOccurrences(of: "</head>", with: toInject)
        return html
    }
    
    func testHtml() -> String {
        let contentString = """
                            <img src="https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fphotoblog%2F1402%2F07%2Fc7%2F31066355_31066355_1391779709500_mthumb.jpg&refer=http%3A%2F%2Fimg.pconline.com.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1619837392&t=f872505e7b259e3656cba972db8b9dee">
                            """
        return """
                                <html>
                                <meta charset="utf-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
                                <head>
                                <style type='text/css'>
                                    body {
                                        font-size: 15px;
                                    }
                                </style>
                                </head>
                                <body>
                                <script type='text/javascript'>
                                    window.onload = function () {
                                        var $img = document.getElementsByTagName('img');
                                        for (var p in $img) {
                                            $img[p].style.width = '100%';
                                            $img[p].style.height = 'auto';
                                        }
                                    }
                                </script>
                                <div>
                                \(contentString)
                                </div>
                                </body>
                                </html>
                                """
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
