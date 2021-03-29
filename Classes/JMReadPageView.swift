//
//  JMReadPageView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/1.
//

import UIKit
import ZJMKit
import EPUBKit

public class JMReadPageView: JMBaseCollectionCell {
    
    lazy var webPage: JMWebPage = {
        let webView = JMWebPage(frame: .zero, config: JMReadConfig())
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.backgroundColor = .clear
        return webView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.green
        contentView.addSubview(webPage)
        webPage.snp.makeConstraints({ $0.edges.equalTo(contentView) })
        if #available(iOS 11.0, *) { webPage.scrollView.contentInsetAdjustmentBehavior = .never }
    }
    
    func refash(_ model: EPUBSpineItem) {
        
    }
    
    func loadHTMLString(_ htmlContent: String, baseURL: URL) {
        let tempHtmlContent = htmlContent
        webPage.alpha = 0
        webPage.loadHTMLString(tempHtmlContent, baseURL: baseURL)
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
        let jsPath = Bundle.path(resource: "Bridge", type: "js")
        let cssPath = Bundle.path(resource: "Style", type: "css")
        let cssTag = "<link rel=\"stylesheet\" type=\"text/css\" href=\"\(cssPath!)\">"
        let jsTag = "<script type=\"text/javascript\" src=\"\(jsPath!)\"></script>" +
        "<script type=\"text/javascript\">setMediaOverlayStyleColors(\(mediaOverlayStyleColors))</script>"
        
        let toInject = "\n\(cssTag)\n\(jsTag)\n</head>"
        html = html.replacingOccurrences(of: "</head>", with: toInject)
        return html
    }
}
