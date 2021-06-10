//
//  JMBookMaskView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/6/10.
//

import UIKit

class JMBookMaskView: UIView {
    
    func brightness(_ alpha: CGFloat) {
        backgroundColor = UIColor.black.jmComponent(1.0 - alpha)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}
