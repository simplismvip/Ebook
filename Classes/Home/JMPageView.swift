//
//  JMReadView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/7.
//

import UIKit
import SnapKit

class JMPageView: JMBookBaseView {
    let contentL = UITextView()
    let gadView = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(contentL)
        addSubview(gadView)
        
        contentL.isEditable = false
        contentL.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    /// 将文本画到View上
    func reDrewText(content: NSAttributedString?) {
        contentL.attributedText = content
    }
    
    /// 刷新文字样式
    func refreshText(range: NSRange) {
        contentL.selectedRange = range
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JMPageView: UIGestureRecognizerDelegate {
    
}
