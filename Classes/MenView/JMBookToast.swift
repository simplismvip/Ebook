//
//  JMMenuToastView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/20.
//

import UIKit
import ZJMKit

final public class JMBookToast: JMBaseView {
    public static let share: JMBookToast = { return JMBookToast() }()
    private let name = UILabel()
    private let bkgView = UIView()
    private var isUpdate = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bkgView.layer.cornerRadius = 8
        bkgView.layer.masksToBounds = true
        addSubview(bkgView)
        
        name.font = UIFont.jmRegular(17)
        name.textAlignment = .center
        addSubview(name)
        name.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY)
        }
        
        bkgView.snp.makeConstraints { (make) in
            make.left.equalTo(name.snp.left).offset(-20)
            make.right.equalTo(name.snp.right).offset(20)
            make.height.equalTo(44)
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY)
        }
    }
    
    public static func toast(_ text: String) {
        JMBookToast.share.name.text = text
        if !JMBookToast.share.isUpdate, let view = UIApplication.shared.keyWindow {
            let config = JMBookCache.config()
            if config.bkgColor == .BkgWhite {
                JMBookToast.share.name.textColor = UIColor.lightGray
                JMBookToast.share.bkgView.backgroundColor = UIColor.black.jmComponent(0.8)
            } else {
                JMBookToast.share.name.textColor = UIColor.darkText
                JMBookToast.share.bkgView.backgroundColor = UIColor.menuBkg.jmComponent(0.8)
            }
            
            JMBookToast.share.isUpdate = true
            view.addSubview(JMBookToast.share)
            JMBookToast.share.snp.makeConstraints { (make) in
                make.width.equalTo(260)
                make.height.equalTo(54)
                make.centerX.equalTo(view.snp.centerX)
                make.centerY.equalTo(view.snp.centerY)
            }
        }
    }
    
    public static func toast(_ text: String, delay: Double) {
        toast(text)
        let deadLine = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: deadLine) {
            self.hide()
        }
    }
    
    public static func hide() {
        JMBookToast.share.isUpdate = false
        JMBookToast.share.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
