//
//  JMMenuLightView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/3/29.
//

import UIKit
import ZJMKit
import RxSwift

final class JMMenuLightView: JMBaseView {
    private let leftBtn = UIButton(type: .system)
    private let rightBtn = UIButton(type: .system)
    private let bkgView = JMReadItemView()
    private let disposeBag = DisposeBag()
    private var slider: UISlider = {
        let slider = UISlider()
        slider.setThumbImage("light-full".image, for: .normal)
        slider.thumbTintColor = .white
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = Float(UIScreen.main.brightness)
        slider.minimumTrackTintColor = UIColor.jmRGB(174, 119, 255)
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.jmRGB(31, 31, 31)
        addSubview(leftBtn)
        addSubview(rightBtn)
        addSubview(slider)
        addSubview(bkgView)
        layoutViews()
        
        leftBtn.setImage("light-null".image, for: .normal)
        rightBtn.setImage("light-full".image, for: .normal)
        leftBtn.tintColor = .white
        rightBtn.tintColor = .white
        bkgView.margin = 30
        bkgView.updateViews(JMJsonParse.parseJson(name: "menu_light_type"))
        
        slider.rx.value.subscribe (onNext:{ (value) in
            UIScreen.main.brightness = CGFloat(value)
        }).disposed(by: disposeBag)
        
        jmRegisterEvent(eventName: kEventNameMenuBrightnessSystem, block: { [weak self](_) in
            UIScreen.main.brightness = 0.5
            self?.slider.value = 0.5
        }, next: false)
        
        jmRegisterEvent(eventName: kEventNameMenuBrightnessCareEye, block: { [weak self](_) in
            UIScreen.main.brightness = 0.3
            self?.slider.value = 0.3
        }, next: false)
    }
    
    /// 获取所有显示的Items
    func allItems() -> [JMReadMenuItem] {
        return bkgView.models
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
        
        bkgView.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.height.equalTo(44)
            make.top.equalTo(leftBtn.snp.bottom).offset(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}
