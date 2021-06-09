//
//  JMBookControlView.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/6/7.
//

import UIKit
import ZJMKit

public class JMBookControlView: JMBaseView {
    /// 状态
    var currType = JMMenuViewType.ViewType_NONE
    
    let topLeft = JMReadItemView()
    let topRight = JMReadItemView()
    let bottom = JMReadItemView()

    let set = JMMenuSetView() // 设置
    let light = JMMenuLightView() // 亮度
    let play = JMMeunPlayVIew() // 播放
    let progress = JMMeunProgress() // 进度
    let topContainer = UIView() // 亮度
    let bottomContainer = UIView() // 亮度
    let chapter = JMChapterContainer() // 左侧目录

    let bookTitle = JMBookTitleView() // 标题
    let battery = JMBatteryView() // 电池
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bottomItems: [JMReadMenuItem] = JMJsonParse.parseJson(name: "menu_bottom")
        let top_left: [JMReadMenuItem] = JMJsonParse.parseJson(name: "menu_top_left")
        let top_right: [JMReadMenuItem] = JMJsonParse.parseJson(name: "menu_top_right")

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
    
    func setupviews(fontSize: Float) {
        set.fontSize.updateFontValue(value: fontSize)
        chapter.isHidden = true
        addSubview(bookTitle)
        bookTitle.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.height.equalTo(20)
            if #available(iOS 11.0, *) {
                make.top.equalTo(safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(self.snp.top)
            }
        }

        addSubview(battery)
        battery.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.height.equalTo(20)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(self.snp.bottom)
            }
        }

        addSubview(topContainer)
        topContainer.addSubview(topLeft)
        topContainer.addSubview(topRight)

        addSubview(bottomContainer)
        bottomContainer.addSubview(bottom)

        addSubview(progress)
        addSubview(chapter)
        addSubview(set)
        addSubview(light)
        addSubview(play)

        chapter.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }

        topContainer.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.height.equalTo(84)
            make.top.equalTo(self.snp.top).offset(-94)
        }

        bottomContainer.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.height.equalTo(84)
            make.bottom.equalTo(self.snp.bottom).offset(94)
        }

        set.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.height.equalTo(236)
            make.bottom.equalTo(self.snp.bottom).offset(236)
        }

        light.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.height.equalTo(204)
            make.bottom.equalTo(self.snp.bottom).offset(204)
        }

        play.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.height.equalTo(136)
            make.bottom.equalTo(self.snp.bottom).offset(136)
        }


        progress.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.height.equalTo(94)
            make.bottom.equalTo(self.snp.bottom).offset(94)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: -- Private Method, Setup views
extension JMBookControlView {

    /// 更新阅读进度
    public func updateProgress(curr: Float, max: Float) {
        progress.setSlider(max: max, curr: curr)
    }

    /// 更新按钮状态
    public func updateItemStatus(config: JMBookConfig) {
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

    public func updateAllItemsBkg(config: JMBookConfig) {
        topContainer.backgroundColor = config.subViewBkgColor()
        bottomContainer.backgroundColor = config.subViewBkgColor()

        bottom.changeBkgColor(config: config)
        topLeft.changeBkgColor(config: config)
        topRight.changeBkgColor(config: config)

        play.changeBkgColor(config: config)
        light.changeBkgColor(config: config)

        set.changeBkgColor(config: config)
        chapter.changeBkgColor(config: config)
        bookTitle.changeBkgColor(config: config)
        battery.changeBkgColor(config: config)
    }
}

extension JMBookControlView {
    /// 展示
    public func showWithType(type: JMMenuViewType) {
        self.currType = type
        if type == .ViewType_TOP_BOTTOM {
            topContainer.snp.updateConstraints { (make) in
                make.top.equalTo(self.snp.top)
            }

            bottomContainer.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom)
            }
            layoutIfNeeded([topContainer,bottomContainer], ishide: false)
        }else if type == .ViewType_LIGHT {
            light.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom)
            }
            layoutIfNeeded([light], ishide: false)
        }else if type == .ViewType_SET {
            set.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom)
            }
            layoutIfNeeded([set], ishide: false)
        }else if type == .ViewType_CHAPTER {
            chapter.snp.updateConstraints { (make) in
                make.left.equalTo(self)
            }
            layoutIfNeeded([chapter], ishide: false)
        }else if type == .ViewType_PLAY {
            play.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom)
            }
            layoutIfNeeded([play], ishide: false)
        }else if type == .ViewType_PROGRESS {
            progress.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom)
            }
            layoutIfNeeded([progress], ishide: false)
        } else if type == .ViewType_NONE {

        }
    }

    /// 隐藏
    public func hideWithType() {
        if currType == .ViewType_TOP_BOTTOM {
            topContainer.snp.updateConstraints { (make) in
                make.top.equalTo(self.snp.top).offset(-104)
            }

            bottomContainer.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom).offset(104)
            }
            layoutIfNeeded([topContainer,bottomContainer], ishide: true)

        }else if currType == .ViewType_LIGHT {
            light.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom).offset(160)
            }
            layoutIfNeeded([light], ishide: true)
        }else if currType == .ViewType_SET {
            set.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom).offset(320)
            }
            layoutIfNeeded([set], ishide: true)
        }else if currType == .ViewType_CHAPTER {
            chapter.snp.updateConstraints { (make) in
                make.left.equalTo(self).offset(-jmWidth)
            }
            layoutIfNeeded([chapter], ishide: true)
        }else if currType == .ViewType_PLAY {
            play.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom).offset(230)
            }
            layoutIfNeeded([play], ishide: true)
        }else if currType == .ViewType_PROGRESS {
            progress.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom).offset(94)
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
        setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        } completion: { (finish) in
            if finish && ishide {
                for view in views {
                    view.isHidden = ishide
                }
            }
        }
    }
}

extension JMBookControlView {
    /// 通过style获取目标Item模型
    public func findItem(_ menuStyle: JMMenuStyle) -> JMReadMenuItem? {
        return [set.allItems(),light.allItems(),play.allItems(),bottom.models,topRight.models]
            .flatMap { $0 }
            .filter({ $0.identify == menuStyle })
            .first
    }

    /// 显示左侧目录
    public func showChapter(items: [JMBookCharpter], title: String, currCharter: Int, bookId: String) {
        chapter.updateSource(items, title: title, currCharter: currCharter)
        chapter.updateTags(bookId)
        showWithType(type: .ViewType_CHAPTER)
    }
}
