//
//  JMBatteryView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/7.
//

import UIKit
import ZJMKit

final class JMBatteryView: JMBookBaseView {
    private let b_width: CGFloat = 20
    private let b_height: CGFloat = 10
    private let b_lineW: CGFloat = 1
    private let b_x: CGFloat = 20
    private let b_y: CGFloat = 5
    private var is12Hour = false
    private let batteryView = UIView(frame: .zero)
    private let batteryLayer = CAShapeLayer()
    private let layerRight = CAShapeLayer()
    
    public let title = UILabel()
    public let progress = UILabel()
    private let timeLabel = UILabel()
    private var timer: Timer?
    var batteryColor = UIColor.black {
        willSet {
            batteryView.backgroundColor = newValue
            layerRight.strokeColor = newValue.cgColor
            batteryLayer.strokeColor = newValue.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(batteryView)
        addSubview(progress)
        addSubview(title)
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
        batteryView.frame = CGRect.Rect(b_x + 1.5, b_y + b_lineW + 0.5, 0, b_height - (b_lineW + 0.5) * 2);
        
        timeLabel.jmConfigLabel(font: UIFont.jmAvenir(11), color: UIColor.jmRGBValue(0x999999))
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(b_x + b_width + 8)
            make.height.equalTo(11)
            make.centerY.equalTo(snp.centerY)
        }
        
        title.jmConfigLabel(font: UIFont.jmAvenir(11), color: UIColor.jmRGBValue(0x999999))
        title.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.height.equalTo(timeLabel)
        }
        
        progress.jmConfigLabel(alig: .right, font: UIFont.jmAvenir(11), color: UIColor.jmRGBValue(0x999999))
        progress.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.height.equalTo(timeLabel)
        }
        
        
        updateValue()
        let name = NSNotification.Name.UIDeviceBatteryLevelDidChange.rawValue
        NotificationCenter.default.jm.addObserver(target: self, name: name) { [weak self](_) in
            self?.updateValue()
        }
        
        updateTime()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self](_) in
            self?.updateTime()
        }
        timer?.tolerance = 0.2
    }
    
    public func fireTimer() {
        timer?.invalidate()
        let name = NSNotification.Name.UIDeviceBatteryLevelDidChange.rawValue
        NotificationCenter.default.jm.removeObserver(target: self, name)
    }
    
    private func updateValue() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        var level = UIDevice.current.batteryLevel
        if level < 0 { level = 1.0 }
        var rect = batteryView.frame
        rect.size.width = (CGFloat(level * 100.0) * (b_width - (b_lineW + 0.5) * 2))/100
        batteryView.frame = rect
    }
    
    private func updateTime() {
        let dateFormat = DateFormatter()
        if is12Hour {
            dateFormat.amSymbol = "上午"
            dateFormat.pmSymbol = "下午"
            dateFormat.dateFormat = "aaah:mm"
        }else {
            dateFormat.dateFormat = "H:mm"
        }
        dateFormat.calendar = Calendar(identifier: .gregorian)
        timeLabel.text = dateFormat.string(from: Date())
    }
    
    // 判断是否是24小时制
    private func is12HourFormat() -> Bool {
        if let formatStr = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current) {
            let containsA = (formatStr as NSString).range(of: "a")
            return containsA.location != NSNotFound
        }
        return false
    }
    
    override func changeBkgColor(config: JMBookConfig) {
        batteryColor = config.textColor()
        title.textColor = config.textColor()
        timeLabel.textColor = config.textColor()
        progress.textColor = config.textColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
