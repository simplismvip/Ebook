//
//  JMTextMagnifierView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/2.
//

import UIKit

final class JMTextMagnifierView: JMBookBaseView {
    var pageView: JMPageView?
    var startPoint: CGPoint? {
        willSet {
            if let value = newValue {
                self.center = CGPoint(x: value.x, y: value.y - 70)
                self.setNeedsDisplay()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 40;
        self.layer.masksToBounds = true;
    }
    
    override func draw(_ rect: CGRect) {
        if let ctx = UIGraphicsGetCurrentContext(), let rendView = pageView, let point = startPoint {
            ctx.translateBy(x: frame.size.width*0.5,y: frame.size.height*0.5)
            ctx.scaleBy(x: 1.5, y: 1.5);
            ctx.translateBy(x: -1 * (point.x), y: -1 * (point.y));
            rendView.layer.render(in: ctx)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
