//
//  JMBookMaskView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/6/10.
//

import UIKit

class JMBookMaskView: UIView {
    
    func brightness(_ alpha: CGFloat) {
        JMBookCache.config().config.brightness = alpha
        backgroundColor = UIColor.black.jmComponent(1.0 - alpha)
        Logger.debug("\(alpha)---\(JMBookCache.config().config.brightness)")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}
