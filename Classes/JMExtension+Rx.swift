//
//  JMExtension+Rx.swift
//  JMEpubReader
//
//  Created by JunMing on 2021/2/2.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import ZJMKit

extension Reactive where Base: UIView {
    
    public var originX: Binder<CGFloat> {
        return Binder(self.base) { tableView, originX in
            var tFrame = tableView.frame
            tFrame.origin.x = originX
            tableView.frame = tFrame
        }
    }
    
    public var originY: Binder<CGFloat> {
        return Binder(self.base) { tableView, originY in
            var tFrame = tableView.frame
            tFrame.origin.y = originY
            tableView.frame = tFrame
        }
    }
    
    public var height: Binder<CGFloat> {
        return Binder(self.base) { view, height in
            var tFrame = view.frame
            tFrame.size.height = height
            view.frame = tFrame
        }
    }
    
    public var width: Binder<CGFloat> {
        return Binder(self.base) { view, width in
            var tFrame = view.frame
            tFrame.size.width = width
            view.frame = tFrame
        }
    }
    
    public var bkgColor: Binder<UIColor?> {
        return Binder(self.base) { view, color in
            view.backgroundColor = color
        }
    }
}

extension Reactive where Base: UIButton {
    public func titleColor(for controlState: UIControl.State = []) -> Binder<UIColor?> {
        return Binder(self.base) { button, titleColor in
            button.setTitleColor(titleColor, for: controlState)
        }
    }
    
    public var titleFont: Binder<UIFont?> {
        return Binder(self.base) { button, font in
            button.titleLabel?.font = font
        }
    }
}

extension Reactive where Base: UILabel {
    
}

extension Reactive where Base: UIViewController {
    public var viewWillAppear: Driver<Void> {
        return sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in }
            .asDriver(onErrorJustReturn: ())
    }
    
    public var viewWillDisappear: Driver<Void> {
        return sentMessage(#selector(UIViewController.viewWillDisappear(_:)))
            .map { _ in }
            .asDriver(onErrorJustReturn: ())
    }
}

extension Reactive where Base: JMReadPageContrller {
    public var isLoading: Binder<JMEpubStatus> {
        return Binder(self.base, binding: { (vc, result) in
            switch result {
            case .OpenFail(let fail):
                vc.hideLoading()
                JMTextToast.share.jmShowString(text: fail, seconds: 1)
            case .OpenSuccess:
                vc.hideLoading()
            case .Opening:
                vc.showLoading()
            case .OpenInit:
                print("")
            }
        })
    }
}


extension Reactive where Base: WKWebView {
    /// webView调用JS代码
    public func js(_ script: String) -> Observable<(String?, Error?)> {
        return Observable<(String?, Error?)>.create { (Observer) -> Disposable in
            self.base.evaluateJavaScript(script) { (item, error) in
                Observer.onNext((item as? String, error))
            }
            return Disposables.create()
        }
    }
    
    /// webView调用JS代码
    public func jss(_ script: String) -> Observable<JMWapper<String?, Error?>> {
        return Observable<JMWapper<String?, Error?>>.create { (Observer) -> Disposable in
            self.base.evaluateJavaScript(script) { (item, error) in
                Observer.onNext(JMWapper(item as? String, error))
            }
            return Disposables.create()
        }
    }
}

