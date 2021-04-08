//
//  JMReadView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/7.
//

import UIKit
import ZJMKit

class JMReadView: JMBaseView {

    let magnifier = JMTextMagnifierView(frame: CGRect.Rect(0, 0, 80, 80))
    var pageItem: JMCoreTextData? {
        willSet {
            setNeedsDisplay()
        }
    }
        
    public override init(frame: CGRect) {
        super.init(frame: frame)
        magnifier.pageView = self
        addSubview(magnifier)
    }
    
    public override func draw(_ rect: CGRect) {
        if let ctx = UIGraphicsGetCurrentContext() {
            let frameSetter = CTFramesetterCreateWithAttributedString(pageItem!.attributeString!)
            ctx.textMatrix = .identity
            ctx.translateBy(x: 0, y: bounds.size.height);
            ctx.scaleBy(x: 1.0, y: -1.0);
            let pathRef = CGPath(rect: bounds, transform: nil);
            let frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), pathRef, nil);
            CTFrameDraw(frameRef, ctx);
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension JMReadView: UIGestureRecognizerDelegate {
    
}
