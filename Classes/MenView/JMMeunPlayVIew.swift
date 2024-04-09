//
//  JMMeunPlayVIew.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/3/31.
//

import UIKit
import SnapKit

final class JMMeunPlayVIew: JMBookBaseView {
    private let playControl = JMMenuItemView()
    private let playRate = JMMenuItemView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.menuBkg
        addSubview(playControl)
        addSubview(playRate)
        setupSubViews()
        loadDatas()
    }
    
    /// 获取所有显示的Items
    func allItems() -> [JMMenuItem] {
        return [playControl.models,playRate.models].flatMap { $0 }
    }

    func setupSubViews() {
        playControl.translatesAutoresizingMaskIntoConstraints = false
        playRate.translatesAutoresizingMaskIntoConstraints = false
        
        // 64
        playControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(snp.centerX)
            make.width.equalTo(320)
            make.height.equalTo(44)
            make.top.equalTo(self).offset(10)
        }
        
        playRate.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.right.equalTo(snp.right).offset(-30)
            make.height.equalTo(44)
            make.top.equalTo(playControl.snp.bottom).offset(10)
        }
    }
    
    func loadDatas() {
        playControl.margin = 15
        playControl.updateViews(JMMenuItem.plays)
        playRate.margin = 15
        playRate.updateViews(JMMenuItem.playrates)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("⚠️⚠️⚠️ Error") }

}
