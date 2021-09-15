//
//  JMReadPageContrller+UI.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/4/8.
//

import Foundation

// MARK: -- Private Method, Setup views
extension JMBookContrller {
    func loadDats() {
        let bottomItems: [JMMenuItem] = JMJsonParse.parseJson(name: "menu_bottom")
        let top_left: [JMMenuItem] = JMJsonParse.parseJson(name: "menu_top_left")
        let top_right: [JMMenuItem] = JMJsonParse.parseJson(name: "menu_top_right")
        
        bottom.updateViews(bottomItems)
        topLeft.updateViews(top_left)
        topRight.updateViews(top_right)
        
        topLeft.margin = 0
        topLeft.snp.makeConstraints { (make) in
            make.left.equalTo(topContainer)
            make.width.equalTo(44.0 * CGFloat(top_left.count))
            make.height.equalTo(44)
            make.bottom.equalTo(topContainer.snp.bottom)
        }
        
        topRight.margin = 0
        topRight.snp.makeConstraints { (make) in
            make.right.equalTo(topContainer.snp.right)
            make.width.equalTo(44.0 * CGFloat(top_right.count))
            make.height.equalTo(topLeft)
            make.bottom.equalTo(topLeft.snp.bottom)
        }

        bottom.snp.makeConstraints { (make) in
            make.left.width.equalTo(bottomContainer)
            make.height.equalTo(44)
            make.top.equalTo(bottomContainer.snp.top).offset(5)
        }
    }
    
