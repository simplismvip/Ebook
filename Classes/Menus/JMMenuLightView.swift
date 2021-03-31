//
//  JMMenuLightView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/3/29.
//

import UIKit
import ZJMKit

final class JMMenuLightView: JMBaseView {
    private let left = UIButton(type: .system)
    private let right = UIButton(type: .system)
    private let bkgView = JMReadItemView()
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
        addSubview(left)
        addSubview(right)
        addSubview(slider)
        addSubview(bkgView)
        backgroundColor = UIColor.jmRGB(31, 31, 31)
        
        left.setImage("light-null".image, for: .normal)
        right.setImage("light-full".image, for: .normal)
        left.tintColor = .white
        right.tintColor = .white
        
        layoutViews()
        slider.addTarget(self, action: #selector(startScroll(_:)), for: .touchUpInside)
        
        bkgView.updateViews(JMJsonParse.parseJson(name: "menu_light_type"))
    }
    
    @objc func startScroll(_ slider: UISlider) {
       
    }
    
    func layoutViews() {
        left.translatesAutoresizingMaskIntoConstraints = false
        right.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        bkgView.translatesAutoresizingMaskIntoConstraints = false
        
        left.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.width.height.equalTo(44)
            make.top.equalTo(self).offset(8)
        }
        
        right.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.width.height.equalTo(left)
            make.top.equalTo(left)
        }
        
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(left.snp.right).offset(10)
            make.right.equalTo(right.snp.left).offset(-10)
            make.height.equalTo(34)
            make.centerY.equalTo(left.snp.centerY)
        }
        
        bkgView.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(34)
            make.top.equalTo(left.snp.bottom).offset(8)
            make.centerX.equalTo(snp.centerX)
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}
