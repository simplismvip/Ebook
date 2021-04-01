//
//  JMHtmlParse.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/1.
//

import UIKit

class JMHtmlParse: NSObject {
    static func html(_ fullHref: String) -> String {
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
}
