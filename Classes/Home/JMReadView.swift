//
//  JMReadView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/7.
//

import UIKit
import ZJMKit
import YYText

class JMReadView: JMBaseView {
    let contentL = YYLabel()
    let magnifier = JMTextMagnifierView(frame: CGRect.Rect(0, 0, 80, 80))
    let selectView = YYTextSelectionView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        magnifier.pageView = self
        magnifier.isHidden = true
        addSubview(magnifier)
        addSubview(contentL)
        addSubview(selectView)
        contentL.isUserInteractionEnabled = true
        contentL.numberOfLines = 0;
        contentL.displaysAsynchronously = true
        contentL.textVerticalAlignment = .top;
        contentL.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        selectView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentL)
        }
        
        contentL.highlightTapAction = { view, text, range, rect in
            print(text.string)
        }
    }
    
    /// 将文本画到View上
    func reDrewText(content: NSAttributedString?) {
        if let content = content {
            contentL.attributedText = content
        }
    }
    
    /// 刷新文字样式
    func refreshText(range: NSRange) {
        if let attri = contentL.attributedText {
            let mutabAttri = NSMutableAttributedString(attributedString: attri)
            mutabAttri.yy_setStroke(UIColor.menuSelColor, range: range)
            contentL.attributedText = mutabAttri
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JMReadView: UIGestureRecognizerDelegate {
    
}
