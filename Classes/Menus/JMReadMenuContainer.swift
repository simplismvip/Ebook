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

class JMReadMenuContainer: JMBaseView {
    let topLeft = JMReadItemView()
    let topRight = JMReadItemView()
    let bottom = JMReadItemView()
    let set = JMMenuSetView() // 设置
    let light = JMMenuLightView() // 亮度
    let play = JMMeunPlayVIew() // 播放
    
    let topContainer = UIView() // 亮度
    let bottomContainer = UIView() // 亮度
    let margin: CGFloat = 10
    private let disposeBag = DisposeBag()
    
    /// 状态
    public let showOrHide = BehaviorSubject<JMMenuStatus>(value: .HideOrShowAll(true))
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = UIColor.gray
        setupviews()
        addGesture()
        loadDats()
    }
    
    func addGesture() {
        let swipLeft = UISwipeGestureRecognizer()
        swipLeft.direction = .left
        addGestureRecognizer(swipLeft)
        swipLeft.rx.event.bind(to: rx.leftSwipe).disposed(by: disposeBag)
        
        let swipRight = UISwipeGestureRecognizer()
        swipRight.direction = .right
        addGestureRecognizer(swipRight)
        swipRight.rx.event.bind(to: rx.rightSwipe).disposed(by: disposeBag)
        
        let tapGes = UITapGestureRecognizer()
        tapGes.delegate = self
        tapGes.numberOfTapsRequired = 1
        addGestureRecognizer(tapGes)
        tapGes.rx.event.bind(to: rx.tapGesture).disposed(by: disposeBag)
        showOrHide.bind(to: rx.hideOrShow).disposed(by: disposeBag)
    }
    
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
        topContainer.backgroundColor = UIColor.jmRGBValue(0xF0F8FF)
        addSubview(topContainer)
        topContainer.addSubview(topLeft)
        topContainer.addSubview(topRight)
        
        bottomContainer.backgroundColor = topContainer.backgroundColor
        addSubview(bottomContainer)
        bottomContainer.addSubview(bottom)
        
        addSubview(set)
        addSubview(light)
        addSubview(play)

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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return super.hitTest(point, with: event)
//        if let value = try? showOrHide.value() {
//            switch value {
//            case .HideOrShowAll(let s1):
//                return s1 ? super.hitTest(point, with: event) : nil
//            case .ShowLight(let s2):
//                return s2 ? super.hitTest(point, with: event) : nil
//            case .ShowSet(let s3):
//                return s3 ? super.hitTest(point, with: event) : nil
//            }
//        }
//        return nil
    }
}

extension JMReadMenuContainer: UIGestureRecognizerDelegate {
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
