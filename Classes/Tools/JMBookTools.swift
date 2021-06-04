//
//  JMBookTools.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/22.
//

import Foundation

class JMBookTools {
    private let hightLabel = UILabel()
    private var contSize = Dictionary<String, CGSize>()
    private let width = UIScreen.main.bounds.size.width
    public static let share: JMBookTools = {
        let util = JMBookTools()
        util.hightLabel.numberOfLines = 0
        return util
    }()
    
    public func contentSize(text: String, textID: String, maxW: CGFloat, font: UIFont) -> CGSize {
        if let size = contSize[textID] {
            return size
        }else {
            hightLabel.font = font
            hightLabel.text = text
            let maxSize = CGSize(width: maxW, height: CGFloat.greatestFiniteMagnitude)
            let size = hightLabel.sizeThatFits(maxSize)
            contSize[textID] = size
            return size
        }
    }
    
    public static func contentHight(text: String, textID: String, maxW: CGFloat, font: UIFont) -> CGFloat {
        JMBookTools.share.contentSize(text: text, textID: textID, maxW: maxW, font: font).height
    }
}
    
