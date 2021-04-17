//
//  JMReadPageContrller+UI.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/8.
//

import Foundation

// MARK: -- Private Method, Setup views
extension JMReadPageContrller {
    
    func loadDats() {
        let bottomItems: [JMReadMenuItem] = JMJsonParse.parseJson(name: "menu_bottom")
        let top_left: [JMReadMenuItem] = JMJsonParse.parseJson(name: "menu_top_left")
        let top_right: [JMReadMenuItem] = JMJsonParse.parseJson(name: "menu_top_right")
        
        bottom.updateViews(bottomItems)
        topLeft.updateViews(top_left)
        topRight.updateViews(top_right)
        
        topLeft.snp.makeConstraints { (make) in
            make.left.equalTo(topContainer).offset(10)
            make.width.equalTo((44.0 + margin) * CGFloat(top_left.count))
            make.height.equalTo(44)
            make.bottom.equalTo(topContainer.snp.bottom).offset(-10)
        }
        
        topRight.snp.makeConstraints { (make) in
            make.right.equalTo(topContainer.snp.right).offset(-10)
            make.width.equalTo((44.0 + margin) * CGFloat(top_right.count))
            make.height.equalTo(topLeft)
            make.bottom.equalTo(topLeft.snp.bottom)
        }

        bottom.snp.makeConstraints { (make) in
            make.left.width.equalTo(bottomContainer)
            make.height.equalTo(44)
            make.top.equalTo(bottomContainer.snp.top).offset(10)
        }
    }
    
    func setupviews()  {
        view.addSubview(battery)
        view.addSubview(bookTitle)
        topContainer.backgroundColor = UIColor.jmRGBValue(0xF0F8FF)
        view.addSubview(topContainer)
        topContainer.addSubview(topLeft)
        topContainer.addSubview(topRight)
        
        bottomContainer.backgroundColor = topContainer.backgroundColor
        view.addSubview(bottomContainer)
        bottomContainer.addSubview(bottom)
        battery.batteryColor = UIColor.darkText
        
        view.addSubview(chapter)
        view.addSubview(set)
        view.addSubview(light)
        view.addSubview(play)
        
        chapter.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(-view.jmWidth*0.9)
            make.width.equalTo(view.jmWidth*0.9)
            make.top.height.equalTo(view)
        }
        
        topContainer.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(104)
            make.top.equalTo(view.snp.top).offset(-104)
        }
        
        bottomContainer.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(104)
            make.bottom.equalTo(view.snp.bottom).offset(104)
        }
        
        set.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(320)
            make.bottom.equalTo(view.snp.bottom).offset(320)
        }
        
        light.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(160)
            make.bottom.equalTo(view.snp.bottom).offset(160)
        }
        
        play.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(230)
            make.bottom.equalTo(view.snp.bottom).offset(230)
        }
        
        bookTitle.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(20)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(view.snp.top)
            }
        }
        
        battery.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(20)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(view.snp.bottom)
            }
        }
    }
}

extension JMReadPageContrller {
    func switchWithType() {
        if currType == .ViewType_TOP_BOTTOM {
            
        }else if currType == .ViewType_LIGHT {
            
        }else if currType == .ViewType_SET {
            
        }else if currType == .ViewType_CHAPTER {
            
        }else if currType == .ViewType_PLAY {
            
        }else if currType == .ViewType_NONE {
            
        }
    }
    
    /// 展示
    func showWithType(type: JMMenuViewType) {
        self.currType = type
        if type == .ViewType_TOP_BOTTOM {
            topContainer.snp.updateConstraints { (make) in
                make.top.equalTo(view.snp.top)
            }
            
            bottomContainer.snp.updateConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom)
            }
            
        }else if type == .ViewType_LIGHT {
            light.snp.updateConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom)
            }
        }else if type == .ViewType_SET {
            set.snp.updateConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom)
            }
        }else if type == .ViewType_CHAPTER {
            chapter.snp.updateConstraints { (make) in
                make.left.equalTo(view)
            }
        }else if type == .ViewType_PLAY {
            play.snp.updateConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom)
            }
        }else if type == .ViewType_NONE {
            
        }
        
        view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// 隐藏
    func hideWithType() {
        if currType == .ViewType_TOP_BOTTOM {
            topContainer.snp.updateConstraints { (make) in
                make.top.equalTo(view.snp.top).offset(-104)
            }

            bottomContainer.snp.updateConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom).offset(104)
            }
        }else if currType == .ViewType_LIGHT {
            light.snp.updateConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom).offset(160)
            }
        }else if currType == .ViewType_SET {
            set.snp.updateConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom).offset(320)
            }
        }else if currType == .ViewType_CHAPTER {
            chapter.snp.updateConstraints { (make) in
                make.left.equalTo(view).offset(-view.jmWidth*0.9)
            }
        }else if currType == .ViewType_PLAY {
            play.snp.updateConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom).offset(230)
            }
        }else if currType == .ViewType_NONE {
            
        }
        
        // 重置
        currType = .ViewType_NONE
        
        view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension JMReadPageContrller {
    /// 通过style获取目标Item模型
    public func findItem(_ menuStyle: JMMenuStyle) -> JMReadMenuItem? {
        return [set.allItems(),light.allItems(),play.allItems(),bottom.models,topRight.models]
            .flatMap { $0 }
            .filter({ $0.identify == menuStyle })
            .first
    }
    
    /// 显示左侧目录
    public func showChapter(items: [JMBookCatalog]) {
        if chapter.dataSource.isEmpty {
            chapter.dataSource = items
        }
        showWithType(type: .ViewType_CHAPTER)
    }
    
    func tapActionSwitchMenu(_ x: CGFloat) {
        if x < s_width/4 {
            if currType == .ViewType_NONE {
                print("点击左侧1/4翻页")
            }else {
                hideWithType()
            }
        }else if x > s_width/4 && x < s_width/4*3 {
            if currType == .ViewType_NONE {
                showWithType(type: .ViewType_TOP_BOTTOM)
            }else {
                hideWithType()
            }
            setNeedsStatusBarAppearanceUpdate()
        }else {
            if currType == .ViewType_NONE {
                print("点击右侧1/4翻页")
            }else {
                hideWithType()
            }
        }
    }
}
