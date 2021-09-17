//
//  JMReadView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/7.
//

import UIKit
import ZJMKit
import YYText

class JMPageView: JMBookBaseView {
    let contentL = YYLabel()
    let gadView = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(contentL)
        addSubview(gadView)
        gadView.backgroundColor = UIColor.jmRandColor
        
        contentL.isUserInteractionEnabled = true
        contentL.numberOfLines = 0;
        contentL.displaysAsynchronously = false
        contentL.textVerticalAlignment = .top;
        contentL.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        contentL.highlightTapAction = { view, text, range, rect in
            Logger.debug(text.string)
        }
    }
    
    /// 将文本画到View上
    func reDrewText(content: NSAttributedString?) {
        if let content = content {
            contentL.attributedText = content
            if let textsize = contentL.textLayout?.textBoundingSize {
                let maxY = textsize.height + 20
                let maxH = jmHeight - maxY - 50
                if maxH > 64 {
                    gadView.isHidden = false
                    gadView.frame = CGRect.Rect(0, maxY, jmWidth, maxH)
                } else {
                    gadView.isHidden = true
                }
            } else {
                gadView.isHidden = true
            }
        }
    }
    
    /// 刷新文字样式
    func refreshText(range: NSRange) {
//        let range = YYTextRange(range: range)
//        if let attri = contentL.attributedText {
//            let mutabAttri = NSMutableAttributedString(attributedString: attri)
//            mutabAttri.yy_setStroke(UIColor.menuSelColor, range: range)
//            contentL.attributedText = mutabAttri
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JMPageView: UIGestureRecognizerDelegate {
    
}
