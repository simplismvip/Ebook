//
//  JMReadMenuContainer.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/3/29.
//

import UIKit
import ZJMKit
import SnapKit
import RxCocoa
import RxSwift

final class JMReadMenuContainer: JMBaseView {
    private let topLeft = JMReadItemView()
    private let topRight = JMReadItemView()
    private let bottom = JMReadItemView()
    
    internal let set = JMMenuSetView() // 设置
    internal let light = JMMenuLightView() // 亮度
    internal let play = JMMeunPlayVIew() // 播放
    
    internal let topContainer = UIView() // 亮度
    internal let bottomContainer = UIView() // 亮度
    private let disposeBag = DisposeBag()
    let chapter = JMChapterView() // 左侧目录
    
    private let margin: CGFloat = 10
    private let s_width = UIScreen.main.bounds.size.width
    /// 状态
    var currType = JMMenuViewType.ViewType_NONE
    
    internal let showOrHide = BehaviorSubject<JMMenuStatus>(value: .HideOrShowAll(true))
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = UIColor.gray
        setupviews()
        loadDats()
        showOrHide.bind(to: rx.hideOrShow).disposed(by: disposeBag)
    }
    
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
            showWithType(type: .ViewType_CHAPTER)
        }
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
        }else {
            if currType == .ViewType_NONE {
                print("点击右侧1/4翻页")
            }else {
                hideWithType()
            }
        }
        
        
//        if let value = try? showOrHide.value() {
//            let width = UIScreen.main.bounds.size.width
//            if x < width/4 {
//                switch value {
//                case .HideOrShowAll(let isHide):
//                    if isHide {
//                        print("点击左侧1/4翻页")
//                    }else {
//                        showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
//                    }
//                case .ShowSet(let isHide):
//                    if isHide {
//
//                    }else {
//                        showOrHide.onNext(JMMenuStatus.ShowSet(true))
//                        showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
//                    }
//                case .ShowLight(let isHide):
//                    if isHide {
//
//                    }else {
//                        showOrHide.onNext(JMMenuStatus.ShowLight(true))
//                        showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
//                    }
//                case .ShowPlay(let isHide):
//                    if isHide {
//
//                    }else {
//                        showOrHide.onNext(JMMenuStatus.ShowPlay(true))
//                        showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
//                    }
//                }
//
//            }else if x > width/4 && x < width/4*3 {
//                switch value {
//                case .HideOrShowAll(let isHide):
//                    showOrHide.onNext(JMMenuStatus.HideOrShowAll(!isHide))
//                case .ShowSet(let isHide):
//                    if !isHide {
//                        showOrHide.onNext(JMMenuStatus.ShowSet(true))
//                        showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
//                    }
//                case .ShowLight(let isHide):
//                    if !isHide {
//                        showOrHide.onNext(JMMenuStatus.ShowLight(true))
//                        showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
//                    }
//                case .ShowPlay(let isHide):
//                    if !isHide {
//                        showOrHide.onNext(JMMenuStatus.ShowPlay(true))
//                        showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
//                    }
//                }
//            }else {
//                switch value {
//                case .HideOrShowAll(let isHide):
//                    if isHide {
//                        print("点击右侧1/4翻页")
//                    }else {
//                        showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
//                    }
//                case .ShowSet(let isHide):
//                    if isHide {
//
//                    }else {
//                        showOrHide.onNext(JMMenuStatus.ShowSet(true))
//                        // 隐藏设置View后，立即修改全局状态为隐藏。否则下一次点击会出问题
//                        showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
//                    }
//                case .ShowLight(let isHide):
//                    if isHide {
//
//                    }else {
//                        showOrHide.onNext(JMMenuStatus.ShowLight(true))
//                        showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
//                    }
//                case .ShowPlay(let isHide):
//                    if isHide {
//
//                    }else {
//                        showOrHide.onNext(JMMenuStatus.ShowPlay(true))
//                        showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
//                    }
//                }
//            }
//        }
    }
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for view in subviews {
            let convertPoint = convert(point, from: self)
            if view.bounds.contains(convertPoint) {
                return super.hitTest(point, with: event)
            }
        }
        return nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: -- Private Method, Setup views
extension JMReadMenuContainer {
    private func loadDats() {
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
    
    private func setupviews()  {
        topContainer.backgroundColor = UIColor.jmRGBValue(0xF0F8FF)
        addSubview(topContainer)
        topContainer.addSubview(topLeft)
        topContainer.addSubview(topRight)
        
        bottomContainer.backgroundColor = topContainer.backgroundColor
        addSubview(bottomContainer)
        bottomContainer.addSubview(bottom)
        
        addSubview(chapter)
        addSubview(set)
        addSubview(light)
        addSubview(play)

        chapter.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(-s_width*0.7)
            make.width.equalTo(s_width*0.7)
            make.top.height.equalTo(self)
        }
        
        topContainer.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.height.equalTo(104)
            make.top.equalTo(snp.top).offset(-104)
        }
        
        bottomContainer.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.height.equalTo(104)
            make.bottom.equalTo(snp.bottom).offset(104)
        }
        
        set.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.height.equalTo(320)
            make.bottom.equalTo(snp.bottom).offset(320)
        }
        
        light.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.height.equalTo(160)
            make.bottom.equalTo(snp.bottom).offset(160)
        }
        
        play.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.height.equalTo(230)
            make.bottom.equalTo(snp.bottom).offset(230)
        }
    }
}
