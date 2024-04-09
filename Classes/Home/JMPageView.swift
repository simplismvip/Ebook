//
//  JMReadView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/7.
//

import UIKit
import YYText

class JMPageView: JMBookBaseView {
    let contentL = YYLabel()
    let gadView = UIView()
    let comment = UIButton(type: .system)
    let reward = UIButton(type: .system)
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(contentL)
        addSubview(gadView)
        gadView.addSubview(comment)
        gadView.addSubview(reward)
//        gadView.backgroundColor = UIColor.jmRandColor
        
        contentL.isUserInteractionEnabled = true
        contentL.numberOfLines = 0;
        contentL.displaysAsynchronously = true
        contentL.textVerticalAlignment = .top;
        contentL.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        contentL.highlightTapAction = { view, text, range, rect in
            Logger.debug(text.string)
        }
        
        comment.titleLabel?.font = UIFont.jmRegular(14)
        comment.layer.cornerRadius = 15
        comment.layer.borderWidth = 1
        comment.layer.borderColor = UIColor.gray.cgColor
        comment.setTitle("写评论", for: .normal)
        comment.setTitleColor(UIColor.black, for: .normal)
        
        reward.titleLabel?.font = UIFont.jmRegular(14)
        reward.layer.cornerRadius = 15
        reward.layer.borderWidth = 1
        reward.layer.borderColor = UIColor.gray.cgColor
        reward.setTitle("打赏TA", for: .normal)
        reward.setTitleColor(UIColor.black, for: .normal)
        
        comment.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(32)
            make.centerY.equalTo(gadView.snp.centerY)
            make.centerX.equalTo(gadView.snp.centerX).offset(-50)
        }
        
        reward.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(32)
            make.centerY.equalTo(gadView.snp.centerY)
            make.centerX.equalTo(gadView.snp.centerX).offset(50)
        }
        
        comment.jmAddAction { [weak self] _ in
            self?.jmRouterEvent(eventName: kMsgNameCommentBook, info: nil)
        }
        
        reward.jmAddAction { [weak self] _ in
            self?.jmRouterEvent(eventName: kMsgNameRewardBook, info: nil)
        }
    }
    
    /// 将文本画到View上
    func reDrewText(content: NSAttributedString?) {
        contentL.attributedText = content
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let textsize = contentL.textLayout?.textBoundingSize {
            let maxY = textsize.height + 20
            let maxH = self.bounds.size.height - maxY - 50
            if maxH > 64 {
                gadView.isHidden = false
                gadView.frame = CGRect.Rect(0, maxY, self.bounds.size.width, maxH)
            } else {
                gadView.isHidden = true
            }
        } else {
            gadView.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JMPageView: UIGestureRecognizerDelegate {
    
}
