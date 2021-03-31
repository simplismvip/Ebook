//
//  JMMeunPlayVIew.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/3/31.
//

import UIKit
import ZJMKit

final class JMMeunPlayVIew: JMBaseView {
    private let playControl = JMReadItemView()
    private let rateName = UILabel()
    private let playRate = JMReadItemView()
    private let styleName = UILabel()
    private let playStyle = JMReadItemView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.jmRGB(31, 31, 31)
        addSubview(playControl)
        addSubview(rateName)
        addSubview(playRate)
        addSubview(styleName)
        addSubview(playStyle)
        
        rateName.jmConfigLabel(alig: .center, font: UIFont.jmAvenir(14), color: .gray)
        styleName.jmConfigLabel(alig: .center, font: UIFont.jmAvenir(14), color: .gray)
        rateName.text = "阅读速率"
        styleName.text = "听书风格"

        setupSubViews()
        loadDatas()
    }

    func setupSubViews() {
        playControl.translatesAutoresizingMaskIntoConstraints = false
        rateName.translatesAutoresizingMaskIntoConstraints = false
        playRate.translatesAutoresizingMaskIntoConstraints = false
        styleName.translatesAutoresizingMaskIntoConstraints = false
        playStyle.translatesAutoresizingMaskIntoConstraints = false
        
        // 64
        playControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(snp.centerX)
            make.width.equalTo(260)
            make.height.equalTo(44)
            make.top.equalTo(self).offset(10)
        }
        
        rateName.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(64)
            make.height.equalTo(44)
            make.top.equalTo(playControl.snp.bottom).offset(20)
        }
        
        playRate.snp.makeConstraints { (make) in
            make.left.equalTo(rateName.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.top.equalTo(rateName)
        }
        
        styleName.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(rateName)
            make.top.equalTo(rateName.snp.bottom).offset(20)
        }

        playStyle.snp.makeConstraints { (make) in
            make.left.equalTo(styleName.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.top.equalTo(styleName)
        }
    }
    
    func loadDatas() {
        playControl.margin = 15
        playControl.updateViews(JMJsonParse.parseJson(name: "menu_play"))
        playRate.margin = 15
        playRate.updateViews(JMJsonParse.parseJson(name: "menu_playrate"))
        playStyle.margin = 15
        playStyle.updateViews(JMJsonParse.parseJson(name: "menu_playstyle"))
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }

}
