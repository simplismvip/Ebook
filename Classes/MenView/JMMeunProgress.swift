//
//  JMMeunProgress.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/20.
//

import UIKit
import ZJMKit

class JMMeunProgress: JMBookBaseView {
    private let leftBtn = UIButton(type: .system)
    private let rightBtn = UIButton(type: .system)
    private var slider: UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = .white
        slider.minimumValue = 0
        slider.minimumTrackTintColor = UIColor.jmRGB(174, 119, 255)
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(leftBtn)
        addSubview(rightBtn)
        addSubview(slider)
        leftBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(20)
        }
        
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-20)
            make.width.height.equalTo(leftBtn)
            make.top.equalTo(leftBtn)
        }
        
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(64)
            make.right.equalTo(snp.right).offset(-64)
            make.height.equalTo(34)
            make.centerY.equalTo(rightBtn.snp.centerY)
        }
        
        leftBtn.setImage("book_progress_left".image, for: .normal)
        rightBtn.setImage("book_progress_right".image, for: .normal)
        slider.addTarget(self, action: #selector(touchSliderStart(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(touchSliderEnd(_:)), for: .touchUpInside)
        
        leftBtn.jmAddAction { [weak self](_) in
            self?.jmRouterEvent(eventName: kEventNameMenuActionPrevCharpter, info: nil)
        }
        
        rightBtn.jmAddAction { [weak self](_) in
            self?.jmRouterEvent(eventName: kEventNameMenuActionNextCharpter, info: nil)
        }
    }
    
    @objc func touchSliderStart(_ slider: UISlider) {
        let value = Int(slider.value)
        jmRouterEvent(eventName: kEventNameMenuSliderValueChange, info: ("转跳到第\(value+1)页") as MsgObjc)
    }
    
    @objc func touchSliderEnd(_ slider: UISlider) {
        let value = Int(slider.value)
        jmRouterEvent(eventName: kEventNameMenuActionTargetCharpter, info: value as MsgObjc)
    }
    
    /// 设置当前值
    public func setSlider(max: Float, curr: Float) {
        if slider.value != curr {
            slider.value = curr
        }
        
        if slider.maximumValue != max {
            slider.maximumValue = max
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}
