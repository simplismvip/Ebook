//
//  JMMenuLightView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/3/29.
//

import UIKit
import ZJMKit

final class JMMenuLightView: JMBaseView {
    private let leftBtn = UIButton(type: .system)
    private let rightBtn = UIButton(type: .system)
    private let bkgView = JMReadItemView()
    private let bkgColor = JMReadItemView()
    private var slider: UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = .white
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = Float(UIScreen.main.brightness)
        slider.minimumTrackTintColor = UIColor.jmRGB(174, 119, 255)
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.menuBkg
        addSubview(leftBtn)
        addSubview(rightBtn)
        addSubview(slider)
        addSubview(bkgView)
        addSubview(bkgColor)
        layoutViews()
        
        leftBtn.setImage("epub_light-null".image, for: .normal)
        rightBtn.setImage("epub_light-full".image, for: .normal)
        leftBtn.tintColor = UIColor.menuTintColor
        rightBtn.tintColor = UIColor.menuTintColor
        
        bkgView.margin = 50
        bkgView.updateViews(JMJsonParse.parseJson(name: "menu_light_type"))
        bkgColor.margin = 0
        bkgColor.updateViews(JMJsonParse.parseJson(name: "menu_bkgcolor"))
        
        slider.addTarget(self, action: #selector(startSlider(_:)), for: .touchUpInside)
        
        jmRegisterEvent(eventName: kEventNameMenuBrightnessSystem, block: { [weak self](_) in
            UIScreen.main.brightness = 0.5
            self?.slider.value = 0.5
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuBrightnessCareEye, block: { [weak self](_) in
            UIScreen.main.brightness = 0.3
            self?.slider.value = 0.3
        }, next: false)
    }
    
    @objc func startSlider(_ slider: UISlider) {
        UIScreen.main.brightness = CGFloat(slider.value)
    }
    
    /// 获取所有显示的Items
    func allItems() -> [JMReadMenuItem] {
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
