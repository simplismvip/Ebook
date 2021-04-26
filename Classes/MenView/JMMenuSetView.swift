//
//  JMMenuSetView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/3/29.
//

import UIKit
import ZJMKit
import SnapKit

final class JMMenuSetView: JMBaseView {
    let fontSize = FontSizeView()
    let pageFlip = PageFlipView()
    let fontType = FontTypeView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(fontSize)
        addSubview(pageFlip)
        addSubview(fontType)
        backgroundColor = UIColor.menuBkg
        
        pageFlip.snp.makeConstraints({ (make) in
            make.width.equalTo(self)
            make.top.equalTo(self.snp.top).offset(8)
            make.height.equalTo(64)
        })
        
        fontSize.snp.makeConstraints({ (make) in
            make.width.equalTo(self)
            make.top.equalTo(pageFlip.snp.bottom)
            make.height.equalTo(64)
        })
        
        fontType.snp.makeConstraints({ (make) in
            make.top.equalTo(fontSize.snp.bottom)
            make.width.equalTo(self)
            make.height.equalTo(64)
        })
    }
    
    /// 获取所有显示的Items
    func allItems() -> [JMReadMenuItem] {
        return [pageFlip.bkgView.models, fontType.bkgView.models].flatMap { $0 }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}

// MARK: -- 背景设置 --
final class BkgColorView: JMBaseView {
    private let name = UILabel()
    internal let bkgView = JMReadItemView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.menuBkg
        name.text = "阅读背景"
        name.jmConfigLabel(alig: .center, font: UIFont.jmAvenir(14), color: UIColor.menuTextColor)
        name.translatesAutoresizingMaskIntoConstraints = false
        bkgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(name)
        addSubview(bkgView)
        
        name.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(64)
            make.height.equalTo(44)
            make.centerY.equalTo(snp.centerY)
        }
        
        bkgView.snp.makeConstraints { (make) in
            make.left.equalTo(name.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(44)
            make.centerY.equalTo(snp.centerY)
        }
        bkgView.margin = 10
        bkgView.updateViews(JMJsonParse.parseJson(name: "menu_bkgcolor"))
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}

// MARK: -- 字体大小 --
final class FontSizeView: JMBaseView {
    private var name = UILabel()
    private var slider: UISlider = {
        let slider = UISlider()
        slider.setThumbImage("green-marker".image, for: .normal)
        slider.minimumValue = 10
        slider.maximumValue = 30
        slider.minimumTrackTintColor = UIColor.jmRGB(174, 119, 255)
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.menuBkg
        addSubview(name)
        
        addSubview(slider)
        name.jmConfigLabel(alig: .center, font: UIFont.jmAvenir(14), color: UIColor.menuTextColor)
        name.text = "字体大小"
        layoutViews()
        
        slider.addTarget(self, action: #selector(touchSliderEnd(_:)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(touchSliderStart(_:)), for: .valueChanged)
    }
    
    @objc func touchSliderStart(_ slider: UISlider) {
        jmRouterEvent(eventName: kEventNameMenuSliderValueChange, info:  CGFloat(slider.value) as MsgObjc)
    }
    
    @objc func touchSliderEnd(_ slider: UISlider) {
        let value = CGFloat(slider.value)
        jmRouterEvent(eventName: kEventNameMenuFontSizeSlider, info: value as MsgObjc)
    }
    
    /// 设置字体大小
    public func updateFontValue(value: Float) {
        slider.value = value
    }
    
    func layoutViews() {
        name.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.height.equalTo(44)
            make.width.equalTo(64)
            make.centerY.equalTo(snp.centerY)
        }
        
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(name.snp.right).offset(20)
            make.right.equalTo(snp.right).offset(-10)
            make.height.equalTo(44)
            make.centerY.equalTo(snp.centerY)
        }
    }
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}

// MARK: -- 翻页模式 --
final class PageFlipView: JMBaseView {
    private let name = UILabel()
    internal let bkgView = JMReadItemView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.menuBkg
        name.text = "翻页设置"
        name.jmConfigLabel(alig: .center, font: UIFont.jmAvenir(14), color: UIColor.menuTextColor)
        name.translatesAutoresizingMaskIntoConstraints = false
        bkgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(name)
        addSubview(bkgView)

        name.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(64)
            make.height.equalTo(44)
            make.centerY.equalTo(snp.centerY)
        }
        
        bkgView.snp.makeConstraints { (make) in
            make.left.equalTo(name.snp.right).offset(10)
            make.width.equalTo(260)
            make.height.equalTo(44)
            make.centerY.equalTo(snp.centerY)
        }
        bkgView.margin = 10
        bkgView.updateViews(JMJsonParse.parseJson(name: "menu_flip_type"))
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}

// MARK: -- 字体类型 --
final class FontTypeView: JMBaseView {
    private var name = UILabel()
    internal let bkgView = JMReadItemView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.menuBkg
        name.text = "字体设置"
        name.jmConfigLabel(alig: .center, font: UIFont.jmAvenir(14), color: UIColor.menuTextColor)
        name.translatesAutoresizingMaskIntoConstraints = false
        bkgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(name)
        addSubview(bkgView)
        
        name.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(64)
            make.height.equalTo(44)
            make.top.equalTo(self).offset(10)
        }
        
        bkgView.snp.makeConstraints { (make) in
            make.left.equalTo(name.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(44)
            make.top.equalTo(name)
        }
        bkgView.margin = 10
        bkgView.updateViews(JMJsonParse.parseJson(name: "menu_font_type"))
    }

    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}
