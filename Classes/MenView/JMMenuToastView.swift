//
//  JMMenuToastView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/20.
//

import UIKit
import ZJMKit

final class JMMenuToastView: JMBookBaseView {
    private let name = UILabel()
    private let bkgView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bkgView.backgroundColor = UIColor.black.jmComponent(0.5)
        bkgView.layer.cornerRadius = 8
        bkgView.layer.masksToBounds = true
        addSubview(bkgView)
        
        name.jmConfigLabel(alig: .center, font: UIFont.jmRegular(17), color: UIColor.white)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateToast(_ text: String) {
        name.text = text
    }
    
    func remove() {
        delay(1) { [weak self] in
            self?.isHidden = true
        }
    }
}
