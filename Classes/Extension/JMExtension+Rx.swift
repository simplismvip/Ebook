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