    func setupviews() {
        set.fontSize.updateFontValue(value: Float(bookModel.config.fontSize()))
        chapter.isHidden = true
        JMBookToast.hide()
        view.addSubview(bookTitle)
        view.addSubview(comment)
        bookTitle.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(20)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(view.snp.top)
            }
        }
        
        comment.setImage("epub_comment".image, for: .normal)
        comment.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.right.equalTo(bookTitle.snp.right).offset(-14)
            make.centerY.equalTo(bookTitle.snp.centerY)
        }
        
        // 底部是否有广告View
        if let bottomAdView = bookModel.config.bottomView  {
            view.addSubview(bottomAdView)
            bottomAdView.snp.makeConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom)
                make.left.width.equalTo(view)
                make.height.equalTo(64)
            }
            
            view.addSubview(battery)
            battery.snp.makeConstraints { (make) in
                make.left.width.equalTo(view)
                make.height.equalTo(20)
                make.bottom.equalTo(bottomAdView.snp.top).offset(-2)
            }
        } else {
            view.addSubview(battery)
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
        
//        topContainer.backgroundColor = UIColor.menuBkg
        view.addSubview(topContainer)
        topContainer.addSubview(topLeft)
        topContainer.addSubview(topRight)
        
//        bottomContainer.backgroundColor = topContainer.backgroundColor
        view.addSubview(bottomContainer)
        bottomContainer.addSubview(bottom)
        
        view.addSubview(progress)
        view.addSubview(chapter)
        view.addSubview(set)
        view.addSubview(light)
        view.addSubview(play)
        
        chapter.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        topContainer.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(84)
            make.top.equalTo(view.snp.top).offset(-94)
        }
        
        bottomContainer.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(84)
            make.bottom.equalTo(view.snp.bottom).offset(94)
        }
        
        set.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(236)
            make.bottom.equalTo(view.snp.bottom).offset(236)
        }
        
        light.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(204)
            make.bottom.equalTo(view.snp.bottom).offset(204)
        }
        
        play.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(136)
            make.bottom.equalTo(view.snp.bottom).offset(136)
        }
        
        
        progress.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(94)
            make.bottom.equalTo(view.snp.bottom).offset(94)
        }
    }
    
    /// 更新阅读进度
    func updateProgress() {
        if let pages = bookModel.currCharpter()?.pages {
            let max = Float(pages.count - 1)
            let curr = Float(bookModel.indexPath.page)
            progress.setSlider(max: max, curr: curr)
        }
    }
    
    /// 更新按钮状态
    func updateItemStatus() {
        let config = bookModel.config
        for item in set.allItems() {
            if item.identify == config.fontName() {
                item.isSelect = true
            }
            
            if item.identify == config.flipType() {
                item.isSelect = true
            }
        }
        
        for item in light.allItems() {
            if item.identify == config.bkgColor {
                item.isSelect = true
                jmRouterEvent(eventName: kEventNameMenuPageBkgColor, info: item)
            }
            
            if (config.brightness() == 0.7) && (item.identify == .PLightCus) {
                item.isSelect = true
            }
            
            if (config.brightness() == 1.0) && (item.identify == .PLightSys) {
                item.isSelect = true
            }
        }
        
        for item in play.allItems() {
            if item.identify == config.playStatus {
                item.isSelect = true
            }
            
            if item.identify == config.playRate {
                item.isSelect = true
            }
        }
    }
    
    func updateAllItemsBkg(config: JMBookConfig) {
        topContainer.backgroundColor = config.subViewColor()
        bottomContainer.backgroundColor = config.subViewColor()
        comment.tintColor = config.tintColor()
        play.changeBkgColor(config: config)
        light.changeBkgColor(config: config)
        
        set.changeBkgColor(config: config)
        chapter.changeBkgColor(config: config)
        bookTitle.changeBkgColor(config: config)
        battery.changeBkgColor(config: config)
        progress.changeBkgColor(config: config)
        
        bottom.refreshViews()
        topLeft.refreshViews()
        topRight.refreshViews()
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension JMBookContrller {
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
            layoutIfNeeded([topContainer,bottomContainer], ishide: false)
        }else if type == .ViewType_LIGHT {
            light.snp.updateConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom)
            }
            layoutIfNeeded([light], ishide: false)
        }else if type == .ViewType_SET {
            set.snp.updateConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom)
            }
            layoutIfNeeded([set], ishide: false)
        }else if type == .ViewType_CHAPTER {
            chapter.snp.updateConstraints { (make) in
                make.left.equalTo(view)
            }
            layoutIfNeeded([chapter], ishide: false)
        }else if type == .ViewType_PLAY {
            play.snp.updateConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom)
            }
            layoutIfNeeded([play], ishide: false)
        }else if type == .ViewType_PROGRESS {
            progress.snp.updateConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom)
            }
            layoutIfNeeded([progress], ishide: false)
        } else if type == .ViewType_NONE {
            
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
            layoutIfNeeded([topContainer,bottomContainer], ishide: true)
            
        }else if currType == .ViewType_LIGHT {
            light.snp.updateConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom).offset(160)
            }
            layoutIfNeeded([light], ishide: true)
        }else if currType == .ViewType_SET {
            set.snp.updateConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom).offset(320)
            }
            layoutIfNeeded([set], ishide: true)
        }else if currType == .ViewType_CHAPTER {
            chapter.snp.updateConstraints { (make) in
                make.left.equalTo(view).offset(-view.jmWidth)
            }
            layoutIfNeeded([chapter], ishide: true)
        }else if currType == .ViewType_PLAY {
            play.snp.updateConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom).offset(230)
            }
            layoutIfNeeded([play], ishide: true)
        }else if currType == .ViewType_PROGRESS {
            progress.snp.updateConstraints { (make) in
                make.bottom.equalTo(view.snp.bottom).offset(94)
            }
            layoutIfNeeded([progress], ishide: false)
        } else if currType == .ViewType_NONE {
            
        }
        
        // 重置
        currType = .ViewType_NONE
    }
    
    private func layoutIfNeeded(_ views: [UIView], ishide: Bool) {
        if !ishide {
            for view in views {
                view.isHidden = ishide
            }
        }
        view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { (finish) in
            if finish && ishide {
                for view in views {
                    view.isHidden = ishide
                }
            }
        }
    }
}

extension JMBookContrller {
    /// 通过style获取目标Item模型
    public func findItem(_ menuStyle: JMMenuStyle) -> JMMenuItem? {
        return [set.allItems(),light.allItems(),play.allItems(),bottom.models,topRight.models]
            .flatMap { $0 }
            .filter({ $0.identify == menuStyle })
            .first
    }
    
    /// 显示左侧目录
    public func showChapter(items: [JMBookCharpter]) {
        chapter.updateSource(items, title: bookModel.title, currCharter: bookModel.indexPath.chapter)
        chapter.updateTags(bookModel.bookId)
        showWithType(type: .ViewType_CHAPTER)
    }
    
    func tapActionSwitchMenu(_ x: CGFloat) {
        if x < s_width/4 {
            if currType == .ViewType_NONE {
                Logger.debug("点击左侧1/4翻页")
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
                Logger.debug("点击右侧1/4翻页")
            }else {
                hideWithType()
            }
        }
    }
}