extension Reactive where Base: JMReadMenuContainer {
    internal var hideOrShow: Binder<JMMenuStatus> {
        return Binder(self.base) { view, menuStatus in
            switch menuStatus {
            case .HideOrShowAll(let isHide):
                if isHide {
                    view.topContainer.snp.updateConstraints { (make) in
                        make.top.equalTo(view.snp.top).offset(-104)
                    }
                    
                    view.bottomContainer.snp.updateConstraints { (make) in
                        make.bottom.equalTo(view.snp.bottom).offset(104)
                    }
                }else {
                    view.topContainer.snp.updateConstraints { (make) in
                        make.top.equalTo(view.snp.top)
                    }
                    
                    view.bottomContainer.snp.updateConstraints { (make) in
                        make.bottom.equalTo(view.snp.bottom)
                    }
                    
                }
                
                view.setNeedsUpdateConstraints()
                UIView.animate(withDuration: 0.3) {
                    view.layoutIfNeeded()
                }
            case .ShowLight(let isHide):
                if isHide {
                    view.light.snp.updateConstraints { (make) in
                        make.bottom.equalTo(view.snp.bottom).offset(160)
                    }
                }else {
                    view.light.snp.updateConstraints { (make) in
                        make.bottom.equalTo(view.snp.bottom)
                    }
                }
                view.setNeedsUpdateConstraints()
                UIView.animate(withDuration: 0.3) {
                    view.layoutIfNeeded()
                }
            case .ShowSet(let isHide):
                if isHide {
                    view.set.snp.updateConstraints { (make) in
                        make.bottom.equalTo(view.snp.bottom).offset(320)
                    }
                }else {
                    view.set.snp.updateConstraints { (make) in
                        make.bottom.equalTo(view.snp.bottom)
                    }
                }
                view.setNeedsUpdateConstraints()
                UIView.animate(withDuration: 0.3) {
                    view.layoutIfNeeded()
                }
            case .ShowPlay(let isHide):
                if isHide {
                    view.play.snp.updateConstraints { (make) in
                        make.bottom.equalTo(view.snp.bottom).offset(230)
                    }
                }else {
                    view.play.snp.updateConstraints { (make) in
                        make.bottom.equalTo(view.snp.bottom)
                    }
                }
                view.setNeedsUpdateConstraints()
                UIView.animate(withDuration: 0.3) {
                    view.layoutIfNeeded()
                }
            }
        }
    }
    
    internal var tapGesture: Binder<UITapGestureRecognizer> {
        return Binder(self.base) { view, tapGes in
            if let value = try? view.showOrHide.value() {
                let point = tapGes.location(in: tapGes.view)
                let width = UIScreen.main.bounds.size.width
                if point.x < width/4 {
                    switch value {
                    case .HideOrShowAll(let isHide):
                        if isHide {
                            print("点击左侧1/4翻页")
                        }else {
                            view.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
                        }
                    case .ShowSet(let isHide):
                        if isHide {
                            
                        }else {
                            view.showOrHide.onNext(JMMenuStatus.ShowSet(true))
                            view.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
                        }
                    case .ShowLight(let isHide):
                        if isHide {
                            
                        }else {
                            view.showOrHide.onNext(JMMenuStatus.ShowLight(true))
                            view.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
                        }
                    case .ShowPlay(let isHide):
                        if isHide {
                            
                        }else {
                            view.showOrHide.onNext(JMMenuStatus.ShowPlay(true))
                            view.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
                        }
                    }
                    
                }else if point.x > width/4 && point.x < width/4*3 {
                    switch value {
                    case .HideOrShowAll(let isHide):
                        view.showOrHide.onNext(JMMenuStatus.HideOrShowAll(!isHide))
                    case .ShowSet(let isHide):
                        if !isHide {
                            view.showOrHide.onNext(JMMenuStatus.ShowSet(true))
                            view.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
                        }
                    case .ShowLight(let isHide):
                        if !isHide {
                            view.showOrHide.onNext(JMMenuStatus.ShowLight(true))
                            view.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
                        }
                    case .ShowPlay(let isHide):
                        if !isHide {
                            view.showOrHide.onNext(JMMenuStatus.ShowPlay(true))
                            view.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
                        }
                    }
                }else {
                    switch value {
                    case .HideOrShowAll(let isHide):
                        if isHide {
                            print("点击右侧1/4翻页")
                        }else {
                            view.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
                        }
                    case .ShowSet(let isHide):
                        if isHide {
                            
                        }else {
                            view.showOrHide.onNext(JMMenuStatus.ShowSet(true))
                            // 隐藏设置View后，立即修改全局状态为隐藏。否则下一次点击会出问题
                            view.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
                        }
                    case .ShowLight(let isHide):
                        if isHide {
                            
                        }else {
                            view.showOrHide.onNext(JMMenuStatus.ShowLight(true))
                            view.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
                        }
                    case .ShowPlay(let isHide):
                        if isHide {
                            
                        }else {
                            view.showOrHide.onNext(JMMenuStatus.ShowPlay(true))
                            view.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
                        }
                    }
                }
            }
        }
    }
    
    internal var leftSwipe: Binder<UISwipeGestureRecognizer> {
        return Binder(self.base) { view, tapGes in
            print("左侧轻扫翻页")
            view.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
        }
    }
    
    internal var rightSwipe: Binder<UISwipeGestureRecognizer> {
        return Binder(self.base) { view, tapGes in
            print("右侧轻扫翻页")
            view.showOrHide.onNext(JMMenuStatus.HideOrShowAll(true))
        }
    }
}
