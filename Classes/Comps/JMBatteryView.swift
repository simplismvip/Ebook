//
//  JMBatteryView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/7.
//

import UIKit
import ZJMKit

class JMBatteryView: JMBaseView {
    private let b_width: CGFloat = 20
    private let b_height: CGFloat = 10
    private let b_lineW: CGFloat = 1
    private var value: CGFloat = 10
    private let b_x: CGFloat = 20
    private let b_y: CGFloat = 5
    private var is12Hour = false
    private let batteryView = UIView(frame: .zero)
    private let batteryLayer = CAShapeLayer()
    private let layerRight = CAShapeLayer()
    
    private let progressLabel = UILabel()
    private let timeLabel = UILabel()
    private let titleLabel = UILabel()
    
    private var timer: Timer?
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
        addSubview(progressLabel)
        addSubview(titleLabel)
        addSubview(timeLabel)
        is12Hour = is12HourFormat()
        
        // 画电池【左边电池】
        let pathLeft = UIBezierPath(roundedRect: CGRect.Rect(b_x, b_y, b_width, b_height), cornerRadius: 2)
        batteryLayer.lineWidth = b_lineW;
        batteryLayer.fillColor = UIColor.clear.cgColor;
        batteryLayer.path = pathLeft.cgPath
        layer.addSublayer(batteryLayer)
        
        // 画电池【右边电池箭头】
        let pathRight = UIBezierPath()
        pathRight.move(to: CGPoint(x: b_x + b_width+1, y: b_y + b_height/3))
        pathRight.addLine(to: CGPoint(x: b_x + b_width+1, y: b_y + b_height * 2/3))
        
        layerRight.lineWidth = 2;
        layerRight.fillColor = UIColor.clear.cgColor;
        layerRight.path = pathRight.cgPath
        layer.addSublayer(layerRight)
        
        // 电池内填充
        batteryView.layer.cornerRadius = 1;
        batteryView.frame = CGRect.Rect(b_x + 1.5,b_y + b_lineW+0.5, 0, b_height - (b_lineW+0.5) * 2);
        
        timeLabel.text = "上午 6:32"
        timeLabel.jmConfigLabel(font: UIFont.jmAvenir(11), color: UIColor.jmRGBValue(0x999999))
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(b_x + b_width + 8)
            make.height.equalTo(11)
            make.centerY.equalTo(snp.centerY)
        }
        
        titleLabel.text = "点击中央屏幕呼出菜单"
        titleLabel.jmConfigLabel(font: UIFont.jmAvenir(11), color: UIColor.jmRGBValue(0x999999))
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.height.equalTo(timeLabel)
        }
        
        progressLabel.text = "16%"
        progressLabel.jmConfigLabel(alig: .right, font: UIFont.jmAvenir(11), color: UIColor.jmRGBValue(0x999999))
        progressLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.height.equalTo(timeLabel)
        }
        
        let value = UIDevice.current.batteryLevel * 100
        self.updateValue(CGFloat(value))
        
        NotificationCenter.default.jm.addObserver(target: self, name: NSNotification.Name.UIDeviceBatteryLevelDidChange.rawValue, object: nil) { [weak self](notify) in
            let value = UIDevice.current.batteryLevel * 100
            self?.updateValue(CGFloat(value))
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self](_) in
            let dateFormat = DateFormatter()
            if self?.is12Hour ?? false {
                dateFormat.amSymbol = "上午"
                dateFormat.pmSymbol = "下午"
                dateFormat.dateFormat = "aaah:mm"
            }else {
                dateFormat.dateFormat = "H:mm"
            }
            dateFormat.calendar = Calendar(identifier: .gregorian)
            self?.timeLabel.text = dateFormat.string(from: Date())
        }
        timer?.tolerance = 0.2
    }
    
    func updateValue(_ value: CGFloat) {
        if value <= 0 { return }
        batteryView.backgroundColor = batteryColor
        
        var rect = batteryView.frame
        rect.size.width = (value * (b_width - (b_lineW+0.5) * 2))/100
        batteryView.frame = rect
    }
    
    public func fireTimer() {
        timer?.invalidate()
        NotificationCenter.default.jm.removeObserver(target: self, NSNotification.Name.UIDeviceBatteryLevelDidChange.rawValue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 判断是否是24小时制
    private func is12HourFormat() -> Bool {
        if let formatStr = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current) {
            let containsA = (formatStr as NSString).range(of: "a")
            return containsA.location != NSNotFound
        }
        return false
    }
}
