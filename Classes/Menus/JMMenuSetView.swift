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
    let bkgColor = BkgColorView()
    let fontSize = FontSizeView()
    let pageFlip = PageFlipView()
    let fontType = FontTypeView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bkgColor)
        addSubview(fontSize)
        addSubview(pageFlip)
        addSubview(fontType)
    }
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}

// MARK: -- 背景设置 --
final class BkgColorView: JMBaseView {
    private let name = UILabel()
    private let bkgView = JMReadItemView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.jmRGB(31, 31, 31)
        name.text = "阅读背景"
        name.jmConfigLabel(alig: .center, font: UIFont.jmAvenir(14), color: .gray)
        name.translatesAutoresizingMaskIntoConstraints = false
        bkgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(name)
        addSubview(bkgView)
        
        name.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(64)
            make.height.equalTo(34)
            make.centerY.equalTo(snp.centerY)
        }
        
        bkgView.snp.makeConstraints { (make) in
            make.left.equalTo(name.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(34)
            make.centerY.equalTo(snp.centerY)
        }
    }
    
    func updateDataSource(callBlock:@escaping (JMReadMenuItem)->Void) {
//        let items = FRDataManager.share[.SET_BkgColor]
//        let width = 64
//        let count = items.count
//        let margin = (UIScreen.main.bounds.size.width - 84 - CGFloat(width * count)) / CGFloat(count+1)
//        bkgView.updateViews(items: items, margin:margin) { callBlock($0) }
    }
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}

// MARK: -- 字体大小 --
final class FontSizeView: JMBaseView {
    private var name = UILabel()
    private var nameSize = UILabel()
    private var callBack:((JMReadMenuItem)->Void)?
    private var model:JMReadMenuItem?
    private var slider:UISlider = {
        let slider = UISlider()
        slider.setThumbImage("green-marker".image, for: .normal)
        slider.minimumTrackTintColor = UIColor.jmRGB(174, 119, 255)
        slider.minimumValue = 10
        slider.minimumValue = 30
        slider.value = 20
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.jmRGB(31, 31, 31)
        addSubview(name)
        addSubview(nameSize)
        addSubview(slider)
        name.jmConfigLabel(alig: .center, font: UIFont.jmAvenir(14), color: .gray)
        nameSize.jmConfigLabel(alig: .center, font: UIFont.jmAvenir(14), color: .gray)
        name.text = "字体大小"
        nameSize.text = "13"
        layoutViews()
        slider.addTarget(self, action: #selector(startScroll(_:)), for: .touchUpInside)
    }
    
    func layoutViews() {
        name.translatesAutoresizingMaskIntoConstraints = false
        nameSize.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        name.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.height.equalTo(34)
            make.width.equalTo(64)
            make.centerY.equalTo(snp.centerY)
        }
        
        nameSize.snp.makeConstraints { (make) in
            make.height.equalTo(34)
            make.centerY.equalTo(snp.centerY)
            make.left.equalTo(name.snp.right).offset(10)
        }
        
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(nameSize.snp.right).offset(20)
            make.right.equalTo(snp.right).offset(-10)
            make.height.equalTo(34)
            make.centerY.equalTo(snp.centerY)
        }
    }
    
    @objc func startScroll(_ slider:UISlider) {
        nameSize.text = String(format: "%.0f", slider.value)
        if let mo = model { callBack?(mo) }
    }
    
    func updateDataSource(callBlock:@escaping (JMReadMenuItem)->Void) {
//        guard let mo = FRDataManager.share[.SET_Flip].first,let value = mo.value else { return }
//        model = mo
//        slider.value = value
//        callBack = callBlock
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}

// MARK: -- 翻页模式 --
final class PageFlipView: JMBaseView {
    private let name = UILabel()
    private let bkgView = JMReadItemView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.jmRGB(31, 31, 31)
        name.text = "翻页设置"
        name.jmConfigLabel(alig: .center, font: UIFont.jmAvenir(14), color: .gray)
        name.translatesAutoresizingMaskIntoConstraints = false
        bkgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(name)
        addSubview(bkgView)

        name.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(64)
            make.height.equalTo(34)
            make.centerY.equalTo(snp.centerY)
        }
        
        bkgView.snp.makeConstraints { (make) in
            make.left.equalTo(name.snp.right).offset(10)
            make.width.equalTo(192)
            make.height.equalTo(34)
            make.centerY.equalTo(snp.centerY)
        }
    }

    func updateDataSource(callBlock:@escaping (JMReadMenuItem)->Void) {
//        bkgView.updateViews(items: FRDataManager.share[.SET_Flip], margin:0) { callBlock($0) }
    }
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}

// MARK: -- 字体类型 --
final class FontTypeView: JMBaseView {
    private var name = UILabel()
    private let bkgView = JMReadItemView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.jmRGB(31, 31, 31)
        name.text = "字体设置"
        name.jmConfigLabel(alig: .center, font: UIFont.jmAvenir(14), color: .gray)
        name.translatesAutoresizingMaskIntoConstraints = false
        bkgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(name)
        addSubview(bkgView)
        
        name.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(64)
            make.height.equalTo(34)
            make.top.equalTo(self).offset(10)
        }
        
        bkgView.snp.makeConstraints { (make) in
            make.left.equalTo(name.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(34)
            make.top.equalTo(name)
        }
    }

    func updateDataSource(callBlock:@escaping (JMReadMenuItem)->Void) {
//        bkgView.updateViews(items: FRDataManager.share[.SET_FontType], margin:0) { callBlock($0) }
    }
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }
}
