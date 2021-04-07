//
//  JMBatteryView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/7.
//

import UIKit
import ZJMKit

class JMBatteryView: JMBaseView {
    
    private var b_width: CGFloat = 10
    private var b_height: CGFloat = 10
    private var b_lineW: CGFloat = 10
    private var value: CGFloat = 10
    private let batteryView = UIView(frame: .zero)
    private let batteryLayer = CAShapeLayer()
    private let layerRight = CAShapeLayer()
    
    var batteryColor = UIColor.black {
        willSet {
            batteryView.backgroundColor = newValue
            layerRight.strokeColor = newValue.cgColor
            batteryLayer.strokeColor = newValue.cgColor
            updateValue(self.value)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(batteryView)
        
        ///x坐标
        let b_x: CGFloat = 1
        ///y坐标
        let b_y: CGFloat = 1
        
        b_height = bounds.size.height - 2;
        b_width = bounds.size.width - 5;
        b_lineW = 1;
        
        // 画电池【左边电池】
        let pathLeft = UIBezierPath(roundedRect: CGRect.Rect(b_x, b_y, b_width, b_height), cornerRadius: 2)
        batteryLayer.lineWidth = b_lineW;
        batteryLayer.fillColor = UIColor.clear.cgColor;
        batteryLayer.path = pathLeft.cgPath
        layer.addSublayer(batteryLayer)
        
        //画电池【右边电池箭头】
        let pathRight = UIBezierPath()
        pathRight.move(to: CGPoint(x: b_x + b_width+1, y: b_y + b_height/3))
        pathRight.addLine(to: CGPoint(x: b_x + b_width+1, y: b_y + b_height * 2/3))
        
        layerRight.lineWidth = 2;
        layerRight.fillColor = UIColor.clear.cgColor;
        layerRight.path = pathRight.cgPath
        layer.addSublayer(layerRight)
        
        ///电池内填充
        batteryView.frame = CGRect.Rect(b_x + 1.5,b_y + b_lineW+0.5, 0, b_height - (b_lineW+0.5) * 2);
        batteryView.layer.cornerRadius = 1;
    }
    
    func updateValue(_ value: CGFloat) {
        if value <= 0 { return }
        batteryView.backgroundColor = batteryColor
        
        var rect = batteryView.frame
        rect.size.width = (value * (b_width - (b_lineW+0.5) * 2))/100
        batteryView.frame = rect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
