//
//  JMMenuLightView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/3/29.
//

import UIKit
import SnapKit

final class JMMenuLightView: JMBookBaseView {
    private let leftBtn = UIButton(type: .system)
    private let rightBtn = UIButton(type: .system)
    private let bkgView = JMMenuItemView()
    private let bkgColor = JMMenuItemView()
    private var slider: UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = .white
        slider.minimumValue = 0
        slider.maximumValue = 1
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(leftBtn)
        addSubview(rightBtn)
        addSubview(slider)
        addSubview(bkgView)
        addSubview(bkgColor)
        layoutViews()
        
        slider.value = Float(JMBookCache.config().brightness())
        leftBtn.setImage("epub_light-null".image, for: .normal)
        rightBtn.setImage("epub_light-full".image, for: .normal)
        
        bkgView.margin = 50
        bkgView.updateViews(JMMenuItem.lights)
        bkgColor.margin = 0
        bkgColor.updateViews(JMMenuItem.bkgs)
        
        slider.addTarget(self, action: #selector(startSlider(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(startSliderEnd(_:)), for: .touchUpInside)
        
        jmRegisterEvent(eventName: kEventNameMenuBrightnessSystem, block: { [weak self](_) in
            self?.slider.value = 1.0
            JMBookCache.config().config.brightness = 1.0
            JMLogger.debug("++++++++ 1.0")
        }, next: true)
        
        jmRegisterEvent(eventName: kEventNameMenuBrightnessCareEye, block: { [weak self](_) in
            self?.slider.value = 0.7
            JMBookCache.config().config.brightness = 0.7
            JMLogger.debug("++++++++ 0.7")
        }, next: true)
    }
    
    @objc func startSlider(_ slider: UISlider) {
        let brightness = CGFloat(slider.value)
        JMBookCache.config().config.brightness = brightness
        JMLogger.debug("++++++++ \(brightness)")
        jmRouterEvent(eventName: kEventNameMenuActionBrightSliderValue, info: brightness as MsgObjc)
    }
    
    @objc func startSliderEnd(_ slider: UISlider) {
        jmRouterEvent(eventName: kEventNameMenuActionBrightSliderEnd, info: nil)
    }
    
    /// 获取所有显示的Items
    func allItems() -> [JMMenuItem] {
        return [bkgColor.models, bkgView.models].flatMap { $0 }
    }
    
    func layoutViews() {        
        leftBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(8)
        }
        
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-10)
            make.width.height.equalTo(leftBtn)
            make.top.equalTo(leftBtn)
        }
        
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(64)
            make.right.equalTo(snp.right).offset(-64)
            make.height.equalTo(34)
            make.centerY.equalTo(rightBtn.snp.centerY)
        }
        
        bkgColor.snp.makeConstraints { (make) in
            make.left.equalTo(leftBtn.snp.left)
            make.right.equalTo(rightBtn.snp.right)
            make.height.equalTo(44)
            make.top.equalTo(leftBtn.snp.bottom).offset(10)
        }
        
        bkgView.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.height.equalTo(34)
            make.top.equalTo(bkgColor.snp.bottom).offset(20)
        }
    }

    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}
